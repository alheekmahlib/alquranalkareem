part of '../whats_new.dart';

class WhatsNewController extends GetxController {
  static WhatsNewController get instance =>
      GetInstance().putOrFind(() => WhatsNewController());

  WhatsNewState state = WhatsNewState();
  @override
  Future<void> onInit() async {
    super.onInit();
    state.newFeatures = await getNewFeatures();
  }

  bool get hasNewFeatures =>
      state.newFeatures.isNotEmpty ||
      (state.box.read(LAST_SHOWN_UPDATE_INDEX) ?? 0) <
          whatsNewList.last['index'];

  /// -------- [Methods] ----------

  Future<List<Map<String, dynamic>>> getNewFeatures() async {
    int lastShownIndex = await getLastShownIndex();

    List<Map<String, dynamic>> newFeatures = whatsNewList.where((item) {
      return item['index'] > lastShownIndex;
    }).toList();

    return newFeatures;
  }

  void showWhatsNew() async {
    List<Map<String, dynamic>> newFeatures = await getNewFeatures();
    if (newFeatures.isNotEmpty) {
      await saveLastShownIndex(newFeatures.last['index']);
    }
  }

  List<Map<String, dynamic>> whatsNewList = [
    {'index': 5, 'title': '', 'details': "What'sNewDetails10", 'imagePath': ''},
  ];
}
