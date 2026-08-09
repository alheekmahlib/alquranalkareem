part of '../ai_search.dart';

/// منسّق دورة المحادثة بين المستخدم والنموذج وخادم alheekmah-mcp (الأقسام).
///
/// نسخة من [AssistantOrchestrator] لكنها تستهدف خادم الأقسام الإسلامية بدلاً من
/// tafsir-mcp. الفروقات:
///
///  - تستخدم [HeekmahMcpClient] بدلاً من [TafsirMcpClient].
///  - تستخدم [HeekmahLlmService.systemMessage] بدلاً من [LlmService.systemMessage].
///  - تقرأ/تكتب `state.heekmahMessages` بدلاً من `state.assistantMessages`.
///  - تُحدّث `state.heekmahToolName` و `state.heekmahError` بدلاً من نظيراتها.
///
/// بنية الحلقة (The Loop) مطابقة تماماً لـ [AssistantOrchestrator].
class HeekmahOrchestrator {
  HeekmahOrchestrator();

  final _llm = LlmService();
  final _mcp = HeekmahMcpClient();

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

    state.heekmahError.value = '';
    state.isHeekmahThinking.value = true;
    state.heekmahToolName.value = '';

    try {
      // 1) تأكد من تهيئة MCP + جلب الأدوات.
      await _mcp.ensureInitialized();
      final tools = await _mcp.listTools();
      final openAiTools = tools.map((t) => t.toOpenAiFunction()).toList();

      // 2) ابنِ سجل الرسائل المبدئي (system + history + الرسالة الجديدة).
      //    لاحظ: نستخدم HeekmahLlmService.systemMessage (prompt الأقسام)
      //    وليس LlmService.systemMessage (prompt tafsir-mcp).
      final messages = <Map<String, dynamic>>[
        HeekmahLlmService.systemMessage,
        ...state.heekmahMessagesToOpenAi(),
        {'role': 'user', 'content': userText},
      ];

      final provider = state.selectedProvider.value;

      // 3) حلقة التكرار (LLM ↔ tools).
      for (int iteration = 0; iteration < maxIterations; iteration++) {
        state.isHeekmahThinking.value = true;
        final resp = await _llm.chatCompletion(
          messages: messages,
          tools: openAiTools,
          provider: provider,
          onFallback: onFallback,
        );

        if (!resp.hasToolCalls) {
          // وصلنا للإجابة النهائية.
          state.isHeekmahThinking.value = false;
          state.heekmahToolName.value = '';
          state.addHeekmahMessage(resp.content);
          return;
        }

        // النموذج طلب أدوات — أضف رسالة الـ assistant التي تحوي tool_calls.
        messages.add({
          'role': 'assistant',
          'content': resp.content,
          'tool_calls': _toolCallsToOpenAiJson(resp.toolCalls),
        });

        // 4) نفّذ كل أداة وأضف نتيجتها كرسالة tool.
        state.isHeekmahThinking.value = false;
        for (final call in resp.toolCalls) {
          state.heekmahToolName.value = call.name;
          final result = await _executeTool(call);
          messages.add({
            'role': 'tool',
            'tool_call_id': call.id,
            'content': result,
          });
        }
        state.heekmahToolName.value = '';
      }

      // بلغنا الحد الأقصى دون ردّ نصي — اطلب رداً نهائياً بلا أدوات.
      state.isHeekmahThinking.value = true;
      final finalResp = await _llm.chatCompletion(
        messages: messages,
        tools: const [],
        provider: provider,
        onFallback: onFallback,
      );
      state.isHeekmahThinking.value = false;
      state.addHeekmahMessage(
        finalResp.content.isNotEmpty
            ? finalResp.content
            : 'heekmahNoFinalAnswer'.tr,
      );
    } on LlmException catch (e) {
      state.isHeekmahThinking.value = false;
      state.heekmahToolName.value = '';
      state.heekmahError.value = _translateLlmError(e.message);
      log('LLM error: ${e.message}', name: 'Heekmah');
    } on McpException catch (e) {
      state.isHeekmahThinking.value = false;
      state.heekmahToolName.value = '';
      state.heekmahError.value = 'heekmahMcpError'.tr;
      log('Heekmah MCP error: ${e.message}', name: 'Heekmah');
    } catch (e, stack) {
      state.isHeekmahThinking.value = false;
      state.heekmahToolName.value = '';
      state.heekmahError.value = 'heekmahUnexpectedError'.tr;
      log('Heekmah orchestrator error: $e\n$stack', name: 'Heekmah');
    } finally {
      _isProcessing = false;
    }
  }

  /// يترجم رسائل خطأ المزودين التقنية لرسائل مفهومة للمستخدم.
  /// (يشارك نفس منطق AssistantOrchestrator لأن مصادر الأخطاء متطابقة.)
  String _translateLlmError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('429') || lower.contains('rate limit')) {
      return 'assistantRateLimit'.tr;
    }
    if (lower.contains('402') ||
        lower.contains('payment') ||
        lower.contains('insufficient balance')) {
      return 'assistantPaymentRequired'.tr;
    }
    if (lower.contains('401') ||
        lower.contains('unauthorized') ||
        lower.contains('api key')) {
      return 'assistantInvalidKey'.tr;
    }
    if (lower.contains('404') ||
        lower.contains('not found') ||
        lower.contains('decommissioned')) {
      return 'assistantModelUnavailable'.tr;
    }
    if (lower.contains('503') ||
        lower.contains('overloaded') ||
        lower.contains('service unavailable')) {
      return 'assistantOverloaded'.tr;
    }
    if (lower.contains('413') ||
        lower.contains('too large') ||
        lower.contains('too many tokens')) {
      return 'assistantTooLarge'.tr;
    }
    return 'assistantGenericError'.tr;
  }

  /// ينفّذ استدعاء أداة واحدة عبر خادم alheekmah-mcp ويرجع نص النتيجة.
  Future<String> _executeTool(LlmToolCall call) async {
    try {
      final result = await _mcp.callTool(call.name, call.arguments);
      if (result.isError) {
        return 'خطأ في تنفيذ الأداة ${call.name}: ${result.text}';
      }
      final text = result.text.trim();
      return text.isEmpty ? 'assistantNoData'.tr : text;
    } catch (e) {
      return 'فشل استدعاء الأداة ${call.name}: $e';
    }
  }

  /// يحوّل قائمة [LlmToolCall] إلى صيغة JSON التي يتوقعها OpenAI.
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
