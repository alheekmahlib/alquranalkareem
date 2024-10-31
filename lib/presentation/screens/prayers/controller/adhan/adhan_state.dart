import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../controllers/general/general_controller.dart';

class AdhanState {
  /// -------- [Variables] ----------
  final generalCtrl = GeneralController.instance;
  final box = GetStorage();
  late PrayerTimes prayerTimes;
  String nextPrayerTime = "";
  final DateTime now = DateTime.now();
  RxBool prayerAlarm = true.obs;
  var countdownTime = "".obs;
  late SunnahTimes sunnahTimes;
  HijriCalendar hijriDateNow = HijriCalendar.now();
  late Coordinates coordinates;
  late DateComponents dateComponents;
  late CalculationParameters params;
  RxDouble timeProgress = 0.0.obs;
  Timer? timer;
  RxString fajrTime = ''.obs;
  RxString dhuhrTime = ''.obs;
  RxString asrTime = ''.obs;
  RxString maghribTime = ''.obs;
  RxString ishaTime = ''.obs;
  RxString lastThirdTime = ''.obs;
  RxString midnightTime = ''.obs;
  RxBool isHanafi = true.obs;
  RxInt highLatitudeRuleIndex = 2.obs;
  RxBool twilightAngle = true.obs;
  RxBool middleOfTheNight = false.obs;
  RxBool seventhOfTheNight = false.obs;
  var prayerTimesNow;
  RxBool autoCalculationMethod = true.obs;
  RxString calculationMethodString = 'أم القرى'.obs;
  RxString selectedCountry = 'Saudi Arabia'.obs;
  List<String> countries = [];
  late final HighLatitudeRule highLatitudeRule;
  var index = RxInt(0);
  List<RxInt> adjustments = List.generate(7, (_) => 0.obs);
  Future<List<String>>? countryListFuture;
}
