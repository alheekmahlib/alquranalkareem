import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/utils/constants/segment_constants.dart';
import '../models/ayah_segment_model.dart';
import 'i_segment_repository.dart';

/// تنفيذ [ISegmentRepository]: تحميل، فك ضغط، كاش، وقراءة segments
class SegmentRepository implements ISegmentRepository {
  SegmentRepository._();
  static final SegmentRepository instance = SegmentRepository._();

  /// كاش الذاكرة: readerIndex → (كل البيانات المفككة)
  final Map<int, Map<String, dynamic>> _memoryCache = {};

  /// منع التحميل المزدوج
  final Map<int, Future<void>> _inflightLoads = {};

  @override
  bool hasSegments(int readerIndex) =>
      SegmentConstants.hasSegments(readerIndex);

  @override
  bool isLoaded(int readerIndex) => _memoryCache.containsKey(readerIndex);

  @override
  Future<void> preloadSegments(int readerIndex) async {
    if (!hasSegments(readerIndex)) return;
    if (_memoryCache.containsKey(readerIndex)) return;

    // منع التحميل المزدوج لنفس القارئ
    if (_inflightLoads.containsKey(readerIndex)) {
      await _inflightLoads[readerIndex];
      return;
    }

    final completer = _loadAndCache(readerIndex);
    _inflightLoads[readerIndex] = completer;
    try {
      await completer;
    } finally {
      _inflightLoads.remove(readerIndex);
    }
  }

  @override
  Future<SurahSegmentsData?> getSegmentsForSurah(
    int readerIndex,
    int surahNumber,
  ) async {
    if (!hasSegments(readerIndex)) return null;

    // تأكد من التحميل أولاً
    if (!_memoryCache.containsKey(readerIndex)) {
      await preloadSegments(readerIndex);
    }

    final allData = _memoryCache[readerIndex];
    if (allData == null) return null;

    return _extractSurahSegments(allData, surahNumber);
  }

  /// --- الدوال الداخلية ---

  Future<void> _loadAndCache(int readerIndex) async {
    try {
      // 1. تحقق من الكاش المحلي
      final localData = await _readFromDisk(readerIndex);
      if (localData != null) {
        _memoryCache[readerIndex] = localData;
        log(
          'Segments loaded from disk cache for reader $readerIndex',
          name: 'SegmentRepository',
        );
        return;
      }

      // 2. حمّل من الإنترنت
      final url = SegmentConstants.segmentUrl(readerIndex);
      if (url == null) return;

      log('Downloading segments from: $url', name: 'SegmentRepository');

      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 30)
        ..options.receiveTimeout = const Duration(minutes: 3);

      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': '*/*', 'User-Agent': 'Flutter/AlQuranAlKareem'},
        ),
      );

      final gzBytes = response.data;
      if (gzBytes == null || gzBytes.isEmpty) {
        log('Empty response for segments: $url', name: 'SegmentRepository');
        return;
      }

      // 3. فك الضغط باستخدام dart:io GZipCodec
      final decompressed = gzip.decode(gzBytes);
      final jsonString = utf8.decode(decompressed);

      // 4. تحليل JSON
      final Map<String, dynamic> parsed = jsonDecode(jsonString);

      // 5. حفظ على القرص (JSON مفكوك) + كاش الذاكرة
      await _writeToDisk(readerIndex, jsonString);
      _memoryCache[readerIndex] = parsed;

      log(
        'Segments downloaded and cached for reader $readerIndex '
        '(${parsed.length} entries)',
        name: 'SegmentRepository',
      );
    } catch (e, s) {
      log(
        'Failed to load segments for reader $readerIndex: $e',
        name: 'SegmentRepository',
        error: e,
        stackTrace: s,
      );
    }
  }

  SurahSegmentsData _extractSurahSegments(
    Map<String, dynamic> allData,
    int surahNumber,
  ) {
    final prefix = '$surahNumber:';
    final ayahs = <int, AyahSegmentModel>{};

    for (final entry in allData.entries) {
      if (!entry.key.startsWith(prefix)) continue;
      final model = AyahSegmentModel.fromJson(
        entry.key,
        entry.value as Map<String, dynamic>,
      );
      ayahs[model.ayahNumber] = model;
    }

    return SurahSegmentsData(surahNumber: surahNumber, ayahs: ayahs);
  }

  Future<String> get _cacheBasePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${SegmentConstants.cacheDir}';
  }

  Future<Map<String, dynamic>?> _readFromDisk(int readerIndex) async {
    try {
      final fileName = SegmentConstants.localFileName(readerIndex);
      if (fileName == null) return null;

      final path = '${await _cacheBasePath}/$fileName';
      final file = File(path);
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      if (content.isEmpty) return null;

      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      log('Error reading segments from disk: $e', name: 'SegmentRepository');
      return null;
    }
  }

  Future<void> _writeToDisk(int readerIndex, String jsonString) async {
    try {
      final fileName = SegmentConstants.localFileName(readerIndex);
      if (fileName == null) return;

      final basePath = await _cacheBasePath;
      final dir = Directory(basePath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File('$basePath/$fileName');
      await file.writeAsString(jsonString, flush: true);
    } catch (e) {
      log('Error writing segments to disk: $e', name: 'SegmentRepository');
    }
  }
}
