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

/// Index for a single section — disk-based, only metadata in RAM
class _SectionIndex {
  List<SearchMetadata>? metadata;
  int vectorCount = 0;
  int dimension = 384;
  String? binaryPath;

  bool get isLoaded => metadata != null && binaryPath != null;
  int get chunkCount => metadata?.length ?? 0;
}

/// Serializable params for isolate search
class _IsolateSearchParams {
  final String binaryPath;
  final Float64List queryEmbedding;
  final int dimension;
  final int vectorCount;
  final int topK;
  final Float64List? bm25Scores;
  final double embeddingWeight;
  final double bm25Weight;

  _IsolateSearchParams({
    required this.binaryPath,
    required this.queryEmbedding,
    required this.dimension,
    required this.vectorCount,
    required this.topK,
    this.bm25Scores,
    this.embeddingWeight = 0.7,
    this.bm25Weight = 0.3,
  });
}

/// Result from isolate
class _IsolateSearchResult {
  final List<int> indices;
  final List<double> scores;

  _IsolateSearchResult(this.indices, this.scores);
}

/// Vector search service — disk-streaming search via Isolate
///
/// Binary file layout (little-endian):
///   [0..3]   vectorCount  (int32)
///   [4..7]   dimension    (int32)
///   [8..15]  reserved
///   [16..]   vectors      (vectorCount × dimension bytes, raw Int8)
///   [...]    scales       (vectorCount × 2 bytes, Float16 as Uint16 LE)
class VectorSearchService {
  static final VectorSearchService _instance = VectorSearchService._();
  factory VectorSearchService() => _instance;
  VectorSearchService._();

  final Map<String, _SectionIndex> _sections = {};

  bool isSectionLoaded(String sectionId) =>
      _sections[sectionId]?.isLoaded ?? false;

  int sectionChunkCount(String sectionId) =>
      _sections[sectionId]?.chunkCount ?? 0;

  int get totalChunkCount =>
      _sections.values.fold(0, (sum, s) => sum + s.chunkCount);

  List<String> get loadedSections => _sections.entries
      .where((e) => e.value.isLoaded)
      .map((e) => e.key)
      .toList();

  /// Check if a flat binary exists for this section
  Future<bool> hasBinary(String sectionId) async {
    final dir = await _getSectionDir(sectionId);
    return File('${dir.path}/vectors_flat.bin').exists();
  }

  /// Convert NPZ → flat binary. Called ONCE per section during download.
  Future<void> convertNpzToBinary(String sectionId) async {
    final dir = await _getSectionDir(sectionId);
    final npzFile = File('${dir.path}/vectors_int8.npz');
    final binaryFile = File('${dir.path}/vectors_flat.bin');

    if (await binaryFile.exists()) return;
    if (!await npzFile.exists()) {
      throw Exception('NPZ not found for: $sectionId');
    }

    print('[VectorSearch] Converting NPZ → binary for $sectionId...');

    final npzBytes = await npzFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(npzBytes);

    Int8List? vectorsData;
    int? vectorCount;
    int? dimension;
    Uint16List? scalesUint16;

    for (final file in archive) {
      if (!file.isFile) continue;
      if (file.name == 'vectors.npy') {
        final result = _parseNpyInt8(file.content);
        vectorCount = result['count'] as int;
        dimension = result['dim'] as int;
        vectorsData = result['data'] as Int8List;
      } else if (file.name == 'scales.npy') {
        scalesUint16 = _parseNpyFloat16AsUint16(file.content);
      }
    }

    if (vectorsData == null || vectorCount == null) {
      throw Exception('Invalid NPZ for: $sectionId');
    }
    dimension ??= 384;

    final raf = await binaryFile.open(mode: FileMode.write);

    try {
      final header = ByteData(16);
      header.setInt32(0, vectorCount, Endian.little);
      header.setInt32(4, dimension, Endian.little);
      header.setInt32(8, 0, Endian.little);
      header.setInt32(12, 0, Endian.little);
      await raf.writeFrom(header.buffer.asUint8List());

      // Write vectors in 1 MB chunks
      const writeChunk = 1024 * 1024;
      int written = 0;
      final totalVecBytes = vectorCount * dimension;
      while (written < totalVecBytes) {
        final end = min(written + writeChunk, totalVecBytes);
        await raf.writeFrom(
          vectorsData.buffer.asUint8List(
            vectorsData.offsetInBytes + written,
            end - written,
          ),
        );
        written = end;
      }

      // Scales
      if (scalesUint16 != null) {
        final scaleBytes = Uint8List(scalesUint16.length * 2);
        final bd = ByteData.sublistView(scaleBytes);
        for (int i = 0; i < scalesUint16.length; i++) {
          bd.setUint16(i * 2, scalesUint16[i], Endian.little);
        }
        await raf.writeFrom(scaleBytes);
      } else {
        final defaultScale = Uint8List(vectorCount * 2);
        final bd = ByteData.sublistView(defaultScale);
        for (int i = 0; i < vectorCount; i++) {
          bd.setUint16(i * 2, 0x3C00, Endian.little);
        }
        await raf.writeFrom(defaultScale);
      }
      await raf.flush();
    } finally {
      await raf.close();
    }

    try {
      await npzFile.delete();
    } catch (_) {}

    print(
      '[VectorSearch] Converted $sectionId: $vectorCount vectors × $dimension = '
      '${(await binaryFile.length() / 1024 / 1024).toStringAsFixed(1)} MB',
    );
  }

  /// Load section — lightweight: metadata + binary header only.
  Future<void> loadSection(String sectionId) async {
    if (_sections[sectionId]?.isLoaded ?? false) return;

    final dir = await _getSectionDir(sectionId);
    final index = _sections[sectionId] ??= _SectionIndex();

    final metaFile = File('${dir.path}/metadata.json');
    if (!await metaFile.exists()) {
      throw Exception('Metadata not found for section: $sectionId');
    }

    final metaJson = json.decode(await metaFile.readAsString()) as List;
    index.metadata = metaJson
        .map((e) => SearchMetadata.fromJson(e as Map<String, dynamic>))
        .toList();

    final binaryFile = File('${dir.path}/vectors_flat.bin');
    if (!await binaryFile.exists()) {
      throw Exception('Binary file not found for $sectionId');
    }

    final raf = await binaryFile.open(mode: FileMode.read);
    try {
      final header = await raf.read(16);
      final bd = ByteData.sublistView(header);
      index.vectorCount = bd.getInt32(0, Endian.little);
      index.dimension = bd.getInt32(4, Endian.little);
    } finally {
      await raf.close();
    }

    index.binaryPath = binaryFile.path;
  }

  // ── Search ──────────────────────────────────────────────────────────

  Future<List<SearchResult>> searchSection(
    String sectionId,
    List<double> queryEmbedding, {
    int topK = 10,
  }) async {
    final index = _sections[sectionId];
    if (index == null || !index.isLoaded) return [];

    return _runSearch(index, queryEmbedding, sectionId, topK);
  }

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

    return _runSearch(
      index,
      queryEmbedding,
      sectionId,
      topK,
      bm25Scores: bm25Scores,
      embeddingWeight: embeddingWeight,
      bm25Weight: bm25Weight,
    );
  }

  /// Run search in a background Isolate to avoid blocking the main thread.
  Future<List<SearchResult>> _runSearch(
    _SectionIndex index,
    List<double> queryEmbedding,
    String sectionId,
    int topK, {
    List<double>? bm25Scores,
    double embeddingWeight = 0.7,
    double bm25Weight = 0.3,
  }) async {
    // Convert query to Float64List for efficient isolate transfer
    final queryFloat64 = Float64List.fromList(queryEmbedding);
    final bm25Float64 =
        bm25Scores != null ? Float64List.fromList(bm25Scores) : null;

    final params = _IsolateSearchParams(
      binaryPath: index.binaryPath!,
      queryEmbedding: queryFloat64,
      dimension: index.dimension,
      vectorCount: index.vectorCount,
      topK: topK,
      bm25Scores: bm25Float64,
      embeddingWeight: embeddingWeight,
      bm25Weight: bm25Weight,
    );

    // Run heavy computation in Isolate
    final result = await Isolate.run(() => _isolateSearch(params));

    // Map indices back to SearchResults
    return List.generate(result.indices.length, (i) {
      return SearchResult(
        score: result.scores[i],
        metadata: index.metadata![result.indices[i]],
        sectionId: sectionId,
      );
    });
  }

  /// Heavy search computation — runs in a background Isolate.
  /// Reads binary file chunk-by-chunk and maintains top-K min-heap.
  static _IsolateSearchResult _isolateSearch(_IsolateSearchParams params) {
    final binaryFile = File(params.binaryPath);
    final count = params.vectorCount;
    final dim = params.dimension;
    final query = params.queryEmbedding;
    final topK = params.topK;
    final bm25 = params.bm25Scores;
    final embW = params.embeddingWeight;
    final bm25W = params.bm25Weight;

    // Min-heap for top-K: heap[0] is always the WORST of the top-K
    // so we can quickly decide whether to replace it.
    final heapIndices = <int>[];
    final heapScores = <double>[];

    void heapPush(int idx, double score) {
      heapIndices.add(idx);
      heapScores.add(score);
      int i = heapIndices.length - 1;
      while (i > 0) {
        final parent = (i - 1) >> 1;
        if (heapScores[parent] <= heapScores[i]) break;
        // Swap
        final ti = heapIndices[i];
        final ts = heapScores[i];
        heapIndices[i] = heapIndices[parent];
        heapScores[i] = heapScores[parent];
        heapIndices[parent] = ti;
        heapScores[parent] = ts;
        i = parent;
      }
    }

    void heapReplaceMin(int idx, double score) {
      heapIndices[0] = idx;
      heapScores[0] = score;
      int i = 0;
      while (true) {
        int smallest = i;
        final left = 2 * i + 1;
        final right = 2 * i + 2;
        if (left < heapIndices.length && heapScores[left] < heapScores[smallest]) {
          smallest = left;
        }
        if (right < heapIndices.length && heapScores[right] < heapScores[smallest]) {
          smallest = right;
        }
        if (smallest == i) break;
        final ti = heapIndices[i];
        final ts = heapScores[i];
        heapIndices[i] = heapIndices[smallest];
        heapScores[i] = heapScores[smallest];
        heapIndices[smallest] = ti;
        heapScores[smallest] = ts;
        i = smallest;
      }
    }

    // Read file in chunks
    const chunkSize = 1024;
    final vectorsOffset = 16;
    final scalesOffset = 16 + count * dim;

    // Synchronous file reading in isolate
    final raf = binaryFile.openSync(mode: FileMode.read);

    try {
      for (int start = 0; start < count; start += chunkSize) {
        final end = min(start + chunkSize, count);
        final chunkLen = end - start;

        raf.setPositionSync(vectorsOffset + start * dim);
        final vecBytes = raf.readSync(chunkLen * dim);

        raf.setPositionSync(scalesOffset + start * 2);
        final scaleBytes = raf.readSync(chunkLen * 2);

        for (int i = 0; i < chunkLen; i++) {
          final globalIdx = start + i;

          // Float16 scale
          final scaleBits =
              scaleBytes[i * 2] | (scaleBytes[i * 2 + 1] << 8);
          final scale = _float16ToDouble(scaleBits);

          // Dot product with dequantization
          double dot = 0;
          final vOff = i * dim;
          for (int d = 0; d < dim; d++) {
            dot += query[d] * vecBytes[vOff + d].toSigned(8);
          }
          dot = dot / 127.0 * scale;

          // Score
          double score;
          if (bm25 != null && globalIdx < bm25.length) {
            score = embW * dot + bm25W * bm25[globalIdx];
          } else {
            score = dot;
          }

          // Maintain top-K min-heap
          if (heapIndices.length < topK) {
            heapPush(globalIdx, score);
          } else if (score > heapScores[0]) {
            heapReplaceMin(globalIdx, score);
          }
        }
      }
    } finally {
      raf.closeSync();
    }

    // Sort results descending by score
    final combined = List.generate(
      heapIndices.length,
      (i) => (heapIndices[i], heapScores[i]),
    );
    combined.sort((a, b) => b.$2.compareTo(a.$2));

    return _IsolateSearchResult(
      combined.map((e) => e.$1).toList(),
      combined.map((e) => e.$2).toList(),
    );
  }

  void unloadSection(String sectionId) {
    _sections.remove(sectionId);
  }

  // ── NPY parsing (used only during conversion) ───────────────────────

  Map<String, dynamic> _parseNpyInt8(Uint8List bytes) {
    int offset = 8;
    final headerLen = bytes[offset] | (bytes[offset + 1] << 8);
    offset += 2 + headerLen;
    final count = (bytes.length - offset) ~/ 384;
    final dim = 384;
    final data = Int8List.view(
      bytes.buffer,
      bytes.offsetInBytes + offset,
      count * dim,
    );
    return {'count': count, 'dim': dim, 'data': data};
  }

  Uint16List _parseNpyFloat16AsUint16(Uint8List bytes) {
    int offset = 8;
    final headerLen = bytes[offset] | (bytes[offset + 1] << 8);
    offset += 2 + headerLen;
    final count = (bytes.length - offset) ~/ 2;
    return Uint16List.view(
      bytes.buffer,
      bytes.offsetInBytes + offset,
      count,
    );
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
