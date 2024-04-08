import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:alquranalkareem/core/services/location/locations.dart';
import 'package:alquranalkareem/core/utils/helpers/date_formatter.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/models/prayer_day_model.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/location_enum.dart';

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

  String get getFajirTime => DateFormatter.justTime(prayerTimes.fajr);

  String get getDhuhrTime => DateFormatter.justTime(prayerTimes.dhuhr);
  String get getAsrTime => DateFormatter.justTime(prayerTimes.asr);
  String get getMaghribTime => DateFormatter.justTime(prayerTimes.maghrib);
  String get getIshaTime => DateFormatter.justTime(prayerTimes.isha);
  int get currentPrayer => prayerTimes.currentPrayer().index - 1;
  int get nextPrayer => prayerTimes.nextPrayer().index;
  String get lastThirdStartTime =>
      DateFormatter.justTime(sunnahTimes.lastThirdOfTheNight);
  String get getMidnightTime =>
      DateFormatter.justTime(sunnahTimes.middleOfTheNight);

  String getTimeLeftForNextPrayer() {
    if (nextPrayerTime == "Not available") {
      return "Next prayer time not available";
    }
    final now = DateTime.now();
    final nextPrayerDateTime =
        prayerTimes.timeForPrayer(prayerTimes.nextPrayer());
    if (nextPrayerDateTime == null) {
      return "Next prayer time not calculated";
    }
    final duration = nextPrayerDateTime.difference(now);
    if (duration.isNegative) {
      return "The time for the next prayer has passed.";
    }
    final String formattedDuration =
        '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return formattedDuration;
  }

  void startCountdownTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownTime.value = getTimeLeftForNextPrayer();
    });
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
  void onInit() {
    super.onInit();
    initializeAdhanVriables();
    startCountdownTimer();
    // prayerAlarm.value = sl<SharedPreferences>().getBool('sharedAlarm') ?? false;
  }

  Future<void> initializeAdhanVriables() async {
    coordinates = Coordinates(Location.instance.position!.latitude,
        Location.instance.position!.latitude);
    dateComponents = DateComponents.from(now);
    params = getCalculationParametersFromLocation(Location.instance.country);
    params.madhab = Madhab.shafi;
    prayerTimes = PrayerTimes(coordinates, dateComponents, params);
    sunnahTimes = SunnahTimes(prayerTimes);
    final nextPrayer = prayerTimes.nextPrayer();
    if (nextPrayer != null) {
      final DateTime? nextPrayerTimeDateTime =
          prayerTimes.timeForPrayer(nextPrayer);
      nextPrayerTime = nextPrayerTimeDateTime != null
          ? DateFormat.jm().format(nextPrayerTimeDateTime)
          : "Not available";
    } else {
      nextPrayerTime = "Not available";
    }
    update();
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
      case LocationEnum.Tehran:
        return CalculationMethod.tehran.getParameters();
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
}
