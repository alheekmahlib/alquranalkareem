part of '../ai_search.dart';

class AiSearchState {
  final searchTextEditing = TextEditingController();

  // Per-section download status
  final Map<String, RxBool> _sectionLoaded = {};
  final Map<String, RxBool> _sectionDownloading = {};
  final Map<String, RxDouble> _sectionProgress = {};
  final Map<String, RxString> _sectionStatus = {};

  // Shared model status
  final isSharedLoaded = false.obs;

  // Global states
  final isSearching = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final downloadingSectionId = ''.obs; // which section is currently downloading

  // Search results per section
  final Map<String, RxList<SearchResult>> _allResults = {};
  final Map<String, RxList<SearchResult>> _displayResults = {};

  // Progressive loading
  final searchingCategory = ''.obs;
  final allResultsReady = false.obs;

  // Streaming state
  final completedCards = <String>{}.obs;
  final nextStreamingKey = RxnString();
  final introStreamed = false.obs; // streaming intro text completed

  // Enabled sections filter (persisted)
  static const _enabledSectionsKey = 'ai_search_enabled_sections';
  final enabledSections = <String>{}.obs;

  void loadEnabledSections() {
    try {
      final box = GetStorage();
      final saved = box.read<List<String>>(_enabledSectionsKey);
      if (saved != null) {
        enabledSections.addAll(saved);
      }
    } catch (_) {}
  }

  void saveEnabledSections() {
    try {
      final box = GetStorage();
      box.write(_enabledSectionsKey, enabledSections.toList());
    } catch (_) {}
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
