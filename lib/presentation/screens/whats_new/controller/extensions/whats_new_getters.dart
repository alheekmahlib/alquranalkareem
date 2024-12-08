part of '../../whats_new.dart';

extension WhatsNewGetters on WhatsNewController {
  /// -------- [Getters] --------
  Future<void> saveLastShownIndex(int index) async {
    await state.box.write(LAST_SHOWN_UPDATE_INDEX, index);
  }

  Future<int> getLastShownIndex() async {
    return state.box.read(LAST_SHOWN_UPDATE_INDEX) ?? 0;
  }
}
