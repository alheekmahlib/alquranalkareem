part of '../ai_search.dart';

/// Handles downloading and extracting AI search index files per-section
class ModelDownloadService {
  static final ModelDownloadService _instance = ModelDownloadService._();
  factory ModelDownloadService() => _instance;
  ModelDownloadService._();

  static const String _githubBase =
      'https://github.com/alheekmahlib/Islamic_database/releases/download';
  static const String _versionPrefix = 'ai_search_v2_';
  static const String _sharedVersionKey = 'ai_search_shared_v2';
  static const String _sharedVersion = '1';

  final _box = GetStorage();
  final Dio _dio = Dio();

  /// Check if shared model files are downloaded
  Future<bool> isSharedDownloaded() async {
    final dir = await _getSharedDir();
    final version = _box.read<String>(_sharedVersionKey);
    if (version != _sharedVersion) return false;

    final modelFile = File('${dir.path}/e5_small_int8.onnx');
    final tokenizerFile = File('${dir.path}/tokenizer.json');

    return await modelFile.exists() && await tokenizerFile.exists();
  }

  /// Check if a specific section is downloaded
  /// Accepts either the old NPZ format or the new flat binary format.
  Future<bool> isSectionDownloaded(SearchSection section) async {
    final dir = await _getSectionDir(section.id);
    final version = _box.read<String>('${_versionPrefix}${section.id}');
    if (version == null) return false;

    final metaFile = File('${dir.path}/metadata.json');
    if (!await metaFile.exists()) return false;

    // New format (flat binary)
    final binaryFile = File('${dir.path}/vectors_flat.bin');
    if (await binaryFile.exists()) return true;

    // Legacy format (NPZ — not yet converted)
    final npzFile = File('${dir.path}/vectors_int8.npz');
    return await npzFile.exists();
  }

  /// Get list of downloaded section IDs
  Future<List<String>> getDownloadedSections() async {
    final result = <String>[];
    for (final section in SearchSection.all) {
      if (await isSectionDownloaded(section)) {
        result.add(section.id);
      }
    }
    return result;
  }

  /// Download shared model files (ONNX + tokenizer)
  Future<void> downloadShared({
    void Function(double progress)? onProgress,
    void Function(String status)? onStatus,
    CancelToken? cancelToken,
  }) async {
    final dir = await _getSharedDir();
    final tempDir = await getTemporaryDirectory();

    // Download ONNX model
    onStatus?.call('جاري تحميل نموذج البحث...');
    final modelGz = File('${tempDir.path}/e5_small_int8.onnx.gz');
    await _downloadFile(
      '$_githubBase/${SearchSection.sharedReleaseTag}/e5_small_int8.onnx.gz',
      modelGz,
      onProgress: (p) => onProgress?.call(p * 0.7),
      cancelToken: cancelToken,
    );

    // Download tokenizer
    onStatus?.call('جاري تحميل المحلل اللغوي...');
    final tokenizerGz = File('${tempDir.path}/tokenizer.json.gz');
    await _downloadFile(
      '$_githubBase/${SearchSection.sharedReleaseTag}/tokenizer.json.gz',
      tokenizerGz,
      onProgress: (p) => onProgress?.call(0.7 + p * 0.3),
      cancelToken: cancelToken,
    );

    // Stage decompression to avoid large allocations and partially installed files.
    onStatus?.call('جاري فك الضغط...');
    final modelStage = File('${dir.path}/e5_small_int8.onnx.tmp');
    final tokenizerStage = File('${dir.path}/tokenizer.json.tmp');
    void checkCancelled() {
      if (cancelToken?.isCancelled ?? false) {
        throw DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.cancel,
        );
      }
    }

    try {
      checkCancelled();
      await gzip.decoder.bind(modelGz.openRead()).pipe(modelStage.openWrite());
      checkCancelled();
      await gzip.decoder
          .bind(tokenizerGz.openRead())
          .pipe(tokenizerStage.openWrite());
      checkCancelled();
      if (await modelStage.length() == 0 ||
          await tokenizerStage.length() == 0) {
        throw const FormatException('Empty shared model files');
      }
      jsonDecode(await tokenizerStage.readAsString());
      await _box.remove(_sharedVersionKey);
      await modelStage.rename('${dir.path}/e5_small_int8.onnx');
      await tokenizerStage.rename('${dir.path}/tokenizer.json');
      await _box.write(_sharedVersionKey, _sharedVersion);
    } finally {
      for (final file in [modelStage, tokenizerStage, modelGz, tokenizerGz]) {
        if (await file.exists()) await file.delete();
      }
    }

    onProgress?.call(1.0);
    onStatus?.call('تم تحميل الملفات المشتركة');
  }

  /// Download a specific section
  Future<void> downloadSection(
    SearchSection section, {
    void Function(double progress)? onProgress,
    void Function(String status)? onStatus,
    CancelToken? cancelToken,
  }) async {
    final dir = await _getSectionDir(section.id);
    final tempDir = await getTemporaryDirectory();
    final baseUrl = '$_githubBase/${section.releaseTag}';
    final _cancel = () => cancelToken?.isCancelled ?? false;
    final _throwIfCancelled = () {
      if (_cancel())
        throw DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.cancel,
        );
    };

    // Clean up any leftover files from previous failed attempts
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);

    // Clean up old temp files too
    for (final name in [
      '${section.id}_vectors_int8.npz.gz',
      '${section.id}_metadata.json.gz',
      '${section.id}_bm25_index.json.gz',
    ]) {
      final f = File('${tempDir.path}/$name');
      if (await f.exists()) await f.delete();
    }

    // 1. Vectors
    onStatus?.call('جاري تحميل المتجهات...');
    final vectorsGz = File('${tempDir.path}/${section.id}_vectors_int8.npz.gz');
    await _downloadFile(
      '$baseUrl/vectors_int8.npz.gz',
      vectorsGz,
      onProgress: (p) => onProgress?.call(p * 0.5),
      cancelToken: cancelToken,
    );
    _throwIfCancelled();

    // 2. Metadata
    onStatus?.call('جاري تحميل الفهرس...');
    final metaGz = File('${tempDir.path}/${section.id}_metadata.json.gz');
    await _downloadFile(
      '$baseUrl/metadata.json.gz',
      metaGz,
      onProgress: (p) => onProgress?.call(0.5 + p * 0.2),
      cancelToken: cancelToken,
    );
    _throwIfCancelled();

    // 3. BM25 index (optional)
    File? bm25Gz;
    try {
      onStatus?.call('جاري تحميل فهرس الكلمات...');
      bm25Gz = File('${tempDir.path}/${section.id}_bm25_index.json.gz');
      await _downloadFile(
        '$baseUrl/bm25_index.json.gz',
        bm25Gz,
        onProgress: (p) => onProgress?.call(0.7 + p * 0.15),
        cancelToken: cancelToken,
      );
    } catch (e) {
      bm25Gz = null;
    }
    _throwIfCancelled();

    // Decompress all files
    onStatus?.call('جاري فك الضغط...');
    try {
      // Vectors
      await gzip.decoder
          .bind(vectorsGz.openRead())
          .pipe(File('${dir.path}/vectors_int8.npz').openWrite());

      _throwIfCancelled();

      // Metadata
      await gzip.decoder
          .bind(metaGz.openRead())
          .pipe(File('${dir.path}/metadata.json').openWrite());

      // BM25 (optional)
      if (bm25Gz != null && await bm25Gz.exists()) {
        _throwIfCancelled();
        await gzip.decoder
            .bind(bm25Gz.openRead())
            .pipe(File('${dir.path}/bm25_index.json').openWrite());
      }
    } catch (e) {
      // Clean up any partial decompressed files on failure/cancel
      try {
        await deleteSection(section);
      } catch (_) {}
      rethrow;
    }

    await _box.write('${_versionPrefix}${section.id}', '1');

    // Convert NPZ → flat binary immediately (one section at a time)
    onStatus?.call('جاري تجهيز بيانات البحث...');
    try {
      await VectorSearchService().convertNpzToBinary(section.id);
    } catch (e) {
      log('NPZ conversion failed for ${section.id}: $e', name: 'AiSearch');
      // Clean up on conversion failure
      try {
        await deleteSection(section);
      } catch (_) {}
      rethrow;
    }

    // Cleanup temp gz files
    try {
      await vectorsGz.delete();
      await metaGz.delete();
      await bm25Gz?.delete();
    } catch (_) {}

    onProgress?.call(1.0);
    onStatus?.call('تم تحميل ${section.titleAr}');
  }

  /// Delete shared model files
  Future<void> deleteShared() async {
    final dir = await _getSharedDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await _box.remove(_sharedVersionKey);
  }

  /// Delete a specific section
  Future<void> deleteSection(SearchSection section) async {
    final dir = await _getSectionDir(section.id);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await _box.remove('${_versionPrefix}${section.id}');
  }

  /// Delete all data (shared + sections)
  Future<void> deleteAll() async {
    final baseDir = await _getBaseDir();
    if (await baseDir.exists()) {
      await baseDir.delete(recursive: true);
    }
    // Clean all version keys
    for (final section in SearchSection.all) {
      await _box.remove('${_versionPrefix}${section.id}');
    }
    await _box.remove(_sharedVersionKey);
  }

  /// Get total downloaded size in bytes
  Future<int> getDownloadedSize() async {
    final baseDir = await _getBaseDir();
    if (!await baseDir.exists()) return 0;

    int total = 0;
    await for (final entity in baseDir.list(recursive: true)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }

  Future<void> _downloadFile(
    String url,
    File outputFile, {
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
    int maxRetries = 3,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await _dio.download(
          url,
          outputFile.path,
          cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
            if (total > 0) onProgress?.call(received / total);
          },
        );
        return; // success
      } on DioException catch (e) {
        if (cancelToken?.isCancelled ?? false) rethrow;
        if (attempt < maxRetries - 1 &&
            (e.response?.statusCode == 502 ||
                e.response?.statusCode == 503 ||
                e.response?.statusCode == 429 ||
                e.type == DioExceptionType.connectionError)) {
          // Wait before retry with exponential backoff
          final delay = Duration(seconds: 2 * (attempt + 1));
          print(
            '[ModelDownload] Retry ${attempt + 1}/$maxRetries after ${delay.inSeconds}s (${e.response?.statusCode ?? e.type})',
          );
          await Future.delayed(delay);
          continue;
        }
        rethrow;
      }
    }
  }

  static Future<Directory> _getBaseDir() async {
    final appDir = await getApplicationSupportDirectory();
    return Directory('${appDir.path}/ai_search');
  }

  static Future<Directory> _getSharedDir() async {
    final baseDir = await _getBaseDir();
    final dir = Directory('${baseDir.path}/shared');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Directory> _getSectionDir(String sectionId) async {
    final baseDir = await _getBaseDir();
    final dir = Directory('${baseDir.path}/$sectionId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
