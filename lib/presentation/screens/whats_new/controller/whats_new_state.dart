import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WhatsNewState {
  /// -------- [Variables] ----------
  RxInt currentPageIndex = 0.obs;
  RxInt onboardingPageNumber = 0.obs;
  final box = GetStorage();
}
