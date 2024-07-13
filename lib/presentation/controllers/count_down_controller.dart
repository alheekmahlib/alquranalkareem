import 'package:flutter/material.dart';
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
    HijriCalendar hijriCalendar = HijriCalendar();
    DateTime start = DateTime.now();
    DateTime end = hijriCalendar.hijriToGregorian(year, month, day);
    if (!start.isAfter(end)) {
      // this if the end date is aftar the start date will do this logic
      return DateTimeRange(start: start, end: end).duration.inDays;
    } else {
      // this if the end date is before the start date will do the else logic
      // end = end.copyWith(year: end.year + 1); // uncomment this if you want to make it calucate the next year occasion
      // return DateTimeRange(start: end, end: start).duration.inDays; // you can make this like مضى X ايام
      return 0;
    }
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
