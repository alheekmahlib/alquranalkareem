import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../controllers/general_controller.dart';

class SplashState {
  RxBool animate = false.obs;
  final generalCtrl = GeneralController.instance;
  RxInt onboardingPageNumber = 0.obs;
  var today = HijriCalendar.now();
  RxInt currentPageIndex = 0.obs;
  final box = GetStorage();
}
