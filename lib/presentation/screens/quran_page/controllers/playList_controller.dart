import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:shared_preferences/shared_preferences.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '../../../../core/utils/constants/url_constants.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../controllers/general_controller.dart';
import '../widgets/playlist/data/models/playList_model.dart';
import 'audio/audio_controller.dart';
import 'quran/quran_controller.dart';

class PlayListController extends GetxController {
  static PlayListController get instance =>
      Get.isRegistered<PlayListController>()
          ? Get.find<PlayListController>()
          : Get.put<PlayListController>(PlayListController());
  final AudioPlayer playlistAudioPlayer = AudioPlayer();
  final RxList<AudioSource> ayahsPlayList = <AudioSource>[].obs;
  RxList<PlayListModel> playLists = RxList<PlayListModel>();
  final ScrollController scrollController = ScrollController();
  RxInt ayahPlayListNumber = 1.obs;
  RxInt startNum = 1.obs;
  RxInt endNum = 1.obs;
  RxInt startUQNum = 1.obs;
  RxInt endUQNum = 1.obs;
  RxInt surahNum = 1.obs;
  double ayahItemHeight = 80.0;
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  late var cancelToken = CancelToken();
  RxBool isSelect = false.obs;
  final box = GetStorage();

  // Assuming these are your dependency injection methods to get controllers
  final audioCtrl = AudioController.instance;
  final GlobalKey<ExpansionTileCardState> saveCard = GlobalKey();
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          playlistAudioPlayer.positionStream,
          playlistAudioPlayer.bufferedPositionStream,
          playlistAudioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  // This method now takes a local file path instead of generating a URL
  AudioSource createAudioSource(String filePath) {
    // Ensure that you return an AudioSource and not a Future
    return AudioSource.uri(Uri.file(filePath));
  }

  Future<String> getLocalPath() async {
    final directory =
        await getApplicationDocumentsDirectory(); // For iOS and Android
    // Use getExternalStorageDirectory() for Android to save files in external storage.
    return directory.path;
  }

  Future<void> loadPlaylist() async {
    if (firstAyahUQ! <= lastAyahUQ!) {
      List<AudioSource> generatedList = [];

      for (int i = firstAyahUQ!; i <= lastAyahUQ!; i++) {
        String fileName = "$i.mp3";
        String localFilePath =
            await getLocalPath() + "${audioCtrl.state.readerValue!}/$fileName";

        bool downloadResult = await downloadFile(
            generateUrl(i, audioCtrl.state.readerValue!), fileName);
        log('downloadResult: $downloadResult');
        if (downloadResult) {
          AudioSource source = createAudioSource(localFilePath);
          generatedList.add(source);
        } else {
          print("Error downloading file: $fileName");
        }
      }

      ayahsPlayList.assignAll(generatedList);

      await playlistAudioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: ayahsPlayList));
    } else {
      print("Error: startNum is greater than endNum.");
    }
  }

  String generateUrl(int ayahNumber, String readerName) {
    log("generateUrl: ${UrlConstants.ayahs1stSource}$readerName/$ayahNumber.mp3");
    return "${UrlConstants.ayahs1stSource}$readerName/$ayahNumber.mp3";
  }

  Future<bool> choiceFromPlayList(
      int startNumber,
      int endNumber,
      int startUQNumber,
      int endUQNumber,
      int surahNumber,
      String readerName) async {
    startNum.value = startNumber;
    endNum.value = endNumber;
    startUQNum.value = startUQNumber;
    endUQNum.value = endUQNumber;
    surahNum.value = surahNumber;
    List<AudioSource> playlistSources = [];

    String localDirectoryPath = await getLocalPath();
    for (int i = startUQNumber; i <= endUQNumber; i++) {
      String fileName = "$i.mp3";
      String localFilePath =
          "$localDirectoryPath/${audioCtrl.state.readerValue!}/$fileName";
      bool downloadResult = await downloadFile(
          generateUrl(i, audioCtrl.state.readerValue!), fileName);

      if (downloadResult) {
        AudioSource source = createAudioSource(localFilePath);
        playlistSources.add(source);
      } else {
        return false;
      }
    }

    ayahsPlayList.assignAll(playlistSources);
    await playlistAudioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: playlistSources));

    return true;
  }

  Future<bool> downloadFile(String url, String fileName) async {
    String localFilePath =
        await getLocalPath() + "${audioCtrl.state.readerValue!}/$fileName";
    final file = File(localFilePath);

    // Check if the file already exists and return true immediately if it does
    if (await file.exists()) {
      print('File already downloaded: $localFilePath');
      return true;
    }

    Dio dio = Dio();
    cancelToken = CancelToken();
    try {
      await Directory(dirname(localFilePath)).create(recursive: true);
      downloading.value = true;
      onDownloading.value = true;
      progressString.value = "0";
      progress.value = 0;
      await dio.download(url, localFilePath, onReceiveProgress: (rec, total) {
        progressString.value = ((rec / total) * 100).toStringAsFixed(0);
        progress.value = (rec / total).toDouble();
        print(progressString.value);
      }, cancelToken: cancelToken);
      downloading.value = false;
      onDownloading.value = false;
      progressString.value = "100";
      print("Download completed");
      return true;
    } catch (e) {
      downloading.value = false;
      onDownloading.value = false;
      progressString.value = "0";
      print('Error during download: $e');
      return false;
    }
  }

  void saveList() {
    loadPlaylist();
    PlayListStorage.savePlayList(playLists);
    addPlayList();
  }

  int? get firstAyah => startNum.value == 1
      ? quranCtrl
          .getPageAyahsByIndex(quranCtrl.state.currentPageNumber.value - 1)
          .first
          .ayahNumber
      : startNum.value;

  int? get lastAyah => endNum.value == 1
      ? quranCtrl
          .getPageAyahsByIndex(quranCtrl.state.currentPageNumber.value - 1)
          .last
          .ayahNumber
      : endNum.value;

  int? get firstAyahUQ => startUQNum.value == 1
      ? quranCtrl
          .getPageAyahsByIndex(quranCtrl.state.currentPageNumber.value - 1)
          .first
          .ayahUQNumber
      : startUQNum.value;

  int? get lastAyahUQ => endUQNum.value == 1
      ? quranCtrl
          .getPageAyahsByIndex(quranCtrl.state.currentPageNumber.value - 1)
          .last
          .ayahUQNumber
      : endUQNum.value;

  void reset() {
    startNum.value = 1;
    endNum.value = 1;
  }

  @override
  void onClose() {
    playlistAudioPlayer.dispose();
    super.onClose();
  }

  void loadSavedPlayList() async {
    List<PlayListModel> loadedPlayList = await PlayListStorage.loadPlayList();
    playLists.value = RxList<PlayListModel>(loadedPlayList);
  }

  Future<void> addPlayList() async {
    playLists.add(PlayListModel(
        id: playLists.length,
        startNum: firstAyah!,
        endNum: lastAyah!,
        startUQNum: firstAyahUQ!,
        endUQNum: lastAyahUQ!,
        surahNum: quranCtrl.getSurahNumberFromPage(
            quranCtrl.state.currentPageNumber.value - 1),
        surahName: quranCtrl
            .getCurrentSurahByPage(quranCtrl.state.currentPageNumber.value - 1)
            .arabicName,
        readerName: audioCtrl.state.readerValue!,
        name: quranCtrl
            .getCurrentSurahByPage(quranCtrl.state.currentPageNumber.value - 1)
            .arabicName));
    PlayListStorage.savePlayList(playLists);
    print('playLists: ${playLists.length.toString()}');
  }

  deletePlayList(BuildContext context, int index) async {
    // Delete the reminder
    await PlayListStorage.deletePlayList(index)
        .then((value) => context.showCustomErrorSnackBar('deletedPlayList'.tr));

    // Update the playList list
    playLists.removeAt(index);

    // Update the reminder IDs
    for (int i = index; i < playLists.length; i++) {
      playLists[i].id = i;
    }

    // Save the updated playList list
    PlayListStorage.savePlayList(playLists);
  }

  scrollToAyah(int ayahNumber) {
    if (scrollController.hasClients) {
      double position = (ayahNumber - 1) * ayahItemHeight;
      scrollController.jumpTo(position);
    } else {
      print("Controller not attached to any scroll views.");
    }
  }

  ayahPosition(bool startNum) {
    if (startNum) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToAyah(firstAyah!);
      });
    }
    if (!startNum) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToAyah(lastAyah!);
      });
    }
  }
}

class PlayListStorage {
  static const String _storageKey = 'playList';

  static Future<void> savePlayList(List<PlayListModel> playLists) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> playListJson =
        playLists.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_storageKey, playListJson);
  }

  static Future<List<PlayListModel>> loadPlayList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> playListsJson =
        prefs.getStringList(_storageKey)?.cast<String>() ?? [];
    List<PlayListModel> playLists = playListsJson
        .map((r) => PlayListModel.fromJson(jsonDecode(r)))
        .toList();
    return playLists;
  }

  static Future<void> deletePlayList(int id) async {
    List<PlayListModel> playLists = await loadPlayList();
    playLists.removeWhere((r) => r.id == id);
    await savePlayList(playLists);
  }
}
