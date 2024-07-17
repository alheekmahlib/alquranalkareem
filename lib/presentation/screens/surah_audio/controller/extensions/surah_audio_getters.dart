import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/widgets/seek_bar.dart';
import '../../../../controllers/general_controller.dart';
import '../../../quran_page/controllers/quran/quran_controller.dart';
import '../surah_audio_controller.dart';

extension SurahAudioGetters on SurahAudioController {
  /// -------- [Getters] ----------
  Future<String> get localFilePath async {
    Directory? directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${state.sorahReaderNameValue.value}${state.surahNum.value.toString().padLeft(3, "0")}.mp3';
  }

  String get urlFilePath {
    return '${state.sorahReaderValue.value}${state.sorahReaderNameValue.value}${state.surahNum.value.toString().padLeft(3, "0")}.mp3';
  }

  Stream<PositionData> get audioStream => positionDataStream;

  Future<MediaItem> get mediaItem async => MediaItem(
        id: '${state.surahNum.value - 1}',
        title:
            '${sl<QuranController>().state.surahs[(state.surahNum.value - 1)].arabicName}',
        artist: '${surahReaderInfo[state.surahReaderIndex.value]['name']}'.tr,
        artUri: await sl<GeneralController>().getCachedArtUri(
            'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/Photos/ios-1024.png'),
      );

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
