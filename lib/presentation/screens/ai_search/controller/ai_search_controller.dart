part of '../ai_search.dart';

class AiSearchController extends GetxController {
  static AiSearchController get instance =>
      GetInstance().putOrFind(() => AiSearchController());

  final state = AiSearchState();
  final _searchService = VectorSearchService();
  final _downloadService = ModelDownloadService();
  final _embeddingService = EmbeddingService();
  final _bm25Service = BM25Service();
  final _chatHistoryService = ChatHistoryService();
  final _unifiedOrchestrator = UnifiedOrchestrator();

  /// متحكم التمرير لقائمة رسائل المساعد الموحَّد.
  final ScrollController assistantScrollController = ScrollController();
  bool _isProcessing = false;

  // Track active downloads per section
  final Map<String, CancelToken> _cancelTokens = {};
  bool _initStarted = false;
  final isInitialized = false.obs;
  static const _keyX = 'floating_menu_x';
  static const _keyY = 'floating_menu_y';

  Offset floatingMenuPosition = const Offset(16, 0);

  /// Call when the AI search screen first opens
  Future<void> ensureInitialized() async {
    if (isInitialized.value || _initStarted) return;
    _initStarted = true;
    Future.delayed(const Duration(milliseconds: 500), () async {
      await _initCheck();
    });
  }

  @override
  void onInit() {
    super.onInit();
    loadPosition();
    // زامن حالة "هل يوجد نص؟" مع حقل الإدخال ليُعيد بناء زر الإرسال.
    state.searchTextEditing.addListener(_syncInputText);
    // مرّر قائمة رسائل المساعد للأسفل تلقائياً.
    ever<dynamic>(state.assistantMessages, (_) => _scrollAssistantToBottom());
    // استعد المزود المحفوظ (إن كان لا يزال له مفتاح).
    _restoreSelectedProvider();
    // استعد الوضع المحفوظ (دلالي ↔ مساعد).
    _restoreMidasMode();
    // احفظ الوضع تلقائياً عند تغييره.
    ever<MidasMode>(state.midasMode, (mode) => _saveMidasMode(mode));
  }

  static const _midasModeKey = 'ai_search_midas_mode';

  /// يستعيد الوضع المحفوظ (دلالي ↔ مساعد) من GetStorage.
  void _restoreMidasMode() {
    try {
      final saved = GetStorage().read<String>(_midasModeKey);
      if (saved == 'assistant') {
        state.midasMode.value = MidasMode.assistant;
      } else {
        state.midasMode.value = MidasMode.semantic;
      }
    } catch (_) {
      state.midasMode.value = MidasMode.semantic;
    }
  }

  /// يحفظ الوضع الحالي في GetStorage.
  void _saveMidasMode(MidasMode mode) {
    try {
      GetStorage().write(_midasModeKey, mode.name);
    } catch (_) {}
  }

  static const _selectedProviderKey = 'ai_search_selected_provider';

  /// استعادة المزود المحفوظ من GetStorage، إن كان له مفتاح.
  void _restoreSelectedProvider() {
    try {
      final savedId = GetStorage().read<String>(_selectedProviderKey);
      if (savedId != null) {
        final match = LlmService.providers
            .where((p) => p.id == savedId && p.hasKey)
            .firstOrNull;
        if (match != null) {
          state.selectedProvider.value = match;
        }
      }
    } catch (_) {}
  }

  /// المزودون الذين لهم مفاتيح في .env (لعرضهم في القائمة المنسدلة).
  List<LlmProvider> get availableProviders => LlmService.availableProviders;

  /// يختار مزوّداً/نموذجاً ويحفظ الاختيار في GetStorage.
  void selectProvider(LlmProvider provider) {
    state.selectedProvider.value = provider;
    GetStorage().write(_selectedProviderKey, provider.id);
  }

  void _syncInputText() {
    state.hasInputText.value = state.searchTextEditing.text.trim().isNotEmpty;
  }

  void _scrollAssistantToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!assistantScrollController.hasClients) return;
      final max = assistantScrollController.position.maxScrollExtent;
      assistantScrollController.animateTo(
        max,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _initCheck() async {
    try {
      // Load persisted enabled sections
      state.loadEnabledSections();

      // Check shared model exists
      final sharedDownloaded = await _downloadService.isSharedDownloaded();
      state.isSharedLoaded.value = sharedDownloaded;
      print('[AiSearch] Shared downloaded: $sharedDownloaded');

      // Check which sections exist on disk (NO loading into memory)
      bool hadSavedPrefs = state.enabledSections.isNotEmpty;
      for (final section in SearchSection.all) {
        final downloaded = await _downloadService.isSectionDownloaded(section);
        final hasBinary = await _searchService.hasBinary(section.id);
        final isReady = downloaded && hasBinary;
        state.setSectionLoaded(section.id, isReady);
        // First time (no saved prefs): auto-enable all downloaded sections
        if (!hadSavedPrefs && isReady) {
          state.enabledSections.add(section.id);
        }
        print(
          '[AiSearch] ${section.id} on disk: $downloaded, binary: $hasBinary',
        );
      }
      state.saveEnabledSections();

      // DO NOT load anything into memory here — everything is lazy.
      // ONNX model, metadata, and BM25 are loaded only when search is performed.
    } catch (e) {
      print('[AiSearch] _initCheck error: $e');
    } finally {
      isInitialized.value = true;
      print('[AiSearch] Init complete (lazy — nothing loaded yet)');
      for (final s in SearchSection.all) {
        print('[AiSearch] ${s.id}: state=${state.isSectionLoaded(s.id).value}');
      }
    }
  }

  /// Download shared model files
  /// [onExternalProgress] / [onExternalStatus] let callers (e.g. downloadSection)
  /// pipe the shared progress into the section card UI.
  Future<void> downloadShared({
    void Function(double progress)? onExternalProgress,
    void Function(String status)? onExternalStatus,
  }) async {
    final cancelToken = CancelToken();
    _cancelTokens['shared'] = cancelToken;

    state.isSharedDownloading.value = true;
    state.isSharedLoaded.value = false;

    try {
      await _downloadService.downloadShared(
        onProgress: (p) {
          state.sharedProgress.value = p;
          onExternalProgress?.call(p);
        },
        onStatus: (s) {
          state.sharedStatus.value = s;
          onExternalStatus?.call(s);
          log('Shared: $s', name: 'AiSearch');
        },
        cancelToken: cancelToken,
      );
      state.isSharedLoaded.value = true;
      await _embeddingService.init();
    } catch (e) {
      if (!cancelToken.isCancelled) {
        log('Shared download failed: $e', name: 'AiSearch');
      }
    } finally {
      state.isSharedDownloading.value = false;
      _cancelTokens.remove('shared');
    }
  }

  /// Download a specific section
  Future<void> downloadSection(SearchSection section) async {
    // Prevent starting a new download if previous one is still running
    if (_cancelTokens.containsKey(section.id)) return;

    // Set UI state FIRST so the card shows progress immediately
    state.resetSectionProgress(section.id);
    state.setSectionDownloading(section.id, true);
    state.downloadingSectionId.value = section.id;

    // Shared model must be downloaded before any section
    if (!state.isSharedLoaded.value) {
      state.setSectionDownloading(section.id, false);
      state.downloadingSectionId.value = '';
      return;
    }

    final cancelToken = CancelToken();
    _cancelTokens[section.id] = cancelToken;

    try {
      await _downloadService.downloadSection(
        section,
        onProgress: (p) => state.sectionProgress(section.id).value = p,
        onStatus: (s) => state.sectionStatus(section.id).value = s,
        cancelToken: cancelToken,
      );

      // Load the newly downloaded section (metadata only — conversion already done)
      await _searchService.loadSection(section.id);
      state.setSectionLoaded(section.id, true);
      state.onSectionDownloaded(section.id);

      log('Downloaded & loaded: ${section.titleAr}', name: 'AiSearch');
    } catch (e) {
      if (cancelToken.isCancelled) {
        log('Download cancelled: ${section.titleAr}', name: 'AiSearch');
      } else {
        log('Download failed for ${section.id}: $e', name: 'AiSearch');
      }
    } finally {
      state.setSectionDownloading(section.id, false);
      state.resetSectionProgress(section.id);
      state.downloadingSectionId.value = '';
      _cancelTokens.remove(section.id);
    }
  }

  /// Cancel a section or shared download
  void cancelDownload(String id) {
    _cancelTokens[id]?.cancel();
    if (id == 'shared') {
      state.isSharedDownloading.value = false;
      state.sharedProgress.value = 0;
      state.sharedStatus.value = '';
    } else {
      state.setSectionDownloading(id, false);
      state.resetSectionProgress(id);
    }
    state.downloadingSectionId.value = '';
  }

  /// Delete shared files only
  Future<void> deleteShared() async {
    await _downloadService.deleteShared();
    state.isSharedLoaded.value = false;
    // Also unload all sections since they depend on shared
    for (final section in SearchSection.all) {
      _searchService.unloadSection(section.id);
      _bm25Service.unloadSection(section.id);
      state.setSectionLoaded(section.id, false);
    }
    state.clearResults();
  }

  /// Delete a specific section
  Future<void> deleteSection(SearchSection section) async {
    _searchService.unloadSection(section.id);
    _bm25Service.unloadSection(section.id);
    await _downloadService.deleteSection(section);
    state.setSectionLoaded(section.id, false);
    state.clearResults();
  }

  /// Delete all data
  Future<void> deleteAll() async {
    for (final section in SearchSection.all) {
      _searchService.unloadSection(section.id);
      _bm25Service.unloadSection(section.id);
    }
    await _downloadService.deleteAll();
    for (final section in SearchSection.all) {
      state.setSectionLoaded(section.id, false);
    }
    state.isSharedLoaded.value = false;
    state.clearResults();
  }

  /// Get downloaded size
  Future<int> getDownloadedSize() => _downloadService.getDownloadedSize();

  /// Search across all loaded sections
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state.clearResults();
      return;
    }

    // Wait for init to complete
    if (_initStarted && !state.isLoading.value) {
      print('[AiSearch] Search called before init complete, waiting...');
      state.isSearching.value = true;
      // Poll until initialized (with timeout)
      for (int i = 0; i < 100; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!_initStarted || state.isLoading.value == false) break;
      }
      state.isSearching.value = false;
    }

    if (!state.hasAnySectionLoaded) {
      state.errorMessage.value = 'لم يتم تحميل أي قسم بعد';
      return;
    }

    state.isSearching.value = true;
    state.errorMessage.value = '';
    state.clearResults();

    try {
      // Lazy init: load ONNX model only when first search is performed
      if (!_embeddingService.isReady) {
        print('[AiSearch] Lazy-init embedding service...');
        try {
          await _embeddingService.init();
          print('[AiSearch] Embedding service initialized successfully');
        } catch (e, stack) {
          print('[AiSearch] Embedding init failed: $e');
          print('[AiSearch] Stack: $stack');
          state.errorMessage.value = 'فشل تحميل نموذج البحث: $e';
          state.isSearching.value = false;
          return;
        }
      }

      // Get embedding
      List<double> embedding;
      if (_embeddingService.isReady) {
        print('[AiSearch] Using real embedding for: $query');
        try {
          embedding = await _embeddingService.embed(query);
          print('[AiSearch] Embedding generated: ${embedding.length} dims');
        } catch (e, stack) {
          print('[AiSearch] Embedding failed: $e');
          print('[AiSearch] Stack: $stack');
          state.errorMessage.value = 'فشل معالجة البحث: $e';
          state.isSearching.value = false;
          return;
        }
      } else {
        print('[AiSearch] Embedding not ready, using pseudo embedding');
        embedding = _pseudoEmbedding(query);
      }

      // Search each enabled section — load ONE at a time, unload after search
      // This keeps peak memory low: ONNX (130MB) + 1 section metadata only
      for (final section in SearchSection.all) {
        if (!state.isSectionEnabled(section.id)) continue;
        if (!state.isSectionLoaded(section.id).value) continue;

        try {
          // Load this section's metadata
          if (!_searchService.isSectionLoaded(section.id)) {
            print('[AiSearch] Loading section: ${section.id}');
            await _searchService.loadSection(section.id);
          }
          print(
            '[AiSearch] Searching section: ${section.id} (${_searchService.sectionChunkCount(section.id)} chunks)',
          );

          List<SearchResult> results;

          // BM25 for small sections only
          const bm25Threshold = 10000;
          final chunkCount = _searchService.sectionChunkCount(section.id);
          bool bm25Loaded = false;

          if (chunkCount <= bm25Threshold) {
            if (!_bm25Service.isSectionLoaded(section.id)) {
              try {
                await _bm25Service.loadSection(section.id);
                bm25Loaded = true;
              } catch (e) {
                print('[AiSearch] BM25 load failed for ${section.id}: $e');
              }
            }
          }

          if (bm25Loaded && _bm25Service.sectionDocCount(section.id) > 0) {
            final bm25Scores = _bm25Service.score(section.id, query);
            final normalizedBm25 = _bm25Service.normalize(bm25Scores);

            results = await _searchService.hybridSearchSection(
              section.id,
              embedding,
              normalizedBm25,
              topK: 15,
            );
          } else {
            results = await _searchService.searchSection(
              section.id,
              embedding,
              topK: 15,
            );
          }

          state.setSectionResults(section.id, results);
          log(
            '  ${section.titleAr}: ${results.length} results',
            name: 'AiSearch',
          );
        } catch (e, stack) {
          print('[AiSearch] Search failed for ${section.id}: $e');
          print('[AiSearch] Stack: $stack');
        } finally {
          // UNLOAD after search to free memory for next section
          _searchService.unloadSection(section.id);
          _bm25Service.unloadSection(section.id);
          print('[AiSearch] Unloaded section: ${section.id}');
        }
      }

      // Progressive display
      for (final section in SearchSection.all) {
        if (state.sectionResults(section.id).isNotEmpty) {
          state.searchingCategory.value = section.id;
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
      state.searchingCategory.value = '';
      state.startStreaming();

      // Auto-save to chat history
      _saveToHistory(query);
    } catch (e) {
      state.errorMessage.value = 'فشل البحث: $e';
      log('AI Search failed: $e', name: 'AiSearch');
    } finally {
      state.isSearching.value = false;
    }
  }

  List<double> _pseudoEmbedding(String query) {
    final dim = 384;
    final seed = query.hashCode;
    final random = _SeededRandom(seed);
    final embedding = List.generate(dim, (_) => random.nextDouble() * 2 - 1);
    double norm = 0;
    for (final v in embedding) {
      norm += v * v;
    }
    norm = _sqrt(norm);
    if (norm > 0) {
      for (int i = 0; i < dim; i++) {
        embedding[i] /= norm;
      }
    }
    return embedding;
  }

  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  // ─── Chat History ──────────────────────────────────────────────

  /// Save current search results to chat history
  void _saveToHistory(String query) {
    try {
      final sectionResults = <String, List<SerializableSearchResult>>{};
      for (final section in SearchSection.all) {
        final results = state.allResultsForSection(section.id);
        if (results.isNotEmpty) {
          sectionResults[section.id] = results
              .map((r) => SerializableSearchResult.fromSearchResult(r))
              .toList();
        }
      }
      if (sectionResults.isEmpty) return;

      final now = DateTime.now();
      final entry = ChatHistoryEntry(
        id: '${now.millisecondsSinceEpoch}',
        query: query,
        date: now,
        sectionResults: sectionResults,
      );
      _chatHistoryService.saveEntry(entry);
    } catch (e) {
      print('[AiSearch] Failed to save history: $e');
    }
  }

  /// Load a chat history entry into the current state.
  /// (تُعرّف لاحقاً مع منطق المساعد — تدعم النوعين semantic و assistant).

  /// Get all history entries
  Future<List<ChatHistoryEntry>> getHistoryEntries() {
    return _chatHistoryService.getEntries();
  }

  /// Delete a single history entry
  Future<void> deleteHistoryEntry(String id) {
    return _chatHistoryService.deleteEntry(id);
  }

  /// Delete all history
  Future<void> deleteAllHistory() {
    return _chatHistoryService.deleteAll();
  }

  void clearSearch() {
    state.searchTextEditing.clear();
    state.clearResults();
    state.errorMessage.value = '';
    state.currentQuery.value = '';
  }

  void loadPosition() {
    try {
      final box = GetStorage();
      floatingMenuPosition = Offset(
        box.read(_keyX) ?? 16,
        box.read(_keyY) ?? 0,
      );
    } catch (_) {}
  }

  void savePosition(Offset offset) {
    try {
      final box = GetStorage();
      box.write(_keyX, offset.dx);
      box.write(_keyY, offset.dy);
    } catch (_) {}
  }

  void downloadAllSections(AiSearchController ctrl) async {
    for (final section in SearchSection.all) {
      if (!ctrl.state.isSectionLoaded(section.id).value) {
        try {
          await ctrl.downloadSection(section);
        } catch (e) {
          print('[AiSearch] Download all failed at ${section.id}: $e');
        }
      }
    }
  }

  // ─── المساعد الذكي (tafsir-mcp) ──────────────────────────────────

  /// يرسل رسالة المستخدم إلى المساعد الذكي ويبدأ دورة المعالجة.
  /// يرسل رسالة المستخدم إلى المساعد الموحَّد (tafsir-mcp + alheekmah-mcp).
  ///
  /// المساعد الموحَّد يصنّف السؤال مسبقاً ويختار الأدوات المناسبة من كلا الخادمين.
  Future<void> sendMessage(String query) async {
    final text = query.trim();
    if (text.isEmpty || _isProcessing) return;

    _isProcessing = true;
    state.addAssistantUserMessage(text);
    state.searchTextEditing.clear();
    state.hasInputText.value = false;

    // اعرض تنويهاً بعد 10 ثوانٍ إن لم تصل الإجابة بعد (بعض النماذج تتأخر).
    final slowNoticeTimer = Timer(const Duration(seconds: 10), () {
      final ctx = Get.context;
      if (ctx != null && state.isAssistantThinking.value) {
        ctx.showCustomErrorSnackBar(
          'slowModelNotice'.trParams({
            'model': state.selectedProvider.value.displayName,
          }),
          isDone: false,
          durationInSeconds: 7,
        );
      }
    });

    try {
      await _unifiedOrchestrator.handleUserMessage(
        userText: text,
        state: state,
        onFallback: (fallback) {
          selectProvider(fallback);
          final ctx = Get.context;
          if (ctx != null) {
            ctx.showCustomErrorSnackBar(
              'fallbackNotice'.trParams({'model': fallback.displayName}),
              isDone: true,
            );
          }
        },
      );
      // احفظ المحادثة في السجل بعد اكتمال الإجابة.
      _saveAssistantToHistory(text);
    } finally {
      slowNoticeTimer.cancel();
      _isProcessing = false;
    }
  }

  /// يمسح المحادثة الحالية ويبدأ محادثة جديدة.
  void clearConversation() {
    state.clearAssistantMessages();
    state.searchTextEditing.clear();
    state.hasInputText.value = false;
  }

  /// ينسخ نص إجابة المساعد (مع السؤال المرتبط والاقتباسات) إلى الحافظة ويعرض تأكيداً.
  Future<void> copyAssistantAnswer(
    BuildContext context,
    String answer, [
    String? question,
    List<Quotation> quotations = const [],
  ]) async {
    final text = _formatAnswerForExport(answer, question, quotations);
    await Clipboard.setData(ClipboardData(text: text)).then(
      (_) => context.showCustomErrorSnackBar('copyAnswer'.tr, isDone: true),
    );
  }

  /// يشارك نص إجابة المساعد (مع السؤال المرتبط والاقتباسات) عبر مشاركة النظام.
  Future<void> shareAssistantAnswer(
    String answer, [
    String? question,
    List<Quotation> quotations = const [],
  ]) async {
    final text = _formatAnswerForExport(answer, question, quotations);
    await SharePlus.instance.share(ShareParams(text: text));
  }

  /// ينسّق الإجابة (مع السؤال والاقتباسات) للنسخ/المشاركة — Markdown خام قابل للقراءة.
  ///
  /// الترتيب مطابق لترتيب العرض في الواجهة: السؤال → مقدمة المساعد → الاقتباسات
  /// (بنفس ترتيبها) → تذييل التطبيق.
  String _formatAnswerForExport(
    String answer,
    String? question, [
    List<Quotation> quotations = const [],
  ]) {
    final buffer = StringBuffer();
    if (question != null && question.trim().isNotEmpty) {
      buffer.writeln('س: $question');
      buffer.writeln();
    }
    buffer.write(answer);
    buffer.writeln();

    // الاقتباسات المنقولة بنفس ترتيب عرضها في الواجهة.
    for (final q in quotations) {
      buffer.writeln();
      buffer.writeln('—');
      buffer.writeln();
      // النسبة التفصيلية (اسم الكتاب + المؤلف) قبل النص المنقول.
      if (q.attribution != null && q.attribution!.trim().isNotEmpty) {
        buffer.writeln('📖 ${q.attribution}');
        buffer.writeln();
      }
      // النص المنقول حرفياً.
      buffer.writeln(q.text);
      // النوع كتلميح.
      buffer.writeln();
      buffer.writeln('(${_quotationTypeLabel(q.type)})');
    }

    buffer.writeln();
    buffer.writeln();
    buffer.write(
      '${'appName'.tr}\n'
      '${ApiConstants.appUrl}',
    );
    return buffer.toString();
  }

  /// يعيد تسمية عربية لنوع الاقتباس (للنسخ/المشاركة).
  String _quotationTypeLabel(QuotationType type) {
    switch (type) {
      case QuotationType.ayah:
        return 'آية قرآنية';
      case QuotationType.hadith:
        return 'حديث نبوي';
      case QuotationType.tafsir:
        return 'تفسير';
      case QuotationType.scholar:
        return 'قول لعالم';
      case QuotationType.fiqh:
        return 'نص فقهي';
      case QuotationType.aqeedah:
        return 'نص عقدي';
      case QuotationType.seerah:
        return 'سيرة وتاريخ';
      case QuotationType.other:
        return 'نص منقول';
    }
  }

  /// يحفظ محادثة المساعد الحالية في السجل.
  void _saveAssistantToHistory(String firstQuery) {
    try {
      if (state.assistantMessages.isEmpty) return;
      final now = DateTime.now();
      final entry = ChatHistoryEntry(
        id: '${now.millisecondsSinceEpoch}',
        query: firstQuery,
        date: now,
        type: ChatHistoryType.assistant,
        sectionResults: const {},
        messages: state.assistantMessages.toList(),
      );
      _chatHistoryService.saveEntry(entry);
    } catch (e) {
      print('[AiSearch] Failed to save assistant history: $e');
    }
  }

  /// يحمّل محادثة مساعد سابقة من السجل إلى الواجهة.
  void loadAssistantFromHistory(ChatHistoryEntry entry) {
    state.searchTextEditing.clear();
    state.hasInputText.value = false;
    state.clearAssistantMessages();
    for (final msg in entry.messages) {
      state.assistantMessages.add(msg);
    }
    state.midasMode.value = MidasMode.assistant;
  }

  /// يحمّل سجل محادثات سابق (يفرّع حسب النوع).
  void loadFromHistory(ChatHistoryEntry entry) {
    if (entry.type == ChatHistoryType.assistant) {
      loadAssistantFromHistory(entry);
      return;
    }
    // البحث الدلالي (السلوك الأصلي).
    state.searchTextEditing.text = entry.query;
    state.clearResults();

    for (final section in SearchSection.all) {
      final savedResults = entry.sectionResults[section.id];
      if (savedResults != null && savedResults.isNotEmpty) {
        final results = savedResults.map((r) => r.toSearchResult()).toList();
        state.setSectionResults(section.id, results);
      }
    }

    state.introStreamed.value = true;
    state.allResultsReady.value = true;
    state._markNewCardsCompleted();
    state.midasMode.value = MidasMode.semantic;
  }

  @override
  void onClose() {
    state.searchTextEditing.removeListener(_syncInputText);
    state.searchTextEditing.dispose();
    assistantScrollController.dispose();
    super.onClose();
  }
}

class _SeededRandom {
  int _state;
  _SeededRandom(int seed) : _state = seed == 0 ? 1 : seed;
  double nextDouble() {
    _state ^= _state << 13;
    _state ^= _state >> 17;
    _state ^= _state << 5;
    return (_state & 0x7FFFFFFF) / 0x7FFFFFFF;
  }
}
