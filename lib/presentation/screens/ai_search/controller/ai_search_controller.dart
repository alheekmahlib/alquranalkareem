part of '../ai_search.dart';

class AiSearchController extends GetxController {
  static AiSearchController get instance => Get.find<AiSearchController>();

  final state = AiSearchState();
  final _searchService = VectorSearchService();
  final _downloadService = ModelDownloadService();
  final _embeddingService = EmbeddingService();
  final _bm25Service = BM25Service();

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
  }

  Future<void> _initCheck() async {
    try {
      // Load persisted enabled sections
      state.loadEnabledSections();

      // Check shared model
      final sharedDownloaded = await _downloadService.isSharedDownloaded();
      state.isSharedLoaded.value = sharedDownloaded;
      print('[AiSearch] Shared downloaded: $sharedDownloaded');

      // Check each section
      for (final section in SearchSection.all) {
        final downloaded = await _downloadService.isSectionDownloaded(section);
        state.setSectionLoaded(section.id, downloaded);
        // Auto-enable newly downloaded sections
        if (downloaded && !state.enabledSections.contains(section.id)) {
          state.enabledSections.add(section.id);
        }
        print('[AiSearch] ${section.id} on disk: $downloaded');
      }
      state.saveEnabledSections();

      // Always try to load downloaded sections into memory
      await _loadDownloadedSections();
    } catch (e) {
      print('[AiSearch] _initCheck error: $e');
    } finally {
      isInitialized.value = true;
      print(
        '[AiSearch] Init complete. Embedding ready: ${_embeddingService.isReady}',
      );
      for (final s in SearchSection.all) {
        print(
          '[AiSearch] ${s.id}: state=${state.isSectionLoaded(s.id).value}, memory=${_searchService.isSectionLoaded(s.id)}',
        );
      }
    }
  }

  Future<void> _loadDownloadedSections() async {
    state.isLoading.value = true;
    try {
      // Init embedding service (shared model)
      await _embeddingService.init();
      print('[AiSearch] Embedding service ready: ${_embeddingService.isReady}');

      // Load each downloaded section
      for (final section in SearchSection.all) {
        if (state.isSectionLoaded(section.id).value) {
          try {
            await _searchService.loadSection(section.id);
            await _bm25Service.loadSection(section.id);
            print(
              '[AiSearch] Loaded section: ${section.titleAr} (${_searchService.sectionChunkCount(section.id)} chunks, BM25: ${_bm25Service.sectionDocCount(section.id)} docs)',
            );
          } catch (e) {
            print('[AiSearch] Failed to load section ${section.id}: $e');
            state.setSectionLoaded(section.id, false);
          }
        }
      }
    } catch (e) {
      print('[AiSearch] Failed to init embedding: $e');
    } finally {
      state.isLoading.value = false;
    }
  }

  /// Download shared model files
  Future<void> downloadShared() async {
    final cancelToken = CancelToken();
    _cancelTokens['shared'] = cancelToken;

    state.isSharedLoaded.value = false;

    try {
      await _downloadService.downloadShared(
        onProgress: (p) {},
        onStatus: (s) => log('Shared: $s', name: 'AiSearch'),
        cancelToken: cancelToken,
      );
      state.isSharedLoaded.value = true;
      await _embeddingService.init();
    } catch (e) {
      if (!cancelToken.isCancelled) {
        log('Shared download failed: $e', name: 'AiSearch');
      }
    } finally {
      _cancelTokens.remove('shared');
    }
  }

  /// Download a specific section
  Future<void> downloadSection(SearchSection section) async {
    // Prevent starting a new download if previous one is still running
    if (_cancelTokens.containsKey(section.id)) return;

    // Ensure shared model is downloaded first
    if (!state.isSharedLoaded.value) {
      await downloadShared();
    }

    final cancelToken = CancelToken();
    _cancelTokens[section.id] = cancelToken;

    state.resetSectionProgress(section.id);
    state.setSectionDownloading(section.id, true);
    state.downloadingSectionId.value = section.id;

    try {
      await _downloadService.downloadSection(
        section,
        onProgress: (p) => state.sectionProgress(section.id).value = p,
        onStatus: (s) => state.sectionStatus(section.id).value = s,
        cancelToken: cancelToken,
      );

      // Load the newly downloaded section
      await _searchService.loadSection(section.id);
      await _bm25Service.loadSection(section.id);
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

  /// Cancel a section download
  void cancelDownload(String sectionId) {
    _cancelTokens[sectionId]?.cancel();
    // Update UI immediately so user sees feedback
    state.setSectionDownloading(sectionId, false);
    state.resetSectionProgress(sectionId);
    state.downloadingSectionId.value = '';
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
      // Get embedding once
      List<double> embedding;
      if (_embeddingService.isReady) {
        print('[AiSearch] Using real embedding for: $query');
        embedding = await _embeddingService.embed(query);
      } else {
        print(
          '[AiSearch] WARNING: Embedding not ready, using pseudo embedding',
        );
        embedding = _pseudoEmbedding(query);
      }

      // Search each loaded & enabled section
      for (final section in SearchSection.all) {
        if (!state.isSectionEnabled(section.id)) {
          print(
            '[AiSearch] Skipping ${section.id}: not enabled for search',
          );
          continue;
        }
        if (!state.isSectionLoaded(section.id).value) {
          print(
            '[AiSearch] Skipping ${section.id}: not marked as loaded in state',
          );
          continue;
        }
        if (!_searchService.isSectionLoaded(section.id)) {
          print(
            '[AiSearch] Skipping ${section.id}: data not in memory (hot restart issue?)',
          );
          continue;
        }

        List<SearchResult> results;

        if (_bm25Service.isSectionLoaded(section.id) &&
            _bm25Service.sectionDocCount(section.id) > 0) {
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

  void clearSearch() {
    state.searchTextEditing.clear();
    state.clearResults();
    state.errorMessage.value = '';
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
