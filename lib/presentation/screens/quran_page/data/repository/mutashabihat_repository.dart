import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/mutashabihat_model.dart';

/// Repository for loading and managing mutashabihat (similar) phrases data
class MutashabihatRepository {
  static MutashabihatRepository? _instance;
  static MutashabihatRepository get instance =>
      _instance ??= MutashabihatRepository._();

  MutashabihatRepository._();

  Map<int, MutashabihatPhraseModel>? _phrasesCache;
  Map<String, List<int>>? _verseToPhrasesCache;

  /// Load mutashabihat phrases from JSON asset
  Future<void> loadData() async {
    if (_phrasesCache != null) return;

    try {
      final phrasesJsonString = await rootBundle.loadString(
        'assets/json/mutashabihat_phrases.json',
      );
      final phrasesJson =
          json.decode(phrasesJsonString) as Map<String, dynamic>;

      _phrasesCache = {};
      phrasesJson.forEach((key, value) {
        final phraseId = int.tryParse(key) ?? 0;
        if (value is Map<String, dynamic>) {
          _phrasesCache![phraseId] = MutashabihatPhraseModel.fromJson(
            phraseId,
            value,
          );
        }
      });
    } catch (e) {
      _phrasesCache = {};
    }

    try {
      final versesJsonString = await rootBundle.loadString(
        'assets/json/mutashabihat_phrase_verses.json',
      );
      final versesJson = json.decode(versesJsonString) as Map<String, dynamic>;

      _verseToPhrasesCache = {};
      versesJson.forEach((key, value) {
        if (value is List) {
          final phraseIds = value.map((e) => e as int).toList();
          _verseToPhrasesCache![key] = phraseIds;
        }
      });
    } catch (e) {
      _verseToPhrasesCache = {};
    }
  }

  /// Get mutashabihat phrases for a specific verse
  MutashabihatResult? getMutashabihatForVerse(int surahNumber, int ayahNumber) {
    final verseKey = '$surahNumber:$ayahNumber';
    return getMutashabihatForVerseKey(verseKey);
  }

  /// Get mutashabihat phrases for a specific verse key
  MutashabihatResult? getMutashabihatForVerseKey(String verseKey) {
    if (_phrasesCache == null || _verseToPhrasesCache == null) {
      return null;
    }

    final phraseIds = _verseToPhrasesCache![verseKey];
    if (phraseIds == null || phraseIds.isEmpty) {
      return null;
    }

    final phraseResults = <MutashabihatPhraseResult>[];

    for (final phraseId in phraseIds) {
      final phrase = _phrasesCache![phraseId];
      if (phrase == null) continue;

      // Get the word positions for the current verse in this phrase
      final currentVersePositions = phrase.ayah[verseKey];
      final wordPositions =
          (currentVersePositions != null && currentVersePositions.isNotEmpty)
          ? currentVersePositions.first
          : <int>[];

      // Collect similar verses (all other verses in this phrase)
      final similarVerses = <SimilarVerseModel>[];
      phrase.ayah.forEach((key, positions) {
        if (key != verseKey) {
          similarVerses.add(SimilarVerseModel.fromVerseKey(key, positions));
        }
      });

      phraseResults.add(
        MutashabihatPhraseResult(
          phrase: phrase,
          wordPositions: wordPositions,
          similarVerses: similarVerses,
        ),
      );
    }

    if (phraseResults.isEmpty) {
      return null;
    }

    return MutashabihatResult(phrases: phraseResults);
  }

  /// Check if a verse has mutashabihat (similar) verses
  bool hasMutashabihat(int surahNumber, int ayahNumber) {
    final verseKey = '$surahNumber:$ayahNumber';
    final phraseIds = _verseToPhrasesCache?[verseKey];
    return phraseIds != null && phraseIds.isNotEmpty;
  }

  /// Get all phrase IDs for a verse
  List<int> getPhraseIdsForVerse(int surahNumber, int ayahNumber) {
    final verseKey = '$surahNumber:$ayahNumber';
    return _verseToPhrasesCache?[verseKey] ?? [];
  }

  /// Get phrases count for a specific verse
  int getPhrasesCount(int surahNumber, int ayahNumber) {
    final verseKey = '$surahNumber:$ayahNumber';
    return _verseToPhrasesCache?[verseKey]?.length ?? 0;
  }

  /// Get all verse keys that have mutashabihat in a specific surah
  List<String> getVerseKeysInSurah(int surahNumber) {
    if (_verseToPhrasesCache == null) return [];
    return _verseToPhrasesCache!.keys
        .where((key) => key.startsWith('$surahNumber:'))
        .toList();
  }

  /// Get all verse keys grouped by surah number
  Map<int, List<String>> getAllVerseKeysGroupedBySurah() {
    if (_verseToPhrasesCache == null) return {};
    final grouped = <int, List<String>>{};
    for (final key in _verseToPhrasesCache!.keys) {
      final surahNumber = int.tryParse(key.split(':').first) ?? 0;
      grouped.putIfAbsent(surahNumber, () => []).add(key);
    }
    return grouped;
  }

  /// Clear cached data
  void clearCache() {
    _phrasesCache = null;
    _verseToPhrasesCache = null;
  }
}
