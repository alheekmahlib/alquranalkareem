part of '../splash.dart';

class SplashState {
  /// -------- [Variables] ----------
  var today = EventController.instance.hijriNow;
  final box = GetStorage();
  // RxBool logoAnimate = false.obs;
  // RxBool containerAnimate = false.obs;
  RxDouble firstContainerHeight = 0.0.obs;
  RxDouble secondContainerHeight = 0.0.obs;
  RxDouble halfFirstContainerHeight = 0.0.obs;
  RxDouble halfSecondContainerHeight = 0.0.obs;
  RxInt customWidgetIndex = 0.obs;
  RxBool isNotificationLoading = false.obs;
}
