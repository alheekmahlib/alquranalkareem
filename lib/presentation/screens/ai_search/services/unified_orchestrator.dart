part of '../ai_search.dart';

/// مصدر الأداة: أي خادم MCP يقدّمها.
enum _McpSource { tafsir, heekmah }

/// منسّق المحادثة الموحَّد — يدمج خادمَي tafsir-mcp و alheekmah-mcp.
///
/// يجمع أدوات الخادمين في قائمة واحدة، ويصنّف سؤال المستخدم مسبقاً (pre-classification)
/// لتقليل الأدوات المرسلة للنموذج (توفير tokens وتقليل التشتت). ثم يوجّه كل استدعاء أداة
/// للخادم الصحيح بناءً على اسمها.
///
/// التدفق:
///   1. يهيّئ كلا الخادمين ويبني خريطة (اسم الأداة → الخادم).
///   2. يصنّف السؤال في جولة LLM خفيفة (لا أدوات) → مجال واحد.
///   3. يختار الأدوات المناسبة فقط للتصنيف.
///   4. حلقة tool calling (مثل AssistantOrchestrator) لكن _executeTool يوجّه للخادم الصحيح.
class UnifiedOrchestrator {
  UnifiedOrchestrator();

  final _llm = LlmService();
  final _tafsirMcp = TafsirMcpClient();
  final _heekmahMcp = HeekmahMcpClient();

  /// الحد الأقصى لعدد جولات استدعاء الأدوات.
  static const int maxIterations = 5;

  bool _isProcessing = false;

  /// خريطة: اسم الأداة → الخادم الذي يقدّمها (تُبنى بعد listTools).
  Map<String, _McpSource> _toolToSource = {};

  /// ذاكرات مؤقتة لأدوات كل خادم (تُبنى مرة واحدة بعد التهيئة).
  List<McpTool> _tafsirTools = const [];
  List<McpTool> _heekmahTools = const [];

  /// يعالج رسالة المستخدم في المحادثة الموحَّدة.
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
      // 1) تأكد من تهيئة كلا الخادمين + بناء خريطة الأدوات.
      await _ensureAllInitialized();
      _buildToolMap();

      // 2) تصنيف خفيف للسؤال (جولة LLM واحدة بلا أدوات).
      final provider = state.selectedProvider.value;
      final category = await _classify(userText, provider, onFallback);
      log('Unified category: "$category" for query: "${userText.substring(0, userText.length.clamp(0, 50))}"',
          name: 'Unified');

      // 3) اختيار الأدوات المناسبة بناءً على التصنيف.
      final selectedTools = _selectToolsForCategory(category);

      // 4) ابنِ سجل الرسائل (system موحَّد + history + الرسالة الجديدة).
      final messages = <Map<String, dynamic>>[
        UnifiedLlmService.systemMessage,
        ...state.assistantMessagesToOpenAi(),
        {'role': 'user', 'content': userText},
      ];

      // 5) حلقة tool calling.
      for (int iteration = 0; iteration < maxIterations; iteration++) {
        state.isAssistantThinking.value = true;
        final resp = await _llm.chatCompletion(
          messages: messages,
          tools: selectedTools,
          provider: provider,
          onFallback: onFallback,
        );

        if (!resp.hasToolCalls) {
          // إجابة نهائية.
          state.isAssistantThinking.value = false;
          state.currentToolName.value = '';
          state.addAssistantMessage(_cleanOutput(resp.content));
          return;
        }

        // أضف رسالة الـ assistant التي تحوي tool_calls.
        messages.add({
          'role': 'assistant',
          'content': resp.content,
          'tool_calls': _toolCallsToOpenAiJson(resp.toolCalls),
        });

        // نفّذ كل أداة وأضف نتيجتها.
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

      // بلغنا الحد الأقصى — اطلب رداً نهائياً بلا أدوات.
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
            ? _cleanOutput(finalResp.content)
            : 'assistantNoFinalAnswer'.tr,
      );
    } on LlmException catch (e) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = _translateLlmError(e.message);
      log('LLM error: ${e.message}', name: 'Unified');
    } on McpException catch (e) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = 'assistantMcpError'.tr;
      log('MCP error: ${e.message}', name: 'Unified');
    } catch (e, stack) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = 'assistantUnexpectedError'.tr;
      log('Unified orchestrator error: $e\n$stack', name: 'Unified');
    } finally {
      _isProcessing = false;
    }
  }

  // ─── التهيئة وخريطة الأدوات ──────────────────────────────────────

  /// يهيّئ كلا الخادمين ويتأكد أن قوائم الأدوات محمّلة.
  Future<void> _ensureAllInitialized() async {
    await _tafsirMcp.ensureInitialized();
    // HeekmahMcpClient قد لا يكون مُهيّأ (HEEKMAH_MCP_ENDPOINT فارغ في .env).
    // نتسامح مع فشله — الخادم القرآني يكفي لوحده.
    try {
      await _heekmahMcp.ensureInitialized();
    } catch (e) {
      log('Heekmah MCP unavailable (endpoint may be empty): $e',
          name: 'Unified');
    }
    _tafsirTools = _tafsirMcp.tools;
    _heekmahTools = _heekmahMcp.tools;
  }

  /// يبني خريطة (اسم الأداة → الخادم) من قوائم الأدوات.
  void _buildToolMap() {
    _toolToSource = {};
    for (final t in _tafsirTools) {
      _toolToSource[t.name] = _McpSource.tafsir;
    }
    for (final t in _heekmahTools) {
      _toolToSource[t.name] = _McpSource.heekmah;
    }
  }

  // ─── التصنيف المسبق ──────────────────────────────────────────────

  /// يصنّف سؤال المستخدم في جولة LLM خفيفة (لا أدوات، لا تاريخ).
  /// يرجع أحد: quran, hadith, fiqh, aqeedah, seerah, mixed.
  Future<String> _classify(
    String userText,
    LlmProvider provider,
    void Function(LlmProvider)? onFallback,
  ) async {
    const validCategories = [
      'quran',
      'hadith',
      'fiqh',
      'aqeedah',
      'seerah',
      'mixed',
    ];
    try {
      final resp = await _llm.chatCompletion(
        messages: [
          {
            'role': 'system',
            'content': 'صنّف سؤال المستخدم في مجال واحد فقط، '
                'وأرجع كلمة واحدة فقط بالإنجليزية من القائمة التالية:\n'
                '- quran: القرآن والتفسير والإعراب والصرف والقراءات وأسباب النزول والإحصاءات.\n'
                '- hadith: الحديث الشريف وأسانيده.\n'
                '- fiqh: الأحكام الفقهية والعبادات والمعاملات.\n'
                '- aqeedah: العقيدة والإيمان والتوحيد وأسماء الله وصفاته.\n'
                '- seerah: السيرة النبوية والتاريخ الإسلامي والغزوات.\n'
                '- mixed: يشمل أكثر من مجال مما سبق.\n'
                'أرجع الكلمة فقط دون أي شرح.',
          },
          {'role': 'user', 'content': userText},
        ],
        tools: const [],
        provider: provider,
        onFallback: onFallback,
      );
      final result = resp.content.trim().toLowerCase();
      // قد يرجع الـ LLM كلمة مع شرح — خذ الكلمة الأولى.
      final firstWord = result.split(RegExp(r'[\s,.]')).first.trim();
      return validCategories.contains(firstWord) ? firstWord : 'mixed';
    } catch (e) {
      log('Classification failed, falling back to mixed: $e',
          name: 'Unified');
      return 'mixed';
    }
  }

  // ─── اختيار الأدوات حسب التصنيف ─────────────────────────────────

  /// يختار الأدوات المناسبة للتصنيف من كلا الخادمين.
  List<Map<String, dynamic>> _selectToolsForCategory(String category) {
    final selected = <McpTool>[];

    // أدوات tafsir-mcp المفيدة لكل تصنيف (بأسماء معروفة).
    const tafsirQuranTools = {
      'fetch_ayah',
      'fetch_tafsir',
      'fetch_nuzool_reason',
      'fetch_surah_info',
      'get_surah_statistics',
      'analyze_word',
      'find_root_occurrences',
      'get_root_stats',
      'search_quran_text',
      'search_in_tafsir',
      'get_qeraat_variants',
      'get_quran_overview',
      'get_page_fawaed',
    };

    // أدوات alheekmah-mcp بأسمائها.
    const heekmahSearchTools = {
      'search_hadith',
      'search_aqeedah',
      'search_fiqh',
      'search_seerah',
      'search_all_sections',
      'fetch_passage',
    };

    // ربط كل تصنيف بالأقسام المناسبة في alheekmah-mcp.
    const sectionByCategory = {
      'hadith': 'search_hadith',
      'fiqh': 'search_fiqh',
      'aqeedah': 'search_aqeedah',
      'seerah': 'search_seerah',
    };

    // فلتر أدوات tafsir حسب التصنيف.
    final tafsirNames = <String>{};
    if (category == 'quran' || category == 'mixed') {
      tafsirNames.addAll(tafsirQuranTools);
    } else {
      // للأقسام غير القرآنية، نضيف فقط search_quran_text كداعم قرآني.
      tafsirNames.add('search_quran_text');
    }
    selected.addAll(_tafsirTools.where((t) => tafsirNames.contains(t.name)));

    // فلتر أدوات heekmah حسب التصنيف.
    if (HeekmahMcpClient.isConfigured && _heekmahTools.isNotEmpty) {
      final heekmahNames = <String>{};
      if (category == 'mixed') {
        heekmahNames.addAll(heekmahSearchTools); // كل أدوات البحث
      } else if (sectionByCategory.containsKey(category)) {
        heekmahNames.add(sectionByCategory[category]!); // أداة القسم المحدد
        heekmahNames.add('fetch_passage'); // لجلب النص الكامل
      } else if (category == 'quran') {
        // للقرآن، نضيف search_all_sections فقط كاحتياط.
        heekmahNames.add('search_all_sections');
      }
      selected.addAll(_heekmahTools.where((t) => heekmahNames.contains(t.name)));
    }

    return selected.map((t) => t.toOpenAiFunction()).toList();
  }

  // ─── تنفيذ الأدوات والتوجيه ──────────────────────────────────────

  /// ينفّذ أداة واحدة ويوجّهها للخادم الصحيح حسب اسمها.
  Future<String> _executeTool(LlmToolCall call) async {
    final source = _toolToSource[call.name];
    try {
      final McpToolResult result;
      if (source == _McpSource.heekmah) {
        result = await _heekmahMcp.callTool(call.name, call.arguments);
      } else {
        result = await _tafsirMcp.callTool(call.name, call.arguments);
      }
      if (result.isError) {
        return 'خطأ في تنفيذ الأداة ${call.name}: ${result.text}';
      }
      // sanitize مناسب حسب المصدر.
      if (source == _McpSource.tafsir) {
        return _sanitizeTafsirOutput(result.text);
      }
      final text = result.text.trim();
      return text.isEmpty ? 'assistantNoData'.tr : text;
    } catch (e) {
      return 'فشل استدعاء الأداة ${call.name}: $e';
    }
  }

  /// يفلتر الأنماط التقنية الخام من مخرجات tafsir-mcp.
  String _sanitizeTafsirOutput(String text) {
    var cleaned = text;
    const techPatterns = [
      'accordingtov2searchbyroot',
      'according_to_v2_search_by_root',
    ];
    for (final pattern in techPatterns) {
      cleaned = cleaned.replaceAll(pattern, '');
    }
    cleaned = cleaned.replaceAll(RegExp(r'[ \t]{3,}'), ' ').trim();
    return cleaned.isEmpty ? 'assistantNoData'.tr : cleaned;
  }

  /// ينظّف إجابة الـ LLM النهائية قبل عرضها للمستخدم.
  ///
  /// 1. يحوّل رموز الأسطر الجديدة الحرفية (`\n` و `\\n`) إلى أسطر جديدة فعلية.
  /// 2. يكشف وينظّف تسرب استدعاءات الأدوات كنص خام (بعض النماذج الضعيفة تكتب
  ///    `<tool_call>...` أو `<arg_key>...` داخل content بدل بنية tool_calls).
  String _cleanOutput(String content) {
    var cleaned = content;
    // حوّل `\\n` (escape sequence مزدوج) أولاً ثم `\n` المفردة.
    cleaned = cleaned.replaceAll('\\n', '\n');

    // كشف تسرب استدعاءات الأدوات كنص خام.
    // أنماط معروفة من النماذج الضعيفة:
    //   <tool_call>search_fiqh</tool_call>
    //   <arg_key>query</arg_key><arg_value>...</arg_value>
    //   <｜tool▁calls▁begin｜>... (نمط GLM الخام)
    final hasLeakedToolCall = cleaned.contains('<tool_call>') ||
        cleaned.contains('<arg_key>') ||
        cleaned.contains('<arg_value>') ||
        cleaned.contains('tool_calls_begin') ||
        cleaned.contains('<｜tool') ||
        cleaned.contains('<|tool');

    if (hasLeakedToolCall) {
      // النص مسرّب وغير صالح للعرض — استبدله برسالة واضحة.
      log('Detected leaked tool_call in content, replacing with error message',
          name: 'Unified');
      return 'assistantGenericError'.tr;
    }

    // احذف تكرار الأسطر الجديدة الفارغة الزائد عن اثنين (تنسيق Markdown نظيف).
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return cleaned.trim();
  }

  // ─── مساعدات ─────────────────────────────────────────────────────

  /// يترجم رسائل خطأ المزودين لرسائل مفهومة للمستخدم.
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

  /// يحوّل قائمة LlmToolCall إلى صيغة OpenAI.
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
