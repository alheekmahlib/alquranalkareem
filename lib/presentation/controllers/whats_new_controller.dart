import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/screen_type.dart';
import '../screens/whats_new/whats_new_screen.dart';

class WhatsNewController extends GetxController {
  static WhatsNewController get instance =>
      Get.isRegistered<WhatsNewController>()
          ? Get.find<WhatsNewController>()
          : Get.put<WhatsNewController>(WhatsNewController());
  RxInt currentPageIndex = 0.obs;
  RxInt onboardingPageNumber = 0.obs;
  final box = GetStorage();

  @override
  void onInit() {
    navigationPage();
    super.onInit();
  }

  void navigationPage() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>> newFeatures = await getNewFeatures();
      if (newFeatures.isNotEmpty) {
        Get.bottomSheet(
          WhatsNewScreen(
            newFeatures: newFeatures,
          ),
          isScrollControlled: true,
          enableDrag: false,
        );
      } else {
        Get.offAll(() => ScreenTypeL(), transition: Transition.downToUp);
      }
    });
    // Get.off(() => OnboardingScreen());
    // Navigator.of(context).pushReplacementNamed(routeName);
  }

  Future<void> saveLastShownIndex(int index) async {
    await box.write(LAST_SHOWN_UPDATE_INDEX, index);
  }

  Future<int> getLastShownIndex() async {
    return box.read(LAST_SHOWN_UPDATE_INDEX) ?? 0;
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
}
