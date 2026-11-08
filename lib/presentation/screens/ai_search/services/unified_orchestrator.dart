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
///   1. يصنّف السؤال في جولة LLM خفيفة (لا أدوات) → مجال واحد.
///   2. يرفض فوراً (رسالة ثابتة، لا أدوات ولا بحث) إن كان السؤال طائفياً
///      (مذهب الشيعة) أو خارج العلوم الإسلامية كلياً.
///   3. يهيّئ الخوادم ويبني خريطة (اسم الأداة → الخادم)، ويختار الأدوات
///      المناسبة فقط للتصنيف.
///   4. حلقة tool calling (مثل AssistantOrchestrator) لكن _executeTool يوجّه للخادم الصحيح.
class UnifiedOrchestrator {
  UnifiedOrchestrator();

  final _llm = LlmService();
  final _tafsirMcp = TafsirMcpClient();
  final _heekmahMcp = HeekmahMcpClient();
  final _seerahMcp = SeerahMcpClient();

  /// الحد الأقصى لعدد جولات استدعاء الأدوات.
  static const int maxIterations = 4;

  /// رفض ثابت للأسئلة الطائفية (تصنيف `sectarian`) — لا يُولَّد من الـ LLM
  /// لضمان رفض نظيف لا ينهار في حلقات تكرار مع النماذج الصغيرة.
  /// المساعد عربي فقط بتصميمه، لذا النص ثابت بالعربية كسائر نصوص المساعد.
  static const String _sectarianRefusal =
      'هذا السؤال يتعلق بمذهب الشيعة، وهو مذهب خارج عن ملّة الإسلام، '
      'ولذلك فهو خارج نطاق هذا المساعد المختص بالعلوم الإسلامية.\n\n'
      'يسعدني خدمتك في القرآن الكريم والحديث الشريف والفقه والعقيدة والسيرة النبوية، '
      'وفي فضائل الصحابة وآل البيت رضي الله عنهم.';

  /// رفض ثابت للأسئلة الخارجة عن العلوم الإسلامية (تصنيف `off_topic`).
  static const String _offTopicRefusal =
      'أنا مساعد متخصص في العلوم الإسلامية (القرآن والحديث والفقه والعقيدة والسيرة)، '
      'وهذا السؤال خارج نطاق تخصصي.\n\n'
      'يسعدني خدمتك في أي موضوع إسلامي.';

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
    bool Function()? isCurrent,
  }) async {
    bool active() => isCurrent?.call() ?? true;
    if (_isProcessing) return;
    if (userText.trim().isEmpty) return;
    _isProcessing = true;

    state.assistantError.value = '';
    state.isAssistantThinking.value = true;
    state.currentToolName.value = '';

    // الاقتباسات المنقولة المجمَّعة من كل أدوات MCP (لا تمر عبر LLM).
    final collectedQuotations = <Quotation>[];

    try {
      // 1) تصنيف خفيف للسؤال (جولة LLM واحدة بلا أدوات) — يسبق تهيئة الخوادم
      // حتى يُرفض السؤال الخارج عن النطاق فوراً دون مصافحة MCP أو بحث.
      final provider = state.selectedProvider.value;
      final history = state.assistantMessagesToOpenAi();
      final category = await _classify(
        userText,
        provider,
        onFallback,
        history.take(history.length - 1).toList(),
      );
      if (!active()) return;
      log('Unified category: $category', name: 'Unified');

      // 2) رفض فوري للأسئلة الخارجة عن نطاق المساعد — برسالة ثابتة لا تُولَّد
      // من الـ LLM (تمنع انهيارات التكرار)، ودون أي بحث في المكتبة:
      // - sectarian: أسئلة مذهب الشيعة وخلافاته الطائفية.
      // - off_topic: ما ليس من العلوم الإسلامية أصلاً.
      if (category == 'sectarian' || category == 'off_topic') {
        state.isAssistantThinking.value = false;
        state.addAssistantMessage(
          category == 'sectarian' ? _sectarianRefusal : _offTopicRefusal,
        );
        return;
      }

      // 3) تأكد من تهيئة كلا الخادمين + بناء خريطة الأدوات.
      await _ensureAllInitialized();
      if (!active()) return;
      _buildToolMap();

      // 4) اختيار الأدوات المناسبة بناءً على التصنيف.
      // Passage IDs are scoped to their MCP server; let the UI fetch them
      // with an explicit source instead of accepting an ambiguous model call.
      final selectedTools = _selectToolsForCategory(category)
          .where(
            (tool) => (tool['function'] as Map?)?['name'] != 'fetch_passage',
          )
          .toList();
      // ابنِ مجموعة بأسماء الأدوات المختارة فعلاً — تُستخدم للتحقق من استدعاءات
      // الـ LLM لمنع تنفيذ أدوات لم تُعرَض عليه (بعض النماذج تهلوس أسماء أدوات).
      final selectedToolNames = selectedTools
          .map((t) => (t['function'] as Map?)?['name'] as String?)
          .whereType<String>()
          .toSet();
      log(
        'Unified tools selected: ${selectedTools.length} for category "$category": '
        '${selectedTools.map((t) => (t['function'] as Map?)?['name'] ?? '?').join(', ')}',
        name: 'Unified',
      );

      // 5) ابنِ سجل الرسائل (system موحَّد + history + الرسالة الجديدة).
      // نستخدم var (لا final) لأن الجولات بلا أدوات تستبدل القائمة بنسخة منظَّفة.
      var messages = <Map<String, dynamic>>[
        UnifiedLlmService.systemMessage,
        ...state.assistantMessagesToOpenAi(),
      ];

      // 6) حلقة tool calling.
      // استراتيجية الجولات (4 جولات فقط):
      // - الجولة 0: أجبر النموذج على البحث (forceToolUse + أدوات بحث فقط).
      // - الجولة 1: اتركه حرّاً (قد يطلب fetch_passage أو يصيغ الإجابة).
      // - الجولة 2+: لا أدوات (أجبره على صياغة الإجابة من النتائج المتاحة).
      // هذا يمنع تضييع الجولات في إعادة البحث بنفس الـ query.
      final searchOnlyTools = selectedTools
          .where((t) => (t['function'] as Map?)?['name'] != 'fetch_passage')
          .toList();
      for (int iteration = 0; iteration < maxIterations; iteration++) {
        // بعد جولتين، أجبر النموذج على صياغة الإجابة (لا أدوات).
        final bool noTools = iteration >= 2;
        final List<Map<String, dynamic>> toolsForThisIteration;
        final bool forceThisIteration;
        if (noTools) {
          toolsForThisIteration = const [];
          forceThisIteration = false;
          // نظّف السياق قبل الجولات بلا أدوات: انزع رسائل role:tool وحقول tool_calls.
          // هذا يمنع النموذج من رؤية سياق تناقضي ("كنت أستدعي أدوات والآن لا أدوات")
          // فيهلوس استدعاءات أدوات كنص خام (<invoke name=...>).
          messages = _sanitizeMessagesForFinalAnswer(messages);
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
          provider: state.selectedProvider.value,
          onFallback: onFallback,
          forceToolUse: forceThisIteration,
        );

        if (!active()) return;
        if (!resp.hasToolCalls) {
          // إجابة نهائية من الـ LLM (مقدمة/خلاصة فقط — لا نصوص منقولة).
          state.isAssistantThinking.value = false;
          state.currentToolName.value = '';
          final finalAnswer = collectedQuotations.isEmpty
              ? 'لم أعثر على نصوص موثقة كافية للإجابة عن سؤالك.'
              : 'إليك النصوص التي عُثر عليها في المصادر المتاحة:';
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
          // تحقق من أن الأداة مُختارة فعلاً لهذا التصنيف — بعض النماذج
          // تهلوس أسماء أدوات لم تُعرَض عليها (مثل search_all_sections لسؤال
          // عن راوٍ). نتحقق من selectedToolNames وليس _toolToSource العام.
          if (!selectedToolNames.contains(call.name)) {
            log(
              'Unified: tool "${call.name}" not in selected set for '
              'category "$category" — skipping',
              name: 'Unified',
            );
            messages.add({
              'role': 'tool',
              'tool_call_id': call.id,
              'content':
                  'هذه الأداة غير متاحة لهذا النوع من الأسئلة. '
                  'الأدوات المتاحة هي: ${selectedToolNames.join(', ')}. '
                  'استخدم إحداها أو أجب من النتائج المتاحة.',
            });
            continue;
          }
          state.currentToolName.value = call.name;
          final rawResult = await _executeTool(call, category);
          if (!active()) return;
          log(
            'Unified tool result: ${call.name}, ${rawResult.length} chars',
            name: 'Unified',
          );

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
          log(
            'Unified: extracted ${extraction.quotations.length} quotations from "${call.name}" '
            '(LLM sees summary: ${extraction.llmSummary.length} chars, not full text)',
            name: 'Unified',
          );

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
      await _llm.chatCompletion(
        messages: messages,
        tools: const [],
        provider: state.selectedProvider.value,
        onFallback: onFallback,
      );
      if (!active()) return;
      state.isAssistantThinking.value = false;
      final fallbackAnswer = collectedQuotations.isEmpty
          ? 'لم أعثر على نصوص موثقة كافية للإجابة عن سؤالك.'
          : 'إليك النصوص التي عُثر عليها في المصادر المتاحة:';
      state.addAssistantMessage(
        fallbackAnswer,
        quotations: collectedQuotations,
      );
    } on LlmException catch (e) {
      if (!active()) return;
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
      if (!active()) return;
      state.isAssistantThinking.value = false;
      state.currentToolName.value = '';
      if (collectedQuotations.isNotEmpty) {
        state.addAssistantMessage(
          'تعذر إكمال البحث. النصوص المتاحة:',
          quotations: collectedQuotations,
        );
      } else {
        state.assistantError.value = 'assistantMcpError'.tr;
      }
      log('MCP error: ${e.message}', name: 'Unified');
    } catch (e, stack) {
      if (!active()) return;
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
      log(
        'Heekmah MCP unavailable (endpoint may be empty): $e',
        name: 'Unified',
      );
    }
    // SeerahMcpClient على حساب منفصل — نتسامح مع فشله أيضاً.
    try {
      await _seerahMcp.ensureInitialized();
    } catch (e) {
      log(
        'Seerah MCP unavailable (endpoint may be empty): $e',
        name: 'Unified',
      );
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
      if (t.name == 'search_narrator') {
        _toolToSource[t.name] = _McpSource.seerah;
      }
    }
  }

  // ─── التصنيف المسبق ──────────────────────────────────────────────

  /// يصنّف سؤال المستخدم في جولة LLM خفيفة (لا أدوات، لا تاريخ).
  /// يرجع أحد: quran, hadith, fiqh, aqeedah, seerah, narrator, mixed,
  /// sectarian, off_topic.
  ///
  /// الفئتان الأخيرتان تؤديان لرفض فوري برسالة ثابتة في [handleUserMessage]:
  /// - `sectarian`: أي سؤال يخص مذهب الشيعة (عقائده، خلافاته، مقارناته، شبهاته).
  /// - `off_topic`: ما ليس من العلوم الإسلامية أصلاً (رياضيات، برمجة، ترفيه...).
  Future<String> _classify(
    String userText,
    LlmProvider provider,
    void Function(LlmProvider)? onFallback,
    List<Map<String, dynamic>> history,
  ) async {
    const validCategories = [
      'quran',
      'hadith',
      'fiqh',
      'aqeedah',
      'seerah',
      'narrator',
      'mixed',
      'sectarian',
      'off_topic',
    ];
    try {
      final resp = await _llm.chatCompletion(
        messages: [
          {
            'role': 'system',
            'content':
                'صنّف سؤال المستخدم في مجال واحد فقط، '
                'وأرجع كلمة واحدة فقط بالإنجليزية من القائمة التالية:\n'
                '- quran: القرآن والتفسير والإعراب والصرف والقراءات وأسباب النزول والإحصاءات.\n'
                '- hadith: الحديث الشريف وأسانيده.\n'
                '- fiqh: الأحكام الفقهية والعبادات والمعاملات.\n'
                '- aqeedah: العقيدة والإيمان والتوحيد وأسماء الله وصفاته.\n'
                '- seerah: السيرة النبوية والتاريخ الإسلامي والغزوات.\n'
                '- narrator: السؤال عن راوٍ حديث بالاسم، أو معلومات عن صحابي أو تابعي أو عالم الحديث.\n'
                '- mixed: يشمل أكثر من مجال إسلامي مما سبق.\n'
                '- sectarian: أي سؤال يخص مذهب الشيعة: عقائده أو فرقه أو دعاواه أو '
                'خلافاته مع أهل السنة أو المقارنة بينهما أو الرد على شبهاته، '
                'ومنها مسائل الإمامة ومن الأحق بالخلافة. أي ذكر للشيعة أو الرافضة '
                'أو الإمامية أو الاثني عشرية أو التشيع يجعل السؤال sectarian '
                'حتى لو تضمن جزءاً إسلامياً.\n'
                '- off_topic: ما ليس من العلوم الإسلامية أصلاً: رياضيات، علوم '
                'دنيوية، برمجة، رياضة، ترفيه، سياسة، أسئلة شخصية عامة، أو سؤال '
                'عن ديانة أو طائفة أخرى غير الإسلام.\n\n'
                'تنبيه مهم: علي بن أبي طالب وآل البيت والصحابة رضي الله عنهم '
                'مسلمون جليلون لا صلة لهم بمذهب الشيعة — أسئلة فضائلهم وسيرتهم '
                'وعلمهم ليست sectarian بل seerah أو narrator أو aqeedah.\n\n'
                'أمثلة:\n'
                '- «هل علي بن أبي طالب أحق بالخلافة من أبو بكر الصديق؟» → sectarian\n'
                '- «ما الفرق بين أهل السنة والشيعة؟» → sectarian\n'
                '- «كيف نرد على شبهة الشيعة في مسألة كذا؟» → sectarian\n'
                '- «ما فضائل علي بن أبي طالب؟» → seerah\n'
                '- «من هم العشرة المبشرون بالجنة؟» → narrator\n'
                '- «كم ناتج اثنين ضرب ثمانية؟» → off_topic\n'
                '- «ما حكم الصلاة في الثوب النجس؟» → fiqh\n'
                'صنّف الرسالة الأخيرة مستعيناً بالسياق السابق عند الحاجة. أرجع الكلمة فقط دون أي شرح.',
          },
          ...history,
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
      log('Classification failed, falling back to mixed: $e', name: 'Unified');
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

    // أدوات tafsir-mcp تُضاف دائماً (آيات، تفاسير، أسباب نزول، إعراب، إحصاءات)
    // **باستثناء** narrator — البحث عن راوٍ لا يحتاج آيات/تفاسير، وإتاحتها
    // قد يُغرى الـ LLM باستدعائها وإضافة نتائج غير مرتبطة.
    if (category != 'narrator') {
      selected.addAll(_tafsirTools);
    }

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
            _heekmahTools.where((t) => t.name == 'search_all_sections'),
          );
          selected.addAll(
            _heekmahTools.where((t) => t.name == 'fetch_passage'),
          );
        }
        break;

      case 'seerah':
        // السيرة: search_seerah من خادم السيرة المنفصل (128K صف وحدها) + fetch_passage.
        // fallback لـ search_all_sections إن لم يكن خادم السيرة مهيّأً.
        if (SeerahMcpClient.isConfigured && _seerahTools.isNotEmpty) {
          selected.addAll(
            _seerahTools.where(
              (t) => t.name == 'search_seerah' || t.name == 'fetch_passage',
            ),
          );
        } else if (HeekmahMcpClient.isConfigured) {
          selected.addAll(
            _heekmahTools.where(
              (t) =>
                  t.name == 'search_all_sections' || t.name == 'fetch_passage',
            ),
          );
        }
        break;

      case 'narrator':
        // الرواة: search_narrator من خادم السيرة (42K راوي).
        if (SeerahMcpClient.isConfigured && _seerahTools.isNotEmpty) {
          selected.addAll(
            _seerahTools.where((t) => t.name == 'search_narrator'),
          );
        }
        break;

      case 'mixed':
      default:
        // mixed: search_all_sections + fetch_passage + search_seerah.
        // أدوات tafsir أُضيفت أعلاه دائماً.
        if (HeekmahMcpClient.isConfigured) {
          selected.addAll(
            _heekmahTools.where((t) => t.name == 'search_all_sections'),
          );
          selected.addAll(
            _heekmahTools.where((t) => t.name == 'fetch_passage'),
          );
        }
        if (SeerahMcpClient.isConfigured && _seerahTools.isNotEmpty) {
          selected.addAll(_seerahTools.where((t) => t.name == 'search_seerah'));
          // أضف search_narrator لـ mixed أيضاً — قد يشمل السؤال راوياً.
          selected.addAll(
            _seerahTools.where((t) => t.name == 'search_narrator'),
          );
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
        throw McpException('فشل تنفيذ الأداة ${call.name}');
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
        finalText = text;
      }

      return finalText;
    } catch (e) {
      throw McpException('فشل استدعاء الأداة ${call.name}: $e');
    }
  }

  /// يجلب النص الكامل لقطعة من خادم heekmah أو seerah عبر `fetch_passage`.
  ///
  /// يُستدعى من زر "عرض النص الكامل" في [QuotationCard] عند توفّر [Quotation.passageId].
  /// يُعيد النص الكامل المنظَّف، أو null عند الفشل.
  /// يجرب heekmah أولاً (لأنه الشامل)، ثم seerah كـ fallback.
  Future<String?> fetchFullPassage(
    QuotationSource source,
    int passageId,
  ) async {
    // Do not guess a different database: IDs can overlap across servers.
    if (source == QuotationSource.heekmah && HeekmahMcpClient.isConfigured) {
      return _tryFetchPassage(passageId, _McpSource.heekmah);
    }
    if (source == QuotationSource.seerah && SeerahMcpClient.isConfigured) {
      return _tryFetchPassage(passageId, _McpSource.seerah);
    }
    return null;
  }

  /// محاولة جلب قطعة من خادم محدد. يعيد null عند الفشل.
  Future<String?> _tryFetchPassage(int passageId, _McpSource source) async {
    try {
      final McpToolResult result;
      if (source == _McpSource.seerah) {
        await _seerahMcp.ensureInitialized();
        result = await _seerahMcp.callTool('fetch_passage', {'id': passageId});
      } else {
        await _heekmahMcp.ensureInitialized();
        result = await _heekmahMcp.callTool('fetch_passage', {'id': passageId});
      }
      if (result.isError) {
        log(
          'fetch_passage($passageId) on $source error: ${result.text}',
          name: 'Unified',
        );
        return null;
      }
      // استخرج النص الكامل (fetch_passage يُعيد Markdown بنفس صيغة search_*).
      final extraction = QuotationExtractor.extract(
        toolResult: result.text,
        toolName: 'fetch_passage',
        source: source,
      );
      if (extraction.quotations.isNotEmpty) {
        return extraction.quotations.first.text;
      }
      return extraction.rawText.isEmpty ? null : extraction.rawText;
    } catch (e) {
      log('fetch_passage($passageId) on $source failed: $e', name: 'Unified');
      return null;
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
    final blocks = text.split(
      RegExp(r'(?=^###\s+النتيجة\s+\d+)', multiLine: true),
    );
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
      log(
        'Unified: no results matched section "$keyword" '
        '(${blocks.where((b) => b.trim().isNotEmpty).length} results filtered out)',
        name: 'Unified',
      );
      return '';
    }

    // أعد بناء النص: الترويسة + النتائج المفلترة.
    final headerMatch = RegExp(
      r'^[\s\S]*?(?=###\s+النتيجة\s+\d+|$)',
    ).firstMatch(text);
    final header = headerMatch?.group(0)?.trim() ?? '';
    final countLine = 'وجدت ${kept.length} نتيجة بعد الفلترة حسب القسم.\n\n';
    return header.isEmpty
        ? countLine + kept.join('\n')
        : '$header\n$countLine${kept.join('\n')}';
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
      return extraction.rawText.isEmpty
          ? 'assistantNoData'.tr
          : extraction.rawText;
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
  /// ينظّف قائمة الرسائل قبل الجولات النهائية (بلا أدوات) لمنع degeneration.
  ///
  /// عند الانتقال لجولة بلا أدوات (iteration >= 2)، يصبح السياق تناقضياً:
  /// رسائل `role: tool` وحقول `tool_calls` في `assistant` تشير لأدوات لم تَعُد
  /// متاحة. النماذج الضعيفة تتفاعب بإفراغ استدعاءات الأدوات كنص خام
  /// (`<invoke name=...>`).
  ///
  /// هذه الدالة:
  /// - تدمج نتائج الأدوات (`role: tool`) في رسالة `role: assistant` واحدة.
  /// - تنزع حقول `tool_calls` من رسائل `assistant`.
  /// - تبقي الـ system + history + user + النصوص المنظّمة فقط.
  List<Map<String, dynamic>> _sanitizeMessagesForFinalAnswer(
    List<Map<String, dynamic>> messages,
  ) {
    // اجمع محتوى رسائل tool في ملخص واحد.
    final toolSummaries = <String>[];
    final cleaned = <Map<String, dynamic>>[];
    for (final m in messages) {
      final role = m['role'] as String?;
      if (role == 'tool') {
        // خزّن محتوى الأداة لدمجه لاحقاً.
        final content = m['content']?.toString() ?? '';
        if (content.trim().isNotEmpty) {
          toolSummaries.add(content);
        }
        // تخطّى رسالة tool الأصلية (لا نُضيفها).
        continue;
      }
      if (role == 'assistant') {
        // انزع tool_calls واحتفظ بنص content فقط.
        final content = m['content']?.toString() ?? '';
        if (m.containsKey('tool_calls')) {
          // كانت رسالة استدعاء أدوات — استبدلها بنصها فقط (أو تخطّاها إن فارغ).
          if (content.trim().isEmpty) continue;
          cleaned.add({'role': 'assistant', 'content': content});
        } else {
          cleaned.add({'role': 'assistant', 'content': content});
        }
        continue;
      }
      // system / user — أبقِها كما هي.
      cleaned.add(m);
    }
    // أضف ملخص نتائج الأدوات كرسالة user (سياق للإجابة النهائية).
    if (toolSummaries.isNotEmpty) {
      cleaned.insert(cleaned.length, {
        'role': 'user',
        'content':
            '(معلومات من البحث)\n${toolSummaries.join('\n')}\n\n'
            'اكتب المقدمة فقط بناءً على ما سبق. لا تكتب استدعاءات أدوات.',
      });
    }
    return cleaned;
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
            'function': {'name': c.name, 'arguments': jsonEncode(c.arguments)},
          },
        )
        .toList();
  }
}
