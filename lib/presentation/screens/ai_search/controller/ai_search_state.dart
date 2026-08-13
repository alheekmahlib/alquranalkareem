part of '../ai_search.dart';

/// أوضاع شاشة مداد: البحث الدلالي على الجهاز، أو المساعد الذكي (LLM + tafsir-mcp).
enum MidasMode { semantic, assistant }

class AiSearchState {
  final searchTextEditing = TextEditingController();

  // Per-section download status
  final Map<String, RxBool> _sectionLoaded = {};
  final Map<String, RxBool> _sectionDownloading = {};
  final Map<String, RxDouble> _sectionProgress = {};
  final Map<String, RxString> _sectionStatus = {};

  // Shared model status
  final isSharedLoaded = false.obs;
  final isSharedDownloading = false.obs;
  final sharedProgress = 0.0.obs;
  final sharedStatus = ''.obs;

  // Global states
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString downloadingSectionId =
      ''.obs; // which section is currently downloading

  // Search results per section
  final Map<String, RxList<SearchResult>> _allResults = {};
  final Map<String, RxList<SearchResult>> _displayResults = {};

  // Progressive loading
  final RxString searchingCategory = ''.obs;
  final RxBool allResultsReady = false.obs;

  // Streaming state
  final completedCards = <String>{}.obs;
  final nextStreamingKey = RxnString();
  final RxBool introStreamed = false.obs; // streaming intro text completed

  // Enabled sections filter (persisted)
  static const _enabledSectionsKey = 'ai_search_enabled_sections';
  final enabledSections = <String>{}.obs;

  final RxString currentQuery = ''.obs;

  /// الوضع النشط حالياً في شاشة مداد (دلالي ↔ مساعد ذكي).
  final Rx<MidasMode> midasMode = MidasMode.semantic.obs;

  // ─── حالة المساعد الذكي (tafsir-mcp) ──────────────────────────────

  /// المزود/النموذج المختار حالياً (يُحفظ في GetStorage).
  final Rx<LlmProvider> selectedProvider = LlmService.defaultProvider.obs;

  /// سجل رسائل محادثة المساعد المعروض في الواجهة.
  final RxList<ChatMessage> assistantMessages = <ChatMessage>[].obs;

  /// هل المساعد يعالج طلباً الآن (يفكر/يستدعي أداة)؟
  final RxBool isAssistantThinking = false.obs;

  /// محتوى رسالة المساعد الحيّة المسموح لها بالتحرك (stream) مرة واحدة فقط.
  ///
  /// تُضبط من المسار المباشر [addAssistantMessage] فقط (لا من تحميل السجل)،
  /// وتُفرَّغ فور اكتمال الأنيميشن — لمنع تكرار streaming عند التمرير/إعادة بناء العنصر،
  /// إذ لا يحفظ `StreamingTextMarkdown` حالة «تم العرض» عبر إعادة التدوير.
  final RxString streamingMessageContent = ''.obs;

  /// اسم الأداة الجاري تنفيذها الآن ('' إن لم تكن أداة قيد التشغيل).
  final RxString currentToolName = ''.obs;

  /// رسالة خطأ المساعد ('' عند عدم وجود خطأ).
  final RxString assistantError = ''.obs;

  /// هل يوجد نص في حقل الإدخال؟ (Rx ليُعيد بناء زر الإرسال عند الكتابة).
  final RxBool hasInputText = false.obs;

  // ─── حالة جلب النص الكامل للاقتباسات ──────────────────────────────
  // مفاتيح RxMap = passageId. القيم:
  //   'loading'  → الجلب جارٍ الآن.
  //   'failed'   → فشل الجلب (لإعادة المحاولة).
  //   النص الكامل → نجح الجلب (يُعرض بدل snippet).
  final RxMap<int, String> fullTextCache = <int, String>{}.obs;

  /// هل النص الكامل لـ [passageId] جارٍ الجلب؟
  bool isFetchingFullText(int passageId) =>
      fullTextCache[passageId] == 'loading';

  /// هل فشل جلب النص الكامل لـ [passageId]؟
  bool hasFetchFailed(int passageId) => fullTextCache[passageId] == 'failed';

  /// النص الكامل المجلوب لـ [passageId] (null لو لم يُجلب أو جارٍ/فاشل).
  String? getFullText(int passageId) {
    final v = fullTextCache[passageId];
    if (v == null || v == 'loading' || v == 'failed') return null;
    return v;
  }

  bool get isAssistantEmpty => assistantMessages.isEmpty;

  void addAssistantUserMessage(String text) =>
      assistantMessages.add(ChatMessage(role: ChatRole.user, content: text));

  /// يضيف رسالة مساعد، مع دعم إرفاق اقتباسات منقولة من MCP (دون تمريرها للـ LLM).
  ///
  /// يضبط [streamingMessageContent] **قبل** الإضافة لتمييزها كرسالة حيّة تُعرض
  /// بحركة streaming مرة واحدة فقط (تفادياً لأي سباق مع إعادة بناء Obx).
  void addAssistantMessage(
    String text, {
    List<Quotation> quotations = const [],
  }) {
    streamingMessageContent.value = text;
    assistantMessages.add(
      ChatMessage(
        role: ChatRole.assistant,
        content: text,
        quotations: quotations,
      ),
    );
  }

  /// هل يجب أن تُعرض هذه الرسالة بحركة streaming؟
  ///
  /// صحيح فقط لآخر رسالة مساعد حيّة لم تُعرض بعد (محتواها يساوي [streamingMessageContent]).
  /// بمجرّد اكتمال الأنيميشن تُفرَّغ الفتحة عبر [markAssistantStreamed] فلا تُعاد أبداً.
  bool shouldStreamAssistant(String content, {required bool isLastMessage}) {
    if (!isLastMessage) return false;
    final pending = streamingMessageContent.value;
    return pending.isNotEmpty && content == pending;
  }

  /// يُستدعى عند اكتمال أنيميشن streaming لرسالة المساعد — يُفرّغ الفتحة فلا تُعاد.
  void markAssistantStreamed() => streamingMessageContent.value = '';

  void clearAssistantMessages() {
    assistantMessages.clear();
    assistantError.value = '';
    currentToolName.value = '';
    isAssistantThinking.value = false;
    streamingMessageContent.value = '';
  }

  /// يحوّل رسائل المساعد إلى صيغة OpenAI (يتجاهل رسائل الأداة والاقتباسات).
  ///
  /// **تقليم context window:** نُبقي آخر [_maxHistoryMessages] رسالة فقط
  /// (تقريباً آخر 3 أزوار سؤال/جواب) لمنع نموّ الـ context بلا حدّ،
  /// ولتفادي خطأ 413 (payload too large) مع المحادثات الطويلة.
  /// الاقتباسات [ChatMessage.quotations] لا تُرسل للنموذج إطلاقاً (هي منفصلة).
  static const int _maxHistoryMessages = 6;

  List<Map<String, dynamic>> assistantMessagesToOpenAi() {
    final nonTool = assistantMessages.where((m) => !m.isTool).toList();
    // تقليم: نُبقي آخر N رسالة فقط.
    final trimmed = nonTool.length > _maxHistoryMessages
        ? nonTool.sublist(nonTool.length - _maxHistoryMessages)
        : nonTool;
    return trimmed
        .map(
          (m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.content,
          },
        )
        .toList();
  }

  void loadEnabledSections() {
    try {
      final box = GetStorage();
      final saved = box.read(_enabledSectionsKey);
      print('[AiSearch] Raw saved sections: $saved (${saved.runtimeType})');
      if (saved != null) {
        final List<String> list;
        if (saved is List) {
          list = saved.cast<String>();
        } else {
          list = <String>[];
        }
        enabledSections.addAll(list);
        print('[AiSearch] Loaded enabled sections: $list');
      } else {
        print('[AiSearch] No saved sections found');
      }
    } catch (e) {
      print('[AiSearch] loadEnabledSections error: $e');
    }
  }

  void saveEnabledSections() {
    try {
      final box = GetStorage();
      final list = enabledSections.toList();
      box.write(_enabledSectionsKey, list);
      print('[AiSearch] Saved enabled sections: $list');
    } catch (e) {
      print('[AiSearch] saveEnabledSections error: $e');
    }
  }

  /// Toggle a section's enabled state. Returns new state.
  bool toggleSection(String sectionId) {
    if (enabledSections.contains(sectionId)) {
      enabledSections.remove(sectionId);
    } else {
      enabledSections.add(sectionId);
    }
    saveEnabledSections();
    return enabledSections.contains(sectionId);
  }

  /// Check if a section is enabled for search.
  /// Only loaded sections can be enabled.
  bool isSectionEnabled(String sectionId) {
    if (!isSectionLoaded(sectionId).value) return false;
    return enabledSections.contains(sectionId);
  }

  /// Called when a section finishes downloading — auto-enable it.
  void onSectionDownloaded(String sectionId) {
    if (!enabledSections.contains(sectionId)) {
      enabledSections.add(sectionId);
      saveEnabledSections();
    }
  }

  static const int initialDisplayCount = 3;
  static const int loadMoreCount = 5;

  /// Initialize observables for a section
  void _ensureSection(String sectionId) {
    _sectionLoaded.putIfAbsent(sectionId, () => false.obs);
    _sectionDownloading.putIfAbsent(sectionId, () => false.obs);
    _sectionProgress.putIfAbsent(sectionId, () => 0.0.obs);
    _sectionStatus.putIfAbsent(sectionId, () => ''.obs);
    _allResults.putIfAbsent(sectionId, () => <SearchResult>[].obs);
    _displayResults.putIfAbsent(sectionId, () => <SearchResult>[].obs);
  }

  AiSearchState() {
    for (final section in SearchSection.all) {
      _ensureSection(section.id);
    }
  }

  // Getters for section state
  RxBool isSectionLoaded(String id) {
    _ensureSection(id);
    return _sectionLoaded[id]!;
  }

  RxBool isSectionDownloading(String id) {
    _ensureSection(id);
    return _sectionDownloading[id]!;
  }

  RxDouble sectionProgress(String id) {
    _ensureSection(id);
    return _sectionProgress[id]!;
  }

  RxString sectionStatus(String id) {
    _ensureSection(id);
    return _sectionStatus[id]!;
  }

  RxList<SearchResult> sectionResults(String id) {
    _ensureSection(id);
    return _displayResults[id]!;
  }

  void setSectionLoaded(String id, bool loaded) {
    _ensureSection(id);
    _sectionLoaded[id]!.value = loaded;
  }

  void setSectionDownloading(String id, bool downloading) {
    _ensureSection(id);
    _sectionDownloading[id]!.value = downloading;
    if (downloading) downloadingSectionId.value = id;
  }

  void resetSectionProgress(String id) {
    _ensureSection(id);
    _sectionProgress[id]!.value = 0;
    _sectionStatus[id]!.value = '';
  }

  /// Get list of section IDs that have been downloaded
  List<String> get downloadedSectionIds => SearchSection.all
      .where((s) => _sectionLoaded[s.id]?.value == true)
      .map((s) => s.id)
      .toList();

  /// Check if any section is downloaded
  bool get hasAnySectionLoaded =>
      SearchSection.all.any((s) => _sectionLoaded[s.id]?.value == true);

  /// Set results for a section
  void setSectionResults(String sectionId, List<SearchResult> results) {
    _ensureSection(sectionId);
    _allResults[sectionId]!.value = results;
    _displayResults[sectionId]!.value = results
        .take(initialDisplayCount)
        .toList();
  }

  /// Show more results for a section
  void showMore(String sectionId) {
    _ensureSection(sectionId);
    final display = _displayResults[sectionId]!;
    final all = _allResults[sectionId]!;
    final current = display.length;
    final remaining = all.length - current;
    if (remaining > 0) {
      final add = remaining > loadMoreCount ? loadMoreCount : remaining;
      display.addAll(all.sublist(current, current + add));
    }
    // Mark new cards as completed (no re-streaming needed)
    _markNewCardsCompleted();
  }

  void _markNewCardsCompleted() {
    final allKeys = _buildAllKeys();
    for (final key in allKeys) {
      if (!completedCards.contains(key)) {
        completedCards.add(key);
      }
    }
  }

  bool hasMore(String sectionId) {
    _ensureSection(sectionId);
    final display = _displayResults[sectionId]!;
    final all = _allResults[sectionId]!;
    return display.length < all.length;
  }

  int remainingCount(String sectionId) {
    _ensureSection(sectionId);
    return (_allResults[sectionId]?.length ?? 0) -
        (_displayResults[sectionId]?.length ?? 0);
  }

  int totalCount(String sectionId) {
    _ensureSection(sectionId);
    return _allResults[sectionId]?.length ?? 0;
  }

  // Streaming helpers
  void startStreaming() {
    completedCards.clear();
    final allKeys = _buildAllKeys();
    if (allKeys.isNotEmpty) {
      nextStreamingKey.value = allKeys.first;
    }
  }

  void markCardCompleted(String key) {
    completedCards.add(key);
    final allKeys = _buildAllKeys();
    final idx = allKeys.indexOf(key);
    if (idx >= 0 && idx + 1 < allKeys.length) {
      nextStreamingKey.value = allKeys[idx + 1];
    } else {
      nextStreamingKey.value = null;
      allResultsReady.value = true;
    }
  }

  bool isCardCompleted(String key) => completedCards.contains(key);
  bool isCardStreaming(String key) => nextStreamingKey.value == key;

  List<String> _buildAllKeys() {
    final keys = <String>[];
    for (final section in SearchSection.all) {
      _ensureSection(section.id);
      final results = _displayResults[section.id]!;
      for (int i = 0; i < results.length; i++) {
        keys.add('${section.id}_$i');
      }
    }
    return keys;
  }

  /// Get all (non-display-truncated) results for a section
  List<SearchResult> allResultsForSection(String id) {
    _ensureSection(id);
    return _allResults[id]?.toList() ?? <SearchResult>[];
  }

  List<SearchResult> get allResults {
    final results = <SearchResult>[];
    for (final section in SearchSection.all) {
      _ensureSection(section.id);
      results.addAll(_displayResults[section.id]!);
    }
    return results;
  }

  void clearResults() {
    for (final section in SearchSection.all) {
      _ensureSection(section.id);
      _allResults[section.id]!.clear();
      _displayResults[section.id]!.clear();
    }
    searchingCategory.value = '';
    allResultsReady.value = false;
    completedCards.clear();
    nextStreamingKey.value = null;
    introStreamed.value = false;
    errorMessage.value = '';
  }

  bool get hasAnyResult {
    for (final section in SearchSection.all) {
      _ensureSection(section.id);
      if (_displayResults[section.id]!.isNotEmpty) return true;
    }
    return false;
  }
}
