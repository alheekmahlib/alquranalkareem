part of '../ai_search.dart';

/// BM25 keyword search service — per-section
class BM25Service {
  static final BM25Service _instance = BM25Service._();
  factory BM25Service() => _instance;
  BM25Service._();

  static const double _k1 = 1.5;
  static const double _b = 0.75;

  final Map<String, _BM25Index> _indexes = {};

  /// Check if a section's BM25 index is loaded
  bool isSectionLoaded(String sectionId) =>
      _indexes[sectionId]?.isLoaded ?? false;

  /// Get doc count for a section
  int sectionDocCount(String sectionId) => _indexes[sectionId]?.docCount ?? 0;

  /// Load BM25 index for a specific section
  Future<void> loadSection(String sectionId) async {
    if (_indexes[sectionId]?.isLoaded ?? false) return;

    final dir = await _getSectionDir(sectionId);
    final bm25File = File('${dir.path}/bm25_index.json');

    final index = _indexes[sectionId] ??= _BM25Index();

    if (!await bm25File.exists()) {
      // No BM25 for this section — mark as loaded (embedding-only)
      index._loaded = true;
      return;
    }

    final jsonStr = await bm25File.readAsString();
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    final idfRaw = data['idf'] as Map<String, dynamic>;
    index._idf = idfRaw.map((k, v) => MapEntry(k, (v as num).toDouble()));
    index._avgdl = (data['avgdl'] as num).toDouble();

    final docsRaw = data['docs'] as List;
    index._docTokens = [];
    index._docLengths = [];

    for (final doc in docsRaw) {
      final docMap = doc as Map<String, dynamic>;
      final tokens = docMap['t'] as Map<String, dynamic>;
      final dl = docMap['d'] as int;
      index._docTokens.add(
        tokens.map((k, v) => MapEntry(k, (v as num).toInt())),
      );
      index._docLengths.add(dl);
    }

    index._loaded = true;
  }

  /// Unload a section's BM25 index
  void unloadSection(String sectionId) {
    _indexes.remove(sectionId);
  }

  /// Score all documents for a section against query
  List<double> score(String sectionId, String query) {
    final index = _indexes[sectionId];
    if (index == null || !index.isLoaded || index._docTokens.isEmpty) {
      return [];
    }

    final queryTokens = _tokenizeArabic(query);
    if (queryTokens.isEmpty) {
      return List.filled(index._docTokens.length, 0.0);
    }

    final scores = List<double>.filled(index._docTokens.length, 0.0);

    for (int i = 0; i < index._docTokens.length; i++) {
      final docTf = index._docTokens[i];
      final dl = index._docLengths[i].toDouble();
      double score = 0;

      for (final token in queryTokens) {
        final tf = docTf[token];
        if (tf == null) continue;

        final wordIdf = index._idf[token] ?? 0;
        final tfNorm =
            (tf * (_k1 + 1)) / (tf + _k1 * (1 - _b + _b * dl / index._avgdl));
        score += wordIdf * tfNorm;
      }
      scores[i] = score;
    }

    return scores;
  }

  /// Normalize scores to [0, 1]
  List<double> normalize(List<double> scores) {
    final maxScore = scores.reduce(max);
    if (maxScore <= 0) return scores;
    return scores.map((s) => s / maxScore).toList();
  }

  List<String> _tokenizeArabic(String text) {
    final normalized = _normalizeArabic(text);
    final regex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FFa-zA-Z0-9]+',
    );
    final words = regex.allMatches(normalized).map((m) => m.group(0)!).toList();

    const stopWords = {
      'في',
      'من',
      'على',
      'الى',
      'عن',
      'مع',
      'هذا',
      'هذه',
      'التي',
      'الذي',
      'الذين',
      'هو',
      'هي',
      'هم',
      'كان',
      'قد',
      'لا',
      'لم',
      'لن',
      'ما',
      'ان',
      'اذ',
      'كل',
      'بعض',
      'اي',
      'بين',
      'ذلك',
      'فى',
      'علي',
      'الي',
      'عليه',
      'عليها',
    };

    return words.where((w) => w.length > 1 && !stopWords.contains(w)).toList();
  }

  String _normalizeArabic(String text) {
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      if (code >= 0x064B && code <= 0x065F) continue;
      if (code == 0x0670) continue;
      final char = text[i];
      if (char == 'أ' || char == 'إ' || char == 'آ' || char == 'ٱ') {
        buffer.write('ا');
      } else if (char == 'ة') {
        buffer.write('ه');
      } else if (char == 'ى') {
        buffer.write('ي');
      } else if (code >= 0x0660 && code <= 0x0669) {
        buffer.write(String.fromCharCode(code - 0x0660 + 0x30));
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  static Future<Directory> _getSectionDir(String sectionId) async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory('${appDir.path}/ai_search/$sectionId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}

class _BM25Index {
  Map<String, double> _idf = {};
  double _avgdl = 100.0;
  List<Map<String, int>> _docTokens = [];
  List<int> _docLengths = [];
  bool _loaded = false;

  bool get isLoaded => _loaded;
  int get docCount => _docTokens.length;
}
