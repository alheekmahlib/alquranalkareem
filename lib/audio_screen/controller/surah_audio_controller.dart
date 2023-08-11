import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/sorahRepository/sorah_repository_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/sorah.dart';
import '../../shared/model/position_data.dart';
import '../../shared/widgets/widgets.dart';

class SurahAudioController extends GetxController {
  final ScrollController controller = ScrollController();
  ValueNotifier<double> position = ValueNotifier(0);
  ValueNotifier<double> duration = ValueNotifier(99999);
  ArabicNumbers arabicNumber = ArabicNumbers();
  String currentTime = '0:00';
  String totalDuration = '0:00';
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlayOnline = false.obs;
  RxBool isPlay = false.obs;
  // StreamSubscription? durationSubscription;
  // StreamSubscription? positionSubscription;
  RxBool downloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  String? currentPlay;
  bool autoPlay = false;
  double? sliderValue;
  RxInt sorahNum = 1.obs;
  final surahNumber =
      List<int>.generate(113, (int index) => index * index, growable: true);
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

  @override
  void onInit() {
    super.onInit();
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
    lastPosition = prefs.getDouble('lastPosition') ?? 0.0;

    return {
      'lastSurah': lastSurah ?? 1,
      'selectedSurah': selectedSurah,
      'lastPosition': lastPosition,
    };
  }

  Future<void> _loadLastSurahAndPosition() async {
    final lastSurahData = await loadLastSurahListen();
    // Print the data to see if it contains the correct last position value
    print('Last Surah Data: $lastSurahData');

    sorahNum = lastSurahData['lastSurah'];
    selectedSurah = lastSurahData['selectedSurah'];
    position.value = lastSurahData['lastPosition'];

    // print('_position.value after assignment: ${_position.value}'); // Add this line

    // await playSorahOnline(this.context); // Play the Surah after loading.value the last position
    // await Future.delayed(Duration(milliseconds: 500));
    // await audioPlayer.seek(Duration(seconds: lastPosition!.toInt())); // Seek to the last position
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
        await audioPlayer.setAudioSource(AudioSource.asset(path));

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

      // Initialize the cancel token
      cancelToken = CancelToken();

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        // print("Rec: $rec , Total: $total");
        progressString.value = ((rec / total) * 100).toStringAsFixed(0);
        progress.value = (rec / total).toDouble();
        print(progressString.value);
      }, cancelToken: cancelToken);
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        print('Download canceled');
        // Delete the partially downloaded file
        try {
          final file = File(path);
          await file.delete();
          print('Partially downloaded file deleted');
        } catch (e) {
          print('Error deleting partially downloaded file: $e');
        }
      } else {
        print(e);
      }
    }
    downloading.value = false;
    progressString.value = "100";
    print("Download completed");
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
    List<Sorah>? sorahList = context.read<SorahRepositoryCubit>().state;

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
