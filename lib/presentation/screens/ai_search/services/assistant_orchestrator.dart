part of '../ai_search.dart';

/// منسّق دورة المحادثة بين المستخدم والنموذج وخادم tafsir-mcp (The Loop).
///
/// يربط [LlmService] و [TafsirMcpClient] معاً عبر دورة تكرارية:
///
///   1. يرسل السجل + قائمة الأدوات إلى النموذج المختار.
///   2. لو ردّ النموذج بـ `tool_calls`:
///        - يستدعي كل أداة عبر خادم MCP.
///        - يضيف نتائجها كرسائل `{role: "tool", ...}`.
///        - يعيد الخطوة 1 (حتى [maxIterations]).
///   3. لو ردّ النموذج نصاً نهائياً → يُرجعه.
///
/// يحدّث [AiSearchState] في كل خطوة لإطعام واجهة المستخدم
/// (حالة "يفكر"، اسم الأداة الجارية، الرسائل).
class AssistantOrchestrator {
  AssistantOrchestrator();

  final _llm = LlmService();
  final _mcp = TafsirMcpClient();

  /// الحد الأقصى لعدد جولات استدعاء الأدوات (لتفادي الحلقات اللانهائية).
  static const int maxIterations = 5;

  bool _isProcessing = false;

  /// يعالج رسالة المستخدم ويرجع نص الإجابة النهائية.
  ///
  /// يحدّث [state] جانبياً أثناء المعالجة لتحديث الواجهة مباشرةً.
  ///
  /// [onFallback] يُستدعى عند نجاح fallback لنموذج بديل (للتنبيه وتحديث القائمة).
  Future<void> handleUserMessage({
    required String userText,
    required AiSearchState state,
    void Function(LlmProvider fallbackProvider)? onFallback,
  }) async {
    if (_isProcessing) return;
    if (userText.trim().isEmpty) return;
    _isProcessing = true;

    state.assistantError.value = '';
    state.isAssistantThinking.value = true;
    state.currentToolName.value = '';

    try {
      // 1) تأكد من تهيئة MCP + جلب الأدوات.
      await _mcp.ensureInitialized();
      final tools = await _mcp.listTools();
      final openAiTools = tools.map((t) => t.toOpenAiFunction()).toList();

      // 2) ابنِ سجل الرسائل المبدئي (system + history + الرسالة الجديدة).
      final messages = <Map<String, dynamic>>[
        LlmService.systemMessage,
        ...state.assistantMessagesToOpenAi(),
        {'role': 'user', 'content': userText},
      ];

      final provider = state.selectedProvider.value;

      // 3) حلقة التكرار (LLM ↔ tools).
      for (int iteration = 0; iteration < maxIterations; iteration++) {
        state.isAssistantThinking.value = true;
        final resp = await _llm.chatCompletion(
          messages: messages,
          tools: openAiTools,
          provider: provider,
          onFallback: onFallback,
        );

        if (!resp.hasToolCalls) {
          // وصلنا للإجابة النهائية.
          state.isAssistantThinking.value = false;
          state.currentToolName.value = '';
          state.addAssistantMessage(resp.content);
          return;
        }

        // النموذج طلب أدوات — أضف رسالة الـ assistant التي تحوي tool_calls.
        messages.add({
          'role': 'assistant',
          'content': resp.content,
          'tool_calls': _toolCallsToOpenAiJson(resp.toolCalls),
        });

        // 4) نفّذ كل أداة وأضف نتيجتها كرسالة tool.
        state.isAssistantThinking.value = false;
        for (final call in resp.toolCalls) {
          state.currentToolName.value = call.name;
          final result = await _executeTool(call);
          messages.add({
            'role': 'tool',
            'tool_call_id': call.id,
            'content': result,
          });
        }
        state.currentToolName.value = '';
      }

      // بلغنا الحد الأقصى دون ردّ نصي — اطلب رداً نهائياً بلا أدوات.
      state.isAssistantThinking.value = true;
      final finalResp = await _llm.chatCompletion(
        messages: messages,
        tools: const [],
        provider: provider,
        onFallback: onFallback,
      );
      state.isAssistantThinking.value = false;
      state.addAssistantMessage(
        finalResp.content.isNotEmpty
            ? finalResp.content
            : 'لم أتمكن من صياغة إجابة نهائية. حاول إعادة صياغة سؤالك.',
      );
    } on LlmException catch (e) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = e.message;
      log('LLM error: ${e.message}', name: 'Assistant');
    } on McpException catch (e) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = 'خطأ في خادم التفسير: ${e.message}';
      log('MCP error: ${e.message}', name: 'Assistant');
    } catch (e, stack) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = 'حدث خطأ غير متوقع: $e';
      log('Orchestrator error: $e\n$stack', name: 'Assistant');
    } finally {
      _isProcessing = false;
    }
  }

  /// ينفّذ استدعاء أداة واحدة عبر خادم MCP ويرجع نص النتيجة.
  Future<String> _executeTool(LlmToolCall call) async {
    try {
      final result = await _mcp.callTool(call.name, call.arguments);
      if (result.isError) {
        return 'خطأ في تنفيذ الأداة ${call.name}: ${result.text}';
      }
      return result.text;
    } catch (e) {
      return 'فشل استدعاء الأداة ${call.name}: $e';
    }
  }

  /// يحوّل قائمة [LlmToolCall] إلى صيغة JSON التي يتوقعها OpenAI
  /// داخل رسالة الـ assistant.
  List<Map<String, dynamic>> _toolCallsToOpenAiJson(List<LlmToolCall> calls) {
    return calls
        .map(
          (c) => {
            'id': c.id,
            'type': 'function',
            'function': {
              'name': c.name,
              'arguments': jsonEncode(c.arguments),
            },
          },
        )
        .toList();
  }
}
