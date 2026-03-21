/// ثوابت ملفات segments — خريطة القراء الذين لديهم ملفات توقيت
class SegmentConstants {
  SegmentConstants._();

  static const String baseUrl =
      'https://github.com/alheekmahlib/Islamic_database/releases/download/audio_segments/';

  /// readerIndex (من ReadersConstants.activeSurahReaders) → اسم ملف segment
  static const Map<int, String> segmentReaders = {
    0: 'abdul_basit', // عبد الباسط
    1: 'al_minshawy', // محمد المنشاوي
    2: 'al_husary', // محمود الحصري
    4: 'al_muaiqly', // ماهر المعيقلي
    5: 'al_shuraym', // سعود الشريم
    6: 'al_ghamidi', // سعد الغامدي
    8: 'al_qatami', // ناصر القطامي
    13: 'ad_dussary', // ياسر الدوسري
    14: 'al_juhaynee', // عبد الله الجهني
    15: 'fares_abbad', // فارس عباد
  };

  /// هل القارئ يدعم segments
  static bool hasSegments(int readerIndex) =>
      segmentReaders.containsKey(readerIndex);

  /// رابط تحميل ملف segment لقارئ معين
  static String? segmentUrl(int readerIndex) {
    final fileName = segmentReaders[readerIndex];
    if (fileName == null) return null;
    return '$baseUrl$fileName.json.gz';
  }

  /// اسم الملف المحلي لقارئ معين
  static String? localFileName(int readerIndex) {
    final fileName = segmentReaders[readerIndex];
    if (fileName == null) return null;
    return '$fileName.json';
  }

  /// مجلد الكاش المحلي
  static const String cacheDir = 'audio_segments';
}
