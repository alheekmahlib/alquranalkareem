import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/screen_type.dart';
import '/presentation/controllers/translate_controller.dart';
import 'audio_controller.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';
import 'settings_controller.dart';

class SplashScreenController extends GetxController {
  RxBool animate = false.obs;

  @override
  void onInit() {
    sl<AyatController>().loadTafseer();
    sl<TranslateDataController>().loadTranslateValue();
    sl<SettingsController>().loadLang();
    sl<AudioController>().loadQuranReader();
    sl<GeneralController>().getLastPageAndFontSize();
    sl<GeneralController>().updateGreeting();
    sl<GeneralController>().screenSelectedValue.value =
        sl<SharedPreferences>().getInt(SCREEN_SELECTED_VALUE) ?? 0;
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
    print('is_first_time ${sl<SharedPreferences>().getBool("is_first_time")}');
    if (sl<SharedPreferences>().getBool("is_first_time") == null) {
      Get.off(() => const OnboardingScreen());
      sl<SharedPreferences>().setBool("is_first_time", false);
    } else {
      Get.off(() => const ScreenTypeL());
    }
    // Get.off(() => OnboardingScreen());
    // Navigator.of(context).pushReplacementNamed(routeName);
  }
}
