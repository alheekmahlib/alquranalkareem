part of '../ai_search.dart';

/// مصدر الأداة: أي خادم MCP يقدّمها.
enum _McpSource { tafsir, heekmah, seerah }

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
  final _seerahMcp = SeerahMcpClient();

  /// الحد الأقصى لعدد جولات استدعاء الأدوات.
  static const int maxIterations = 4;

  bool _isProcessing = false;

  /// خريطة: اسم الأداة → الخادم الذي يقدّمها (تُبنى بعد listTools).
  Map<String, _McpSource> _toolToSource = {};

  /// ذاكرات مؤقتة لأدوات كل خادم (تُبنى مرة واحدة بعد التهيئة).
  List<McpTool> _tafsirTools = const [];
  List<McpTool> _heekmahTools = const [];
  List<McpTool> _seerahTools = const [];

  /// يعالج رسالة المستخدم في المحادثة الموحَّدة.
  ///
  /// **المبدأ الجوهري (مكافحة التحريف):** النصوص المنقولة من الكتب (أحاديث،
  /// آيات، تفاسير، أقوال علماء) تُستخرج مباشرةً من نتائج MCP عبر [QuotationExtractor]
  /// وتُخزَّن كـ [Quotation] منفصلة. الـ LLM **لا يرى النصوص الكاملة إطلاقاً** —
  /// يرى فقط ملخصاً قصيراً (`llmSummary`) يصف ما وُجد. هذا يضمن نسخاً حرفياً
  /// بلا أي تحريف أو إعادة صياغة، بصرف النظر عن قوة النموذج أو التزامه بالتعليمات.
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

    // الاقتباسات المنقولة المجمَّعة من كل أدوات MCP (لا تمر عبر LLM).
    final collectedQuotations = <Quotation>[];

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
      log('Unified tools selected: ${selectedTools.length} for category "$category": '
          '${selectedTools.map((t) => (t['function'] as Map?)?['name'] ?? '?').join(', ')}',
          name: 'Unified');

      // 4) ابنِ سجل الرسائل (system موحَّد + history + الرسالة الجديدة).
      final messages = <Map<String, dynamic>>[
        UnifiedLlmService.systemMessage,
        ...state.assistantMessagesToOpenAi(),
        {'role': 'user', 'content': userText},
      ];

      // 5) حلقة tool calling.
      // استراتيجية الجولات (4 جولات فقط):
      // - الجولة 0: أجبر النموذج على البحث (forceToolUse + أدوات بحث فقط).
      // - الجولة 1: اتركه حرّاً (قد يطلب fetch_passage أو يصيغ الإجابة).
      // - الجولة 2+: لا أدوات (أجبره على صياغة الإجابة من النتائج المتاحة).
      // هذا يمنع تضييع الجولات في إعادة البحث بنفس الـ query.
      final searchOnlyTools = selectedTools
          .where((t) =>
              (t['function'] as Map?)?['name'] != 'fetch_passage')
          .toList();
      for (int iteration = 0; iteration < maxIterations; iteration++) {
        // بعد جولتين، أجبر النموذج على صياغة الإجابة (لا أدوات).
        final bool noTools = iteration >= 2;
        final List<Map<String, dynamic>> toolsForThisIteration;
        final bool forceThisIteration;
        if (noTools) {
          toolsForThisIteration = const [];
          forceThisIteration = false;
        } else if (iteration == 0) {
          toolsForThisIteration = searchOnlyTools;
          forceThisIteration = true;
        } else {
          toolsForThisIteration = selectedTools;
          forceThisIteration = false;
        }
        state.isAssistantThinking.value = true;
        final resp = await _llm.chatCompletion(
          messages: messages,
          tools: toolsForThisIteration,
          provider: provider,
          onFallback: onFallback,
          forceToolUse: forceThisIteration,
        );

        if (!resp.hasToolCalls) {
          // إجابة نهائية من الـ LLM (مقدمة/خلاصة فقط — لا نصوص منقولة).
          state.isAssistantThinking.value = false;
          state.currentToolName.value = '';
          final finalAnswer = _cleanOutput(resp.content);
          state.addAssistantMessage(
            finalAnswer,
            quotations: collectedQuotations,
          );
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
          // تحقق من أن الأداة موجودة فعلاً — بعض النماذج تخترع أسماء أدوات.
          if (!_toolToSource.containsKey(call.name)) {
            log('Unified: unknown tool "${call.name}" — skipping', name: 'Unified');
            messages.add({
              'role': 'tool',
              'tool_call_id': call.id,
              'content': 'هذه الأداة غير متاحة. الأدوات المتاحة هي: '
                  '${_toolToSource.keys.join(', ')}. استخدم إحداها أو أجب من النتائج المتاحة.',
            });
            continue;
          }
          state.currentToolName.value = call.name;
          final rawResult = await _executeTool(call, category);
          log('Unified tool result: ${call.name}(${call.arguments}) → '
              '${rawResult.length} chars: ${rawResult.substring(0, rawResult.length.clamp(0, 100))}',
              name: 'Unified');

          // ─── قلب مكافحة التحريف ───
          // استخرج الاقتباسات المنقولة من نتيجة MCP. هذه الاقتباسات تُخزَّن
          // منفصلةً ولا تُمرَّر للـ LLM إطلاقاً (تُعرض للمستخدم مباشرةً في بطاقات).
          final source = _toolToSource[call.name] ?? _McpSource.tafsir;
          final extraction = QuotationExtractor.extract(
            toolResult: rawResult,
            toolName: call.name,
            source: source,
          );
          collectedQuotations.addAll(extraction.quotations);
          log('Unified: extracted ${extraction.quotations.length} quotations from "${call.name}" '
              '(LLM sees summary: ${extraction.llmSummary.length} chars, not full text)',
              name: 'Unified');

          // مرّر للـ LLM الملخص الآمن فقط (لا النص الكامل) — هذا يمنع إعادة الصياغة.
          messages.add({
            'role': 'tool',
            'tool_call_id': call.id,
            'content': extraction.llmSummary,
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
      final fallbackAnswer = finalResp.content.isNotEmpty
          ? _cleanOutput(finalResp.content)
          : 'assistantNoFinalAnswer'.tr;
      state.addAssistantMessage(
        fallbackAnswer,
        quotations: collectedQuotations,
      );
    } on LlmException catch (e) {
      // حتى عند خطأ الـ LLM، اعرض الاقتباسات المجمَّعة إن وُجدت.
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      if (collectedQuotations.isNotEmpty) {
        // اعرض النصوص المنقولة مباشرةً مع تنبيه لخطأ الصياغة.
        state.addAssistantMessage(
          'assistantQuotationsOnly'.tr,
          quotations: collectedQuotations,
        );
      } else {
        state.assistantError.value = _translateLlmError(e.message);
      }
      log('LLM error: ${e.message}', name: 'Unified');
    } on McpException catch (e) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      state.assistantError.value = 'assistantMcpError'.tr;
      log('MCP error: ${e.message}', name: 'Unified');
    } catch (e, stack) {
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      // عند خطأ غير متوقع، اعرض الاقتباسات إن وُجدت كذلك.
      if (collectedQuotations.isNotEmpty) {
        state.addAssistantMessage(
          'assistantQuotationsOnly'.tr,
          quotations: collectedQuotations,
        );
      } else {
        state.assistantError.value = 'assistantUnexpectedError'.tr;
      }
      log('Unified orchestrator error: $e\n$stack', name: 'Unified');
    } finally {
      _isProcessing = false;
    }
  }

  // ─── التهيئة وخريطة الأدوات ──────────────────────────────────────

  /// يهيّئ كل الخوادم ويتأكد أن قوائم الأدوات محمّلة.
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
    // SeerahMcpClient على حساب منفصل — نتسامح مع فشله أيضاً.
    try {
      await _seerahMcp.ensureInitialized();
    } catch (e) {
      log('Seerah MCP unavailable (endpoint may be empty): $e',
          name: 'Unified');
    }
    _tafsirTools = _tafsirMcp.tools;
    _heekmahTools = _heekmahMcp.tools;
    _seerahTools = _seerahMcp.tools;
  }

  /// يبني خريطة (اسم الأداة → الخادم) من قوائم الأدوات.
  ///
  /// **مهم:** خادما heekmah و seerah يتشاركان نفس أسماء الأدوات
  /// (`search_all_sections`, `search_fiqh`, `search_hadith`, `search_aqeedah`,
  /// `fetch_passage`)، لكنهما مختلفان في البيانات:
  /// - heekmah: يحوي الفقه والحديث والعقيدة (والسيرة جزئياً).
  /// - seerah: يحوي السيرة والتاريخ فقط (128K صف).
  ///
  /// قاعدة التوجيه:
  /// - `search_seerah` → خادم seerah.
  /// - كل الأدوات الأخرى (search_all_sections, search_fiqh, search_hadith,
  ///   search_aqeedah, fetch_passage) → خادم heekmah (له الأولوية لأنه شامل).
  ///
  /// لو مررنا بالعكس، ستُرسل أسئلة الفقه لخادم seerah الذي يحوي سيرة فقط!
  void _buildToolMap() {
    _toolToSource = {};
    for (final t in _tafsirTools) {
      _toolToSource[t.name] = _McpSource.tafsir;
    }
    // heekmah أولاً (له الأولوية للأدوات المشتركة لأنه شامل).
    for (final t in _heekmahTools) {
      _toolToSource[t.name] = _McpSource.heekmah;
    }
    // seerah: فقط `search_seerah` تُوجَّه لخادم السيرة.
    // الأدوات الأخرى (search_all_sections, search_fiqh, ...) تبقى على heekmah.
    for (final t in _seerahTools) {
      if (t.name == 'search_seerah') {
        _toolToSource[t.name] = _McpSource.seerah;
      }
      // باقي أدوات seerah (search_all_sections, search_fiqh, ...) لا نستبدلها —
      // تبقى موجّهة لـ heekmah من الحلقة السابقة.
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

  /// يختار الأدوات المناسبة للتصنيف من كل الخوادم.
  ///
  /// **مبدأ التصميم:**
  /// - أدوات tafsir-mcp تُضاف **دائماً** لكل التصنيفات، لأن المستخدم قد يحتاج
  ///   آية قرآنية أو سبب نزولها أو تفسيرها في أي سياق (حتى في سؤال فقهي قد يُستدل
  ///   بآية). أدوات tafsir فريدة الأسماء ولا تتعارض مع أدوات heekmah/seerah.
  /// - أدوات heekmah (`search_all_sections`, `fetch_passage`) للأقسام الشرعية.
  /// - `search_seerah` للسيرة.
  ///
  /// **مهم:** لو أضفنا tafsir فقط لـ `quran`، فلن يستطيع الـ LLM جلب آية أو
  /// سبب نزولها عند سؤال مُصنَّف `mixed` أو `fiqh` (مثل «سبب نزول آية كذا»).
  List<Map<String, dynamic>> _selectToolsForCategory(String category) {
    final selected = <McpTool>[];

    // أدوات tafsir-mcp تُضاف دائماً (آيات، تفاسير، أسباب نزول، إعراب، إحصاءات).
    // هي فريدة الأسماء ولا تتعارض مع أدوات الأقسام الشرعية.
    selected.addAll(_tafsirTools);

    switch (category) {
      case 'quran':
        // القرآن: أدوات tafsir كافية (أُضيفت أعلاه) — لا حاجة لأدوات الأقسام.
        break;

      case 'hadith':
      case 'fiqh':
      case 'aqeedah':
        // قسم شرعي محدد: search_all_sections (موثوقة) + fetch_passage.
        // الفلترة بقسم تتم جهة العميل في _executeTool (حقل «القسم» في كل نتيجة).
        if (HeekmahMcpClient.isConfigured) {
          selected.addAll(
              _heekmahTools.where((t) => t.name == 'search_all_sections'));
          selected.addAll(
              _heekmahTools.where((t) => t.name == 'fetch_passage'));
        }
        break;

      case 'seerah':
        // السيرة: search_seerah من خادم السيرة المنفصل (128K صف وحدها) + fetch_passage.
        // fallback لـ search_all_sections إن لم يكن خادم السيرة مهيّأً.
        if (SeerahMcpClient.isConfigured && _seerahTools.isNotEmpty) {
          selected.addAll(_seerahTools.where((t) =>
              t.name == 'search_seerah' || t.name == 'fetch_passage'));
        } else if (HeekmahMcpClient.isConfigured) {
          selected.addAll(_heekmahTools.where((t) =>
              t.name == 'search_all_sections' || t.name == 'fetch_passage'));
        }
        break;

      case 'mixed':
      default:
        // mixed: search_all_sections + fetch_passage + search_seerah.
        // أدوات tafsir أُضيفت أعلاه دائماً.
        if (HeekmahMcpClient.isConfigured) {
          selected.addAll(
              _heekmahTools.where((t) => t.name == 'search_all_sections'));
          selected.addAll(
              _heekmahTools.where((t) => t.name == 'fetch_passage'));
        }
        if (SeerahMcpClient.isConfigured && _seerahTools.isNotEmpty) {
          selected.addAll(
              _seerahTools.where((t) => t.name == 'search_seerah'));
        }
        break;
    }

    return selected.map((t) => t.toOpenAiFunction()).toList();
  }

  // ─── تنفيذ الأدوات والتوجيه ──────────────────────────────────────

  /// ينفّذ أداة واحدة ويوجّهها للخادم الصحيح حسب اسمها.
  ///
  /// [category] = تصنيف السؤال (fiqh/hadith/aqeedah/seerah/...)، يُستخدم لفلترة
  /// نتائج `search_all_sections` حسب القسم لمنع ظهور نصوص من أقسام غير مرتبطة.
  Future<String> _executeTool(LlmToolCall call, String category) async {
    final source = _toolToSource[call.name];
    try {
      final McpToolResult result;
      if (source == _McpSource.seerah) {
        result = await _seerahMcp.callTool(call.name, call.arguments);
      } else if (source == _McpSource.heekmah) {
        result = await _heekmahMcp.callTool(call.name, call.arguments);
      } else {
        result = await _tafsirMcp.callTool(call.name, call.arguments);
      }
      if (result.isError) {
        return 'خطأ في تنفيذ الأداة ${call.name}: ${result.text}';
      }

      var text = result.text.trim();

      // فلترة جهة العميل: لو الأداة search_all_sections والتصنيف محدد (fiqh/hadith/...)،
      // احذف النتائج التي قسمها لا يطابق التصنيف. هذا يمنع ظهور نتائج السيرة
      // مثلاً في سؤال فقهي، رغم أن search_all_sections تبحث في كل الأقسام.
      // كل نتيجة تحوي سطراً مثل: «| القسم: الفقه» أو «| القسم: الحديث».
      if (call.name == 'search_all_sections' && source == _McpSource.heekmah) {
        text = _filterResultsBySection(text, category);
      }

      // sanitize مناسب حسب المصدر.
      String finalText;
      if (source == _McpSource.tafsir) {
        finalText = _sanitizeTafsirOutput(result.text);
      } else {
        finalText = text.isEmpty ? 'assistantNoData'.tr : text;
      }

      return finalText;
    } catch (e) {
      return 'فشل استدعاء الأداة ${call.name}: $e';
    }
  }

  /// يفلتر نتائج `search_all_sections` لتبقى فقط نتائج القسم المطلوب.
  ///
  /// كل نتيجة في الـ Markdown تحوي سطراً مثل:
  /// `المصدر: ... | المؤلف: ... | المرجع: ... | القسم: الفقه`
  /// نحذف النتائج التي قسمها لا يطابق التصنيف المطلوب.
  /// للتصنيف `mixed` أو غير الشرعي، نُبقي كل النتائج.
  String _filterResultsBySection(String text, String category) {
    // خريطة: التصنيف → الكلمة المفتاحية للقسم كما تظهر في النتائج.
    const sectionKeywords = {
      'fiqh': 'فقه',
      'hadith': 'حديث',
      'aqeedah': 'عقيد',
      'seerah': 'سير',
    };
    final keyword = sectionKeywords[category];
    if (keyword == null) {
      // mixed أو quran — لا فلترة.
      return text;
    }

    // قسّم النتائج على «### النتيجة» وافحص حقل القسم في كل كتلة.
    final blocks = text.split(RegExp(r'(?=^###\s+النتيجة\s+\d+)', multiLine: true));
    // نمط مطابقة حقل القسم: يدعم صيغاً متعددة «القسم:» و«التصنيف:» و«section:».
    final sectionPattern = RegExp(
      '(?:القسم|التصنيف|section)\\s*:\\s*[^|\\n]*' + RegExp.escape(keyword),
      caseSensitive: false,
    );
    final kept = <String>[];
    for (final block in blocks) {
      if (block.trim().isEmpty) continue;
      // هل الكتلة تحوي «القسم: <keyword>»؟
      if (sectionPattern.hasMatch(block)) {
        kept.add(block);
      }
    }

    if (kept.isEmpty) {
      // لا نتائج في القسم المطلوب — أعد رسالة واضحة، لا النص الأصلي بكل النتائج.
      // هذا يمنع إغراق المستخدم بنتائج من أقسام خاطئة عند فشل الفلترة.
      log('Unified: no results matched section "$keyword" '
          '(${blocks.where((b) => b.trim().isNotEmpty).length} results filtered out)',
          name: 'Unified');
      return 'لا توجد نتائج في قسم $category لهذا الاستعلام.';
    }

    // أعد بناء النص: الترويسة + النتائج المفلترة.
    final headerMatch = RegExp(r'^[\s\S]*?(?=###\s+النتيجة\s+\d+|$)').firstMatch(text);
    final header = headerMatch?.group(0)?.trim() ?? '';
    final countLine = 'وجدت ${kept.length} نتيجة بعد الفلترة حسب القسم.\n\n';
    return header.isEmpty ? countLine + kept.join('\n') : '$header\n$countLine${kept.join('\n')}';
  }

  /// ينسّق نتيجة أداة طويلة لعرض مباشر دون LLM.
  ///
  /// **مهجور** — بعد إعادة الهيكلة، الاستخراج يتم عبر [QuotationExtractor]
  /// والاقتباسات تُعرض كـ [Quotation] منفصلة، لا كنص مدمج. هذه الدالة
  /// محفوظة مؤقتاً للتوافق الخلفي فقط لكنها لم تُعد تُستدعى.
  // ignore: unused_element
  String _formatDirectResult(String result, String toolName) {
    // تفويض لـ QuotationExtractor ثم تنسيق بسيط للعرض المباشر الاحتياطي.
    final extraction = QuotationExtractor.extract(
      toolResult: result,
      toolName: toolName,
      source: _McpSource.tafsir,
    );
    if (extraction.quotations.isEmpty) {
      return extraction.rawText.isEmpty ? 'assistantNoData'.tr : extraction.rawText;
    }
    final parts = <String>[];
    for (final q in extraction.quotations) {
      if (q.attribution != null) parts.add('**المصدر:** ${q.attribution}\n\n');
      parts.add(q.text);
    }
    return '${parts.join('\n\n---\n\n')}\n\n---\nلطرح أسئلة حول هذا النص، اكتب سؤالك.';
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

  /// ينظّف إجابة الـ LLM النهائية (المقدمة/الخلاصة فقط) قبل عرضها.
  ///
  /// **هام:** هذه الدالة تُطبَّق فقط على نص الـ LLM (الذي يرى ملخصات، لا النصوص
  /// المنقولة). النصوص المنقولة من الكتب لا تمر عبرها إطلاقاً — هي محفوظة في
  /// [Quotation] منفصلة وتُعرض كاملةً كما هي. لذا التنظيف هنا خفيف وآمن.
  ///
  /// 1. يحوّل رموز الأسطر الجديدة الحرفية (`\n` و `\\n`) إلى أسطر جديدة فعلية.
  /// 2. يكشف تسرب استدعاءات الأدوات كنص خام (يعيد رسالة خطأ).
  /// 3. يصلح المصطلحات الإنجليزية الشائعة (Source → المصدر).
  String _cleanOutput(String content) {
    var cleaned = content;
    // حوّل `\\n` (escape sequence مزدوج) أولاً ثم `\n` المفردة.
    cleaned = cleaned.replaceAll('\\n', '\n');

    // كشف تسرب استدعاءات الأدوات كنص خام.
    final hasLeakedToolCall = cleaned.contains('<tool_call>') ||
        cleaned.contains('<arg_key>') ||
        cleaned.contains('<arg_value>') ||
        cleaned.contains('tool_calls_begin') ||
        cleaned.contains('<｜tool') ||
        cleaned.contains('<|tool');

    if (hasLeakedToolCall) {
      log('Detected leaked tool_call in content, replacing with error message',
          name: 'Unified');
      return 'assistantGenericError'.tr;
    }

    // كشف الإخراج المشوه (JSON خام مسرّب).
    final trimmed = cleaned.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      log('Detected leaked JSON in content, replacing with error message',
          name: 'Unified');
      return 'assistantGenericError'.tr;
    }
    // كشف النص القصير المشوه (أقل من 20 حرف ولا يحوي جملة عربية مفيدة).
    if (trimmed.length < 15 && trimmed.contains('"')) {
      log('Detected malformed output: $trimmed', name: 'Unified');
      return 'assistantGenericError'.tr;
    }

    // أصلح المصطلحات الإنجليزية الشائعة التي يكتبها بعض النماذج.
    cleaned = cleaned.replaceAll('-Source:', '-المصدر:');
    cleaned = cleaned.replaceAll('Source:', 'المصدر:');
    cleaned = cleaned.replaceAll('**Source**', '**المصدر**');
    cleaned = cleaned.replaceAll('-Source\n', '-المصدر\n');

    // احذف أي روابط (URLs) تتسلل لإجابة المساعد — لا مكان لها في المقدمة.
    cleaned = cleaned.replaceAll(RegExp(r'https?://\S+'), '').trim();
    // احذف أسطراً تحتوي فقط على رابط (بعد حذف الرابط قد تبقى أسطر فارغة/نقاط).
    // احذف اسم التطبيق إن تسلّل لإجابة المساعد (النموذج يضيفه أحياناً).
    cleaned = cleaned
        .replaceAll('القرآن الكريم - مكتبة الحكمة', '')
        .replaceAll('مكتبة الحكمة', '')
        .trim();

    // احذف تكرار الأسطر الجديدة الفارغة الزائد عن اثنين (تنسيق Markdown نظيف).
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return cleaned.trim();
  }

  /// يفحص الإجابة النهائية ويحذف الأحاديث/الآيات المختلقة.
  ///
  /// **معطّل ومهجور** — بعد إعادة الهيكلة، الـ LLM لا يرى النصوص المنقولة إطلاقاً
  /// (يرى ملخصات فقط)، فلا يمكنه اختلاق أحاديث أو إعادة صياغتها. الاقتباسات
  /// تؤخذ مباشرة من MCP كـ [Quotation]. هذه الدوال محفوظة للتوافق الخلفي فقط.
  // ignore: unused_element
  String _filterFabricatedContent(String answer, String toolResults) => answer;

  // ignore: unused_element
  String _normalizeForCompare(String text) => text;

  // ignore: unused_element
  String _extractCoreQuote(String line) => line;

  /// يقصّ النصوص الطويلة لأجزاء صغيرة (~1000 حرف).
  ///
  /// **معطّل ومهجور** — بعد إعادة الهيكلة، النصوص الطويلة تُستخرج بالكامل
  /// كـ [Quotation] وتُعرض مباشرة دون أي تقسيم أو تمرير للـ LLM.
  // ignore: unused_element
  String _chunkLongText(String text) => text;

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
