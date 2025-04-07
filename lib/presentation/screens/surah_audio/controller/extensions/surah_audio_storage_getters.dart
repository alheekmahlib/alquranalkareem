import '../../../../../core/utils/constants/api_constants.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../surah_audio_controller.dart';

extension SurahAudioStorageGetters on SurahAudioController {
  /// -------- [Storage] ----------

  Future loadLastSurahListen() async {
    int? lastSurah = state.box.read(LAST_SURAH) ?? 1;
    int? selectedSurah = state.box.read(SELECTED_SURAH) ?? 1;
    int? lastPosition = state.box.read(LAST_POSITION) ?? 0;
    return {
      LAST_SURAH: lastSurah,
      SELECTED_SURAH: selectedSurah,
      LAST_POSITION: lastPosition,
    };
  }

  Future<void> loadLastSurahAndPosition() async {
    final lastSurahData = await loadLastSurahListen();
    print('Last Surah Data: $lastSurahData');

    state.surahNum.value = lastSurahData[LAST_SURAH];
    state.selectedSurah.value = lastSurahData[SELECTED_SURAH];
    state.lastPosition.value = lastSurahData[LAST_POSITION];
  }

  void saveLastSurahListen() {
    state.box.write(LAST_SURAH, state.surahNum.value);
    state.box.write(
      SELECTED_SURAH,
      state.selectedSurah.value,
    );
  }

  void loadSurahReader() {
    state.surahReaderValue.value =
        state.box.read(SURAH_AUDIO_PLAYER_SOUND) ?? ApiConstants.surahUrl1;
    state.surahReaderNameValue.value =
        state.box.read(SURAH_AUDIO_PLAYER_NAME) ?? 'abdul_basit_murattal/';
    state.surahReaderIndex.value = state.box.read(SURAH_READER_INDEX) ?? 0;
  }
}
