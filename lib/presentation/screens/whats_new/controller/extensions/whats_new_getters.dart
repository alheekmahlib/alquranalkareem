import '/presentation/screens/whats_new/controller/whats_new_controller.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';

extension WhatsNewGetters on WhatsNewController {
  /// -------- [Getters] --------
  Future<void> saveLastShownIndex(int index) async {
    await state.box.write(LAST_SHOWN_UPDATE_INDEX, index);
  }

  Future<int> getLastShownIndex() async {
    return state.box.read(LAST_SHOWN_UPDATE_INDEX) ?? 0;
  }
}
