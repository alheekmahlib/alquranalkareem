part of '../surah_audio.dart';

/// كونترولر مخصص لشاشة AudioSurahWithAyahs
/// يدير دورة حياة تتبع الـ segments (تهيئة عند الفتح، تنظيف عند الإغلاق)
class AudioSurahWithAyahsController extends GetxController {
  final _surahCtrl = AudioCtrl.instance;
  final segState = SurahAudioState();

  @override
  void onInit() {
    super.onInit();
    _initSegments();
  }

  Future<void> _initSegments() async {
    await _surahCtrl.initSegmentsForCurrentReader();
    _surahCtrl.enableSegmentTracking(
      _surahCtrl.state.currentAudioListSurahNum.value,
    );
  }

  @override
  void onClose() {
    _surahCtrl.disableSegmentTracking();
    super.onClose();
  }
}
