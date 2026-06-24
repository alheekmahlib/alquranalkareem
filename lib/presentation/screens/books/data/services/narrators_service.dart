import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../models/narrator_model.dart';

/// خدمة فهرس الرواة — تحميل أونلاين وبحث سريع
class NarratorsService extends GetxService {
  static NarratorsService get instance => Get.find<NarratorsService>();

  final Map<String, List<NarratorInfo>> _index = {};
  List<NarratorInfo> _allNarrators = [];
  bool _isLoaded = false;

  /// RX state for UI
  final RxBool isLoaded = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  static const String _downloadUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/shamela_narrators/shamela_narrators.json';

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/shamela_narrators.json');
  }

  @override
  void onInit() {
    super.onInit();
    _tryLoadFromDisk();
  }

  /// تحميل الملف من التخزين المحلي إن وجد
  Future<void> _tryLoadFromDisk() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        log('Narrators file found on disk, loading...',
            name: 'NarratorsService');
        final contents = await file.readAsString();
        await _parseAndIndex(contents);
        isLoaded.value = true;
        _isLoaded = true;
        log('Loaded ${_allNarrators.length} narrators from disk',
            name: 'NarratorsService');
      }
    } catch (e) {
      log('Error loading narrators from disk: $e',
          name: 'NarratorsService');
    }
  }

  /// تحميل الملف من GitHub
  Future<void> downloadNarratorsFile() async {
    if (isDownloading.value) return;
    isDownloading.value = true;
    downloadProgress.value = 0.0;

    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(_downloadUrl));
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception('Failed to download: ${response.statusCode}');
      }

      final totalBytes = response.contentLength;
      int receivedBytes = 0;

      final file = await _localFile;
      final sink = file.openWrite();

      await for (final chunk in response) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        if (totalBytes > 0) {
          downloadProgress.value = receivedBytes / totalBytes;
        }
      }

      await sink.close();
      client.close();

      log('Downloaded narrators file: $receivedBytes bytes',
          name: 'NarratorsService');

      // Parse and index
      final contents = await file.readAsString();
      await _parseAndIndex(contents);
      isLoaded.value = true;
      _isLoaded = true;
      downloadProgress.value = 1.0;

      log('Loaded ${_allNarrators.length} narrators',
          name: 'NarratorsService');
    } catch (e) {
      log('Error downloading narrators: $e', name: 'NarratorsService');
      downloadProgress.value = 0.0;
    } finally {
      isDownloading.value = false;
    }
  }

  /// تحليل JSON وبناء الفهرس
  Future<void> _parseAndIndex(String jsonString) async {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List;

    _allNarrators = jsonList
        .map((e) => NarratorInfo.fromJson(e as Map<String, dynamic>))
        .toList();

    _index.clear();

    for (var narrator in _allNarrators) {
      // فهرسة بالاسم الكامل
      final normalized = _normalizeForIndex(narrator.name);
      _index.putIfAbsent(normalized, () => []).add(narrator);

      // فهرسة بالاسم المختصر
      final short = _normalizeForIndex(narrator.searchName);
      if (short != normalized) {
        _index.putIfAbsent(short, () => []).add(narrator);
      }

      // فهرسة بالكنية
      if (narrator.kunyah != null && narrator.kunyah!.isNotEmpty) {
        final kunyahNorm = _normalizeForIndex(narrator.kunyah!);
        _index.putIfAbsent(kunyahNorm, () => []).add(narrator);
      }

      // فهرسة بالنسب
      if (narrator.nasab != null && narrator.nasab!.isNotEmpty) {
        final nasabNorm = _normalizeForIndex(narrator.nasab!);
        _index.putIfAbsent(nasabNorm, () => []).add(narrator);
      }
    }

    log('NarratorsService: Indexed ${_allNarrators.length} narrators, '
        '${_index.length} index entries');
  }

  /// البحث عن راوي بالنص المحدد
  List<NarratorInfo> lookup(String selectedText) {
    if (!_isLoaded || selectedText.trim().isEmpty) return [];

    final normalized = _normalizeForIndex(selectedText.trim());

    // ١. بحث مباشر
    if (_index.containsKey(normalized)) {
      return _index[normalized]!;
    }

    // ٢. بحث جزئي
    final results = <NarratorInfo>[];
    final seen = <int>{};

    for (var narrator in _allNarrators) {
      final nameNorm = _normalizeForIndex(narrator.name);
      if (normalized.length >= 3 && nameNorm.contains(normalized)) {
        if (!seen.contains(narrator.id)) {
          seen.add(narrator.id);
          results.add(narrator);
        }
      }
    }

    return results;
  }

  String _normalizeForIndex(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(
            RegExp(r'[\u064B-\u065E\u0670\u0640\u06D6-\u06E2]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
