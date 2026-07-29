import '../models/ayah_segment_model.dart';

/// واجهة مجردة لإدارة بيانات segments القراء
abstract class ISegmentRepository {
  /// هل القارئ لديه ملف segments
  bool hasSegments(int readerIndex);

  /// تحميل ملف segments مسبقاً (بالخلفية)
  Future<void> preloadSegments(int readerIndex);

  /// جلب بيانات segments لسورة معينة
  Future<SurahSegmentsData?> getSegmentsForSurah(
    int readerIndex,
    int surahNumber,
  );

  /// هل الملف محمّل ومتاح
  bool isLoaded(int readerIndex);
}
