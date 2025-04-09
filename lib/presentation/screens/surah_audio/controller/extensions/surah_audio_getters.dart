import 'dart:io' show Directory;

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;

import '/core/utils/constants/lists.dart';
import '/core/widgets/seek_bar.dart';
import '../../../quran_page/quran.dart';
import '../audio_player_handler.dart';
import '../surah_audio_controller.dart';

extension SurahAudioGetters on SurahAudioController {
  /// -------- [Getters] ----------
  Future<String> get localFilePath async {
    Directory? directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${state.surahReaderNameValue.value}${state.surahNum.value.toString().padLeft(3, "0")}.mp3';
  }

  String get urlFilePath {
    return '${state.surahReaderValue.value}${state.surahReaderNameValue.value}${state.surahNum.value.toString().padLeft(3, "0")}.mp3';
  }

  Stream<PositionData> get audioStream => positionDataStream;

  MediaItem get mediaItem => MediaItem(
        id: '${state.surahNum.value}',
        title:
            '${QuranController.instance.state.surahs[(state.surahNum.value - 1)].arabicName}',
        artist: '${surahReaderInfo[state.surahReaderIndex.value]['name']}'.tr,
        artUri: AudioController.instance.state.cachedArtUri,
      );

  Future<void> lastAudioSource() async {
    await updateMediaItemAndPlay().then((_) async => await state.audioPlayer
        .seek(Duration(seconds: state.lastPosition.value)));
    print('URL: $urlFilePath');
  }

  Future<void> updateMediaItemAndPlay() async {
    final newMediaItem = mediaItem;
    AudioPlayerHandler.instance.mediaItem.add(newMediaItem);
    await state.audioPlayer.setAudioSource(
        state.surahDownloadStatus.value[state.surahNum.value] == false
            ? AudioSource.uri(
                Uri.parse(urlFilePath),
                tag: newMediaItem,
              )
            : AudioSource.file(
                await localFilePath,
                tag: newMediaItem,
              ));
  }

  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          state.audioPlayer.positionStream,
          state.audioPlayer.bufferedPositionStream,
          state.audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> get DownloadPositionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          state.audioPlayer.positionStream,
          state.audioPlayer.bufferedPositionStream,
          state.audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
