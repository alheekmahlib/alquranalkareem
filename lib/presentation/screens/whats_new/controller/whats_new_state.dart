part of '../whats_new.dart';

class WhatsNewState {
  /// -------- [Variables] ----------
  RxInt currentPageIndex = 0.obs;
  RxInt onboardingPageNumber = 0.obs;
  final box = GetStorage();
  List<Map<String, dynamic>> newFeatures = [];
}
