part of '../whats_new.dart';

class WhatsNewController extends GetxController {
  static WhatsNewController get instance =>
      Get.isRegistered<WhatsNewController>()
          ? Get.find<WhatsNewController>()
          : Get.put<WhatsNewController>(WhatsNewController());

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

  // Future<void> activeLocation() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (!GeneralController.instance.isActiveLocation ||
  //         !GeneralController.instance.state.activeLocation.value) {
  //       GetStorage().write(IS_LOCATION_ACTIVE, true);
  //       SplashScreenController.instance.state.customWidget.value = 1;
  //     } else {
  //       navigationPage();
  //     }
  //   });
  // }
}
