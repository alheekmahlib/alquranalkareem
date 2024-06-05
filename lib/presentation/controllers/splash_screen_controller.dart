import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/translate_controller.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/lottie.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/screen_type.dart';
import '../screens/whats_new/whats_new_screen.dart';
import 'audio_controller.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';
import 'settings_controller.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get instance =>
      Get.isRegistered<SplashScreenController>()
          ? Get.find<SplashScreenController>()
          : Get.put<SplashScreenController>(SplashScreenController());
  RxBool animate = false.obs;
  final generalCtrl = GeneralController.instance;
  RxInt onboardingPageNumber = 0.obs;
  var today = HijriCalendar.now();
  RxInt currentPageIndex = 0.obs;
  final box = GetStorage();

  @override
  void onInit() {
    sl<AyatController>().loadTafseer();
    sl<TranslateDataController>().loadTranslateValue();
    sl<SettingsController>().loadLang();
    sl<AudioController>().loadQuranReader();
    sl<GeneralController>().getLastPageAndFontSize();
    sl<GeneralController>().updateGreeting();
    sl<QuranController>().loadSwitchValue();
    sl<GeneralController>().screenSelectedValue.value =
        box.read(SCREEN_SELECTED_VALUE) ?? 0;
    startTime();
    super.onInit();
  }

  Future startTime() async {
    await Future.delayed(const Duration(seconds: 1));
    animate.value = true;
    await Future.delayed(const Duration(seconds: 3));
    // Get.off(() => OnboardingScreen());
    navigationPage();
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

  Widget ramadhanOrEidGreeting() {
    if (today.hMonth == 9) {
      return ramadanOrEid('ramadan_white', height: 100.0);
    } else if (generalCtrl.eidDays) {
      return ramadanOrEid('eid_white', height: 100.0);
    } else {
      return const SizedBox.shrink();
    }
  }
}
