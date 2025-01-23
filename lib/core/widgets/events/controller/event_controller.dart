part of '../events.dart';

class EventController extends GetxController {
  static EventController get instance => Get.isRegistered<EventController>()
      ? Get.find<EventController>()
      : Get.put<EventController>(EventController());

  final box = GetStorage();
  var hijriNow = HijriCalendar.now();
  var now = DateTime.now();
  List<int> noHadithInMonth = <int>[2, 3, 4, 5];
  List<int> notReminderIndex = <int>[1, 2, 3, 5, 6, 7, 8, 9, 10, 12];
  var events = <Event>[].obs;
  late HijriCalendar selectedDate;
  late PageController pageController;
  late List<HijriCalendar> months;
  int? startYear;
  int? endYear;
  BoxController boxController = BoxController();
  Rx<HijriCalendar> calenderMonth = HijriCalendar.now().obs;

  final generalCtrl = GeneralController.instance;

  bool get isNewHadith =>
      hijriNow.hMonth != noHadithInMonth.contains(hijriNow.hMonth)
          ? true
          : false;

  RxBool isEvent(List<int> months, days) {
    for (Event event in events) {
      if (months.contains(event.month) && event.day.contains(days)) {
        return true.obs;
      }
    }
    return false.obs;
  }

  RxBool isCurrentDay(HijriCalendar month, int dayOffset) =>
      (month.hYear == hijriNow.hYear &&
              month.hMonth == hijriNow.hMonth &&
              dayOffset == hijriNow.hDay)
          .obs;

  Event? getIsReminder(List<int> months, int days) {
    return events.firstWhere(
      (r) => months.contains(r.month) && r.day.contains(days),
      orElse: () => Event(
        id: 0,
        title: '',
        day: [],
        month: 1,
        isReminder: false,
        hadith: [],
        isLottie: false,
        isSvg: false,
        isTitle: false,
        lottiePath: '',
        svgPath: '',
      ),
    );
  }

  Color getDayColor(bool isCurrentDay, List<int> months, int days) {
    if (isCurrentDay) {
      return Get.theme.colorScheme.surface;
    }

    final reminder = getIsReminder(months, days);

    if (!isEvent(months, days).value) {
      return Colors.transparent;
    } else if (reminder != null && reminder.isReminder) {
      return Get.theme.colorScheme.surface.withValues(alpha: 0.2);
    } else if (reminder != null && !reminder.isReminder) {
      return Get.theme.colorScheme.primary.withValues(alpha: 0.2);
    } else {
      return Colors.transparent;
    }
  }

  String titleString(int id, int month) {
    switch (id) {
      case 1:
        return '${hijriNow.hYear}'.convertNumbers();
      case 2:
        return '${'9'.convertNumbers()}, ${months[month - 1].longMonthName.tr}';
      case 3:
        return '${'10'.convertNumbers()}, ${months[month - 1].longMonthName.tr}';
      case 4:
        return '${'10'.convertNumbers()}, ${months[month - 1].longMonthName.tr}';
      case 8:
        return '${'6'.convertNumbers()}, ${months[month - 1].longMonthName.tr}';
      case 9:
        return '${'9'.convertNumbers()}, ${months[month - 1].longMonthName.tr}';
      case 10:
        return '${'9'.convertNumbers()}, ${months[month - 1].longMonthName.tr}';
      default:
        return '${hijriNow.hYear}'.convertNumbers();
    }
  }

  Widget getArtWidget(Widget lottieWidget, Widget svgWidget, Widget titleWidget,
      int day, int month) {
    for (Event event in events) {
      if (event.month == month && event.day.contains(day)) {
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
    startYear = hijriNow.hYear - 3;
    endYear = hijriNow.hYear + 3;
    loadJson().then((_) => ramadhanOrEidGreeting());
    selectedDate = generalCtrl.state.today;
    pageController = PageController(
      initialPage: selectedDate.hMonth - 1,
    );
    initializeMonths();
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
        customBottomSheet(ReminderEventBottomSheet(
          lottieFile: event.lottiePath,
          title: event.title.tr,
          hadith: hadithText,
          bookInfo: bookInfo,
          titleString: titleString(event.id, event.month),
          svgPath: event.svgPath,
        ));
        box.write(event.title, false);
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

  bool get isLastDayOfMonth =>
      hijriNow.hDay == hijriNow.lengthOfMonth ? true : false;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  String getWeekdayName(int index) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[index].tr;
  }

  void initializeMonths() {
    months = List.generate(12, (index) {
      var hijri = HijriCalendar.setLocal(
        Get.locale!.languageCode,
      );
      hijri.hYear = selectedDate.hYear;
      hijri.hMonth = index + 1;
      hijri.hDay = 1;
      hijri.gregorianToHijri(
        hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay).year,
        hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay).month,
        hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay).day,
      );
      return hijri;
    });
  }

  void onMonthChanged(int month) {
    selectedDate = HijriCalendar()
      ..hYear = selectedDate.hYear
      ..hMonth = month + 1
      ..hDay = selectedDate.hDay;
    update();
  }

  void onYearChanged(int year) {
    selectedDate = HijriCalendar()
      ..hYear = year
      ..hMonth = selectedDate.hMonth
      ..hDay = selectedDate.hDay;
    initializeMonths();
    update();
  }

  void showEvent(int day, int month) {
    for (Event event in events) {
      if (event.month == month && event.day.contains(day)) {
        String hadithText = event.hadith.map((h) => h.hadith).join("\n\n");
        String bookInfo = event.hadith.map((h) => h.bookInfo).join("\n\n");

        customBottomSheet(
          ReminderEventBottomSheet(
            lottieFile: event.lottiePath,
            title: event.title.tr,
            hadith: hadithText,
            bookInfo: bookInfo,
            titleString: titleString(event.id, event.month),
            svgPath: event.svgPath,
            day: day,
            month: month,
          ),
        );
      }
    }
  }

  // void showMonthPicker() {
  //   final currentMonth = selectedDate.hMonth;
  //   final months = List.generate(12, (index) {
  //     var hijri = HijriCalendar();
  //     hijri.hYear = selectedDate.hYear;
  //     hijri.hMonth = index + 1;
  //     hijri.hDay = 1;
  //     return hijri;
  //   });
  //
  //   showDialog(
  //     context: Get.context!,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       title: Text(
  //         'month'.tr,
  //         style: TextStyle(
  //           fontFamily: 'kufi',
  //           fontSize: 18.sp,
  //           color: Theme.of(context).textTheme.bodyLarge!.color,
  //         ),
  //       ),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: GridView.builder(
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 8.h,
  //             crossAxisSpacing: 8.w,
  //             childAspectRatio: 3,
  //           ),
  //           itemCount: months.length,
  //           itemBuilder: (context, index) {
  //             final month = months[index];
  //             final isSelected = month.hMonth == currentMonth;
  //             return InkWell(
  //               onTap: () {
  //                 pageController.animateToPage(
  //                   month.hMonth - 1,
  //                   duration: const Duration(milliseconds: 300),
  //                   curve: Curves.easeInOut,
  //                 );
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.all(8.0),
  //                 decoration: BoxDecoration(
  //                   color: isSelected
  //                       ? Theme.of(context).colorScheme.primary
  //                       : null,
  //                   borderRadius: BorderRadius.circular(8.r),
  //                   border: Border.all(
  //                     color: Theme.of(context).colorScheme.primary,
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Text(
  //                   month.getLongMonthName().tr,
  //                   style: TextStyle(
  //                     fontFamily: 'kufi',
  //                     fontSize: 14.sp,
  //                     color: isSelected
  //                         ? Theme.of(context).canvasColor
  //                         : Theme.of(context).textTheme.bodyLarge!.color,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void showYearPicker() {
  //   final currentYear = selectedDate.hYear;
  //   final years = List.generate(
  //     endYear - startYear + 1,
  //     (index) => startYear + index,
  //   );
  //
  //   showDialog(
  //     context: Get.context!,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       title: Text(
  //         'year'.tr,
  //         style: TextStyle(
  //           fontFamily: 'kufi',
  //           fontSize: 18.sp,
  //           color: Theme.of(context).textTheme.bodyLarge!.color,
  //         ),
  //       ),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: GridView.builder(
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             mainAxisSpacing: 8.h,
  //             crossAxisSpacing: 8.w,
  //             childAspectRatio: 2,
  //           ),
  //           itemCount: years.length,
  //           itemBuilder: (context, index) {
  //             final year = years[index];
  //             final isSelected = year == currentYear;
  //             return InkWell(
  //               onTap: () {
  //                 onYearChanged(year);
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: isSelected
  //                       ? Theme.of(context).colorScheme.primary
  //                       : null,
  //                   borderRadius: BorderRadius.circular(8.r),
  //                   border: Border.all(
  //                     color: Theme.of(context).colorScheme.primary,
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     year.toString(),
  //                     style: TextStyle(
  //                       fontFamily: 'kufi',
  //                       fontSize: 14.sp,
  //                       color: isSelected
  //                           ? Theme.of(context).canvasColor
  //                           : Theme.of(context).textTheme.bodyLarge!.color,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
