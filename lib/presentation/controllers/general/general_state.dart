import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/widgets/time_now.dart';

class GeneralState {
  /// -------- [Variables] ----------
  final GlobalKey<NavigatorState> navigatorNotificationKey =
      GlobalKey<NavigatorState>();
  final box = GetStorage();

  RxDouble fontSizeArabic = 20.0.obs;
  RxBool isShowControl = true.obs;
  RxString greeting = ''.obs;
  TimeNow timeNow = TimeNow();
  final ScrollController ayahListController = ScrollController();
  double ayahItemWidth = 30.0;
  ArabicNumbers arabicNumber = ArabicNumbers();
  RxBool showSelectScreenPage = false.obs;
  RxInt screenSelectedValue = 0.obs;
  var today = HijriCalendar.now();
  var now = DateTime.now();

  final ItemScrollController waqfScrollController = ItemScrollController();
}
