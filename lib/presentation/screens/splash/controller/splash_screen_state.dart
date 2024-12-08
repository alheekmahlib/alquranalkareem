part of '../splash.dart';

class SplashState {
  /// -------- [Variables] ----------
  final generalCtrl = GeneralController.instance;
  RxBool animate = false.obs;
  var today = HijriCalendar.now();
  final box = GetStorage();
  RxBool containerAnimate = false.obs;
  RxDouble containerHeight = 230.0.h.obs;
  RxDouble containerHHeight = 270.0.h.obs;
  RxDouble smallContainerHeight = 0.0.obs;
  RxDouble secondSmallContainerHeight = 0.0.obs;
  RxDouble thirdSmallContainerHeight = 0.0.obs;
  RxInt customWidget = 0.obs;
}
