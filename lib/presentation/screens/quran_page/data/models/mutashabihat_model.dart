/// Model for mutashabihat (similar) phrases in the Quran
class MutashabihatPhraseModel {
  final int phraseId;
  final int surahsCount;
  final int ayahsCount;
  final int count;
  final MutashabihatSource source;
  final Map<String, List<List<int>>> ayah;

  MutashabihatPhraseModel({
    required this.phraseId,
    required this.surahsCount,
    required this.ayahsCount,
    required this.count,
    required this.source,
    required this.ayah,
  });

  factory MutashabihatPhraseModel.fromJson(int key, Map<String, dynamic> json) {
    final ayahJson = json['ayah'] as Map<String, dynamic>? ?? {};
    final ayahMap = <String, List<List<int>>>{};

    ayahJson.forEach((key, value) {
      if (value is List) {
        ayahMap[key] = value.map((e) {
          if (e is List) {
            return e.map((i) => i as int).toList();
          }
          return <int>[];
        }).toList();
      }
    });

    return MutashabihatPhraseModel(
      phraseId: key,
      surahsCount: json['surahs'] as int? ?? 0,
      ayahsCount: json['ayahs'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
      source: MutashabihatSource.fromJson(
        json['source'] as Map<String, dynamic>? ?? {},
      ),
      ayah: ayahMap,
    );
  }
}

/// Source information for a mutashabihat phrase
class MutashabihatSource {
  final String key;
  final int from;
  final int to;

  MutashabihatSource({required this.key, required this.from, required this.to});

  factory MutashabihatSource.fromJson(Map<String, dynamic> json) {
    return MutashabihatSource(
      key: json['key'] as String? ?? '',
      from: json['from'] as int? ?? 0,
      to: json['to'] as int? ?? 0,
    );
  }
}

/// Model for a similar verse
class SimilarVerseModel {
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final List<List<int>> positions;

  SimilarVerseModel({
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.positions,
  });

  factory SimilarVerseModel.fromVerseKey(
    String key,
    List<List<int>> positions,
  ) {
    final parts = key.split(':');
    return SimilarVerseModel(
      verseKey: key,
      surahNumber: int.tryParse(parts[0]) ?? 0,
      ayahNumber: int.tryParse(parts[1]) ?? 0,
      positions: positions,
    );
  }
}

/// Result for a single phrase found in a verse
class MutashabihatPhraseResult {
  final MutashabihatPhraseModel phrase;
  final List<int> wordPositions;
  final List<SimilarVerseModel> similarVerses;

  MutashabihatPhraseResult({
    required this.phrase,
    required this.wordPositions,
    required this.similarVerses,
  });
}

/// Result of mutashabihat lookup for a verse — contains all phrases
class MutashabihatResult {
  final List<MutashabihatPhraseResult> phrases;
  final bool hasPhrases;

  MutashabihatResult({required this.phrases}) : hasPhrases = phrases.isNotEmpty;
}
