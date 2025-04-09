import 'dart:developer' show log;

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'extensions/surah_audio_getters.dart';
import 'surah_audio_controller.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();
  static AudioPlayerHandler get instance => _instance;

  final surahCtrl = SurahAudioController.instance;

  // final audioHandler = AudioService();

  AudioPlayerHandler._internal() {
    // الاستماع لتغيرات حالة التشغيل
    surahCtrl.state.audioPlayer.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState);

    // إضافة العنصر الصوتي الأولي
    mediaItem.add(surahCtrl.mediaItem);

    // تحديث mediaItem عند تغيير السورة من داخل اللاعب
    // surahCtrl.state.audioPlayer.currentIndexStream.listen((index) {
    //   if (index != null && index >= 0 && index < 114) {
    //     surahCtrl.state.surahNum.value = index + 1;
    //     final newMediaItem = surahCtrl.mediaItem;
    //     mediaItem.add(newMediaItem);
    //   }
    // });
  }

  @override
  Future<void> play() async {
    log('Surah is playing');
    surahCtrl.state.isPlaying.value = true;
    await surahCtrl.state.audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    log('Surah is paused');
    surahCtrl.state.isPlaying.value = false;
    await surahCtrl.state.audioPlayer.pause();
  }

  @override
  Future<void> skipToNext() async {
    if (surahCtrl.state.surahNum.value < 114) {
      await surahCtrl.playNextSurah();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (surahCtrl.state.surahNum.value > 1) {
      await surahCtrl.playPreviousSurah();
    }
  }

  @override
  Future<void> seek(Duration position) =>
      surahCtrl.state.audioPlayer.seek(position);

  @override
  Future<void> stop() async {
    await surahCtrl.state.audioPlayer.stop();
  }

  /// تحويل حدث just_audio إلى حالة audio_service
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (surahCtrl.state.audioPlayer.playing)
          MediaControl.pause
        else
          MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[surahCtrl.state.audioPlayer.processingState]!,
      playing: surahCtrl.state.audioPlayer.playing,
      updatePosition: surahCtrl.state.audioPlayer.position,
      bufferedPosition: surahCtrl.state.audioPlayer.bufferedPosition,
      speed: surahCtrl.state.audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
