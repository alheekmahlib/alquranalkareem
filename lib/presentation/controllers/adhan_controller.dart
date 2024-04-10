import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:alquranalkareem/core/services/location/locations.dart';
import 'package:alquranalkareem/core/utils/helpers/date_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/models/prayer_day_model.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/location_enum.dart';
import '../../core/utils/constants/lottie.dart';
import '../../core/utils/constants/lottie_constants.dart';

class AdhanController extends GetxController {
  late PrayerTimes prayerTimes;
  String nextPrayerTime = "";
  final DateTime now = DateTime.now();
  RxBool prayerAlarm = true.obs;
  final sharedCtrl = sl<SharedPreferences>();
  var countdownTime = "".obs;
  late SunnahTimes sunnahTimes;
  // RxBool formatted12Hour = true.obs;
  // RxBool isHijri = true.obs;
  // HijriCalendar hijriDateNow = HijriCalendar.now();
  late Coordinates coordinates;
  // Create date components from the provided date
  late final dateComponents;
  // Get calculation parameters based on your desired calculation method
  late final params;
  RxDouble timeProgress = 0.0.obs;
  Timer? timer;
  // late String getFajrTime;
  // late String getDhuhrTime;
  // late String getAsrTime;
  // late String getMaghribTime;
  // late String getIshaTime;
  // late String lastThirdStartTime;
  // late String getMidnightTime;

  int get currentPrayer => prayerTimes.currentPrayer().index - 1;
  int get nextPrayer => prayerTimes.nextPrayer().index;

  Future<String> get getFajrTime async =>
      await DateFormatter.justTime(prayerTimes.fajr);

  Future<String> get getDhuhrTime async =>
      await DateFormatter.justTime(prayerTimes.dhuhr);
  Future<String> get getAsrTime async =>
      await DateFormatter.justTime(prayerTimes.asr);
  Future<String> get getMaghribTime async =>
      await DateFormatter.justTime(prayerTimes.maghrib);
  Future<String> get getIshaTime async =>
      await DateFormatter.justTime(prayerTimes.isha);
  Future<String> get lastThirdStartTime async =>
      await DateFormatter.justTime(sunnahTimes.lastThirdOfTheNight);
  Future<String> get getMidnightTime async =>
      await DateFormatter.justTime(sunnahTimes.middleOfTheNight);

  // Future<void> prayerTimesInitialization() async {
  //   getFajrTime = await DateFormatter.justTime(prayerTimes.fajr);
  //   getDhuhrTime = await DateFormatter.justTime(prayerTimes.dhuhr);
  //   getAsrTime = await DateFormatter.justTime(prayerTimes.asr);
  //   getMaghribTime = await DateFormatter.justTime(prayerTimes.maghrib);
  //   getIshaTime = await DateFormatter.justTime(prayerTimes.isha);
  //   lastThirdStartTime =
  //       await DateFormatter.justTime(sunnahTimes.lastThirdOfTheNight);
  //   getMidnightTime =
  //       await DateFormatter.justTime(sunnahTimes.middleOfTheNight);
  //   update();
  // }

  Widget get LottieWidget {
    if (prayerTimes.sunrise.isBefore(now)) {
      return customLottie(LottieConstants.assetsLottieSun, height: 120);
    } else if (prayerTimes.maghrib.isBefore(now)) {
      return customLottie(LottieConstants.assetsLottieMoon, height: 120);
    } else {
      return customLottie(LottieConstants.assetsLottieMoon, height: 120);
    }
  }

  Widget get icon => prayerTimes.maghrib.isBefore(now)
      ? customLottie(LottieConstants.assetsLottieSun, height: 120)
      : customLottie(LottieConstants.assetsLottieMoon, height: 120);

  Duration getTimeLeftForNextPrayer() {
    final now = DateTime.now();
    final Prayer? nextPrayer = prayerTimes.nextPrayer();
    if (nextPrayer == null) {
      return Duration.zero;
    }
    final DateTime? nextPrayerDateTime = prayerTimes.timeForPrayer(nextPrayer);
    if (nextPrayerDateTime == null || nextPrayerDateTime.isBefore(now)) {
      return Duration.zero;
    }
    return nextPrayerDateTime.difference(now);
  }

  void prayerAlarmSwitch(int index) {
    switch (index) {
      case 0:
        sharedCtrl.setBool(prayerNameList[0]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 1:
        sharedCtrl.setBool(prayerNameList[1]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 2:
        sharedCtrl.setBool(prayerNameList[2]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 3:
        sharedCtrl.setBool(prayerNameList[3]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 4:
        sharedCtrl.setBool(prayerNameList[4]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
      case 5:
        sharedCtrl.setBool(prayerNameList[5]['sharedAlarm'],
            prayerAlarm.value = !prayerAlarm.value);
        break;
    }
    update();
  }

  // TODO: check if it necessary or delete it
  // void anotherTimeSwitch(int index) {
  //   switch (index) {
  //     case 0:
  //       sharedCtrl.setBool(anotherTimeList[0]['sharedAlarm'],
  //           prayerAlarm.value = !prayerAlarm.value);
  //       break;
  //     case 1:
  //       sharedCtrl.setBool(anotherTimeList[1]['sharedAlarm'],
  //           prayerAlarm.value = !prayerAlarm.value);
  //       break;
  //     case 2:
  //       sharedCtrl.setBool(anotherTimeList[2]['sharedAlarm'],
  //           prayerAlarm.value = !prayerAlarm.value);
  //       break;
  //   }
  //   update();
  // }

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeAdhanVariables();
    // await prayerTimesInitialization();
    updateProgress();
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => updateProgress());
  }

  Future<PrayerTimes> initializeAdhanVariables() async {
    coordinates = Coordinates(Location.instance.position!.latitude,
        Location.instance.position!.latitude);
    dateComponents = DateComponents.from(now);
    params = CalculationMethod.north_america.getParameters();
    // params = getCalculationParametersFromLocation(Location.instance.country);
    params.madhab = Madhab.shafi;
    final prayerTimesNow = PrayerTimes(coordinates, dateComponents, params);
    sunnahTimes = SunnahTimes(prayerTimesNow);
    update();
    return prayerTimes = prayerTimesNow;
  }

  getPrayerSelected(int index, var v1, var v2) =>
      sharedCtrl.getBool(prayerNameList[index]['sharedAlarm']) == true
          ? v1
          : v2;

  // getAnotherTimeSelected(int index, var v1, var v2) =>
  //     sharedCtrl.getBool(anotherTimeList[index]['sharedAlarm']) == true
  //         ? v1
  //         : v2;

  Future<PrayerDay> getPrayerTimesForDay(DateTime date) async {
    // Convert to Hijri
    final hijriDate = HijriCalendar.fromDate(date);

    // Create and return the PrayerDay object
    return PrayerDay(
      date: date,
      fajr: prayerTimes.fajr,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      hijriDate: hijriDate,
    );
  }

  CalculationParameters getCalculationParametersFromLocation(String location) {
    LocationEnum select = location.getCountry();
    switch (select) {
      case LocationEnum.NorthAmerica:
        return CalculationMethod.north_america.getParameters();
      case LocationEnum.Egyptian:
        return CalculationMethod.egyptian.getParameters();
      case LocationEnum.Dubai:
        return CalculationMethod.dubai.getParameters();
      case LocationEnum.Karachi:
        return CalculationMethod.karachi.getParameters();
      case LocationEnum.Kuwait:
        return CalculationMethod.kuwait.getParameters();
      case LocationEnum.Qatar:
        return CalculationMethod.qatar.getParameters();
      case LocationEnum.Turkey:
        return CalculationMethod.turkey.getParameters();
      case LocationEnum.Singapore:
        return CalculationMethod.singapore.getParameters();
      default:
        return CalculationMethod.other.getParameters();
    }
  }

  // TODO: upcoming feature
  // Future<List<PrayerDay>> generatePrayerCalendarForHijriMonth() async {
  //   List<PrayerDay> calendar = [];
  //   // Calculate the start of the Hijri month
  //   HijriCalendar hijriDate = HijriCalendar()
  //     ..hYear = hijriDateNow.hYear
  //     ..hMonth = hijriDateNow.hMonth
  //     ..hDay = 1; // Start from the first day of the month
  //
  //   // Convert the start of the Hijri month to Gregorian
  //   DateTime startDate = hijriDate.hijriToGregorian(
  //       hijriDateNow.hYear, hijriDateNow.hMonth, hijriDateNow.hDay);
  //
  //   // Determine the number of days in the Hijri month
  //   int monthLength = hijriDateNow.lengthOfMonth;
  //
  //   for (int i = 0; i < monthLength; i++) {
  //     // Increment the day starting from the first day of the Hijri month
  //     DateTime date = startDate.add(Duration(days: i));
  //
  //     // Calculate prayer times for the Gregorian date
  //     var prayerTimesForDay = await getPrayerTimesForDay(date);
  //
  //     // Re-calculate the Hijri date for each day (since the month can vary in length)
  //     HijriCalendar recalculatedHijriDate = HijriCalendar.fromDate(date);
  //
  //     // Create a new entry for the calendar
  //     PrayerDay prayerDay = PrayerDay(
  //       date: date,
  //       hijriDate: recalculatedHijriDate,
  //       fajr: prayerTimesForDay.fajr,
  //       dhuhr: prayerTimesForDay.dhuhr,
  //       asr: prayerTimesForDay.asr,
  //       maghrib: prayerTimesForDay.maghrib,
  //       isha: prayerTimesForDay.isha,
  //     );
  //     calendar.add(prayerDay);
  //   }
  //   return calendar;
  // }
  //
  // Future<void> goToPrayerTimesCalendarForMonth() async {
  //   try {
  //     List<PrayerDay> prayerDays =
  //         await adhanCtrl.generatePrayerCalendarForHijriMonth();
  //     Get.to(() => PrayerTimesCalendar(prayerDays: prayerDays));
  //   } catch (e) {
  //     print(e); // or use a more sophisticated error handling approach
  //   }
  // }

  void updateProgress() {
    var now = DateTime.now();
    var totalMinutes = 24 * 60;
    var currentMinutes = now.hour * 60 + now.minute;
    timeProgress.value = (currentMinutes / totalMinutes) * 100;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
