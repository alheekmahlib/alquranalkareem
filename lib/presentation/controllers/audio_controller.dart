import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:alquranalkareem/core/utils/constants/constants.dart';
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

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_pref_services.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/functions.dart';
import '../../core/widgets/seek_bar.dart';
import '../../core/widgets/widgets.dart';
import '../screens/quran_text/data/models/Ahya.dart';
import '../screens/quran_text/data/models/QuranModel.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';
import 'quran_controller.dart';
import 'surahTextController.dart';

class AudioController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer pageAudioPlayer = AudioPlayer();
  AudioPlayer textAudioPlayer = AudioPlayer();
  RxBool isPlay = false.obs;
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxBool isPagePlay = false.obs;
  RxDouble progress = 0.0.obs;
  RxBool downloadingPage = false.obs;
  RxString progressPageString = "0".obs;
  RxDouble progressPage = 0.0.obs;
  String? currentPlay;
  RxBool autoPlay = false.obs;
  double? sliderValue;
  String? readerValue;
  RxString readerName = 'عبد الباسط عبد الصمد'.obs;
  String? pageAyahNumber;
  // String? pageSurahNumber;
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
  RxInt _currentAyahInPage = 1.obs;
  RxInt _currentSurahInPage = 1.obs;
  bool goingToNewSurah = false;
  RxBool selected = false.obs;
  RxInt readerIndex = 0.obs;
  RxBool isStartPlaying = false.obs;

  void startPlayingToggle() {
    isStartPlaying.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isStartPlaying.value = false;
    });
  }

  void playAyahOnTap(int surahNum, int ayahNum) {
    _currentAyahInPage.value = ayahNum;
    _currentSurahInPage.value = surahNum;
    playAyah();
  }

  int get currentAyahInPage => _currentAyahInPage.value == 1
      ? sl<QuranController>()
          .allAyahs
          .firstWhere(
              (ayah) => ayah.page == sl<GeneralController>().currentPage.value)
          .ayahNumber
      : _currentAyahInPage.value;

  int get currentSurahInPage => _currentSurahInPage.value == 1
      ? sl<QuranController>()
          .getSurahNumberFromPage(sl<GeneralController>().currentPage.value)
      : _currentSurahInPage.value;

  // final controller = Get.find<AyatController>();

  // Color determineColor(int b) {
  //   backColor = const Color(0xff91a57d).withOpacity(0.4);
  //
  //   return sl<QuranTextController>().selected.value == true
  //       ? audioController.ayahSelected.value == b
  //           ? backColor!
  //           : Colors.transparent
  //       : Colors.transparent;
  // }

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

  Stream<PositionData> get positionPageDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          pageAudioPlayer.positionStream,
          pageAudioPlayer.bufferedPositionStream,
          pageAudioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  String get currentAyahFileName {
    final surahNumber = sl<SurahTextController>()
        .surahs
        .where((s) =>
            s.ayahs != null &&
            s.ayahs!
                .any((a) => a.number == sl<AyatController>().currentAyah?.id))
        .first
        .number;
    return "$readerValue/${formatNumber(surahNumber!)}${formatNumber(sl<AyatController>().currentAyah!.id)}.mp3";
  }

  SurahText get getCurrentSurah {
    print(sl<SurahTextController>().surahs.length);
    return sl<SurahTextController>().currentSurah;
  }

  Ayahs get currentAyahs => getCurrentSurah.ayahs!
      .firstWhere((a) => a.number == sl<AyatController>().currentAyah!.id);

  bool get isLastAyahInPage =>
      sl<SurahTextController>()
          .allPages[sl<GeneralController>().currentPage.value - 1]
          .length ==
      int.parse(sl<AyatController>().currentAyahNumber.value);

  bool get isLastAyahInSurah =>
      sl<SurahTextController>().currentSurah.ayahs!.length ==
      int.parse(sl<AyatController>().currentAyahNumber.value);

  bool get isLastAyahInSurahButNotInPage =>
      isLastAyahInSurah && !isLastAyahInPage;
  bool get isLastAyahInSurahAndPage => isLastAyahInSurah && isLastAyahInPage;
  bool get isLastAyahInPageButNotInSurah =>
      isLastAyahInPage && !isLastAyahInSurah;

  void moveToNextPage({bool withScroll = true}) {
    if (withScroll) {
      sl<GeneralController>().quranPageController.jumpToPage(
            (sl<GeneralController>().currentPage.value - 1),
            // duration: const Duration(milliseconds: 600),
            // curve: Curves.easeInOut
          );
    }
  }

  // void moveToNextSurah() {
  //   sl<GeneralController>().dPageController!.jumpToPage(
  //     sl<GeneralController>().cuMPage.value,
  //     // duration: const Duration(milliseconds: 600), curve: Curves.easeInOut
  //   );
  // }

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
          customErrorSnackBar('noInternet'.tr);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar('mobileDataAyat'.tr);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      lastAyahInPage.value = sl<QuranController>().allAyahs.last.ayahNumber;
      // lastAyahInSurah.value = sl<AyaController>().ayahList.last.ayaNum;
      await audioPlayer.setAudioSource(AudioSource.file(
        path,
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${sl<AyatController>().ayahUQNumber.value}',
          // Metadata to display in the notification:
          album: '${sl<AyatController>().currentAyah?.sorahName ?? ''}',
          title: '${sl<AyatController>().currentAyah?.ayaNum ?? ''}',
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      ));
      audioPlayer.playerStateStream.listen((playerState) async {
        // if (playerState.processingState == ProcessingState.completed) {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = false;
          isPlay.value = false;
          await audioPlayer.pause();
          isPlay.value = false;
          print(
              'sl<GeneralController>().cuMPage.value ${sl<GeneralController>().currentPage.value}');
          // if (sl<GeneralController>().currentPage.value == 604) {
          //   print('doneeeeeeeeeeee');
          //   await audioPlayer.pause();
          //   isPlay.value = false;
          // } else if (isLastAyahInPageButNotInSurah) {
          //   print('moveToPage');
          //   sl<GeneralController>().currentPage.value += 1;
          //   moveToNextPage();
          //   // isPlay.value = true;
          //   // await playNextAyah(context);
          // } else if (isLastAyahInSurahAndPage) {
          //   sl<GeneralController>().currentPage.value += 1;
          //   moveToNextPage();
          //   goingToNewSurah = true;
          // } else if (isLastAyahInSurahButNotInPage) {
          //   moveToNextPage(withScroll: false);
          //   goingToNewSurah = true;
          // }
          print(
              'sl<AyatController>().currentAyahNumber.value${sl<AyatController>().currentAyahNumber.value}');
          // playNextAyah(context);

          print('ProcessingState.completed');
        }
      });

      // Duration position = await audioPlayer.position;
      // lastPosition = position;
      // if (lastPosition != null) {
      //   audioPlayer
      //       .seek(lastPosition); // Seek to the last position when resuming
      //   print('lastPosition != null: $lastPosition');
      //   lastPosition = null; // Reset the last position
      //   isPlay.value = true;
      //   // await audioPlayer.play();
      // }
      isPlay.value = true;
      await audioPlayer.play();
      print('playFile2: play');
    } catch (e) {
      print(e);
    }
  }

  // Future<void> playNextAyah() async {
  //   print('playNextAyah ' * 6);
  //
  //   // currentAyahInPage = int.parse(sl<AyatController>().currentAyahNumber.value);
  //   if (goingToNewSurah) {
  //     currentAyahInPage = 1;
  //     // currentAyah = 1;
  //     sl<SurahTextController>().currentSurahIndex += 1;
  //     goingToNewSurah = false;
  //     // await playFile(context, bismillahFileUrl(readerValue!),
  //     //     bismillahFileName(readerValue!));
  //     await playFile("https://www.everyayah.com/data/$readerValue!/001007.mp3",
  //         "$readerValue!/001007.mp3");
  //   } else {
  //     currentAyahInPage += 1;
  //     currentAyah ??= 0 + 1;
  //   }
  //
  //   sl<AyatController>().currentAyahNumber.value = '${currentAyahInPage}';
  //   // currentAyahInPage == sl<AyatController>().ayatList.last.ayaNum
  //   //     ? currentSorahInPage = int.parse(pageSurahNumber!) + 1
  //   //     : currentSorahInPage = int.parse(pageSurahNumber!);
  //   sl<AyatController>().currentAyahNumber.value =
  //       formatNumber(currentAyahInPage);
  //
  //   String reader = readerValue!;
  //   String fileName =
  //       "$reader/${formatNumber(sl<SurahTextController>().currentSurahIndex + 1)}${sl<AyatController>().currentAyahNumber.value}.mp3";
  //   String url = "https://www.everyayah.com/data/$fileName";
  //   print('nextURL $url');
  //
  //   print('currentAyah ${currentAyahInPage}');
  //
  //   await playFile(url, fileName);
  //   isProcessingNextAyah.value = false;
  // }

  Future<void> playAyah() async {
    isPagePlay.value = false;
    await pageAudioPlayer.pause();

    String reader = readerValue!;
    String fileName =
        "$reader/${formatNumber(currentSurahInPage)}${formatNumber(currentAyahInPage)}.mp3";
    String url = "${UrlConstants.ayahUrl}$fileName";
    print('URL: $url');

    if (!goingToNewSurah && isPlay.value) {
      await audioPlayer.pause();
      isPlay.value = false;
      print('audioPlayer: pause');
    } else {
      await playFile(url, fileName);
      isPlay.value = true;
    }
  }

  int? lastAyah(int pageNamber, var widget) {
    return lastAyahInTextPage.value =
        widget.surah.ayahs![pageNamber].numberInSurah!;
  }

  void textPlayNextPage(BuildContext context) async {
    print('playNextAyah ' * 6);
    await textAudioPlayer.pause();
    isPlay.value = false;
    // ayahSelected.value;
    // ayahSelected.value = ayahSelected.value + 1;
    //
    // print('currentAyah $currentAyah');
    //
    // print('lastAyahInPage ${lastAyahInTextPage.value}');
    // if (currentAyah == lastAyahInTextPage.value) {
    //   /// TODO lastAyahInTextPage = false
    //   print('next page');
    //   pageN + 1;
    //   currentAyah = int.parse(sl<AyatController>().ayahTextNumber.value) + 1;
    //   audioController.ayahSelected.value = currentAyah!;
    //   print('ayahSelected.value: ${audioController.ayahSelected.value}');
    //   sl<QuranTextController>().itemScrollController.scrollTo(
    //       index: pageN + 1,
    //       duration: const Duration(seconds: 1),
    //       curve: Curves.easeOut);
    // } else {
    //   currentAyah = int.parse(sl<AyatController>().ayahTextNumber.value) + 1;
    //   audioController.ayahSelected.value = currentAyah!;
    //   print('ayahSelected.value: ${audioController.ayahSelected.value}');
    // }
    //
    // currentSorah = int.parse(sl<AyatController>().sorahTextNumber.value);
    // sl<AyatController>().sorahTextNumber.value = formatNumber(currentSorah!);
    // sl<AyatController>().ayahTextNumber.value = formatNumber(currentAyah!);
    //
    // String reader = readerValue!;
    // String fileName =
    //     "$reader/${sl<AyatController>().sorahTextNumber.value}${sl<AyatController>().ayahTextNumber.value}.mp3";
    // String url = "https://www.everyayah.com/data/$fileName";
    // print('nextURL $url');
    // await textPlayFile(context, url, fileName);
    isProcessingNextAyah.value = false;
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

  Future playPageFile(String url, String fileName) async {
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
          if (exists) {
            await pageAudioPlayer.setAudioSource(AudioSource.file(
              path,
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: '${sl<AyatController>().ayahUQNumber.value}',
                // Metadata to display in the notification:
                album: '${sl<AyatController>().currentAyah?.sorahName ?? ''}',
                title: 'page number ...', // TODO: edit this.
                // artUri: Uri.parse('https://example.com/albumart.jpg'),
              ),
            ));
          } else {
            customErrorSnackBar('noInternet'.tr);
          }
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar('mobileDataAyat'.tr);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      // await audioPlayer.stop();
      // isPagePlay.value = true;
      await pageAudioPlayer.setAudioSource(AudioSource.file(
        path,
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${sl<AyatController>().ayahUQNumber.value}',
          // Metadata to display in the notification:
          album: '${sl<AyatController>().currentAyah?.sorahName ?? ''}',
          title: 'page number ... ', //TODO: edit this.
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      ));
      pageAudioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;
          isPagePlay.value = false;
          if (sl<GeneralController>().currentPage.value == 604) {
            await pageAudioPlayer.stop();
            isPagePlay.value = false;
          } else {
            playNextPage();
          }
          print('ProcessingState.completed');
        }
      });
      Duration position = pageAudioPlayer.position;
      pageLastPosition = position;
      if (pageLastPosition != null) {
        await pageAudioPlayer
            .seek(pageLastPosition); // Seek to the last position when resuming
        isPagePlay.value = true;
        print('pageLastPosition != null: $pageLastPosition');
        pageLastPosition = null; // Reset the last position
        // await pageAudioPlayer.play();
      }
      isPagePlay.value = true;
      await pageAudioPlayer.play();

      print('playPageFile2: play');
    } catch (e) {
      print(e);
    }
  }

  void playNextPage() async {
    print('playNextPage ' * 6);
    int pageNum = sl<GeneralController>().currentPage.value + 1;
    sl<GeneralController>().quranPageController.animateToPage(
        sl<GeneralController>().currentPage.value,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 700));
    String? stringPageNum;
    if (pageNum < 10) {
      stringPageNum = "00" + pageNum.toString();
    } else if (pageNum < 100) {
      stringPageNum = "0" + pageNum.toString();
    } else if (pageNum < 1000) {
      stringPageNum = pageNum.toString();
    }

    // String sorahNumWithLeadingZeroes = stringPageNum!;

    String reader = readerValue!;
    String fileName = "$reader/PageMp3s/Page${stringPageNum!}.mp3";
    print(readerValue);
    String url = "${UrlConstants.ayahUrl}$fileName";
    print("url $url");

    if (isPagePlay.value) {
      await pageAudioPlayer.pause();
      isPagePlay.value = false;
    } else {
      await playPageFile(url, fileName);
      isPagePlay.value = true;
    }

    isProcessingNextAyah.value = false;
  }

  playPage(int pageNum) async {
    isPlay.value = false;
    await audioPlayer.pause();
    pageNum = sl<GeneralController>().currentPage.value;
    String? stringPageNum;
    if (pageNum < 10) {
      stringPageNum = "00" + pageNum.toString();
    } else if (pageNum < 100) {
      stringPageNum = "0" + pageNum.toString();
    } else if (pageNum < 1000) {
      stringPageNum = pageNum.toString();
    }

    // String sorahNumWithLeadingZeroes = stringPageNum!;

    String reader = readerValue!;
    String fileName = "$reader/PageMp3s/Page${stringPageNum!}.mp3";
    print(readerValue);
    String url = "https://everyayah.com/data/$fileName";
    print("url $url");

    if (isPagePlay.value) {
      await pageAudioPlayer.pause();
      isPagePlay.value = false;
    } else {
      await playPageFile(url, fileName);
      isPagePlay.value = true;
    }
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
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
      isPlay.value = false;
      isPagePlay.value = false;
    }
  }

  loadQuranReader() async {
    readerValue = await sl<SharedPrefServices>().getString(AUDIO_PLAYER_SOUND,
        defaultValue: "Abdul_Basit_Murattal_192kbps");

    readerName.value = await sl<SharedPrefServices>()
        .getString(READER_NAME, defaultValue: 'عبد الباسط عبد الصمد');

    readerIndex.value = await sl<SharedPrefServices>()
        .getInteger(READER_INDEX, defaultValue: 0);
  }
}
