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

import '../../quran_page/data/model/sorah.dart';
import '../../shared/controller/surah_repository_controller.dart';
import '../../shared/widgets/seek_bar.dart';

class SurahAudioController extends GetxController {
  final SorahRepositoryController sorahRepositoryController =
      Get.put(SorahRepositoryController());
  final ScrollController controller = ScrollController();
  ValueNotifier<double> position = ValueNotifier(0);
  ValueNotifier<double> duration = ValueNotifier(99999);
  ArabicNumbers arabicNumber = ArabicNumbers();
  RxDouble currentTime = 0.00.obs;
  double totalDuration = 0.00;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer downAudioPlayer = AudioPlayer();
  RxBool isDownloading = false.obs;
  RxBool downloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  RxInt sorahNum = 1.obs;
  var url;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ConnectivityResult result;
  final _connectivity = Connectivity();
  late CancelToken cancelToken;
  TextEditingController textController = TextEditingController();
  RxInt selectedSurah = 0.obs;
  double lastPosition = 0.0;
  RxString sorahReaderValue = "https://server7.mp3quran.net/".obs;
  RxString sorahReaderNameValue = "basit/".obs;

  bool _isDisposed = false;

  List<AudioSource>? surahsPlayList;
  List<Map<int, AudioSource>> downloadSurahsPlayList = [];

  late final surahsList = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: surahsPlayList!,
  );

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

  String beautifySurahNumber(int surahNum) {
    switch (surahNum) {
      case < 10:
        return "00$surahNum";
      case < 100:
        return "0$surahNum";
      default:
        return "$surahNum";
    }
  }

  AudioSource get getAudioSource {
    return downloadSurahsPlayList
        .firstWhere((e) => e.keys.first == sorahNum.value)
        .values
        .first;
  }

  Future<void> playNextSurah() async {
    print('first print: ${DateTime.now()}');
    if (isDownloading.value == true) {
      // await downAudioPlayer.setAudioSource(getAudioSource);
      await downloadSurah();
    } else {
      await audioPlayer.setAudioSource(surahsPlayList![sorahNum.value - 1]);
      audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed) {
          if (sorahNum.value - 1 == 114) {
            await audioPlayer.stop();
          } else {
            sorahNum.value += 1;
            await audioPlayer
                .setAudioSource(surahsPlayList![sorahNum.value - 1]);
          }
        }
      });
    }
  }

  Future<void> downloadSurah() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    String filePath =
        '${directory.path}/${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3';

    File file = File(filePath);
    print("File Path: $filePath");
    isDownloading.value = true;
    if (await file.exists()) {
      // if (downloadSurahsPlayList
      //         .firstWhereOrNull((e) => e.keys.contains(filePath)) !=
      //     null) {
      print("File exists. Playing...");

      await downAudioPlayer.setAudioSource(AudioSource.asset(filePath));
      downAudioPlayer.play();
    } else {
      print("File doesn't exist. Downloading...");
      print("sorahReaderNameValue: ${sorahReaderNameValue.value}");
      String fileUrl =
          "${sorahReaderValue.value}${sorahReaderNameValue.value}${beautifiedSurahNumber}.mp3";
      print("Downloading from URL: $fileUrl");
      // await downloadFile(filePath, fileUrl, beautifiedSurahNumber);
      if (await downloadFile(filePath, fileUrl)) {
        String filePath =
            '${directory.path}/${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3';
        _addFileAudioSourceToPlayList(filePath);
        print("File successfully downloaded and saved to $filePath");
        await downAudioPlayer
            .setAudioSource(AudioSource.asset(filePath))
            .then((_) => downAudioPlayer.play());
      }
    }
  }

  Future<bool> downloadFile(String path, String url) async {
    Dio dio = Dio();
    print('11111111111');
    try {
      print('22222222222222');
      await Directory(dirname(path)).create(recursive: true);
      isDownloading.value = true;
      progressString.value = "0";
      progress.value = 0;

      cancelToken = CancelToken();

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        progressString.value = ((rec / total) * 100).toStringAsFixed(0);
        progress.value = (rec / total).toDouble();
        print(progressString.value);
      }, cancelToken: cancelToken);

      progressString.value = "100";
      print("Download completed for $path");
      return true;
    } catch (e) {
      print("Error isDownloading: $e");
      if (e is DioError) {
        print("Dio error: ${e.message}");
        print("Dio error type: ${e.type}");
        if (e.type != DioErrorType.cancel) {
          print("Dio error response data: ${e.response?.data}");
        }
      }
    }
    return false;
  }

  Future<void> _addDownloadedSurahToPlaylist() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    for (int i = 1; i <= 114; i++) {
      String filePath =
          '${directory.path}/${sorahReaderNameValue.value}${beautifySurahNumber(i)}.mp3';

      File file = File(filePath);

      if (await file.exists()) {
        // print("File Path: $file");
        downloadSurahsPlayList.add({i: AudioSource.file(filePath)});
      } else {
        // print("iiiiiiiiii $i");
      }
    }
  }

  void _addFileAudioSourceToPlayList(String filePath) {
    downloadSurahsPlayList.add({sorahNum.value: AudioSource.file(filePath)});
  }

  changeAudioSource() async {
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        '${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3')));
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _addDownloadedSurahToPlaylist();
    surahsPlayList = List.generate(114, (i) {
      sorahNum.value = i + 1;
      return AudioSource.uri(Uri.parse(
          '${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3'));
    });
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
    sorahReaderValue.value = prefs.getString('sorah_audio_player_sound') ??
        "https://server7.mp3quran.net/";
    sorahReaderNameValue.value =
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

  @override
  void onClose() {
    audioPlayer.dispose();
    controller.dispose();
    _connectivitySubscription.cancel();
    audioPlayer.pause();
    super.onClose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.pause();
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
