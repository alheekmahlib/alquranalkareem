import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../quran_page/quran.dart';
import '/presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../surah_audio_controller.dart';

extension SurahAudioUi on SurahAudioController {
  Future<void> changeAudioSource() async {
    state.surahDownloadStatus.value[state.surahNum.value] ?? false
        ? await state.audioPlayer.setAudioSource(AudioSource.file(
            await localFilePath,
            tag: await mediaItem,
          ))
        : await state.audioPlayer.setAudioSource(AudioSource.uri(
            Uri.parse(urlFilePath),
            tag: await mediaItem,
          ));
    print('URL: $urlFilePath');
  }

  void changeReadersOnTap(int index) {
    initializeSurahDownloadStatus();
    state.surahReaderValue.value = surahReaderInfo[index]['readerD'];
    state.surahReaderNameValue.value = surahReaderInfo[index]['readerN'];
    state.box
        .write(SURAH_AUDIO_PLAYER_SOUND, surahReaderInfo[index]['readerD']);
    state.box.write(SURAH_AUDIO_PLAYER_NAME, surahReaderInfo[index]['readerN']);
    state.box.write(SURAH_READER_INDEX, index);
    state.surahReaderIndex.value = index;
    changeAudioSource();
    Get.back();
  }

  void searchSurah(String searchInput) {
    final surahList = QuranController.instance.state.surahs;

    int index = surahList.indexWhere((surah) => surah.arabicName
        .removeDiacritics(surah.arabicName)
        .contains(searchInput));
    developer.log('surahNumber: $index');
    if (index != -1 || state.surahListController != false) {
      jumpToSurah(index);
      state.selectedSurah.value = index;
    }
  }

  // ItemScrollController get surahController {
  //   if (state.surahListController!.isAttached) {
  //     state.surahListController!.jumpTo(index: state.surahNum.value - 1);
  //     // = ItemScrollController(
  //     //     initialScrollOffset: 73.0 * state.surahNum.value - 1,
  //     //   );
  //   }
  //   return state.surahListController!;
  // }

  void jumpToSurah(int index) {
    state.surahListController.jumpTo(index: index);
  }
}
