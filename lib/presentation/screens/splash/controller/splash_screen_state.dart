import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../controllers/general_controller.dart';

class SplashState {
  /// -------- [Variables] ----------
  final generalCtrl = GeneralController.instance;
  RxBool animate = false.obs;
  var today = HijriCalendar.now();
  final box = GetStorage();
}
