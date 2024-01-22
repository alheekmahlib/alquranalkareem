import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/models/playList_model.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/helpers/functions.dart';
import '../../core/widgets/seek_bar.dart';
import '../../core/widgets/widgets.dart';
import 'audio_controller.dart';
import 'ayat_controller.dart';
import 'surahTextController.dart';

class PlayListController extends GetxController {
  final AudioPlayer playlistAudioPlayer = AudioPlayer();
  final RxList<AudioSource> ayahsPlayList = <AudioSource>[].obs;
  RxList<PlayListModel> playLists = RxList<PlayListModel>();
  TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ayatList = sl<AyatController>();
  RxInt ayahPlayListNumber = 1.obs;
  RxInt startNum = 1.obs;
  RxInt endNum = 1.obs;
  RxInt surahNum = 1.obs;
  double ayahItemHeight = 80.0;
  RxString playListReader = 'Abdul_Basit_Murattal_192kbps'.obs;
  RxBool downloading = false.obs;
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  late var cancelToken = CancelToken();

  // Assuming these are your dependency injection methods to get controllers
  final SurahTextController surahTextController = sl<SurahTextController>();
  final AudioController audioController = sl<AudioController>();
  final AyatController ayatController = sl<AyatController>();
  final GlobalKey<ExpansionTileCardState> saveCard = GlobalKey();

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

// This method now ensures files are downloaded before creating audio sources
  Future<void> loadPlaylist() async {
    if (startNum.value <= endNum.value) {
      List<AudioSource> generatedList = [];

      // This loop should await the download of each verse
      for (int i = startNum.value; i <= endNum.value; i++) {
        String fileName =
            "${formatNumber(surahNum.value)}${formatNumber(i)}.mp3";
        String localFilePath =
            await getLocalPath() + "/$fileName"; // Correctly constructed path

        // Await the download and check the result
        bool downloadResult = await downloadFile(
            generateUrl(i, surahNum.value, playListReader.value), fileName);
        if (downloadResult) {
          // If the download was successful, create the audio source
          AudioSource source = createAudioSource(localFilePath);
          generatedList.add(source);
        } else {
          // Handle the error appropriately
          print("Error downloading file: $fileName");
        }
      }

      // Once all files are downloaded, assign them to the playlist
      ayahsPlayList.assignAll(generatedList);

      // This setAudioSource call should also be awaited
      await playlistAudioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: ayahsPlayList));
    } else {
      // Handle the error case where startNum is greater than endNum
      print("Error: startNum is greater than endNum.");
    }
  }

// Helper method to generate the URL for downloading
  String generateUrl(int ayahNumber, int surahNumber, String readerName) {
    return "https://www.everyayah.com/data/$readerName/${formatNumber(surahNumber)}${formatNumber(ayahNumber)}.mp3";
  }

  Future<bool> choiceFromPlayList(int startNumber, int endNumber,
      int surahNumber, String readerName) async {
    startNum.value = startNumber;
    endNum.value = endNumber;
    surahNum.value = surahNumber;
    playListReader.value = readerName;
    List<AudioSource> playlistSources = [];

    // Get the local directory path
    String localDirectoryPath = await getLocalPath();

    for (int i = startNumber; i <= endNumber; i++) {
      String fileName = "${formatNumber(surahNumber)}${formatNumber(i)}.mp3";

      // Use the correct local directory path to construct the full file path
      String localFilePath =
          "$localDirectoryPath/$fileName"; // This is correct now

      // Download the file using the correct URL and the filename only, path handling is inside downloadFile
      bool downloadResult =
          await downloadFile(generateUrl(i, surahNumber, readerName), fileName);

      if (downloadResult) {
        // If the download was successful, create the audio source with the local file path
        AudioSource source = createAudioSource(localFilePath);
        playlistSources.add(source);
      } else {
        // Handle the error case here
        return false;
      }
    }

    // Load the local files into the playlist
    ayahsPlayList.assignAll(playlistSources);
    await playlistAudioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: playlistSources));

    return true;
  }

  Future<bool> downloadFile(String url, String fileName) async {
    final path = await getLocalPath();
    final localFilePath = '$path/$fileName';
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

  // void loadPlaylist() {
  //   if (startNum.value <= endNum.value) {
  //     List<AudioSource> generatedList = List.generate(
  //       endNum.value - startNum.value + 1,
  //           (index) => createAudioSource(
  //           index + startNum.value, surahNum.value, playListReader.value),
  //     );
  //     ayahsPlayList.assignAll(generatedList);
  //     playlistAudioPlayer.setAudioSource(
  //       ConcatenatingAudioSource(children: ayahsPlayList),
  //     );
  //   } else {}
  // }
  //
  // AudioSource createAudioSource(int startNum, int surahNum, String readerName) {
  //   String audioUrl =
  //       "https://www.everyayah.com/data/$readerName/${formatNumber(surahNum)}${formatNumber(startNum)}.mp3";
  //   print('listURL: $audioUrl');
  //   return AudioSource.uri(Uri.parse(audioUrl));
  // }
  //
  // void choiceFromPlayList(
  //     int startNumber, int endNumber, int surahNumber, String readerName) {
  //   startNum.value = startNumber;
  //   endNum.value = endNumber;
  //   surahNum.value = surahNumber;
  //   surahNum.value = surahNumber;
  //   playListReader.value = readerName;
  //   createAudioSource(startNumber, surahNumber, readerName);
  //   loadPlaylist();
  // }

  void saveList() {
    // if (controller.text.isNotEmpty) {
    loadPlaylist();
    PlayListStorage.savePlayList(playLists);
    addPlayList(controller.text);
    controller.clear();
    // } else {
    //   customErrorSnackBar(context, AppLocalizations.of(context)!.fillAllFields);
    // }
  }

  int? get firstAyah =>
      startNum.value == 1 ? ayatList.ayatList.first.ayaNum : startNum.value;

  int? get lastAyah =>
      endNum.value == 1 ? ayatList.ayatList.last.ayaNum : endNum.value;

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

  Future<void> addPlayList(String playListName) async {
    playLists.add(PlayListModel(
        id: playLists.length,
        startNum: startNum.value,
        endNum: endNum.value,
        surahNum: ayatList.allAyatList.first.surahNum,
        surahName: ayatList.allAyatList.first.sorahName,
        readerName: audioController.readerValue!,
        name: playListName));
    PlayListStorage.savePlayList(playLists);
    print('playLists: ${playLists.length.toString()}');
  }

  deletePlayList(BuildContext context, int index) async {
    // Delete the reminder
    await PlayListStorage.deletePlayList(index)
        .then((value) => customErrorSnackBar(context, 'deletedPlayList'.tr));

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
