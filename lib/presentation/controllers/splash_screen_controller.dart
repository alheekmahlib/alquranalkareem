import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/translate_controller.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lottie.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import 'audio_controller.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';
import 'settings_controller.dart';
import 'whats_new_controller.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get instance =>
      Get.isRegistered<SplashScreenController>()
          ? Get.find<SplashScreenController>()
          : Get.put<SplashScreenController>(SplashScreenController());
  RxBool animate = false.obs;
  final generalCtrl = GeneralController.instance;
  var today = HijriCalendar.now();
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
    // Get.offAll(() => ScreenTypeL(), transition: Transition.downToUp);
    WhatsNewController.instance.navigationPage();
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
