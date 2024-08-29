import 'package:just_audio/just_audio.dart';

import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../surah_audio_controller.dart';

extension SurahAudioStorageGetters on SurahAudioController {
  /// -------- [Storage] ----------

  Future<void> lastAudioSource() async {
    await state.audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(urlFilePath),
      tag: await mediaItem,
    ));
    await state.audioPlayer.seek(Duration(seconds: state.lastPosition.value));
    print('URL: $urlFilePath');
  }

  Future loadLastSurahListen() async {
    int? lastSurah = await state.box.read(LAST_SURAH) ?? 1;
    state.selectedSurah.value = await state.box.read(SELECTED_SURAH) ?? -1;

    state.lastPosition.value = await state.box.read(LAST_POSITION) ?? 0;

    return {
      LAST_SURAH: lastSurah,
      SELECTED_SURAH: state.selectedSurah,
      LAST_POSITION: state.lastPosition.value,
    };
  }

  Future<void> loadLastSurahAndPosition() async {
    final lastSurahData = await loadLastSurahListen();
    print('Last Surah Data: $lastSurahData');

    state.surahNum.value = lastSurahData[LAST_SURAH];
    state.selectedSurah = lastSurahData[SELECTED_SURAH];

    // Here, you're assigning the Duration object from the lastSurahData map to your position.value
    state.position.value = lastSurahData[LAST_POSITION];
  }
}
