import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:quran_library/quran_library.dart';

/// خدمة تحميل صوت الآية لأغراض المشاركة.
///
/// تستخدم نفس بنية المجلدات التي تستخدمها مكتبة quran_library
/// لتجنب التحميل المزدوج والاستفادة من الكاش الموجود.
class AyahAudioShareService extends GetxController {
  static AyahAudioShareService get instance =>
      GetInstance().putOrFind(() => AyahAudioShareService());

  final RxBool isDownloading = false.obs;
  final RxString downloadProgress = '0'.obs;

  final Dio _dio = Dio();
  CancelToken? _cancelToken;

  /// يُرجع ملف صوت الآية محلياً (من الكاش أو بعد التحميل).
  ///
  /// يُرجع `null` في حال فشل التحميل أو الإلغاء.
  Future<File?> getAyahAudioFile({
    required int surahNumber,
    required int ayahNumber,
    required int ayahUQNumber,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final readerInfo = _currentReader;
    final localPath = _buildLocalPath(
      dir,
      surahNumber,
      ayahNumber,
      ayahUQNumber,
      readerInfo,
    );

    final file = File(localPath);
    if (await file.exists()) return file;

    final url = _buildAyahUrl(
      surahNumber,
      ayahNumber,
      ayahUQNumber,
      readerInfo,
    );

    return _downloadAyahAudio(url, localPath);
  }

  /// يلغي التحميل الجاري إن وُجد.
  void cancelDownload() {
    _cancelToken?.cancel();
    _cancelToken = null;
    isDownloading.value = false;
    downloadProgress.value = '0';
  }

  /// اسم القارئ الحالي المحدد.
  String get currentReaderName => _currentReader.name;

  // ─── Private ────────────────────────────────────────────

  ReaderInfo get _currentReader {
    final index = AudioCtrl.instance.state.ayahReaderIndex.value;
    return ReadersConstants.activeAyahReaders[index];
  }

  String _buildAyahUrl(
    int surahNumber,
    int ayahNumber,
    int ayahUQNumber,
    ReaderInfo reader,
  ) {
    if (reader.url == ReadersConstants.ayahs1stSource) {
      return '${reader.url}${reader.readerNamePath}/$ayahUQNumber.mp3';
    }
    final surah = surahNumber.toString().padLeft(3, '0');
    final ayah = ayahNumber.toString().padLeft(3, '0');
    return '${reader.url}${reader.readerNamePath}/$surah$ayah.mp3';
  }

  String _buildLocalPath(
    Directory dir,
    int surahNumber,
    int ayahNumber,
    int ayahUQNumber,
    ReaderInfo reader,
  ) {
    final fileName = reader.url == ReadersConstants.ayahs1stSource
        ? '$ayahUQNumber.mp3'
        : '${surahNumber.toString().padLeft(3, '0')}'
              '${ayahNumber.toString().padLeft(3, '0')}.mp3';
    return p.join(dir.path, reader.readerNamePath, fileName);
  }

  Future<File?> _downloadAyahAudio(String url, String localPath) async {
    _cancelToken = CancelToken();
    isDownloading.value = true;
    downloadProgress.value = '0';

    try {
      final file = File(localPath);
      await file.parent.create(recursive: true);

      await _dio.download(
        url,
        localPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            downloadProgress.value = ((received / total) * 100)
                .toInt()
                .toString();
          }
        },
      );

      isDownloading.value = false;
      downloadProgress.value = '0';
      return file;
    } on DioException catch (e) {
      isDownloading.value = false;
      downloadProgress.value = '0';
      if (e.type == DioExceptionType.cancel) return null;
      rethrow;
    }
  }

  @override
  void onClose() {
    cancelDownload();
    _dio.close();
    super.onClose();
  }
}
