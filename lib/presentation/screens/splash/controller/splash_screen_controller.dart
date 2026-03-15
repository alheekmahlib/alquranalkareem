part of '../splash.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get instance =>
      GetInstance().putOrFind(() => SplashScreenController());

  SplashState state = SplashState();

  @override
  Future<void> onInit() async {
    super.onInit();
    _loadInitialData();
    halfOpenSlider(duration: 1, height: 200);
    Future.delayed(
      const Duration(milliseconds: 4300),
    ).then((_) => hasNewFeatures());
  }

  @override
  void onReady() {
    // toggleSlider(duration: 3500);
    super.onReady();
  }

  void toggleSlider({required int duration}) {
    final height = Get.height;
    openSlider(duration: duration, height: height);
    closeSlider(duration: duration + 700, height: 0.0);
  }

  void openSlider({required int duration, required double height}) {
    Future.delayed(
      Duration(milliseconds: duration),
    ).then((_) => state.firstContainerHeight.value = height);
    Future.delayed(
      Duration(milliseconds: duration + 200),
    ).then((_) => state.secondContainerHeight.value = height);
  }

  void halfOpenSlider({required int duration, required double height}) {
    Future.delayed(
      Duration(milliseconds: duration),
    ).then((_) => state.halfFirstContainerHeight.value = height);
    Future.delayed(
      Duration(milliseconds: duration + 200),
    ).then((_) => state.halfSecondContainerHeight.value = height + 20);
  }

  void closeSlider({required int duration, required double height}) {
    Future.delayed(
      Duration(milliseconds: duration),
    ).then((_) => state.secondContainerHeight.value = height);
    Future.delayed(
      Duration(milliseconds: duration + 200),
    ).then((_) => state.firstContainerHeight.value = height);
  }

  bool get _isFirstOpen => !(state.box.read('hasOpenedBefore') ?? false);

  void _markAsOpened() => state.box.write('hasOpenedBefore', true);

  void hasNewFeatures() {
    if (_isFirstOpen) {
      toggleSlider(duration: 0);
      Future.delayed(
        const Duration(milliseconds: 600),
        () => state.customWidgetIndex.value = 1,
      );
    } else if (WhatsNewController.instance.hasNewFeatures) {
      toggleSlider(duration: 0);
      halfOpenSlider(duration: 0, height: Get.height);
      Future.delayed(
        const Duration(milliseconds: 600),
        () => state.customWidgetIndex.value = 2,
      );
    } else {
      toggleSlider(duration: 0);
      Future.delayed(
        const Duration(milliseconds: 900),
        () => Get.offAll(const HomeScreen(), transition: Transition.fadeIn),
      );
    }
  }

  void onSettingsDone() {
    _markAsOpened();
    if (WhatsNewController.instance.hasNewFeatures) {
      toggleSlider(duration: 0);
      state.customWidgetIndex.value = 2;
    } else {
      toggleSlider(duration: 0);
      Get.offAll(const HomeScreen(), transition: Transition.fadeIn);
    }
  }

  Widget get customWidget {
    switch (state.customWidgetIndex.value) {
      case 0:
        return const LogoAndTitle();
      case 1:
        return _buildFirstTimeSettings();
      case 2:
        return WhatsNewScreen(
          newFeatures: WhatsNewController.instance.state.newFeatures,
        );
      default:
        return const LogoAndTitle();
    }
  }

  Widget _buildFirstTimeSettings() {
    return Stack(
      children: [
        SettingsList(
          isQuranSetting: false,
          isCalendarSetting: false,
          isStartScreen: true,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ContainerButton(
            onPressed: onSettingsDone,
            width: Get.width * .5,
            verticalMargin: 8.0,
            isTitleCentered: true,
            title: 'start',
          ),
        ),
      ],
    );
  }

  /// -------- [Methods] ----------

  Future<void> _loadInitialData() async {
    SettingsController.instance.loadLang();
    TafsirCtrl.instance.fontSizeArabic.value =
        GetStorage().read(FONT_SIZE) ?? 22.0;
  }

  Widget ramadhanOrEidGreeting() {
    if (state.today.hMonth == 9) {
      return ramadanOrEid(
        'ramadan_white',
        height: 100.0,
        color: Get.theme.canvasColor,
      );
    } else if (GeneralController.instance.eidDays) {
      return ramadanOrEid(
        'eid_white',
        height: 100.0,
        color: Get.theme.canvasColor,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
