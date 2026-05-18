part of '../ai_search.dart';

/// Metadata entry for a single chunk
class SearchMetadata {
  final int id;
  final String preview;
  final String source;
  final String author;
  final String type;
  final String reference;
  final Map<String, dynamic> details;

  SearchMetadata({
    required this.id,
    required this.preview,
    required this.source,
    this.author = '',
    required this.type,
    required this.reference,
    this.details = const {},
  });

  factory SearchMetadata.fromJson(Map<String, dynamic> json) {
    return SearchMetadata(
      id: json['i'] as int,
      preview: json['p'] as String,
      source: json['s'] as String,
      author: json['a'] as String? ?? '',
      type: json['t'] as String,
      reference: json['r'] as String? ?? '',
      details: json['d'] as Map<String, dynamic>? ?? {},
    );
  }
}

/// Search result with score
class SearchResult {
  final double score;
  final SearchMetadata metadata;
  final String sectionId;

  SearchResult({
    required this.score,
    required this.metadata,
    required this.sectionId,
  });
}

/// Index for a single section
class _SectionIndex {
  List<Int8List>? vectors;
  List<double>? scales;
  List<SearchMetadata>? metadata;
  int? dimension;

  bool get isLoaded => vectors != null && metadata != null;
  int get chunkCount => metadata?.length ?? 0;
}

/// Vector search service — loads INT8 vectors + metadata per section
/// v2: Multiple sections with hybrid search support
class VectorSearchService {
  static final VectorSearchService _instance = VectorSearchService._();
  factory VectorSearchService() => _instance;
  VectorSearchService._();

  final Map<String, _SectionIndex> _sections = {};

  /// Check if a section is loaded
  bool isSectionLoaded(String sectionId) =>
      _sections[sectionId]?.isLoaded ?? false;

  /// Get chunk count for a section
  int sectionChunkCount(String sectionId) =>
      _sections[sectionId]?.chunkCount ?? 0;

  /// Get total chunks across all loaded sections
  int get totalChunkCount =>
      _sections.values.fold(0, (sum, s) => sum + s.chunkCount);

  /// Get loaded section IDs
  List<String> get loadedSections => _sections.entries
      .where((e) => e.value.isLoaded)
      .map((e) => e.key)
      .toList();

  /// Load vectors and metadata for a specific section
  Future<void> loadSection(String sectionId) async {
    if (_sections[sectionId]?.isLoaded ?? false) return;

    final dir = await _getSectionDir(sectionId);
    final index = _sections[sectionId] ??= _SectionIndex();

    // Load metadata
    final metaFile = File('${dir.path}/metadata.json');
    if (!await metaFile.exists()) {
      throw Exception('Metadata not found for section: $sectionId');
    }

    final metaJson = json.decode(await metaFile.readAsString()) as List;
    index.metadata = metaJson
        .map((e) => SearchMetadata.fromJson(e as Map<String, dynamic>))
        .toList();

    // Load INT8 vectors
    final npzFile = File('${dir.path}/vectors_int8.npz');
    if (!await npzFile.exists()) {
      throw Exception('Vectors not found for section: $sectionId');
    }

    final npzBytes = await npzFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(npzBytes);

    Int8List? vectorsData;
    int? vectorCount;
    int? dimension;
    Float16List? scalesData;

    for (final file in archive) {
      if (!file.isFile) continue;
      if (file.name == 'vectors.npy') {
        final result = _parseNpyInt8(file.content);
        vectorCount = result['count'] as int;
        dimension = result['dim'] as int;
        vectorsData = result['data'] as Int8List;
      } else if (file.name == 'scales.npy') {
        scalesData = _parseNpyFloat16(file.content);
      }
    }

    if (vectorsData == null || vectorCount == null || dimension == null) {
      throw Exception('Invalid NPZ for section: $sectionId');
    }

    index.dimension = dimension;

    // Split flat array into per-vector Int8Lists
    index.vectors = [];
    for (int i = 0; i < vectorCount; i++) {
      final start = i * dimension;
      index.vectors!.add(
        Int8List.fromList(vectorsData.sublist(start, start + dimension)),
      );
    }

    // Convert float16 scales to doubles
    if (scalesData != null) {
      index.scales = scalesData.map((h) => _float16ToDouble(h)).toList();
    } else {
      index.scales = List.filled(vectorCount, 1.0);
    }
  }

  /// Unload a section from memory
  void unloadSection(String sectionId) {
    final index = _sections[sectionId];
    if (index != null) {
      index.vectors = null;
      index.scales = null;
      index.metadata = null;
      index.dimension = null;
    }
    _sections.remove(sectionId);
  }

  /// Hybrid search within a specific section
  Future<List<SearchResult>> hybridSearchSection(
    String sectionId,
    List<double> queryEmbedding,
    List<double> bm25Scores, {
    int topK = 10,
    double embeddingWeight = 0.7,
    double bm25Weight = 0.3,
  }) async {
    final index = _sections[sectionId];
    if (index == null || !index.isLoaded) return [];

    final dim = index.dimension!;
    final results = <_ScoredIndex>[];

    for (int i = 0; i < index.vectors!.length; i++) {
      final vec = index.vectors![i];
      final scale = index.scales![i];

      double dotProduct = 0;
      for (int d = 0; d < dim; d++) {
        final deq = vec[d] / 127.0 * scale;
        dotProduct += queryEmbedding[d] * deq;
      }

      final bm25 = i < bm25Scores.length ? bm25Scores[i] : 0.0;
      final hybridScore = embeddingWeight * dotProduct + bm25Weight * bm25;

      results.add(_ScoredIndex(i, hybridScore));
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    return results.take(topK).map((r) {
      return SearchResult(
        score: r.score,
        metadata: index.metadata![r.index],
        sectionId: sectionId,
      );
    }).toList();
  }

  /// Pure embedding search within a specific section
  Future<List<SearchResult>> searchSection(
    String sectionId,
    List<double> queryEmbedding, {
    int topK = 10,
  }) async {
    final index = _sections[sectionId];
    if (index == null || !index.isLoaded) return [];

    final dim = index.dimension!;
    final results = <_ScoredIndex>[];

    for (int i = 0; i < index.vectors!.length; i++) {
      final vec = index.vectors![i];
      final scale = index.scales![i];

      double dotProduct = 0;
      for (int d = 0; d < dim; d++) {
        final deq = vec[d] / 127.0 * scale;
        dotProduct += queryEmbedding[d] * deq;
      }

      results.add(_ScoredIndex(i, dotProduct));
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    return results.take(topK).map((r) {
      return SearchResult(
        score: r.score,
        metadata: index.metadata![r.index],
        sectionId: sectionId,
      );
    }).toList();
  }

  Map<String, dynamic> _parseNpyInt8(Uint8List bytes) {
    int offset = 8;
    final headerLen = bytes[offset] | (bytes[offset + 1] << 8);
    offset += 2 + headerLen;
    final count = (bytes.length - offset) ~/ 384;
    final dim = 384;
    final data = Int8List.view(
      bytes.buffer,
      bytes.offsetInBytes + offset,
      bytes.lengthInBytes - offset,
    );
    return {'count': count, 'dim': dim, 'data': data};
  }

  Float16List _parseNpyFloat16(Uint8List bytes) {
    int offset = 8;
    final headerLen = bytes[offset] | (bytes[offset + 1] << 8);
    offset += 2 + headerLen;
    final count = (bytes.length - offset) ~/ 2;
    final uint16Data = Uint16List.view(
      bytes.buffer,
      bytes.offsetInBytes + offset,
      count,
    );
    return Float16List.fromUint16List(uint16Data);
  }

  static double _float16ToDouble(int bits) {
    final sign = (bits & 0x8000) != 0 ? -1 : 1;
    final exponent = (bits & 0x7C00) >> 10;
    final mantissa = bits & 0x03FF;

    if (exponent == 0) {
      return sign * mantissa * pow(2, -24).toDouble();
    } else if (exponent == 31) {
      return sign * (mantissa == 0 ? double.infinity : double.nan);
    }
    return sign * pow(2, exponent - 15).toDouble() * (1 + mantissa / 1024.0);
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

/// Float16 list wrapper
class Float16List {
  final Uint16List _data;
  Float16List._(this._data);
  factory Float16List.fromUint16List(Uint16List data) => Float16List._(data);
  int get length => _data.length;
  int operator [](int index) => _data[index];
  Iterable<double> map(double Function(int bits) converter) sync* {
    for (int i = 0; i < _data.length; i++) {
      yield converter(_data[i]);
    }
  }

  factory Float16List.filled(int count, int value) {
    final data = Uint16List(count);
    data.fillRange(0, count, value);
    return Float16List._(data);
  }
}

class _ScoredIndex {
  final int index;
  final double score;
  _ScoredIndex(this.index, this.score);
}
