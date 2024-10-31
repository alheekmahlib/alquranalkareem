import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:alquranalkareem/presentation/controllers/general/extensions/general_getters.dart';
import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_storage_getters.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_ui.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../controllers/general/general_controller.dart';
import '../../quran_page/controllers/audio/audio_controller.dart';
import '../../quran_page/controllers/quran/quran_controller.dart';
import 'audio_player_handler.dart';
import 'surah_audio_state.dart';

class SurahAudioController extends GetxController {
  static SurahAudioController get instance =>
      Get.isRegistered<SurahAudioController>()
          ? Get.find<SurahAudioController>()
          : Get.put<SurahAudioController>(SurahAudioController());

  SurahAudioState state = SurahAudioState();

  @override
  Future<void> onInit() async {
    super.onInit();
    initializeSurahDownloadStatus();
    await _addDownloadedSurahToPlaylist();
    loadLastSurahAndPosition();
    loadSurahReader();
    state.surahsPlayList = List.generate(114, (i) {
      state.surahNum.value = i + 1;
      return AudioSource.uri(
        Uri.parse(urlFilePath),
      );
    });
    Future.wait([
      GeneralController.instance
          .getCachedArtUri()
          .then((v) => AudioController.instance.state.cachedArtUri = v),
    ]);
    if (Platform.isIOS || Platform.isAndroid) {
      await QuranController.instance.loadQuran().then((_) => AudioService.init(
            builder: () => AudioPlayerHandler.instance,
            config: const AudioServiceConfig(
              androidNotificationChannelId:
                  'com.alheekmah.alquranalkareem.alquranalkareem',
              androidNotificationChannelName: 'Audio playback',
              androidNotificationOngoing: true,
            ),
          ));
    }
    state.connectivitySubscription = state.connectivity.onConnectivityChanged
        .listen(_updateConnectionStatus);
    initConnectivity();
    Future.delayed(const Duration(milliseconds: 700))
        .then((_) => jumpToSurah(state.surahNum.value - 1));
  }

  @override
  void onClose() {
    state.audioPlayer.dispose();
    // state.surahListController!.dispose();
    state.connectivitySubscription.cancel();
    state.audioPlayer.pause();
    state.boxController.dispose();
    super.onClose();
  }

  /// -------- [Methods] ----------

  late final surahsList = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: state.surahsPlayList!,
  );

  Future<void> playPreviousSurah() async {
    if (state.surahNum.value > 1) {
      state.surahNum.value -= 1;
      state.selectedSurah.value -= 1;
      state.isPlaying.value = true;
      saveLastSurahListen();
      await updateMediaItemAndPlay().then((_) => state.audioPlayer.play());
    } else {
      await state.audioPlayer.pause();
    }
  }

  Future<void> playNextSurah() async {
    if (state.surahNum.value < 114) {
      state.surahNum.value += 1;
      state.selectedSurah.value += 1;
      state.isPlaying.value = true;
      saveLastSurahListen();
      await updateMediaItemAndPlay().then((_) => state.audioPlayer.play());
    } else {
      await state.audioPlayer.pause();
    }
  }

  Future<void> _addFileAudioSourceToPlayList(String filePath) async {
    state.downloadSurahsPlayList.add({
      state.surahNum.value: AudioSource.file(
        filePath,
        tag: await mediaItem,
      )
    });
  }

  /// -------- [DownloadingMethods] ----------

  Future<void> downloadSurah() async {
    String filePath = await localFilePath;
    File file = File(filePath);
    log("File Path: $filePath");
    state.isPlaying.value = true;
    if (await file.exists()) {
      log("File exists. Playing...");

      await state.audioPlayer.setAudioSource(AudioSource.file(
        filePath,
        tag: await mediaItem,
      ));
      state.audioPlayer.play();
    } else {
      log("File doesn't exist. Downloading...");
      log("state.sorahReaderNameValue: ${state.surahReaderNameValue.value}");
      log("Downloading from URL: $urlFilePath");
      if (await downloadFile(filePath, urlFilePath)) {
        _addFileAudioSourceToPlayList(filePath);
        onDownloadSuccess(
            int.parse(state.surahNum.value.toString().padLeft(3, "0")));
        log("File successfully downloaded and saved to $filePath");
        await state.audioPlayer
            .setAudioSource(AudioSource.file(
              filePath,
              tag: await mediaItem,
            ))
            .then((_) => state.audioPlayer.play());
      }
    }
    state.audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        await playNextSurah();
      }
    });
  }

  Future<bool> downloadFile(String path, String url) async {
    d.Dio dio = d.Dio();
    state.cancelToken = d.CancelToken();

    try {
      // الحصول على حجم الملف قبل التحميل
      d.Response response = await dio.head(url);
      int? contentLength =
          response.headers.value(HttpHeaders.contentLengthHeader) != null
              ? int.tryParse(
                  response.headers.value(HttpHeaders.contentLengthHeader)!)
              : null;

      if (contentLength != null) {
        state.fileSize.value = contentLength;
        log('File size: $contentLength bytes');
      } else {
        log('Could not determine file size.');
      }

      await Directory(dirname(path)).create(recursive: true);
      state.onDownloading.value = true;
      state.progressString.value = "0";
      state.progress.value = 0;
      update(['seekBar_id']);

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        state.progressString.value = ((rec / total) * 100).toStringAsFixed(0);
        state.progress.value = (rec / total).toDouble();
        // log(message)(state.progressString.value);

        state.downloadProgress.value = rec;
        update(['seekBar_id']);
      }, cancelToken: state.cancelToken);

      state.onDownloading.value = false;
      state.progressString.value = "100";
      log("Download completed for $path");
      return true;
    } catch (e) {
      if (e is d.DioException && e.type == d.DioExceptionType.cancel) {
        log('Download canceled');
        // Delete the partially downloaded file
        try {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
            state.onDownloading.value = false;
            log('Partially downloaded file deleted');
          }
        } catch (e) {
          log('Error deleting partially downloaded file: $e');
        }
        return false;
      } else {
        print(e);
      }
      state.onDownloading.value = false;
      state.progressString.value = "0";
      update(['seekBar_id']);
      return false;
    }
  }

  void initializeSurahDownloadStatus() async {
    // Directly obtain the initial download status for each Surah
    Map<int, bool> initialStatus = await checkAllSurahsDownloaded();

    // Assign it to the Rx variable to ensure it's observable
    state.surahDownloadStatus.value = initialStatus;
  }

  void updateDownloadStatus(int surahNumber, bool downloaded) {
    final newStatus = Map<int, bool>.from(state.surahDownloadStatus.value);
    newStatus[surahNumber] = downloaded;
    state.surahDownloadStatus.value = newStatus;
  }

  void onDownloadSuccess(int surahNumber) {
    // Assuming this function is called when a Surah download is successful
    updateDownloadStatus(surahNumber, true);
  }

  Future<Map<int, bool>> checkAllSurahsDownloaded() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    Map<int, bool> surahDownloadStatus = {};

    for (int i = 1; i <= 114; i++) {
      String filePath =
          '${directory.path}/${state.surahReaderNameValue.value}${i.toString().padLeft(3, '0')}.mp3';
      File file = File(filePath);
      surahDownloadStatus[i] = await file.exists();
    }
    return surahDownloadStatus;
  }

  void cancelDownload() {
    state.isPlaying.value = false;
    state.cancelToken.cancel('Request cancelled');
  }

  Future<void> startDownload() async {
    await state.audioPlayer.pause();
    await downloadSurah();
  }

  Future<void> _addDownloadedSurahToPlaylist() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    for (int i = 1; i <= 114; i++) {
      String filePath =
          '${directory.path}/${state.surahReaderNameValue.value}${i.toString().padLeft(3, "0")}.mp3';

      File file = File(filePath);

      if (await file.exists()) {
        // log(message)("File Path: $file");
        state.downloadSurahsPlayList.add({
          i: AudioSource.file(
            filePath,
            tag: await mediaItem,
          )
        });
      } else {
        // log(message)("iiiiiiiiii $i");
      }
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void updateControllerValues(PositionData positionData) {
    audioStream.listen((p) {
      state.lastPosition.value = p.position.inSeconds;
      state.seekNextSeconds.value = p.position.inSeconds;
      state.box.write(LAST_POSITION, p.position.inSeconds);
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState states) {
    if (states == AppLifecycleState.paused) {
      state.audioPlayer.pause();
    }
    //log(message)('state = $state');
  }

  /// -------- [ConnectivityMethods] ----------

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await state.connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (state.isDisposed) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    state.connectionStatus = result;
    update();
    // ignore: avoid_log(message)
    log('Connectivity changed: ${state.connectionStatus}');
  }
}
