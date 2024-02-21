import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/widgets/seek_bar.dart';
import '/core/utils/constants/constants.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/custom_mobile_notes_snack_bar.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';
import 'quran_controller.dart';

class AudioController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer textAudioPlayer = AudioPlayer();
  RxBool isPlay = false.obs;
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  String? currentPlay;
  RxBool autoPlay = false.obs;
  double? sliderValue;
  String? readerValue;
  RxString readerName = 'عبد الباسط عبد الصمد'.obs;
  String? pageAyahNumber;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ConnectivityResult result;
  final _connectivity = Connectivity();
  late var cancelToken = CancelToken();
  final bool _isDisposed = false; // to keep track of the controller lifecycle
  RxBool isProcessingNextAyah = false.obs;
  Duration? lastPosition;
  Duration? pageLastPosition;
  RxInt pageNumber = 0.obs;
  RxInt lastAyahInPage = 0.obs;
  RxInt lastAyahInTextPage = 0.obs;
  RxInt lastAyahInSurah = 0.obs;
  Color? backColor;
  RxInt _currentAyahInSurah = 1.obs;
  RxInt _currentAyahUQInPage = 1.obs;
  RxInt _currentSurahInPage = 1.obs;
  bool goingToNewSurah = false;
  RxBool selected = false.obs;
  RxInt readerIndex = 0.obs;
  RxBool isStartPlaying = false.obs;

  final generalCtrl = sl<GeneralController>();
  final quranCtrl = sl<QuranController>();
  final ayatCtrl = sl<AyatController>();

  void startPlayingToggle() {
    isStartPlaying.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isStartPlaying.value = false;
    });
  }

  void playAyahOnTap(int surahNum, int ayahNum, int ayahUQNum) {
    _currentAyahInSurah.value = ayahNum;
    _currentSurahInPage.value = surahNum;
    _currentAyahUQInPage.value = ayahUQNum;
    playAyah();
  }

  int get currentAyahInPage => _currentAyahInSurah.value == 1
      ? quranCtrl.allAyahs
          .firstWhere(
              (ayah) => ayah.page == generalCtrl.currentPageNumber.value)
          .ayahNumber
      : _currentAyahInSurah.value;

  int get currentSurahInPage => _currentSurahInPage.value == 1
      ? quranCtrl.getSurahNumberFromPage(generalCtrl.currentPageNumber.value)
      : _currentSurahInPage.value;

  @override
  void onInit() {
    isPlay.value = false;
    sliderValue = 0;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    loadQuranReader();

    super.onInit();
  }

  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  bool get isLastAyahInPage =>
      quranCtrl
          .getCurrentPageAyahs(generalCtrl.currentPageNumber.value - 1)
          .last
          .ayahUQNumber ==
      _currentAyahUQInPage.value;
  bool get isFirstAyahInPage =>
      quranCtrl
          .getCurrentPageAyahs(generalCtrl.currentPageNumber.value - 1)
          .first
          .ayahUQNumber ==
      _currentAyahUQInPage.value;

  bool get isLastAyahInSurah =>
      quranCtrl
          .getCurrentSurahByPage(generalCtrl.currentPageNumber.value - 1)
          .ayahs
          .last
          .ayahUQNumber ==
      _currentAyahUQInPage.value;

  bool get isFirstAyahInSurah =>
      quranCtrl
          .getCurrentSurahByPage(generalCtrl.currentPageNumber.value - 1)
          .ayahs
          .first
          .ayahUQNumber ==
      _currentAyahUQInPage.value;

  bool get isLastAyahInSurahButNotInPage =>
      isLastAyahInSurah && !isLastAyahInPage;
  bool get isLastAyahInSurahAndPage => isLastAyahInSurah && isLastAyahInPage;
  bool get isLastAyahInPageButNotInSurah =>
      isLastAyahInPage && !isLastAyahInSurah;

  bool get isFirstAyahInPageButNotInSurah =>
      isFirstAyahInPage && !isFirstAyahInSurah;

  String get reader => readerValue!;
  String get fileName => "$reader/${_currentAyahUQInPage.value}.mp3";
  String get url => "${UrlConstants.ayahUrl}$fileName";
  void get pausePlayer async {
    isPlay.value = false;
    await audioPlayer.pause();
  }

  void moveToNextPage({bool withScroll = true}) {
    if (withScroll) {
      generalCtrl.quranPageController.animateToPage(
          (generalCtrl.currentPageNumber.value),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
    }
  }

  void moveToPreviousPage({bool withScroll = true}) {
    if (withScroll) {
      generalCtrl.quranPageController.animateToPage(
          (generalCtrl.currentPageNumber.value - 2),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
    }
  }

  Future playFile(String url, String fileName) async {
    String path;
    try {
      var dir = await getApplicationDocumentsDirectory();
      path = join(dir.path, fileName);
      var file = File(path);
      bool exists = await file.exists();
      if (!exists) {
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (e) {
          print(e);
        }
        if (_connectionStatus == ConnectivityResult.none) {
          Get.context!.showCustomErrorSnackBar('noInternet'.tr);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          Get.context!.customMobileNoteSnackBar('mobileDataAyat'.tr);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      await audioPlayer.setAudioSource(AudioSource.file(
        path,
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${ayatCtrl.ayahUQNumber.value}',
          // Metadata to display in the notification:
          album: '${ayatCtrl.currentAyah?.sorahName ?? ''}',
          title: '${ayatCtrl.currentAyah?.ayaNum ?? ''}',
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      ));
      audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;
          log(_currentAyahUQInPage.value);
          log(_currentAyahInSurah.value);
          if (quranCtrl.isPages.value == 0) {
            if (generalCtrl.currentPageNumber.value == 604) {
              print('doneeeeeeeeeeee');
              await audioPlayer.pause();
              isPlay.value = false;
            } else if (isLastAyahInPageButNotInSurah) {
              print('moveToPage');
              moveToNextPage();
            } else if (isLastAyahInSurahAndPage) {
              moveToNextPage();
              goingToNewSurah = true;
            } else if (isLastAyahInSurahButNotInPage) {
              moveToNextPage(withScroll: false);
              goingToNewSurah = true;
            }
          }

          await playNextAyah();

          print('ProcessingState.completed');
        }
      });
      isPlay.value = true;
      await audioPlayer.play();
      print('playFile2: play');
    } catch (e) {
      print(e);
    }
  }

  Future<void> playNextAyah() async {
    isProcessingNextAyah.value = true;
    _currentAyahUQInPage.value += 1;
    quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
    await playFile(url, fileName);
    isProcessingNextAyah.value = false;
    if (quranCtrl.isPages.value == 1) {
      quranCtrl.itemScrollController.scrollTo(
        index: _currentAyahUQInPage.value,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> playAyah() async {
    if (quranCtrl.isPages.value == 1) {
      _currentAyahUQInPage.value = _currentAyahUQInPage.value == 1
          ? quranCtrl.allAyahs
              .firstWhere((ayah) =>
                  ayah.page ==
                  quranCtrl.itemPositionsListener.itemPositions.value.last
                          .index +
                      1)
              .ayahUQNumber
          : _currentAyahUQInPage.value;
    } else {
      _currentAyahUQInPage.value = _currentAyahUQInPage.value == 1
          ? quranCtrl.allAyahs
              .firstWhere(
                  (ayah) => ayah.page == generalCtrl.currentPageNumber.value)
              .ayahUQNumber
          : _currentAyahUQInPage.value;
    }
    quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
    if (isPlay.value) {
      await audioPlayer.pause();
      isPlay.value = false;
      print('audioPlayer: pause');
    } else {
      await playFile(url, fileName);
      isPlay.value = true;
    }
  }

  Future downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    cancelToken = CancelToken();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
        downloading.value = true;
        onDownloading.value = true;
        progressString.value = "0";
        progress.value = 0;
        await dio.download(url, path, onReceiveProgress: (rec, total) {
          progressString.value = ((rec / total) * 100).toStringAsFixed(0);
          progress.value = (rec / total).toDouble();
          print(progressString.value);
        }, cancelToken: cancelToken);
      } catch (e) {
        if (e is DioException && e.type == DioExceptionType.cancel) {
          print('Download canceled');
          // Delete the partially downloaded file
          try {
            final file = File(path);
            if (await file.exists()) {
              await file.delete();
              onDownloading.value = false;
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

      downloading.value = false;
      onDownloading.value = false;
      progressString.value = "100";
      print("Download completed");
    } catch (e) {
      print(e);
    }
    return false;
  }

  void cancelDownload() {
    cancelToken.cancel('Request cancelled');
  }

  Future<void> skipNextAyah() async {
    if (_currentAyahUQInPage.value == 6236) {
      pausePlayer;
    } else if (isLastAyahInPageButNotInSurah || isLastAyahInSurahAndPage) {
      pausePlayer;
      _currentAyahUQInPage.value += 1;
      quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      moveToNextPage();
      await playFile(url, fileName);
    } else {
      pausePlayer;
      _currentAyahUQInPage.value += 1;
      quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      await playFile(url, fileName);
    }
  }

  Future<void> skipPreviousAyah() async {
    if (_currentAyahUQInPage.value == 1) {
      pausePlayer;
    } else if (isFirstAyahInPageButNotInSurah) {
      pausePlayer;
      _currentAyahUQInPage.value -= 1;
      quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      moveToPreviousPage();
      await playFile(url, fileName);
    } else {
      _currentAyahUQInPage.value -= 1;
      quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      await playFile(url, fileName);
    }
  }

  void clearSelection() {
    if (quranCtrl.isPages.value == 1) {
      generalCtrl.isShowControl.value = true;
    } else {
      if (isPlay.value) {
        quranCtrl.showControl();
      } else {
        quranCtrl.showControl();
        quranCtrl.selectedAyahIndexes.clear();
      }
    }
    generalCtrl.drawerKey.currentState!.closeSlider();
  }

  Future<void> initConnectivity() async {
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (_isDisposed) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
  }

  @override
  void onClose() {
    audioPlayer.pause();
    audioPlayer.dispose();
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.stop();
      isPlay.value = false;
    }
  }

  loadQuranReader() async {
    readerValue = await sl<SharedPreferences>().getString(AUDIO_PLAYER_SOUND) ??
        "192/ar.abdulbasitmurattal";

    readerName.value = await sl<SharedPreferences>().getString(READER_NAME) ??
        'عبد الباسط عبد الصمد';

    readerIndex.value = await sl<SharedPreferences>().getInt(READER_INDEX) ?? 0;
  }
}
