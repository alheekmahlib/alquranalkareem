part of '../whats_new.dart';

class WhatsNewController extends GetxController {
  static WhatsNewController get instance =>
      GetInstance().putOrFind(() => WhatsNewController());

  WhatsNewState state = WhatsNewState();

  @override
  Future<void> onInit() async {
    navigationPage();
    state.newFeatures = await getNewFeatures();
    super.onInit();
  }

  /// -------- [Methods] ----------

  void navigationPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.newFeatures.isNotEmpty) {
        SplashScreenController.instance.state.customWidget.value = 1;
      } else {
        Get.offAll(() => ScreenTypeL(),
            transition: Transition.fadeIn, curve: Curves.easeIn);
      }
    });
  }

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
    {
      'index': 13,
      'title': "",
      'details': "What'sNewDetails10",
      'imagePath': '',
    },
  ];
}
