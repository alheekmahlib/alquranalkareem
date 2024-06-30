import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '/core/utils/constants/extensions/extensions.dart';

class CountdownController extends GetxController {
  static CountdownController get instance =>
      Get.isRegistered<CountdownController>()
          ? Get.find<CountdownController>()
          : Get.put<CountdownController>(CountdownController());

  var hijriNow = HijriCalendar.now();
  var now = DateTime.now();
  List<int> noHadithInMonth = <int>[2, 3, 4, 5, 6];

  bool get isNewHadith =>
      hijriNow.hMonth != noHadithInMonth.contains(hijriNow.hMonth)
          ? true
          : false;

  int calculate(int year, int month, int day) {
    DateTime occasionDate = hijriNow.hijriToGregorian(year, month, day);
    HijriCalendar today = HijriCalendar.now();
    DateTime todayGregorian =
        today.hijriToGregorian(today.hYear, today.hMonth, today.hDay);
    Duration difference = occasionDate.difference(todayGregorian);
    return difference.inDays;
  }

  double calculateProgress(int currentIndex, int total) {
    int totalPages = total;
    if (currentIndex < 1) {
      return 0.0;
    }
    if (currentIndex > totalPages) {
      return 100.0;
    }
    return ((currentIndex / totalPages) *
        Get.context!.customOrientation(Get.width * .8, Get.width * .4));
  }

  String daysArabicConvert(int day) {
    const List<int> daysList = [3, 4, 5, 6, 7, 8, 9, 10];
    if (day == 1) {
      return 'Day';
    } else if (day == 2) {
      return 'يومان';
    } else if (daysList.contains(day)) {
      return 'Days';
    } else {
      return 'Day';
    }
  }
}
