import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../../core/utils/constants/url_constants.dart';
import '../../../quran_page/controllers/quran/quran_controller.dart';
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
    state.sorahReaderValue.value = surahReaderInfo[index]['readerD'];
    state.sorahReaderNameValue.value = surahReaderInfo[index]['readerN'];
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
    if (index != -1) {
      state.controller.jumpTo(index * 80.0);
      state.selectedSurah.value = index;
    }
  }

  void loadSurahReader() {
    state.sorahReaderValue.value =
        state.box.read(SURAH_AUDIO_PLAYER_SOUND) ?? UrlConstants.ayahs3rdSource;
    state.sorahReaderNameValue.value =
        state.box.read(SURAH_AUDIO_PLAYER_NAME) ?? 'abdul_basit_murattal/';
    state.surahReaderIndex.value = state.box.read(SURAH_READER_INDEX) ?? 0;
  }
}
