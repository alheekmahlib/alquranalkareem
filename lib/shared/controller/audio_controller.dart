import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../quran_text/text_page_view.dart';
import '../functions.dart';
import '../widgets/controllers_put.dart';
import '../widgets/seek_bar.dart';
import '../widgets/widgets.dart';
import 'ayat_controller.dart';

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
  Color? backColor;
  final controller = Get.find<AyatController>();

  Color determineColor(int b) {
    backColor = const Color(0xff91a57d).withOpacity(0.4);

    return quranTextController.selected.value == true
        ? audioController.ayahSelected.value == b
            ? backColor!
            : Colors.transparent
        : Colors.transparent;
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
  void onInit() {
    isPlay.value = false;
    sliderValue = 0;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
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
      await audioPlayer.setAudioSource(AudioSource.asset(path));
      audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;

          isPlay.value = false;
          if (generalController.cuMPage == 604) {
            await audioPlayer.stop();
            isPlay.value = false;
          } else if (lastAyahInPage.value ==
              int.parse(ayatController.currentAyahNumber.value)) {
            print('generalController.cuMPage ${generalController.cuMPage++}');
            generalController.dPageController!.jumpToPage(
              (generalController.cuMPage - 1),
              // duration: const Duration(milliseconds: 600), curve: Curves.easeInOut
            );
            isPlay.value = true;
            playNextAyah(context);
            // Call playAyah again to play the next ayah
            await playFile(context, url, fileName);
          }
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

  void playNextAyah(BuildContext context) async {
    print('playNextAyah ' * 6);

    print('ayat!.last.ayaNum ${lastAyahInPage.value}');
    // Increment Ayah number
    int currentAyah;
    int currentSorah;
    currentAyah = int.parse(ayatController.currentAyahNumber.value) + 1;
    ayatController.currentAyahNumber.value = '$currentAyah';
    currentAyah == ayatController.ayatList.last.ayaNum
        ? currentSorah = int.parse(pageSurahNumber!) + 1
        : currentSorah = int.parse(pageSurahNumber!);
    pageSurahNumber = formatNumber(currentSorah);
    ayatController.currentAyahNumber.value = formatNumber(currentAyah);

    String reader = readerValue!;
    String fileName =
        "$reader/${pageSurahNumber!}${ayatController.currentAyahNumber.value}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";
    print('nextURL $url');

    print('currentAyah $currentAyah');
    // print('lastAyah $lastAyah');

    await playFile(context, url, fileName);
    isProcessingNextAyah.value = false;
  }

  playAyah(BuildContext context) async {
    int? currentAyah;
    int? currentSorah;

    currentAyah = int.parse(ayatController.currentAyahNumber.value);
    currentSorah = int.parse(pageSurahNumber!);
    pageSurahNumber = formatNumber(currentSorah);
    ayatController.currentAyahNumber.value = formatNumber(currentAyah);

    String reader = readerValue!;
    String fileName =
        "$reader/${pageSurahNumber!}${ayatController.currentAyahNumber.value}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";

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
      await textAudioPlayer.setAudioSource(AudioSource.asset(path));
      textAudioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;

          isPlay.value = false;
          textPlayNextAyah(context);

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
    int? currentAyah;
    int? currentSorah;

    currentAyah = int.parse(ayatController.ayahTextNumber!);
    currentSorah = int.parse(ayatController.sorahTextNumber!);
    ayatController.sorahTextNumber = formatNumber(currentSorah);
    ayatController.ayahTextNumber = formatNumber(currentAyah);

    String reader = readerValue!;
    String fileName =
        "$reader/${ayatController.sorahTextNumber!}${ayatController.ayahTextNumber!}.mp3";
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
    print('ayahSelected.value ${ayahSelected.value}');
    // Increment Ayah number
    int currentAyah;
    int currentSorah;
    currentAyah = int.parse(ayatController.ayahTextNumber!) + 1;
    currentSorah = int.parse(ayatController.sorahTextNumber!);
    ayatController.sorahTextNumber = formatNumber(currentSorah);
    ayatController.ayahTextNumber = formatNumber(currentAyah);

    String reader = readerValue!;
    String fileName =
        "$reader/${ayatController.sorahTextNumber!}${ayatController.ayahTextNumber!}.mp3";
    String url = "https://www.everyayah.com/data/$fileName";
    print('nextURL $url');

    print('currentAyah $currentAyah');
    // print('lastAyah $lastAyah');

    print('lastAyahInPageA $lastAyahInPageA');
    if (currentAyah == lastAyahInPage.value) {
      audioController.ayahSelected.value = currentAyah;
      print('ayahSelected.value: ${audioController.ayahSelected.value}');
      // textCubit.changeSelectedIndex(currentAyah - 1);
      quranTextController.itemScrollController.scrollTo(
          index: pageNumber.value + 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
      await textPlayFile(context, url, fileName);
    } else {
      audioController.ayahSelected.value = currentAyah;
      print('ayahSelected.value: ${audioController.ayahSelected.value}');
      // textCubit.changeSelectedIndex(currentAyah - 1);
      await textPlayFile(context, url, fileName);
    }

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
            await audioPlayer.setAudioSource(AudioSource.asset(path));
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
      await audioPlayer.setAudioSource(AudioSource.asset(path));
      audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed &&
            !isProcessingNextAyah.value) {
          isProcessingNextAyah.value = true;
          print('generalController.cuMPage ${generalController.cuMPage}');
          isPagePlay.value = false;
          if (generalController.cuMPage == 604) {
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
    int pageNum = generalController.cuMPage + 1;
    generalController.dPageController!.jumpToPage(generalController.cuMPage++);
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
    pageNum = generalController.cuMPage;
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

  // Save & Load Reader Quran
  saveQuranReader(String readerValue) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setString('audio_player_sound', readerValue);
  }

  loadQuranReader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    readerValue =
        prefs.getString('audio_player_sound') ?? "Abdul_Basit_Murattal_192kbps";
    print('Quran Reader ${prefs.getString('audio_player_sound')}');
  }
}
