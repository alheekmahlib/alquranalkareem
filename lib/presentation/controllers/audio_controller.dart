import 'dart:async' show StreamSubscription;
import 'dart:developer' show log;
import 'dart:io' show File, Directory;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;

import '/core/services/services_locator.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/custom_mobile_notes_snack_bar.dart';
import '/core/utils/constants/lists.dart';
import '/core/utils/constants/shared_preferences_constants.dart';
import '/core/utils/constants/url_constants.dart';
import '/core/utils/helpers/global_key_manager.dart';
import '/core/widgets/seek_bar.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';
import 'quran_controller.dart';

class AudioController extends GetxController {
  static AudioController get instance => Get.isRegistered<AudioController>()
      ? Get.find<AudioController>()
      : Get.put<AudioController>(AudioController());
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer textAudioPlayer = AudioPlayer();
  RxBool isPlay = false.obs;
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = '0'.obs;
  RxDouble progress = 0.0.obs;
  String? currentPlay;
  RxBool autoPlay = false.obs;
  double? sliderValue;
  String? readerValue;
  RxString readerName = 'عبد الباسط عبد الصمد'.obs;
  String? pageAyahNumber;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late Directory dir;
  late Uri cachedArtUri;
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
  RxInt _selectedAyahNum = 1.obs;
  RxInt _currentAyahUQInPage = 1.obs;
  RxInt _currentSurahNumInPage = 1.obs;
  bool goingToNewSurah = false;
  RxBool selected = false.obs;
  RxInt readerIndex = 0.obs;
  RxBool isStartPlaying = false.obs;

  /// wether the app should play next ayahs or not..
  bool playSingleAyahOnly = false;

  /// to use it in future.. for now the app is playing all ayahs until user stop the player..
  bool stopWhenSurahEnds = false;

  /// GetStorage Box [SharedPrefrences]
  final box = GetStorage();

  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;
  final ayatCtrl = AyatController.instance;

  void startPlayingToggle() {
    isStartPlaying.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isStartPlaying.value = false;
    });
  }

  void playAyahOnTap(int surahNum, int ayahNum, int ayahUQNum,
      [bool singleAyahOnly = false]) {
    _selectedAyahNum.value = ayahNum;
    _currentSurahNumInPage.value = surahNum;
    _currentAyahUQInPage.value = ayahUQNum;
    playSingleAyahOnly = singleAyahOnly;
    log('s: ${quranCtrl.surahs[_currentSurahNumInPage.value - 1].arabicName} | _currentAyahUQInPage: ${_currentAyahUQInPage.value}',
        name: 'AudioController_playAyahOnTap');
    playAyah();
  }

  MediaItem get mediaItemForCurrentAyah => MediaItem(
        id: '${_currentAyahUQInPage.value}',
        title:
            '${sl<QuranController>().getPageAyahsByIndex(generalCtrl.currentPageNumber.value - 1).firstWhere((a) => a.ayahUQNumber == _currentAyahUQInPage.value).text}',
        artist: '${ayahReaderInfo[readerIndex.value]['name']}'.tr,
        artUri: cachedArtUri,
      );
  List<MediaItem> get mediaItemsForCurrentSurah {
    final ayahsOfCrntSurah =
        sl<QuranController>().surahs[currentSurahNumInPage - 1].ayahs;
    return List.generate(
        ayahsOfCrntSurah.length,
        (i) => MediaItem(
              id: '${ayahsOfCrntSurah[i].ayahUQNumber}',
              title: '${ayahsOfCrntSurah[i].text}',
              artist: '${ayahReaderInfo[readerIndex.value]['name']}'.tr,
              artUri: cachedArtUri,
            ));
  }

  int get currentAyahInPage => _selectedAyahNum.value == 1
      ? quranCtrl.allAyahs
          .firstWhere(
              (ayah) => ayah.page == generalCtrl.currentPageNumber.value)
          .ayahNumber
      : _selectedAyahNum.value;

  int get currentSurahNumInPage => _currentSurahNumInPage.value == 1
      ? quranCtrl.getSurahNumberFromPage(generalCtrl.currentPageNumber.value)
      : _currentSurahNumInPage.value;

  @override
  void onInit() async {
    isPlay.value = false;
    sliderValue = 0;
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    loadQuranReader();
    await Future.wait([
      sl<GeneralController>()
          .getCachedArtUri(
              'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/Photos/ios-1024.png')
          .then((v) => cachedArtUri = v),
      getApplicationDocumentsDirectory().then((v) => dir = v),
    ]);
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
          .getPageAyahsByIndex(generalCtrl.currentPageNumber.value - 1)
          .last
          .ayahUQNumber ==
      _currentAyahUQInPage.value;
  bool get isFirstAyahInPage =>
      quranCtrl
          .getPageAyahsByIndex(generalCtrl.currentPageNumber.value - 1)
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
  String get currentAyahFileName {
    if (ayahReaderInfo[readerIndex.value]['url'] ==
        UrlConstants.ayahs1stSource) {
      return '$reader/${_currentAyahUQInPage.value}.mp3';
    } else {
      final surahNum = quranCtrl
          .getSurahNumberByAyah(
              quranCtrl.allAyahs[_currentAyahUQInPage.value - 1])
          .toString()
          .padLeft(3, '0');
      final currentAyahNumber = quranCtrl
          .allAyahs[_currentAyahUQInPage.value - 1].ayahNumber
          .toString()
          .padLeft(3, '0');
      return '$reader/$surahNum$currentAyahNumber.mp3';
    }
  }

  List<int> get selectedSurahAyahsUniqueNumbers =>
      quranCtrl.surahs[currentSurahNumInPage - 1].ayahs
          .map((ayah) => ayah.ayahUQNumber)
          .toList();

  List<String> get selectedSurahAyahsFileNames {
    final selectedSurah = quranCtrl.surahs[currentSurahNumInPage - 1];
    log('selectedSurah: ${selectedSurah.arabicName}',
        name: 'AudioController_selectedSurahAyahsFileNames');
    return List.generate(
        selectedSurah.ayahs.length,
        (i) => ayahReaderInfo[readerIndex.value]['url'] ==
                UrlConstants.ayahs1stSource
            ? '$reader/${selectedSurah.ayahs[i].ayahUQNumber}.mp3'
            : '$reader/${selectedSurah.surahNumber.toString().padLeft(3, "0")}${selectedSurah.ayahs[i].ayahNumber.toString().padLeft(3, "0")}.mp3');
  }

  // +1
  List<String> get selectedSurahAyahsUrls {
    return List.generate(selectedSurahAyahsFileNames.length,
        (i) => '$ayahDownloadSource${selectedSurahAyahsFileNames[i]}');
  }

  String get ayahDownloadSource =>
      ayahReaderInfo[readerIndex.value]['url'] == UrlConstants.ayahs1stSource
          ? UrlConstants.ayahs1stSource
          : UrlConstants.ayahs2ndSource;

  String get currentAyahUrl => '$ayahDownloadSource$currentAyahFileName';
  void get pausePlayer async {
    isPlay.value = false;
    await audioPlayer.pause();
  }

  Future<void> moveToNextPage({bool withScroll = true}) async {
    if (withScroll) {
      await generalCtrl.quranPageController.animateToPage(
          (generalCtrl.currentPageNumber.value),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
      log('Going To Next Page at: ${generalCtrl.currentPageNumber.value} ');
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

  Future<String> _downloadFileIfNotExist(String url, String fileName,
      [bool showSnakbars = true]) async {
    String path;
    path = join(dir.path, fileName);
    var file = File(path);
    bool exists = await file.exists();
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print('Error creating directory: $e');
      }
      if (showSnakbars) {
        if (_connectionStatus.contains(ConnectivityResult.none)) {
          Get.context!.showCustomErrorSnackBar('noInternet'.tr);
        } else if (_connectionStatus.contains(ConnectivityResult.mobile)) {
          try {
            await _downloadFile(path, url, fileName);
            Get.context!.customMobileNoteSnackBar('mobileDataAyat'.tr);
          } catch (e) {
            log('Error downloading file: $e');
          }
        } else if (_connectionStatus.contains(ConnectivityResult.wifi)) {
          try {
            await _downloadFile(path, url, fileName);
          } catch (e) {
            log('Error downloading file: $e');
          }
        }
      } else {
        if (false == _connectionStatus.contains(ConnectivityResult.none)) {
          try {
            await _downloadFile(path, url, fileName);
          } catch (e) {
            log('Error downloading file: $e');
          }
        }
      }
    }
    tmpDownloadedAyahsCount += 1;
    return path;
  }

  /// used for download seek bar.
  RxInt tmpDownloadedAyahsCount = 0.obs;

  Future playFile() async {
    tmpDownloadedAyahsCount = 0.obs;
    final ayahsFilesNames = selectedSurahAyahsFileNames;
    try {
      log('currentAyahUrl: $currentAyahUrl', name: 'AudioController');
      if (playSingleAyahOnly) {
        final path =
            await _downloadFileIfNotExist(currentAyahUrl, currentAyahFileName);
        await audioPlayer.setAudioSource(AudioSource.file(
          path,
          tag: mediaItemForCurrentAyah,
        ));
        // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value + 2);
      } else {
        final futures = List.generate(
          ayahsFilesNames.length,
          (i) => _downloadFileIfNotExist(
              selectedSurahAyahsFileNames[i], ayahsFilesNames[i]),
        );

        await Future.wait(futures);
        // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value -= 1);
        await audioPlayer.setAudioSource(
          initialIndex: _selectedAyahNum.value - 1,
          ConcatenatingAudioSource(
            children: List.generate(
              ayahsFilesNames.length,
              (i) => AudioSource.file(
                join(dir.path, ayahsFilesNames[i]),
                tag: mediaItemsForCurrentSurah[i],
              ),
            ),
          ),
        );
      }
      log('${'-' * 30} player is starting.. ${'-' * 30}',
          name: 'AudioController');

      // int lastIndex = _selectedAyahNum.value - 1;

      audioPlayer.currentIndexStream.listen((index) {
        if (index != null &&
            index != 0 &&
            index != _selectedAyahNum.value - 1) {
          log('index: $index | _selectedAyahNum: ${_selectedAyahNum.value} | _currentAyahUQInPage: ${_currentAyahUQInPage.value}');
          log('_currentAyahUQInPage.value: ${_currentAyahUQInPage.value}');
          _selectedAyahNum.value = index + 1;
          _currentAyahUQInPage.value =
              selectedSurahAyahsUniqueNumbers[_selectedAyahNum.value - 1];
          // lastIndex = index;
          quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
        }
      });

      // audioPlayer.playerStateStream.listen((state) {
      //   if (state.playing != isPlay.value) {
      //     isPlay.value = state.playing;
      //   }
      // });
      print('playFile2: play');
      isPlay.value = true;
      audioPlayer.play().then((_) => isPlay.value = false).whenComplete(() {
        audioPlayer.stop();
        isPlay.value = false;
      });
    } catch (e) {
      isPlay.value = false;
      audioPlayer.stop();
      log('Error in playFile: $e', name: 'AudioController');
    }
  }

  // Future<void> playNextAyah() async {
  //   isProcessingNextAyah.value = true;
  //   // _currentAyahUQInPage.value += 1;
  //   // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
  //   // await playFile();
  //   await audioPlayer.seekToNext();
  //   isProcessingNextAyah.value = false;
  //   if (quranCtrl.isPages.value == 1) {
  //     quranCtrl.scrollOffsetController.animateScroll(
  //       offset: quranCtrl.ayahsWidgetHeight.value,
  //       duration: const Duration(milliseconds: 600),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

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
    if (audioPlayer.playing || isPlay.value) {
      isPlay.value = false;
      await audioPlayer.pause();
      print('audioPlayer: pause');
    } else {
      quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      await playFile();
    }
  }

  Future<bool> _downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      await Directory(dirname(path)).create(recursive: true);
      downloading.value = true;
      onDownloading.value = true;
      progressString.value = 'Indeterminate';
      progress.value = 0;

      // First, attempt to fetch file size to decide on progress indication strategy
      var fileSize = await _fetchFileSize(url, dio);
      if (fileSize != null) {
        print('Known file size: $fileSize bytes');
      } else {
        print('File size unknown.');
      }

      var incrementalProgress = 0.0;
      const incrementalStep =
          0.1; // Adjust the step size based on expected download sizes and durations

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        if (total <= 0) {
          // Update the progress value incrementally
          incrementalProgress += incrementalStep;
          if (incrementalProgress >= 1) {
            incrementalProgress = 0; // Reset if it reaches 1
          }
          // Update your UI based on incrementalProgress here
          // For example, update a progress bar's value or animate an indicator
        } else {
          // Handle determinate progress as before
          double progressValue = (rec / total).toDouble().clamp(0.0, 1.0);
          progress.value = progressValue;
        }
        print('Received bytes: $rec, Total bytes: $total');
      });
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        print('Download canceled');
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
    } finally {
      downloading.value = false;
      onDownloading.value = false;
      progressString.value = 'Completed';
      print('Download completed or failed');
    }
    return true;
  }

  Future<int?> _fetchFileSize(String url, Dio dio) async {
    try {
      var response = await dio.head(url);
      if (response.headers.value('Content-Length') != null) {
        return int.tryParse(response.headers.value('Content-Length')!);
      }
    } catch (e) {
      print('Error fetching file size: $e');
    }
    return null;
  }

  void cancelDownload() {
    cancelToken.cancel('Request cancelled');
  }

  Future<void> skipNextAyah() async {
    if (_currentAyahUQInPage.value == 6236) {
      pausePlayer;
    } else if (isLastAyahInPageButNotInSurah || isLastAyahInSurahAndPage) {
      // pausePlayer;
      // _currentAyahUQInPage.value += 1;
      // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      await moveToNextPage();
      await audioPlayer.seekToNext();
      // await playFile();
    } else {
      // pausePlayer;
      // _currentAyahUQInPage.value += 1;
      // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      // await playFile();
      await audioPlayer.seekToNext();
    }
  }

  Future<void> skipPreviousAyah() async {
    if (_currentAyahUQInPage.value == 1) {
      pausePlayer;
    } else if (isFirstAyahInPageButNotInSurah) {
      // pausePlayer;
      // _currentAyahUQInPage.value -= 1;
      // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      moveToPreviousPage();
      // await playFile();
      await audioPlayer.seekToPrevious();
    } else {
      // _currentAyahUQInPage.value -= 1;
      // quranCtrl.clearAndAddSelection(_currentAyahUQInPage.value);
      // await playFile();
      await audioPlayer.seekToPrevious();
    }
  }

  void clearSelection() {
    if (isPlay.value) {
      quranCtrl.showControl();
    } else if (quranCtrl.selectedAyahIndexes.isNotEmpty) {
      quranCtrl.selectedAyahIndexes.clear();
    } else {
      quranCtrl.showControl();
    }
    GlobalKeyManager().drawerKey.currentState!.closeSlider();
  }

  Future<void> initConnectivity() async {
    late dynamic result; // Can be either List<ConnectivityResult> or String
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // Handle both potential return types
    if (result is List<ConnectivityResult>) {
      _updateConnectionStatus(result);
    } else if (result is String) {
      // Handle String case (parse the string or handle error)
      // For example, log an error message
      log('Unexpected data type from checkConnectivity: $result');
    } else {
      // Handle unexpected data type (shouldn't happen)
      log('Unknown data type from checkConnectivity: $result');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (_isDisposed) {
      return Future.value(null);
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    update();
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
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

  void loadQuranReader() {
    readerValue =
        box.read(AUDIO_PLAYER_SOUND) ?? 'Abdul_Basit_Murattal_192kbps';
    readerName.value = box.read(READER_NAME) ?? 'عبد الباسط عبد الصمد';
    readerIndex.value = box.read(READER_INDEX) ?? 0;
  }

  void changeReadersOnTap(int index) {
    readerName.value = ayahReaderInfo[index]['name'];
    readerValue = ayahReaderInfo[index]['readerD'];
    readerIndex.value = index;
    box.write(AUDIO_PLAYER_SOUND, ayahReaderInfo[index]['readerD']);
    box.write(READER_NAME, ayahReaderInfo[index]['name']);
    box.write(READER_INDEX, index);
    Get.back();
  }
}
