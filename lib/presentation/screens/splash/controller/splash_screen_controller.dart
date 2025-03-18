part of '../splash.dart';

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
    Future.delayed(const Duration(milliseconds: 600))
        .then((_) => state.containerAnimate.value = true);
    Future.delayed(const Duration(seconds: 3)).then((_) {
      state.containerHeight.value = Get.height;
      state.containerHHeight.value = Get.height;
      state.customWidget.value = 0;
    });
    Future.delayed(const Duration(milliseconds: 2800))
        .then((_) => state.smallContainerHeight.value = Get.height);
    Future.delayed(const Duration(milliseconds: 2900))
        .then((_) => state.secondSmallContainerHeight.value = Get.height);
    Future.delayed(const Duration(milliseconds: 2950))
        .then((_) => state.thirdSmallContainerHeight.value = Get.height);
    super.onInit();
  }

  /// -------- [Methods] ----------

  Future<void> _loadInitialData() async {
    TafsirAndTranslateController.instance.loadTranslateValue();
    SettingsController.instance.loadLang();
    GeneralController.instance.getLastPageAndFontSize();
    QuranController.instance.loadSwitchValue();
    QuranController.instance.getLastPage();
    GeneralController.instance.updateGreeting();
    AudioController.instance.loadQuranReader();
    GeneralController.instance.state.screenSelectedValue.value =
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

  Widget get customWidget {
    switch (state.customWidget.value) {
      case 0:
        return const LogoAndTitle();
      case 1:
        return WhatsNewScreen(
          newFeatures: WhatsNewController.instance.state.newFeatures,
        );
      default:
        return const LogoAndTitle();
    }
  }
}
