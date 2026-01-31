part of '../events.dart';

class EventController extends GetxController {
  static EventController get instance => Get.isRegistered<EventController>()
      ? Get.find<EventController>()
      : Get.put<EventController>(EventController());

  final box = GetStorage();
  late HijriDate hijriNow;
  var now = DateTime.now();
  List<int> noHadithInMonth = <int>[2, 3, 4, 5];
  List<int> notReminderIndex = <int>[1, 2, 3, 5, 6, 7, 8, 9, 10, 12];
  var events = <Event>[].obs;
  late HijriDate selectedDate;
  late PageController pageController;
  late List<HijriDate> months;
  int? startYear;
  int? endYear;
  RxInt adjustHijriDays = 0.obs;
  BoxController boxController = BoxController();
  Rx<HijriDate> calenderMonth = HijriDate.now().obs;

  @override
  void onInit() {
    super.onInit();
    adjustHijriDays.value = box.read('adjustHijriDays') ?? 0;
    selectedDate = HijriDate.now();
    initializeMonths();
    pageController = PageController(initialPage: selectedDate.hMonth - 1);
    Future.delayed(const Duration(seconds: 20), () async {
      await loadJson();
      await ramadhanOrEidGreeting();
    });
  }

  void initializeMonths() {
    months = List.generate(12, (index) {
      var hijri = HijriDate.fromHijri(selectedDate.hYear, index + 1, 1);
      // Ensure lengthOfMonth is initialized
      // حساب بداية اليوم (أول يوم في الشهر)
      hijri.wkDay = calculateFirstDayOfMonth(index + 1, selectedDate.hYear);

      hijri.lengthOfMonth = hijri.getDaysInMonth(hijri.hYear, hijri.hMonth);
      return hijri;
    });

    var currentHijri = HijriDate.now();
    var adjustedDay = currentHijri.hDay + adjustHijriDays.value;
    var adjustedMonth = currentHijri.hMonth;
    var adjustedYear = currentHijri.hYear;

    // Ensure days do not exceed the month length
    var daysInMonth = currentHijri.getDaysInMonth(
      currentHijri.hYear,
      currentHijri.hMonth,
    );
    if (adjustedDay > daysInMonth) {
      adjustedDay -= daysInMonth;
      adjustedMonth++;
      if (adjustedMonth > 12) {
        adjustedMonth = 1;
        adjustedYear++;
      }
    }

    hijriNow = HijriDate.fromHijri(adjustedYear, adjustedMonth, adjustedDay);
    hijriNow.lengthOfMonth = hijriNow.getDaysInMonth(
      hijriNow.hYear,
      hijriNow.hMonth,
    );

    startYear = hijriNow.hYear - 3;
    endYear = hijriNow.hYear + 3;
  }

  int calculateFirstDayOfMonth(int hMonth, int hYear) {
    // الحصول على اليوم الأخير من الشهر السابق
    var previousMonth = hMonth - 1 == 0 ? 12 : hMonth - 1;
    var previousYear = hMonth - 1 == 0 ? hYear - 1 : hYear;

    var lastDayOfPreviousMonth = HijriDate().getDaysInMonth(
      previousYear,
      previousMonth,
    );

    // اليوم الذي ينتهي به الشهر السابق
    var lastDayWeekday = HijriDate.fromHijri(
      previousYear,
      previousMonth,
      lastDayOfPreviousMonth,
    ).weekDay();

    // حساب اليوم الأول من الشهر الجديد
    return (lastDayWeekday + 1) % 7; // اليوم الذي يلي اليوم الأخير
  }

  int get getLengthOfMonth {
    return hijriNow.lengthOfMonth;
  }

  int getDaysInMonth(HijriDate hijri, int hYear, int hMonth) {
    return hijri.getDaysInMonth(hYear, hMonth);
  }

  bool get isNewHadith =>
      noHadithInMonth.contains(hijriNow.hMonth - 1) ? false : true;

  RxBool isEvent(List<int> months, days) {
    for (Event event in events) {
      if (months.contains(event.month) && event.day.contains(days)) {
        return true.obs;
      }
    }
    return false.obs;
  }

  RxBool isCurrentDay(HijriDate month, int dayOffset) =>
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
      return Get.context!.theme.colorScheme.surface;
    }

    final reminder = getIsReminder(months, days);

    if (!isEvent(months, days).value) {
      return Get.context!.theme.colorScheme.primary.withValues(alpha: .1);
    } else if (reminder != null && reminder.isReminder) {
      return Get.context!.theme.colorScheme.surface.withValues(alpha: .15);
    } else if (reminder != null && !reminder.isReminder) {
      return Get.context!.theme.colorScheme.primary.withValues(alpha: .4);
    } else {
      return Colors.transparent;
    }
  }

  String titleString(int id, int month) {
    switch (id) {
      case 1:
        return '${hijriNow.hYear}'.convertNumbersToCurrentLang();
      case 2:
        return '${'9'.convertNumbersToCurrentLang()}, ${months[month - 1].getLongMonthName().tr}';
      case 3:
        return '${'10'.convertNumbersToCurrentLang()}, ${months[month - 1].getLongMonthName().tr}';
      case 4:
        return '${'10'.convertNumbersToCurrentLang()}, ${months[month - 1].getLongMonthName().tr}';
      case 8:
        return '${'6'.convertNumbersToCurrentLang()}, ${months[month - 1].getLongMonthName().tr}';
      case 9:
        return '${'9'.convertNumbersToCurrentLang()}, ${months[month - 1].getLongMonthName().tr}';
      case 10:
        return '${'9'.convertNumbersToCurrentLang()}, ${months[month - 1].getLongMonthName().tr}';
      default:
        return '${hijriNow.hYear}'.convertNumbersToCurrentLang();
    }
  }

  Widget getArtWidget(
    Widget lottieWidget,
    Widget svgWidget,
    Widget titleWidget,
    int day,
    int month,
  ) {
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

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString(
      'assets/json/religious_event.json',
    );
    final data = await json.decode(response);
    DataModel dataModel = DataModel.fromJson(data);
    events.value = dataModel.data;
  }

  Future<void> ramadhanOrEidGreeting() async {
    for (Event event in events) {
      // box.write(event.title, true);
      bool isTrue = box.read(event.title) ?? true;
      if (event.month == hijriNow.hMonth &&
          event.day.contains(hijriNow.hDay) &&
          isTrue) {
        String hadithText = event.hadith.map((h) => h.hadith).join("\n\n");
        String bookInfo = event.hadith.map((h) => h.bookInfo).join("\n\n");

        await Future.delayed(const Duration(seconds: 2));
        customBottomSheet(
          ReminderEventBottomSheet(
            lottieFile: event.lottiePath,
            title: event.title.tr,
            hadith: hadithText,
            bookInfo: bookInfo,
            titleString: titleString(event.id, event.month),
            svgPath: event.svgPath,
            day: hijriNow.hDay,
            month: event.month,
          ),
        );
        box.write(event.title, false);
      }
      bool notSameDay = event.day.contains(hijriNow.hDay);
      if (event.month == hijriNow.hMonth + 1 && !notSameDay) {
        box.remove(event.title);
      }
    }
  }

  int calculate(int year, int month, int day) {
    // حساب الأيام المتبقية للمناسبة مع إعادة التعيين للسنة القادمة - Calculate remaining days for the event with reset to next year
    HijriDate hijriCalendar = HijriDate();
    DateTime start = DateTime.now().add(Duration(days: adjustHijriDays.value));
    DateTime end = hijriCalendar.hijriToGregorian(year, month, day);

    if (!start.isAfter(end)) {
      // إذا كان تاريخ المناسبة لم يحن بعد - If the event date hasn't arrived yet
      return DateTimeRange(start: start, end: end).duration.inDays;
    } else {
      // إذا مضى على المناسبة أكثر من 4 أيام، احسب الموعد للسنة القادمة - If more than 4 days have passed since the event, calculate for next year
      int daysPassed = DateTimeRange(start: end, end: start).duration.inDays;

      if (daysPassed > 4) {
        // احسب المناسبة للسنة الهجرية القادمة - Calculate the event for the next Hijri year
        DateTime nextYearEnd = hijriCalendar.hijriToGregorian(
          year + 1,
          month,
          day,
        );
        return DateTimeRange(start: start, end: nextYearEnd).duration.inDays;
      } else {
        // إذا مضى 4 أيام أو أقل، أظهر أن المناسبة قد مضت - If 4 days or less have passed, show that the event has passed
        return 0;
      }
    }
  }

  String daysArabicConvert(int day, String dayNumber) {
    const List<int> daysList = [3, 4, 5, 6, 7, 8, 9, 10];
    if (day == 1) {
      return 'Day'.tr;
    } else if (day == 2) {
      return 'twoDays'.tr;
    } else if (daysList.contains(day)) {
      return '$dayNumber ${'Days'.tr}';
    } else {
      return '$dayNumber ${'Day'.tr}';
    }
  }

  bool get isLastDayOfMonth => hijriNow.hDay == getLengthOfMonth ? true : false;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  String getWeekdayShortName(int index) {
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return weekdays[index].tr;
  }

  void onMonthChanged(int month) {
    selectedDate = HijriDate()
      ..hYear = selectedDate.hYear
      ..hMonth = month + 1
      ..hDay = selectedDate.hDay;
    update();
  }

  void onYearChanged(int year) {
    selectedDate = HijriDate()
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

  void increaseDay() {
    adjustHijriDays.value += 1;
    box.write('adjustHijriDays', adjustHijriDays.value);
    initializeMonths();
    update();
  }

  void decreaseDay() {
    adjustHijriDays.value -= 1;
    box.write('adjustHijriDays', adjustHijriDays.value);
    initializeMonths();
    update();
  }

  void resetDate() {
    selectedDate = HijriDate()
      ..hYear = HijriDate.now().hYear
      ..hMonth = selectedDate.hMonth
      ..hDay = selectedDate.hDay;
    initializeMonths();
  }

  // حساب السنة المناسبة للمناسبة (الحالية أو القادمة) - Calculate appropriate year for the event (current or next)
  int getEventYear(int month, int day) {
    HijriDate hijriCalendar = HijriDate();
    DateTime start = DateTime.now().add(Duration(days: adjustHijriDays.value));
    DateTime currentYearEnd = hijriCalendar.hijriToGregorian(
      hijriNow.hYear,
      month,
      day,
    );

    if (!start.isAfter(currentYearEnd)) {
      // إذا كان تاريخ المناسبة لم يحن بعد في السنة الحالية - If the event date hasn't arrived yet in current year
      return hijriNow.hYear;
    } else {
      // إذا مضى على المناسبة، تحقق من عدد الأيام - If the event has passed, check number of days
      int daysPassed = DateTimeRange(
        start: currentYearEnd,
        end: start,
      ).duration.inDays;

      if (daysPassed > 4) {
        // إذا مضى أكثر من 4 أيام، استخدم السنة القادمة - If more than 4 days have passed, use next year
        return hijriNow.hYear + 1;
      } else {
        // إذا مضى 4 أيام أو أقل، استخدم السنة الحالية - If 4 days or less have passed, use current year
        return hijriNow.hYear;
      }
    }
  }
}
