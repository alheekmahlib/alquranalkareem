import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:arabic_numbers/arabic_numbers.dart';
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
import '../../quran_page/data/model/sorah.dart';
import '../../shared/controller/surah_repository_controller.dart';
import '../../shared/widgets/seek_bar.dart';
import '../../shared/widgets/widgets.dart';

class SurahAudioController extends GetxController {
  final SorahRepositoryController sorahRepositoryController =
      Get.put(SorahRepositoryController());
  final ScrollController controller = ScrollController();
  ValueNotifier<double> position = ValueNotifier(0);
  ValueNotifier<double> duration = ValueNotifier(99999);
  ArabicNumbers arabicNumber = ArabicNumbers();
  String currentTime = '0:00';
  String totalDuration = '0:00';
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer downAudioPlayer = AudioPlayer();
  RxBool isPlayOnline = false.obs;
  RxBool isPlay = false.obs;
  RxBool isDownloading = false.obs;
  // StreamSubscription? durationSubscription;
  // StreamSubscription? positionSubscription;
  RxBool downloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;
  RxInt sorahNum = 1.obs;
  late final surahNumber;
  String? selectedValue;
  bool repeatSurah = false;
  bool repeatSurahOnline = false;
  int intValue = 1;
  // late Source audioUrl;
  var url;
  String? fileNameDownload;
  String? urlDownload;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ConnectivityResult result;
  final _connectivity = Connectivity();
  late CancelToken cancelToken;
  TextEditingController textController = TextEditingController();
  RxInt selectedSurah = 0.obs;
  double lastPosition = 0.0;
  bool isInitialLoadComplete = false;
  String? sorahReaderValue;
  String? sorahPageReaderValue;
  String? sorahReaderNameValue;

  bool _isDisposed = false;

  late Animation<Offset> offset;
  late AnimationController controllerSorah;
  List<AudioSource>? surahsPlayList;
  List<AudioSource>? downloadSurahsPlayList;

  late final surahsList = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: surahsPlayList!,
    // children: [
    //   AudioSource.uri(Uri.parse('${sorahReaderValue!}001.mp3')),
    //   AudioSource.uri(Uri.parse('${sorahReaderValue!}002.mp3')),
    //   AudioSource.uri(Uri.parse('${sorahReaderValue!}003.mp3')),
    //   AudioSource.uri(Uri.parse('${sorahReaderValue!}004.mp3')),
    // ]
  );

  // late final downloadSurahsList = ConcatenatingAudioSource(
  //   // Start loading next item just before reaching it
  //   useLazyPreparation: true,
  //   // Customise the shuffle algorithm
  //   shuffleOrder: DefaultShuffleOrder(),
  //   // Specify the playlist items
  //   children: downloadSurahsPlayList!,
  //   // children: [
  //   //   AudioSource.uri(Uri.parse('${sorahReaderValue!}001.mp3')),
  //   //   AudioSource.uri(Uri.parse('${sorahReaderValue!}002.mp3')),
  //   //   AudioSource.uri(Uri.parse('${sorahReaderValue!}003.mp3')),
  //   //   AudioSource.uri(Uri.parse('${sorahReaderValue!}004.mp3')),
  //   // ]
  // );

  String get beautifiedSurahNumber {
    // String sorahNumString;
    switch (sorahNum.value) {
      case < 10:
        return "00${sorahNum.value}";
      case < 100:
        return "0${sorahNum.value}";
      default:
        return "${sorahNum.value}";
    }
  }

  changeSurahNumber() async {
    print('first print: ${DateTime.now()}');
    String paddedString =
        beautifiedSurahNumber; // copy the padded string to a new variable
    intValue = int.parse(
        paddedString); // temporarily convert the padded string to an integer

    // convert intValue back to a padded string
    paddedString = intValue.toString().padLeft(3, '0');

    print('URL: ${sorahReaderValue!}basit/$beautifiedSurahNumber.mp3');
    // await audioPlayer.setAudioSource(AudioSource.uri(
    //     Uri.parse('${sorahReaderValue!}basit/$beautifiedSurahNumber.mp3')));
    await downAudioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse('${sorahReaderValue!}basit/$beautifiedSurahNumber.mp3')));
    print('last print: ${DateTime.now()}');
  }

  downloadSurah({bool skipToNext = false, bool skipToPrevious = false}) async {
    Directory? directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/basit/$beautifiedSurahNumber.mp3';

    File file = File(filePath);
    print("File Path: $filePath");

    if (skipToNext) {
      sorahNum.value++; // Go to the next surah.
    } else if (skipToPrevious) {
      sorahNum.value--; // Go to the previous surah.
    }

    if (await file.exists()) {
      print("File exists. Playing...");

      await downAudioPlayer.setAudioSource(AudioSource.uri(Uri.file(filePath)));
      downAudioPlayer.play();
    } else {
      print("File doesn't exist. Downloading...");
      if (!isDownloading.value) {
        isDownloading.value = true;
        String fileUrl =
            "${sorahReaderValue!}basit/${beautifiedSurahNumber}.mp3";
        print("Downloading from URL: $fileUrl");
        await downloadFile(filePath, fileUrl, beautifiedSurahNumber);

        if (await file.exists()) {
          print("File successfully downloaded and saved to $filePath");
        } else {
          print(
              "Failed to download the file or save it to the expected location.");
        }

        downAudioPlayer.setAudioSource(AudioSource.uri(Uri.file(filePath)));
        downAudioPlayer.play();
      }
    }
  }

  Future downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      await Directory(dirname(path)).create(recursive: true);
      downloading.value = true;
      progressString.value = "0";
      progress.value = 0;

      cancelToken = CancelToken();

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        progressString.value = ((rec / total) * 100).toStringAsFixed(0);
        progress.value = (rec / total).toDouble();
        print(progressString.value);
      }, cancelToken: cancelToken);
    } catch (e) {
      print("Error downloading: $e");
      if (e is DioError) {
        print("Dio error: ${e.message}");
        print("Dio error type: ${e.type}");
        if (e.type != DioErrorType.cancel) {
          print("Dio error response data: ${e.response?.data}");
        }
      }
    }
    downloading.value = false;
    progressString.value = "100";
    print("Download completed for $path");
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    sorahReaderValue ??= "https://server7.mp3quran.net/basit/";

    surahsPlayList = List.generate(114, (i) {
      sorahNum.value = i + 1;
      return AudioSource.uri(
          Uri.parse('${sorahReaderValue!}$beautifiedSurahNumber.mp3'));
    });

    // downloadSurahsPlayList = List.generate(114, (i) {
    //   sorahNum.value = i + 1;
    //   return AudioSource.uri(
    //       Uri.parse('${sorahReaderValue!}$beautifiedSurahNumber.mp3'));
    // });

    // downloadSurahsPlayList!.forEach((audioSource) {
    //   if (audioSource is ProgressiveAudioSource) {
    //     print('audioSource.uri ${audioSource.uri}');
    //   }
    // });
    print('URL: ${sorahReaderValue!}$beautifiedSurahNumber.mp3');
    try {
      await audioPlayer.setAudioSource(surahsList,
          initialIndex: sorahNum.value - 1, initialPosition: Duration.zero);
      // await downAudioPlayer.setAudioSource(downloadSurahsList,
      //     initialIndex: sorahNum.value - 1, initialPosition: Duration.zero);
    } catch (e) {
      print("Error setting audio source: $e");
    }

    // changeSurahNumber();
    isPlay.value = false;
    // currentPlay = null;
    sliderValue = 0;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    loadLastSurahListen();
    _loadLastSurahAndPosition();
  }

  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> get DownloadPositionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          downAudioPlayer.positionStream,
          downAudioPlayer.bufferedPositionStream,
          downAudioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  // Save & Load Reader Quran
  saveSorahReader(String readerValue, sorahReaderName) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setString('sorah_audio_player_sound', readerValue);
    await prefService.setString('sorah_audio_player_name', sorahReaderName);
  }

  loadSorahReader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sorahReaderValue = prefs.getString('sorah_audio_player_sound') ??
        "https://server7.mp3quran.net/";
    sorahReaderNameValue =
        prefs.getString('sorah_audio_player_name') ?? "basit/";
    print('Quran Reader ${prefs.getString('sorah_audio_player_sound')}');
  }

  // Save & Last Surah Listen
  Future<void> saveLastSurahListen(
      int surahNum, selectedSurah, double position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSurah', surahNum);
    await prefs.setInt('selectedSurah', selectedSurah);
    await prefs.setDouble('lastPosition', position);
  }

  Future loadLastSurahListen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastSurah = prefs.getInt('lastSurah');
    selectedSurah.value = prefs.getInt('selectedSurah') ?? -1;

    // This line converts the saved double back to a Duration
    lastPosition = prefs.getDouble('lastPosition') ?? 0.0;

    return {
      'lastSurah': lastSurah ?? 1,
      'selectedSurah': selectedSurah,
      'lastPosition': lastPosition, // Now this is a Duration object
    };
  }

  Future<void> _loadLastSurahAndPosition() async {
    final lastSurahData = await loadLastSurahListen();
    print('Last Surah Data: $lastSurahData');

    sorahNum.value = lastSurahData['lastSurah'];
    selectedSurah = lastSurahData['selectedSurah'];

    // Here, you're assigning the Duration object from the lastSurahData map to your position.value
    position.value = lastSurahData['lastPosition'];
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  playSorahOnline(BuildContext context) async {
    int result = 1;

    String? sorahNumString;
    if (sorahNum < 10) {
      sorahNumString = "00" + sorahNum.toString();
    } else if (sorahNum < 100) {
      sorahNumString = "0" + sorahNum.toString();
    } else if (sorahNum < 1000) {
      sorahNumString = sorahNum.toString();
    }

    String paddedString =
        sorahNumString!; // copy the padded string to a new variable
    intValue = int.parse(
        paddedString); // temporarily convert the padded string to an integer

    // convert intValue back to a padded string
    paddedString = intValue.toString().padLeft(3, '0');

    String reader = sorahReaderValue!;
    String readerN = sorahReaderNameValue!;
    String fileName = "$readerN$paddedString.mp3";
    print('sorah reader: $reader');
    url = "$reader${fileName}";
    await audioPlayer.setUrl(url);
    await audioPlayer.playerStateStream.listen((playerState) async {
      isPlayOnline.value = false;
      isPlay.value = false;
      if (repeatSurahOnline == true) {
        isPlayOnline.value = true;
        await audioPlayer.play();
      } else {
        sorahNum++;
        intValue++;
        isPlayOnline.value = true;
        await audioPlayer.play();
      }
    });
    print("url $url");
    if (isPlayOnline.value) {
      await audioPlayer.pause();
      isPlayOnline.value = false;
    } else {
      try {
        if (_connectionStatus == ConnectivityResult.none) {
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.noInternet);
        } else if (_connectionStatus == ConnectivityResult.mobile) {
          customMobileNoteSnackBar(
              context, AppLocalizations.of(context)!.mobileDataListen);
          if (result == 1) {
            isPlayOnline.value = true;
          }
          await audioPlayer.play();
        } else if (_connectionStatus == ConnectivityResult.wifi) {
          if (result == 1) {
            isPlayOnline.value = true;
          }
          await audioPlayer.play();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  playSorah(BuildContext context) async {
    String? sorahNumString;

    if (sorahNum < 10) {
      sorahNumString = "00" + sorahNum.toString();
    } else if (sorahNum < 100) {
      sorahNumString = "0" + sorahNum.toString();
    } else if (sorahNum < 1000) {
      sorahNumString = sorahNum.toString();
    }
    // int sorahNumInt = sorahNum;
    String sorahNumWithLeadingZeroes = sorahNumString!;
    String reader = sorahReaderValue!;
    String readerN = sorahReaderNameValue!;
    fileNameDownload = "$readerN$sorahNumWithLeadingZeroes.mp3";
    print('sorah reader: $reader');
    urlDownload = "$reader${fileNameDownload}";
    // audioPlayer.onPlayerComplete.listen((event) async {
    //   setState(() {
    //     isPlay.value = false;
    //   });
    //   if (repeatSurah == true) {
    //     await playFile(context, url, fileNameDownload!);
    //     setState(() {
    //       isPlay.value = true;
    //     });
    //   }
    // });
    print("url $url");
    if (isPlay.value) {
      audioPlayer.pause();
      isPlay.value = false;
    } else {
      await playFile(context, urlDownload!, fileNameDownload!);
    }
  }

  Future playFile(BuildContext context, String url, String fileName) async {
    var path;
    int result = 1;

    if (downloading.value) {
      cancelToken.cancel("User canceled the download");
    } else {
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
            customMobileNoteSnackBar(
                context, AppLocalizations.of(context)!.mobileDataSurahs);
            await downloadFile(path, url, fileName);
          } else if (_connectionStatus == ConnectivityResult.wifi ||
              _connectionStatus == ConnectivityResult.mobile) {
            await downloadFile(path, url, fileName);
          }
        }
        surahsPlayList = List.generate(114, (i) {
          sorahNum.value = i + 1;
          return AudioSource.asset(path);
        });
        await downAudioPlayer.play();

        if (result == 1) {
          isPlay.value = true;
        }
      } catch (e) {
        print(e);
      }
    }
  }

  skip_previous(BuildContext context) async {
    if (isPlayOnline.value == true) {
      await audioPlayer.stop();
      sorahNum--;
      intValue--;
      playSorahOnline(context);
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
      isPlayOnline.value = true;
    } else if (isPlay.value == true) {
      await audioPlayer.stop();
      sorahNum--;
      intValue--;
      playSorah(context);
      await playFile(context, urlDownload!, fileNameDownload!);
      isPlay.value = true;
    }
  }

  skip_next(BuildContext context) async {
    if (isPlayOnline.value == true) {
      await audioPlayer.stop();
      sorahNum++;
      intValue++;
      playSorahOnline(context);
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
      isPlayOnline.value = true;
    } else if (isPlay.value == true) {
      await audioPlayer.stop();
      sorahNum++;
      intValue++;
      playSorah(context);
      await playFile(context, urlDownload!, fileNameDownload!);
      isPlay.value = true;
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    controller.dispose();
    _connectivitySubscription.cancel();
    if (isPlay.value) {
      audioPlayer.pause();
    }
    super.onClose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (isPlay.value) {
        audioPlayer.pause();
        isPlay.value = false;
      }
    }
    //print('state = $state');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
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

  void searchSurah(BuildContext context, String searchInput) {
    // Get the current state of the SorahCubit
    List<Sorah>? sorahList = sorahRepositoryController.sorahs;

    // Check if the list is not null before using it
    if (sorahList != null) {
      int index = sorahList
          .indexWhere((sorah) => sorah.searchText.contains(searchInput));
      if (index != -1) {
        controller.jumpTo(
            index * 65.0); // Assuming 65.0 is the height of each ListTile
        selectedSurah.value = index;
      }
    }
  }
}
