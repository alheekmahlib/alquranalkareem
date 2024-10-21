import '/presentation/screens/quran_page/controllers/audio/audio_controller.dart';
import '../../../../../../core/utils/constants/shared_preferences_constants.dart';

extension AudiuStorageGetters on AudioController {
  /// -------- [Storage] ----------

  void loadQuranReader() {
    state.readerValue =
        state.box.read(AUDIO_PLAYER_SOUND) ?? 'Abdul_Basit_Murattal_192kbps';
    state.readerName.value =
        state.box.read(READER_NAME) ?? 'عبد الباسط عبد الصمد';
    state.readerIndex.value = state.box.read(READER_INDEX) ?? 0;
  }
}
