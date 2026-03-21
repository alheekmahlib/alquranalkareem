part of '../surah_audio.dart';

/// extension لإدارة segments (تتبع الآية الحالية أثناء تشغيل السورة)
extension SurahAudioSegmentHelper on AudioCtrl {
  SurahAudioState get _segState => SurahAudioState();

  /// تهيئة segments للقارئ الحالي — يُستدعى عند بدء التشغيل أو تغيير القارئ
  Future<void> initSegmentsForCurrentReader() async {
    final readerIndex = state.surahReaderIndex.value;
    final repo = SegmentRepository.instance;

    if (!repo.hasSegments(readerIndex)) {
      _segState.isSegmentsAvailable.value = false;
      _segState.currentSegmentAyahNumber.value = null;
      _segState.currentSegmentSurahNumber.value = null;
      return;
    }

    _segState.isSegmentsAvailable.value = true;

    // إذا كان محمّلاً مسبقاً لا نعيد التحميل
    if (repo.isLoaded(readerIndex)) return;

    _segState.isSegmentsLoading.value = true;
    await repo.preloadSegments(readerIndex);
    _segState.isSegmentsLoading.value = false;
  }

  /// تفعيل تتبع الموضع لتحديث رقم الآية الحالية
  void enableSegmentTracking(int surahNumber) {
    disableSegmentTracking();

    final readerIndex = state.surahReaderIndex.value;
    final repo = SegmentRepository.instance;

    if (!repo.hasSegments(readerIndex) || !repo.isLoaded(readerIndex)) return;

    _segState.currentSegmentSurahNumber.value = surahNumber;

    // تخزين مؤقت لبيانات السورة لتفادي إعادة البناء كل مرة
    SurahSegmentsData? cachedSurahData;
    int? lastSurah;

    _segState.segmentPositionSubscription = state.audioPlayer.positionStream
        .listen((position) async {
          final currentSurah = state.currentAudioListSurahNum.value;
          final positionMs = position.inMilliseconds;

          // أعد بناء الكاش إذا تغيرت السورة
          if (cachedSurahData == null || lastSurah != currentSurah) {
            cachedSurahData = await repo.getSegmentsForSurah(
              readerIndex,
              currentSurah,
            );
            lastSurah = currentSurah;
            _segState.currentSegmentSurahNumber.value = currentSurah;
          }

          if (cachedSurahData == null) return;

          final ayahNum = cachedSurahData!.getAyahNumberAtPosition(positionMs);
          if (ayahNum != null) {
            if (ayahNum != _segState.currentSegmentAyahNumber.value) {
              _segState.currentSegmentAyahNumber.value = ayahNum;
            }
            final wordIdx = cachedSurahData!.ayahs[ayahNum]
                ?.getWordIndexAtPosition(positionMs);
            if (wordIdx != null &&
                wordIdx != _segState.currentSegmentWordIndex.value) {
              _segState.currentSegmentWordIndex.value = wordIdx;
            }
          }
        });
  }

  /// تعطيل تتبع الموضع
  void disableSegmentTracking() {
    _segState.segmentPositionSubscription?.cancel();
    _segState.segmentPositionSubscription = null;
  }

  /// تحديث segments عند تغيير السورة (مثلاً الانتقال التلقائي للسورة التالية)
  void updateSegmentSurah(int surahNumber) {
    _segState.currentSegmentSurahNumber.value = surahNumber;
    _segState.currentSegmentAyahNumber.value = null;
    _segState.currentSegmentWordIndex.value = null;
  }
}
