import 'package:alquranalkareem/presentation/screens/splash/controller/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/translate_controller.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/ayat_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/settings_controller.dart';
import '../../whats_new/controller/controller.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get instance =>
      Get.isRegistered<SplashScreenController>()
          ? Get.find<SplashScreenController>()
          : Get.put<SplashScreenController>(SplashScreenController());

  SplashState state = SplashState();
  @override
  void onInit() {
    _loadInitialData();
    startTime();

    super.onInit();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      sl<AyatController>().loadTafseer(),
      sl<TranslateDataController>().loadTranslateValue(),
      sl<SettingsController>().loadLang(),
      sl<GeneralController>().getLastPageAndFontSize(),
      sl<QuranController>().loadSwitchValue(),
    ]);
    sl<GeneralController>().updateGreeting();
    sl<AudioController>().loadQuranReader();
    sl<GeneralController>().screenSelectedValue.value =
        state.box.read(SCREEN_SELECTED_VALUE) ?? 0;
  }

  Future startTime() async {
    await Future.delayed(const Duration(seconds: 1));
    state.animate.value = true;
    await Future.delayed(const Duration(seconds: 3));
    WhatsNewController.instance.navigationPage();
  }

  Widget ramadhanOrEidGreeting() {
    if (state.today.hMonth == 9) {
      return ramadanOrEid('ramadan_white', height: 100.0);
    } else if (state.generalCtrl.eidDays) {
      return ramadanOrEid('eid_white', height: 100.0);
    } else {
      return const SizedBox.shrink();
    }
  }
}
