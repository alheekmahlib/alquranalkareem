import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_storage_getters.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_ui.dart';
import '../../../../core/widgets/seek_bar.dart';
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
    _addDownloadedSurahToPlaylist();
    loadLastSurahListen();
    loadLastSurahAndPosition();
    loadSurahReader();
    loadLastSurahListen();
    state.surahsPlayList = List.generate(114, (i) {
      state.surahNum.value = i + 1;
      return AudioSource.uri(
        Uri.parse(urlFilePath),
      );
    });
    state.connectivitySubscription = state.connectivity.onConnectivityChanged
        .listen(_updateConnectionStatus);
    initConnectivity();
    if (Platform.isIOS) {
      await JustAudioBackground.init(
        androidNotificationChannelId:
            'com.alheekmah.alquranalkareem.alquranalkareem',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      );
    }
  }

  @override
  void onClose() {
    state.audioPlayer.dispose();
    state.controller.dispose();
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
    state.surahNum.value -= 1;
    state.selectedSurah.value -= 1;
    await state.audioPlayer
        .setAudioSource(
            state.surahDownloadStatus.value[state.surahNum.value] == false
                ? AudioSource.uri(
                    Uri.parse(urlFilePath),
                    tag: await mediaItem,
                  )
                : AudioSource.file(
                    await localFilePath,
                    tag: await mediaItem,
                  ))
        .then((_) => state.audioPlayer.play());
  }

  // "https://everyayah.com/data/MaherAlMuaiqly128kbps/${_quranController.getSurahNumberByAya(_quranController.allAyas[ayaUniqeId.value - 1]).toString().padLeft(3, "0")}${_quranController.allAyas[ayaUniqeId.value - 1].numberOfAyaInSurah.toString().padLeft(3, "0")}.mp3",

  Future<void> playNextSurah() async {
    state.surahNum.value += 1;
    state.selectedSurah.value += 1;
    state.isPlaying.value = true;
    await state.audioPlayer
        .setAudioSource(
            state.surahDownloadStatus.value[state.surahNum.value] == false
                ? AudioSource.uri(
                    Uri.parse(urlFilePath),
                    tag: await mediaItem,
                  )
                : AudioSource.file(
                    await localFilePath,
                    tag: await mediaItem,
                  ))
        .then((_) => state.audioPlayer.play());
  }

  Future<void> downloadSurah() async {
    File file = File(await localFilePath);
    print("File Path: $localFilePath");
    state.isPlaying.value = true;
    if (await file.exists()) {
      print("File exists. Playing...");

      await state.audioPlayer.setAudioSource(AudioSource.file(
        await localFilePath,
        tag: await mediaItem,
      ));
      state.audioPlayer.play();
    } else {
      print("File doesn't exist. Downloading...");
      print("state.sorahReaderNameValue: ${state.sorahReaderNameValue.value}");
      print("Downloading from URL: $urlFilePath");
      if (await downloadFile(await localFilePath, urlFilePath)) {
        _addFileAudioSourceToPlayList(await localFilePath);
        onDownloadSuccess(
            int.parse(state.surahNum.value.toString().padLeft(3, "0")));
        print("File successfully downloaded and saved to ${localFilePath}");
        await state.audioPlayer
            .setAudioSource(AudioSource.file(
              await localFilePath,
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
    Dio dio = Dio();
    state.cancelToken = CancelToken();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
        state.onDownloading.value = true;
        state.progressString.value = "0";
        state.progress.value = 0;

        await dio.download(url, path, onReceiveProgress: (rec, total) {
          state.progressString.value = ((rec / total) * 100).toStringAsFixed(0);
          state.progress.value = (rec / total).toDouble();
          print(state.progressString.value);
        }, cancelToken: state.cancelToken);
      } catch (e) {
        if (e is DioException && e.type == DioExceptionType.cancel) {
          print('Download canceled');
          // Delete the partially downloaded file
          try {
            final file = File(path);
            if (await file.exists()) {
              await file.delete();
              state.onDownloading.value = false;
              print('Partially downloaded file deleted');
            }
          } catch (e) {
            print('Error deleting partially downloaded file: $e');
          }
          return false;
        } else {
          print(e);
        }
      }
      state.onDownloading.value = false;
      state.progressString.value = "100";
      print("Download completed for $path");
      return true;
    } catch (e) {
      print("Error isDownloading: $e");
    }
    return false;
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
          '${directory.path}/${state.sorahReaderNameValue.value}${i.toString().padLeft(3, '0')}.mp3';
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
          '${directory.path}/${state.sorahReaderNameValue.value}${i.toString().padLeft(3, "0")}.mp3';

      File file = File(filePath);

      if (await file.exists()) {
        // print("File Path: $file");
        state.downloadSurahsPlayList.add({
          i: AudioSource.file(
            filePath,
            tag: await mediaItem,
          )
        });
      } else {
        // print("iiiiiiiiii $i");
      }
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

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void updateControllerValues(PositionData positionData) {
    audioStream.listen((p) {
      state.lastPosition.value = p.position.inSeconds;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState states) {
    if (states == AppLifecycleState.paused) {
      state.audioPlayer.pause();
    }
    //print('state = $state');
  }

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
    // ignore: avoid_print
    print('Connectivity changed: $state.connectionStatus');
  }
}
