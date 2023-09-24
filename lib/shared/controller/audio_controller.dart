import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:alquranalkareem/quran_text/model/QuranModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;

import '../../l10n/app_localizations.dart';
import '../../quran_text/model/Ahya.dart';
import '../../quran_text/text_page_view.dart';
import '../functions.dart';
import '../services/controllers_put.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '../widgets/seek_bar.dart';
import '../widgets/widgets.dart';

class AudioController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  // AudioPlayer pageAudioPlayer = AudioPlayer();
  AudioPlayer textAudioPlayer = AudioPlayer();
  RxBool isPlay = false.obs;
  RxBool downloading = false.obs;
  RxString progressString = "0".obs;
  RxBool isPagePlay = false.obs;
  RxDouble progress = 0.0.obs;
  RxBool downloadingPage = false.obs;
  RxString progressPageString = "0".obs;
  RxDouble progressPage = 0.0.obs;
  RxInt ayahSelected = (-1).obs;
  String? currentPlay;
  RxBool autoPlay = false.obs;
  double? sliderValue;
  String? readerValue;
  String? pageAyahNumber;
  String? pageSurahNumber;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ConnectivityResult result;
  final _connectivity = Connectivity();
  final bool _isDisposed = false; // to keep track of the controller lifecycle
  RxBool isProcessingNextAyah = false.obs;
  Duration? lastPosition;
  Duration? pageLastPosition;
  RxInt pageNumber = 0.obs;
  RxInt lastAyahInPage = 0.obs;
  RxInt lastAyahInTextPage = 0.obs;
  RxInt lastAyahInSurah = 0.obs;
  Color? backColor;
  RxInt currentAyahInPage = 1.obs;
  int? currentSorahInPage;
  int? currentAyah;
  int? currentSorah;
  bool goingToNewSurah = false;
  // final controller = Get.find<AyatController>();

  // Color determineColor(int b) {
  //   backColor = const Color(0xff91a57d).withOpacity(0.4);
  //
  //   return quranTextController.selected.value == true
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

  Stream<PositionData> get textPositionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          textAudioPlayer.positionStream,
          textAudioPlayer.bufferedPositionStream,
          textAudioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  String get currentAyahFileName {
    final surahNumber = surahTextController.surahs
        .firstWhere((s) =>
            s.ayahs!.firstWhere(
                (a) => a.number == ayatController.currentAyah!.ayaId) !=
            null)
        .number;
    return "$readerValue/${formatNumber(surahNumber!)}${formatNumber(ayatController.currentAyah!.ayaId!)}.mp3";
  }

  SurahText get getSurahByAID {
    print(surahTextController.surahs.length);
    return surahTextController.surahs.firstWhere((s) =>
        s.ayahs!.firstWhereOrNull(
            (a) => a.number == ayatController.currentAyah!.ayaId) !=
        null);
  }

  Ayahs get currentAyahs => getSurahByAID.ayahs!
      .firstWhere((a) => a.number == ayatController.currentAyah!.ayaId);

  bool get isLastAyahInPage =>
      surahTextController
          .allPages[generalController.cuMPage.value - 1].length ==
      int.parse(ayatController.currentAyahNumber.value);

  Future playFile(BuildContext context, String url, String fileName) async {
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
          customErrorSnackBar(
              context, AppLocalizations.of(context)!.noInternet);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.mobileDataAyat);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      lastAyahInPage.value = ayatController.ayatList.last.ayaNum!;
      // lastAyahInSurah.value = ayaController.ayahList.last.ayaNum;
      await audioPlayer.setAudioSource(AudioSource.file(path));
      audioPlayer.playerStateStream.listen((playerState) async {
        // if (playerState.processingState == ProcessingState.completed) {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;
          // isPlay.value = false;
          // await audioPlayer.pause();
          // isPlay.value = false;
          print(
              'generalController.cuMPage.value ${generalController.cuMPage.value}');
          if (generalController.cuMPage.value == 604) {
            print('doneeeeeeeeeeee');
            await audioPlayer.pause();
            isPlay.value = false;
          } else if (isLastAyahInPage) {
            print('moveToPage');
            moveToNextPage();
            isPlay.value = true;
            // await playNextAyah(context);
          } else if (getSurahByAID.ayahs!.length ==
              int.parse(ayatController.currentAyahNumber.value)) {
            moveToNextPage();
            goingToNewSurah = true;
          }
          print(
              'ayatController.currentAyahNumber.value${ayatController.currentAyahNumber.value}');
          playNextAyah(context);

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

  void moveToNextPage() {
    generalController.dPageController!.jumpToPage(
      generalController.cuMPage.value,
      // duration: const Duration(milliseconds: 600), curve: Curves.easeInOut
    );
  }

  // void moveToNextSurah() {
  //   generalController.dPageController!.jumpToPage(
  //     generalController.cuMPage.value,
  //     // duration: const Duration(milliseconds: 600), curve: Curves.easeInOut
  //   );
  // }

  Future<void> playNextAyah(BuildContext context) async {
    print('playNextAyah ' * 6);

    // currentAyahInPage.value = int.parse(ayatController.currentAyahNumber.value);
    if (goingToNewSurah) {
      currentSorahInPage = int.parse(pageSurahNumber!) + 1;
      currentAyahInPage.value = 1;
      goingToNewSurah = false;
    } else {
      currentAyahInPage.value += 1;
      currentSorahInPage = int.parse(pageSurahNumber!);
    }

    ayatController.currentAyahNumber.value = '${currentAyahInPage.value}';
    // currentAyahInPage.value == ayatController.ayatList.last.ayaNum
    //     ? currentSorahInPage = int.parse(pageSurahNumber!) + 1
    //     : currentSorahInPage = int.parse(pageSurahNumber!);
    pageSurahNumber = formatNumber(currentSorahInPage!);
    ayatController.currentAyahNumber.value =
        formatNumber(currentAyahInPage.value);

    String reader = readerValue!;
    String fileName =
        "$reader/${pageSurahNumber!}${ayatController.currentAyahNumber.value}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";
    print('nextURL $url');

    print('currentAyah ${currentAyahInPage.value}');

    await playFile(context, url, fileName);
    isProcessingNextAyah.value = false;
  }

  playAyah(BuildContext context) async {
    currentAyahInPage.value = int.parse(ayatController.currentAyahNumber.value);
    currentSorahInPage = int.parse(pageSurahNumber!);
    pageSurahNumber = formatNumber(currentSorahInPage!);
    ayatController.currentAyahNumber.value =
        formatNumber(currentAyahInPage.value);

    String reader = readerValue!;
    String fileName =
        "$reader/${pageSurahNumber!}${ayatController.currentAyahNumber.value}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";
    print('URL: $url');

    if (isPlay.value) {
      await audioPlayer.pause();
      isPlay.value = false;
      print('audioPlayer: pause');
    } else {
      await playFile(context, url, fileName);
      isPlay.value = true;
    }
  }

  Future textPlayFile(BuildContext context, String url, String fileName) async {
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
          customErrorSnackBar(
              context, AppLocalizations.of(context)!.noInternet);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.mobileDataAyat);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      await textAudioPlayer.setAudioSource(AudioSource.file(path));
      textAudioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;

          isPlay.value = false;
          quranTextController.value.value == 1
              ? textPlayNextAyah(context)
              : textPlayNextPage(context);

          print('ProcessingState.completed');
        }
      });

      // Duration position = await textAudioPlayer.position;
      // lastPosition = position;
      // if (lastPosition != null) {
      //   textAudioPlayer
      //       .seek(lastPosition); // Seek to the last position when resuming
      //   print('lastPosition != null: $lastPosition');
      //   lastPosition = null; // Reset the last position
      //   isPlay.value = true;
      //   // await textAudioPlayer.play();
      // }
      isPlay.value = true;
      await textAudioPlayer.play();
      print('playFile2: play');
    } catch (e) {
      print(e);
    }
  }

  textPlayAyah(BuildContext context) async {
    currentAyah = int.parse(ayatController.ayahTextNumber.value);
    currentSorah = int.parse(ayatController.sorahTextNumber.value);
    ayatController.sorahTextNumber.value = formatNumber(currentSorah!);
    ayatController.ayahTextNumber.value = formatNumber(currentAyah!);

    String reader = readerValue!;
    String fileName =
        "$reader/${ayatController.sorahTextNumber.value}${ayatController.ayahTextNumber.value}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";

    if (isPlay.value) {
      await textAudioPlayer.pause();
      isPlay.value = false;
      print('audioPlayer: pause');
    } else {
      await textPlayFile(context, url, fileName);
      isPlay.value = true;
    }
  }

  void textPlayNextAyah(BuildContext context) async {
    print('playNextAyah ' * 6);
    ayahSelected.value;
    ayahSelected.value = ayahSelected.value + 1;

    currentAyah = int.parse(ayatController.ayahTextNumber.value) + 1;
    currentSorah = int.parse(ayatController.sorahTextNumber.value);
    ayatController.sorahTextNumber.value = formatNumber(currentSorah!);
    ayatController.ayahTextNumber.value = formatNumber(currentAyah!);

    String reader = readerValue!;
    String fileName =
        "$reader/${ayatController.sorahTextNumber.value}${ayatController.ayahTextNumber.value}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";
    print('nextURL $url');

    print('currentAyah $currentAyah');

    quranTextController.itemScrollController.scrollTo(
        index: (currentAyah! - 1),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut);
    await textPlayFile(context, url, fileName);
    print('lastAyahInPageA $lastAyahInPageA');
    // if (currentAyah == lastAyahInPage.value) {
    //   audioController.ayahSelected.value = currentAyah!;
    //   print('ayahSelected.value: ${audioController.ayahSelected.value}');
    //   quranTextController.itemScrollController.scrollTo(
    //       index: pageNumber.value + 1,
    //       duration: const Duration(seconds: 1),
    //       curve: Curves.easeOut);
    //   await textPlayFile(context, url, fileName);
    // } else {
    //   audioController.ayahSelected.value = currentAyah!;
    //   print('ayahSelected.value: ${audioController.ayahSelected.value}');
    //   await textPlayFile(context, url, fileName);
    // }

    isProcessingNextAyah.value = false;
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
    //   currentAyah = int.parse(ayatController.ayahTextNumber.value) + 1;
    //   audioController.ayahSelected.value = currentAyah!;
    //   print('ayahSelected.value: ${audioController.ayahSelected.value}');
    //   quranTextController.itemScrollController.scrollTo(
    //       index: pageN + 1,
    //       duration: const Duration(seconds: 1),
    //       curve: Curves.easeOut);
    // } else {
    //   currentAyah = int.parse(ayatController.ayahTextNumber.value) + 1;
    //   audioController.ayahSelected.value = currentAyah!;
    //   print('ayahSelected.value: ${audioController.ayahSelected.value}');
    // }
    //
    // currentSorah = int.parse(ayatController.sorahTextNumber.value);
    // ayatController.sorahTextNumber.value = formatNumber(currentSorah!);
    // ayatController.ayahTextNumber.value = formatNumber(currentAyah!);
    //
    // String reader = readerValue!;
    // String fileName =
    //     "$reader/${ayatController.sorahTextNumber.value}${ayatController.ayahTextNumber.value}.mp3";
    // String url = "https://www.everyayah.com/data/$fileName";
    // print('nextURL $url');
    // await textPlayFile(context, url, fileName);
    isProcessingNextAyah.value = false;
  }

  Future downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      downloading.value = true;
      progressString.value = "0";
      progress.value = 0;
      await dio.download(
        url,
        path,
        onReceiveProgress: (rec, total) {
          progressString.value = ((rec / total) * 100).toStringAsFixed(0);
          progress.value = (rec / total).toDouble();
          print(progressString.value);
        },
      );
    } catch (e) {
      print(e);
    }
    downloading.value = false;
    progressString.value = "100";
    print("Download completed");
  }

  Future playPageFile(BuildContext context, String url, String fileName) async {
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
            await audioPlayer.setAudioSource(AudioSource.file(path));
          } else {
            customErrorSnackBar(
                context, AppLocalizations.of(context)!.noInternet);
          }
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          await downloadFile(path, url, fileName);
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.mobileDataAyat);
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          await downloadFile(path, url, fileName);
        }
      }
      // await audioPlayer.stop();
      // isPagePlay.value = true;
      await audioPlayer.setAudioSource(AudioSource.file(path));
      audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;
          print(
              'generalController.cuMPage.value ${generalController.cuMPage.value}');
          isPagePlay.value = false;
          if (generalController.cuMPage.value == 604) {
            await audioPlayer.stop();
            isPagePlay.value = false;
          } else {
            playNextPage(context);
          }
          print('ProcessingState.completed');
        }
      });
      Duration position = audioPlayer.position;
      pageLastPosition = position;
      if (pageLastPosition != null) {
        await audioPlayer
            .seek(pageLastPosition); // Seek to the last position when resuming
        isPagePlay.value = true;
        print('pageLastPosition != null: $pageLastPosition');
        pageLastPosition = null; // Reset the last position
        // await pageAudioPlayer.play();
      }
      isPagePlay.value = true;
      await audioPlayer.play();

      print('playPageFile2: play');
    } catch (e) {
      print(e);
    }
  }

  void playNextPage(BuildContext context) async {
    print('playNextPage ' * 6);
    int pageNum = generalController.cuMPage.value + 1;
    generalController.dPageController!
        .jumpToPage((generalController.cuMPage.value) + 1);
    String? stringPageNum;
    if (pageNum < 10) {
      stringPageNum = "00" + pageNum.toString();
    } else if (pageNum < 100) {
      stringPageNum = "0" + pageNum.toString();
    } else if (pageNum < 1000) {
      stringPageNum = pageNum.toString();
    }
    late int sorahNumInt;
    sorahNumInt = pageNum;

    // String sorahNumWithLeadingZeroes = stringPageNum!;

    String reader = readerValue!;
    String fileName = "$reader/PageMp3s/Page${stringPageNum!}.mp3";
    print(readerValue);
    String url = "https://everyayah.com/data/$fileName";
    print("url $url");

    if (isPagePlay.value) {
      await audioPlayer.pause();
      isPagePlay.value = false;
    } else {
      await playPageFile(context, url, fileName);
      isPagePlay.value = true;
    }

    isProcessingNextAyah.value = false;
  }

  playPage(BuildContext context, int pageNum) async {
    pageNum = generalController.cuMPage.value;
    String? stringPageNum;
    if (pageNum < 10) {
      stringPageNum = "00" + pageNum.toString();
    } else if (pageNum < 100) {
      stringPageNum = "0" + pageNum.toString();
    } else if (pageNum < 1000) {
      stringPageNum = pageNum.toString();
    }
    late int sorahNumInt;
    sorahNumInt = pageNum;

    // String sorahNumWithLeadingZeroes = stringPageNum!;

    String reader = readerValue!;
    String fileName = "$reader/PageMp3s/Page${stringPageNum!}.mp3";
    print(readerValue);
    String url = "https://everyayah.com/data/$fileName";
    print("url $url");

    if (isPagePlay.value) {
      await audioPlayer.pause();
      isPagePlay.value = false;
    } else {
      await playPageFile(context, url, fileName);
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
    readerValue = await pref.getString(AUDIO_PLAYER_SOUND,
        defaultValue: "Abdul_Basit_Murattal_192kbps");
  }
}
