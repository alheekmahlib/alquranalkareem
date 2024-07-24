import 'dart:convert';

import 'package:alquranalkareem/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../data/model/event_model.dart';
import '../reminder_event_bottom_sheet.dart';

class EventController extends GetxController {
  static EventController get instance => Get.isRegistered<EventController>()
      ? Get.find<EventController>()
      : Get.put<EventController>(EventController());

  final box = GetStorage();
  var hijriNow = HijriCalendar.now();
  var now = DateTime.now();
  List<int> noHadithInMonth = <int>[2, 3, 4, 5, 6];
  var events = <Event>[].obs;

  bool get isNewHadith =>
      hijriNow.hMonth != noHadithInMonth.contains(hijriNow.hMonth)
          ? true
          : false;

  String titleString(int id) {
    switch (id) {
      case 1:
        return '${hijriNow.hYear}'.convertNumbers();
      case 2:
        return '${'9'.convertNumbers()}, ${hijriNow.longMonthName.tr}';
      case 3:
        return '${'10'.convertNumbers()}, ${hijriNow.longMonthName.tr}';
      case 7:
        return '${'6'.convertNumbers()}, ${hijriNow.longMonthName.tr}';
      case 8:
        return '${'9'.convertNumbers()}, ${hijriNow.longMonthName.tr}';
      default:
        return '${hijriNow.hYear}'.convertNumbers();
    }
  }

  Widget getArtWidget(
      Widget lottieWidget, Widget svgWidget, Widget titleWidget) {
    for (Event event in events) {
      if (event.month == hijriNow.hMonth && event.day.contains(hijriNow.hDay)) {
        if (event.isLottie) {
          return lottieWidget;
        } else if (event.isSvg) {
          return svgWidget;
        } else if (event.isTitle) {
          return titleWidget;
        } else {
          return titleWidget;
        }
      }
    }
    return titleWidget;
  }

  @override
  void onInit() {
    super.onInit();
    loadJson().then((_) => ramadhanOrEidGreeting());
  }

  Future<void> loadJson() async {
    final String response =
        await rootBundle.loadString('assets/json/religious_event.json');
    final data = await json.decode(response);
    DataModel dataModel = DataModel.fromJson(data);
    events.value = dataModel.data;
  }

  Future<void> ramadhanOrEidGreeting() async {
    for (Event event in events) {
      box.write(event.title, true);
      bool isTrue = box.read(event.title) ?? true;
      if (event.month == hijriNow.hMonth &&
          event.day.contains(hijriNow.hDay) &&
          isTrue) {
        String hadithText = event.hadith.map((h) => h.hadith).join("\n\n");
        String bookInfo = event.hadith.map((h) => h.bookInfo).join("\n\n");

        await Future.delayed(const Duration(seconds: 2));
        Get.bottomSheet(
          ReminderEventBottomSheet(
            lottieFile: event.lottiePath,
            title: event.title.tr,
            hadith: hadithText,
            bookInfo: bookInfo,
            titleString: titleString(event.id),
            svgPath: event.svgPath,
          ),
          isScrollControlled: true,
          isDismissible: true,
        ).then((_) => box.write(event.title, false));
      }
      bool notSameDay = event.day.contains(hijriNow.hDay);
      if (event.month == hijriNow.hMonth + 1 && !notSameDay)
        box.remove(event.title);
    }
  }

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
