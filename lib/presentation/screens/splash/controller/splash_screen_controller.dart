import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/controllers/general/extensions/general_getters.dart';
import '/presentation/screens/splash/controller/splash_screen_state.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../controllers/general/general_controller.dart';
import '../../../controllers/settings_controller.dart';
import '../../quran_page/quran.dart';
import '../../whats_new/controller/whats_new_controller.dart';

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

  /// -------- [Methods] ----------

  Future<void> _loadInitialData() async {
    await Future.wait([
      sl<TranslateDataController>().loadTranslateValue(),
      sl<SettingsController>().loadLang(),
      sl<GeneralController>().getLastPageAndFontSize(),
      sl<QuranController>().loadSwitchValue(),
      sl<QuranController>().getLastPage(),
    ]);
    sl<GeneralController>().updateGreeting();
    sl<AudioController>().loadQuranReader();
    sl<GeneralController>().state.screenSelectedValue.value =
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
