import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/constants/url_constants.dart';
import '../../core/widgets/seek_bar.dart';
import '/presentation/controllers/aya_controller.dart';
import 'general_controller.dart';
import 'quran_controller.dart';

class SurahAudioController extends GetxController {
  final ScrollController controller = ScrollController();
  RxInt position = RxInt(0);
  ArabicNumbers arabicNumber = ArabicNumbers();

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer downAudioPlayer = AudioPlayer();
  // RxBool isDownloading = false.obs;
  RxBool onDownloading = false.obs;
  RxBool isPlaying = false.obs;
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
  RxString sorahReaderValue = "https://download.quranicaudio.com/quran/".obs;
  RxString sorahReaderNameValue = "abdul_basit_murattal/".obs;
  final bool _isDisposed = false;
  List<AudioSource>? surahsPlayList;
  List<Map<int, AudioSource>> downloadSurahsPlayList = [];
  double? lastTime;
  RxInt lastPosition = 0.obs;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');
  final BoxController boxController = BoxController();
  final TextEditingController textEditingController = TextEditingController();
  RxInt surahReaderIndex = 1.obs;
  final Rx<Map<int, bool>> surahDownloadStatus = Rx<Map<int, bool>>({});
  RxInt seekNextSeconds = 5.obs;

  late final surahsList = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: surahsPlayList!,
  );

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

  Future<String> get localFilePath async {
    Directory? directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${sorahReaderNameValue.value}${surahNum.value.toString().padLeft(3, "0")}.mp3';
  }

  String get urlFilePath {
    return '${sorahReaderValue.value}${sorahReaderNameValue.value}${surahNum.value.toString().padLeft(3, "0") ?? 001}.mp3';
  }

  Future<void> playPreviousSurah() async {
    if (surahDownloadStatus.value[surahNum.value] == false) {
      isPlaying.value = false;
      await audioPlayer.stop();
    } else {
      if (surahNum.value - 1 == 1) {
        await audioPlayer.stop();
      } else {
        await audioPlayer
            .setAudioSource(AudioSource.file(
              await localFilePath,
              tag: await mediaItem,
            ))
            .then((_) => audioPlayer.play());
      }
    }
  }

  // "https://everyayah.com/data/MaherAlMuaiqly128kbps/${_quranController.getSurahNumberByAya(_quranController.allAyas[ayaUniqeId.value - 1]).toString().padLeft(3, "0")}${_quranController.allAyas[ayaUniqeId.value - 1].numberOfAyaInSurah.toString().padLeft(3, "0")}.mp3",

  Future<void> playNextSurah() async {
    if (surahDownloadStatus.value[surahNum.value] == false) {
      isPlaying.value = false;
      await audioPlayer.stop();
    } else {
      if ((surahNum.value - 1) == 114) {
        isPlaying.value = false;
        audioPlayer.stop();
      } else {
        isPlaying.value = true;
        await audioPlayer
            .setAudioSource(AudioSource.file(
              await localFilePath,
              tag: await mediaItem,
            ))
            .then((_) => audioPlayer.play());
      }
    }
  }

  Future<void> downloadSurah() async {
    File file = File(await localFilePath);
    print("File Path: $localFilePath");
    isPlaying.value = true;
    if (await file.exists()) {
      print("File exists. Playing...");

      await audioPlayer.setAudioSource(AudioSource.file(
        await localFilePath,
        tag: await mediaItem,
      ));
      audioPlayer.play();
    } else {
      print("File doesn't exist. Downloading...");
      print("sorahReaderNameValue: ${sorahReaderNameValue.value}");
      print("Downloading from URL: $urlFilePath");
      if (await downloadFile(await localFilePath, urlFilePath)) {
        _addFileAudioSourceToPlayList(await localFilePath);
        onDownloadSuccess(int.parse(surahNum.value.toString().padLeft(3, "0")));
        print("File successfully downloaded and saved to ${localFilePath}");
        await audioPlayer
            .setAudioSource(AudioSource.file(
              await localFilePath,
              tag: await mediaItem,
            ))
            .then((_) => audioPlayer.play());
      }
    }
    audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        await playNextSurah();
      }
    });
  }

  Future<bool> downloadFile(String path, String url) async {
    Dio dio = Dio();
    print('11111111111');
    cancelToken = CancelToken();
    try {
      try {
        print('22222222222222');
        await Directory(dirname(path)).create(recursive: true);
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

  void initializeSurahDownloadStatus() async {
    // Directly obtain the initial download status for each Surah
    Map<int, bool> initialStatus = await checkAllSurahsDownloaded();

    // Assign it to the Rx variable to ensure it's observable
    surahDownloadStatus.value = initialStatus;
  }

  void updateDownloadStatus(int surahNumber, bool downloaded) {
    final newStatus = Map<int, bool>.from(surahDownloadStatus.value);
    newStatus[surahNumber] = downloaded;
    surahDownloadStatus.value = newStatus;
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
          '${directory.path}/${sorahReaderNameValue.value}${i.toString().padLeft(3, '0')}.mp3';
      File file = File(filePath);
      surahDownloadStatus[i] = await file.exists();
    }
    return surahDownloadStatus;
  }

  void cancelDownload() {
    isPlaying.value = false;
    cancelToken.cancel('Request cancelled');
  }

  Future<void> startDownload() async {
    await audioPlayer.pause();
    await downloadSurah();
  }

  Future<void> _addDownloadedSurahToPlaylist() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    for (int i = 1; i <= 114; i++) {
      String filePath =
          '${directory.path}/${sorahReaderNameValue.value}${beautifySurahNumber(i)}.mp3';

      File file = File(filePath);

      if (await file.exists()) {
        // print("File Path: $file");
        downloadSurahsPlayList.add({
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
    downloadSurahsPlayList.add({
      surahNum.value: AudioSource.file(
        filePath,
        tag: await mediaItem,
      )
    });
  }

  changeAudioSource() async {
    surahDownloadStatus.value[surahNum.value] ?? false
        ? await audioPlayer.setAudioSource(AudioSource.file(
            await localFilePath,
            tag: await mediaItem,
          ))
        : await audioPlayer.setAudioSource(AudioSource.uri(
            Uri.parse(urlFilePath),
            tag: await mediaItem,
          ));
    print('URL: $urlFilePath');
  }

  lastAudioSource() async {
    await audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(urlFilePath),
      tag: await mediaItem,
    ));
    await audioPlayer.seek(Duration(seconds: lastPosition.value));
    print('URL: $urlFilePath');
  }

  Future<MediaItem> get mediaItem async => MediaItem(
        id: '${surahNum.value - 1}',
        title:
            '${sl<QuranController>().surahs[(surahNum.value - 1) ?? 1].arabicName ?? ''}',
        artist: '${surahReaderInfo[surahReaderIndex.value]['name']}'.tr,
        artUri: await sl<GeneralController>().getCachedArtUri(
            'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/Photos/ios-1024.png'),
      );

  @override
  Future<void> onInit() async {
    super.onInit();
    initializeSurahDownloadStatus();
    _addDownloadedSurahToPlaylist();
    loadLastSurahListen();
    _loadLastSurahAndPosition();
    loadSurahReader();
    loadLastSurahListen();
    surahsPlayList = List.generate(114, (i) {
      surahNum.value = i + 1;
      return AudioSource.uri(
        Uri.parse(urlFilePath),
      );
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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

  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> get DownloadPositionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  loadSurahReader() async {
    sorahReaderValue.value =
        await sl<SharedPreferences>().getString(SURAH_AUDIO_PLAYER_SOUND) ??
            UrlConstants.surahUrl;
    sorahReaderNameValue.value =
        await sl<SharedPreferences>().getString(SURAH_AUDIO_PLAYER_NAME) ??
            'abdul_basit_murattal/';
    surahReaderIndex.value =
        sl<SharedPreferences>().getInt(SURAH_READER_INDEX) ?? 0;
  }

  Future loadLastSurahListen() async {
    int? lastSurah = await sl<SharedPreferences>().getInt(LAST_SURAH) ?? 1;
    selectedSurah.value =
        await sl<SharedPreferences>().getInt(SELECTED_SURAH) ?? -1;

    lastPosition.value =
        await sl<SharedPreferences>().getInt(LAST_POSITION) ?? 0;

    return {
      LAST_SURAH: lastSurah,
      SELECTED_SURAH: selectedSurah,
      LAST_POSITION: lastPosition.value,
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

  Stream<PositionData> get audioStream => positionDataStream;

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
    boxController.dispose();
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
    late ConnectivityResult result;
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

  void searchSurah(String searchInput) {
    final surahList = sl<QuranController>().surahs;

    int index = surahList.indexWhere((surah) => sl<AyaController>()
        .removeDiacritics(surah.arabicName)
        .contains(searchInput));
    developer.log('surahNumber: $index');
    if (index != -1) {
      controller.jumpTo(index * 80.0);
      selectedSurah.value = index;
    }
  }
}
