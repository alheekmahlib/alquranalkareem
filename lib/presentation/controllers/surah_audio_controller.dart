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

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_pref_services.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/widgets/seek_bar.dart';
import '../screens/quran_page/data/model/surah.dart';
import 'surah_repository_controller.dart';

class SurahAudioController extends GetxController {
  final ScrollController controller = ScrollController();
  RxInt position = RxInt(0);
  ArabicNumbers arabicNumber = ArabicNumbers();

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer downAudioPlayer = AudioPlayer();
  RxBool isDownloading = false.obs;
  RxBool onDownloading = false.obs;
  RxBool isPlaying = false.obs;
  RxBool downloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  RxInt surahNum = 1.obs;
  var url;
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ConnectivityResult result;
  final _connectivity = Connectivity();
  late var cancelToken = CancelToken();
  TextEditingController textController = TextEditingController();
  RxInt selectedSurah = 0.obs;
  // RxDouble lastPosition = 0.0.obs;
  RxString sorahReaderValue = "https://server7.mp3quran.net/".obs;
  RxString sorahReaderNameValue = "basit/".obs;
  final bool _isDisposed = false;
  List<AudioSource>? surahsPlayList;
  List<Map<int, AudioSource>> downloadSurahsPlayList = [];
  double? lastTime;
  RxInt lastPosition = 0.obs;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');

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
    switch (surahNum.value) {
      case < 10:
        return "00${surahNum.value}";
      case < 100:
        return "0${surahNum.value}";
      default:
        return "${surahNum.value}";
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
        .firstWhere((e) => e.keys.first == surahNum.value)
        .values
        .first;
  }

  Future<void> playNextSurah() async {
    print('first print: ${DateTime.now()}');
    if (isDownloading.value == true) {
      // await downAudioPlayer.setAudioSource(getAudioSource);
      await downloadSurah();
    } else {
      await audioPlayer.setAudioSource(surahsPlayList![surahNum.value - 1]);
      audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed) {
          if (surahNum.value - 1 == 114) {
            await audioPlayer.stop();
          } else {
            surahNum.value += 1;
            await audioPlayer
                .setAudioSource(surahsPlayList![surahNum.value - 1]);
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

      await downAudioPlayer.setAudioSource(AudioSource.file(filePath));
      downAudioPlayer.play();
    } else {
      print("File doesn't exist. Downloading...");
      print("sorahReaderNameValue: ${sorahReaderNameValue.value}");
      String fileUrl =
          "${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3";
      print("Downloading from URL: $fileUrl");
      // await downloadFile(filePath, fileUrl, beautifiedSurahNumber);
      if (await downloadFile(filePath, fileUrl)) {
        String filePath =
            '${directory.path}/${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3';
        _addFileAudioSourceToPlayList(filePath);
        print("File successfully downloaded and saved to $filePath");
        await downAudioPlayer
            .setAudioSource(AudioSource.file(filePath))
            .then((_) => downAudioPlayer.play());
      }
    }
  }

  Future<bool> downloadFile(String path, String url) async {
    Dio dio = Dio();
    print('11111111111');
    cancelToken = CancelToken();
    try {
      try {
        print('22222222222222');
        await Directory(dirname(path)).create(recursive: true);
        isDownloading.value = true;
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
      onDownloading.value = false;
      progressString.value = "100";
      print("Download completed for $path");
      return true;
    } catch (e) {
      print("Error isDownloading: $e");
    }
    return false;
  }

  void cancelDownload() {
    cancelToken.cancel('Request cancelled');
  }

  Future<void> startDownload() async {
    await audioPlayer.pause();
    await downloadSurah();
  }

  // Future downloadFile(String path, String url, String fileName) async {
  //   Dio dio = Dio();
  //   try {
  //     try {
  //       await Directory(dirname(path)).create(recursive: true);
  //     } catch (e) {
  //       print(e);
  //     }
  //     setState(() {
  //       downloading = true;
  //       progressString = "0";
  //       progress = 0;
  //     });
  //
  //     // Initialize the cancel token
  //
  //     cancelToken = CancelToken();
  //
  //     await dio.download(url, path, onReceiveProgress: (rec, total) {
  //       // print("Rec: $rec , Total: $total");
  //       setState(() {
  //         progressString = ((rec / total) * 100).toStringAsFixed(0);
  //         progress = (rec / total).toDouble();
  //       });
  //       print(progressString);
  //     }, cancelToken: cancelToken);
  //   } catch (e) {
  //     if (e is DioError && e.type == DioErrorType.cancel) {
  //       print('Download canceled');
  //       // Delete the partially downloaded file
  //       try {
  //         final file = File(path);
  //         await file.delete();
  //         print('Partially downloaded file deleted');
  //       } catch (e) {
  //         print('Error deleting partially downloaded file: $e');
  //       }
  //     } else {
  //       print(e);
  //     }
  //   }
  //   setState(() {
  //     downloading = false;
  //     progressString = "100";
  //   });
  //   print("Download completed");
  // }

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
    downloadSurahsPlayList.add({surahNum.value: AudioSource.file(filePath)});
  }

  changeAudioSource() async {
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        '${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3')));
    print(
        'URL: ${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3');
  }

  lastAudioSource() async {
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        '${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3')));
    await audioPlayer.seek(Duration(seconds: lastPosition.value));
    print(
        'URL: ${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3');
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _addDownloadedSurahToPlaylist();
    surahsPlayList = List.generate(114, (i) {
      surahNum.value = i + 1;
      return AudioSource.uri(
        Uri.parse(
            '${sorahReaderValue.value}${sorahReaderNameValue.value}$beautifiedSurahNumber.mp3'),
        // tag: MediaItem(
        //   id: '${i + 1}',
        //   album: "القرآن الكريم - مكتبة الحكمة",
        //   title: "${surahNameList[i]}",
        //   artUri: Uri.parse(
        //       "https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/Photos/app_icon.png"),
        // ),
      );
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    loadLastSurahListen();
    _loadLastSurahAndPosition();
    loadSorahReader();
    loadLastSurahListen();
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

  loadSorahReader() async {
    sorahReaderValue.value = await sl<SharedPrefServices>().getString(
        SURAH_AUDIO_PLAYER_SOUND,
        defaultValue: "https://server7.mp3quran.net/");
    sorahReaderNameValue.value = await sl<SharedPrefServices>()
        .getString(SURAH_AUDIO_PLAYER_NAME, defaultValue: "basit/");
  }

  Future loadLastSurahListen() async {
    int? lastSurah =
        await sl<SharedPrefServices>().getInteger(LAST_SURAH, defaultValue: 1);
    selectedSurah.value = await sl<SharedPrefServices>()
        .getInteger(SELECTED_SURAH, defaultValue: -1);

    // This line converts the saved double back to a Duration
    lastPosition.value = await sl<SharedPrefServices>()
        .getInteger(LAST_POSITION, defaultValue: 0);

    return {
      LAST_SURAH: lastSurah,
      SELECTED_SURAH: selectedSurah,
      LAST_POSITION: lastPosition.value, // Now this is a Duration object
    };
  }

  Future<void> _loadLastSurahAndPosition() async {
    final lastSurahData = await loadLastSurahListen();
    print('Last Surah Data: $lastSurahData');

    surahNum.value = lastSurahData[LAST_SURAH];
    selectedSurah = lastSurahData[SELECTED_SURAH];

    // Here, you're assigning the Duration object from the lastSurahData map to your position.value
    position.value = lastSurahData[LAST_POSITION];
  }

  Stream<PositionData> get audioStream => isDownloading.value == true
      ? DownloadPositionDataStream
      : positionDataStream;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void updateControllerValues(PositionData positionData) {
    audioStream.listen((p) {
      lastPosition.value = p.position.inSeconds;
    });
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
    connectionStatus = result;
  }

  void searchSurah(BuildContext context, String searchInput) {
    // Get the current state of the SorahCubit
    List<Surah>? sorahList = sl<SurahRepositoryController>().sorahs;

    // Check if the list is not null before using it
    int index =
        sorahList.indexWhere((sorah) => sorah.searchText.contains(searchInput));
    if (index != -1) {
      controller
          .jumpTo(index * 65.0); // Assuming 65.0 is the height of each ListTile
      selectedSurah.value = index;
    }
  }
}
