part of '../events.dart';

class EventController extends GetxController {
  static EventController get instance =>
      GetInstance().putOrFind(() => EventController());

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
    loadJson().then((_) => ramadhanOrEidGreeting());
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
    hijriNow.lengthOfMonth =
        hijriNow.getDaysInMonth(hijriNow.hYear, hijriNow.hMonth) - 1;

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
    if (hijriNow.hMonth == 6) {
      return hijriNow.lengthOfMonth - 1;
    } else {
      return hijriNow.lengthOfMonth;
    }
  }

  int getDaysInMonth(HijriDate hijri, int hYear, int hMonth) {
    if (hijriNow.hMonth == 6) {
      return hijri.getDaysInMonth(hYear, hMonth) - 1;
    } else {
      return hijri.getDaysInMonth(hYear, hMonth);
    }
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
        return '${'9'.convertNumbers()}, ${months[month - 1].getLongMonthName().tr}';
      case 3:
        return '${'10'.convertNumbers()}, ${months[month - 1].getLongMonthName().tr}';
      case 4:
        return '${'10'.convertNumbers()}, ${months[month - 1].getLongMonthName().tr}';
      case 8:
        return '${'6'.convertNumbers()}, ${months[month - 1].getLongMonthName().tr}';
      case 9:
        return '${'9'.convertNumbers()}, ${months[month - 1].getLongMonthName().tr}';
      case 10:
        return '${'9'.convertNumbers()}, ${months[month - 1].getLongMonthName().tr}';
      default:
        return '${hijriNow.hYear}'.convertNumbers();
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
      if ((event.month == (hijriNow.hMonth + 1) &&
              hijriNow.hDay == !event.day.contains(hijriNow.hDay)) &&
          !notSameDay) {
        box.remove(event.title);
      }
    }
  }

  int calculate(int year, int month, int day) {
    HijriDate hijriCalendar = HijriDate();
    DateTime start = DateTime.now().add(Duration(days: adjustHijriDays.value));
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

  String daysArabicConvert(int day, String dayNumber) {
    const List<int> daysList = [3, 4, 5, 6, 7, 8, 9, 10];
    if (day == 1) {
      return '${'Day'.tr}';
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

  String getWeekdayName(int index) {
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
}
