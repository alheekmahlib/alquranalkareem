import 'dart:developer';
import 'dart:io';

import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:alquranalkareem/presentation/controllers/adhan_controller.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/share_controller.dart';
import '/presentation/controllers/theme_controller.dart';
import '/presentation/screens/home/home_screen.dart';
import '../../core/services/location/locations.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/constants/string_constants.dart';
import '../../core/utils/helpers/responsive.dart';
import '../../core/widgets/ramadan_greeting.dart';
import '../../core/widgets/time_now.dart';
import '../screens/athkar/screens/alzkar_view.dart';
import '../screens/quran_page/screens/quran_home.dart';
import '../screens/surah_audio_screen/audio_surah.dart';
import 'audio_controller.dart';
import 'ayat_controller.dart';
import 'bookmarks_controller.dart';
import 'notification_controller.dart';
import 'playList_controller.dart';

class GeneralController extends GetxController {
  final GlobalKey<NavigatorState> navigatorNotificationKey =
      GlobalKey<NavigatorState>();

  /// Slide and Scroll Controller
  late ScrollController scrollController;
  bool isPanelControllerDisposed = false;

  /// Page Controller
  PageController quranPageController = PageController();

  RxInt currentPageNumber = 1.obs;
  RxInt lastReadSurahNumber = 1.obs;
  RxDouble fontSizeArabic = 20.0.obs;
  List<InlineSpan> text = [];

  RxBool isShowControl = true.obs;
  RxBool opened = false.obs;
  // RxBool menuOpened = false.obs;
  double? height;
  double width = 800;
  RxString greeting = ''.obs;
  RxInt shareTafseerValue = 1.obs;
  RxInt pageIndex = 0.obs;
  RxBool isExpanded = false.obs;
  bool isReversed = false;
  RxBool showSettings = true.obs;
  RxDouble viewport = .5.obs;
  TimeNow timeNow = TimeNow();
  RxDouble? animatedWidth;
  RxDouble? animatedHeight;
  Rx<Size>? _screenSize;
  double? xScale;
  double? yScale;
  double _fabPosition = 16;
  double _fabSize = 56;
  final ScrollController surahListController = ScrollController();
  final ScrollController ayahListController = ScrollController();
  double surahItemHeight = 65.0;
  double ayahItemWidth = 30.0;
  RxBool isLoading = false.obs;
  var verses;
  ArabicNumbers arabicNumber = ArabicNumbers();
  final themeCtrl = sl<ThemeController>();
  RxBool showSelectScreenPage = false.obs;
  RxInt screenSelectedValue = 0.obs;
  var today = HijriCalendar.now();
  List<int> noHadithInMonth = <int>[2, 3, 4, 5, 6];
  RxBool activeLocation = false.obs;
  RxBool isPageMode = false.obs;
  RxString imagePath = ''.obs;
  final globalKey = GlobalKey();

  final sharedCtrl = sl<SharedPreferences>();

  bool get isNewHadith =>
      today.hMonth != noHadithInMonth.contains(today.hMonth) ? true : false;

  // final khatmahCtrl = sl<KhatmahController>();

  double get scr_height => _screenSize!.value.height;

  double get scr_width => _screenSize!.value.width;

  double get positionBottom => _fabSize + _fabPosition * 4;

  double get positionRight => _fabPosition;

  Uint8List? hijriWidgetToImageBytes;
  final ScreenshotController hijriWidgetController = ScreenshotController();

  Future<void> updateHijriWidget(Widget widget) async {
    Uint8List? bytes = await hijriWidgetController.capture();
    hijriWidgetToImageBytes = bytes;

    final directory = await getTemporaryDirectory();
    final tempFile =
        File("${directory.path}/${DateTime.now().toIso8601String()}.png");
    await tempFile.writeAsBytes(bytes!);

    await HomeWidget.saveWidgetData('hijriDate', tempFile.path);
    await HomeWidget.updateWidget(
        iOSName: StringConstants.iosWidget,
        androidName: StringConstants.androidWidget);
  }

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(StringConstants.groupId);
  }

  @override
  Future<void> onInit() async {
    activeLocation.value = sharedCtrl.getBool(ACTIVE_LOCATION) ?? false;
    isPageMode.value = sharedCtrl.getBool(PAGE_MODE) ?? false;

    super.onInit();
  }

  Future<void> initLocation() async {
    try {
      await LocationHelper.instance.getPositionDetails();
    } catch (e) {
      log(e.toString(), name: "Main", error: e);
    }
  }

  Future<void> toggleLocationService() async {
    bool isEnabled = await LocationHelper.instance.isLocationServiceEnabled();
    if (!isEnabled) {
      await LocationHelper.instance.openLocationSettings();
      await Future.delayed(const Duration(seconds: 3));
      isEnabled = await LocationHelper.instance.isLocationServiceEnabled();
      if (isEnabled || activeLocation.value) {
        await initLocation().then((_) async {
          activeLocation.value = true;
          await sl<NotificationController>().initializeNotification();
          await sl<AdhanController>().initializeAdhan();
          sharedCtrl.setBool(ACTIVE_LOCATION, true);
          sl<AdhanController>().onInit();
        });
      } else {
        log('Location services were not enabled by the user.');
      }
    } else {
      await initLocation().then((_) async {
        activeLocation.value = true;
        await sl<NotificationController>().initializeNotification();
        await sl<AdhanController>().initializeAdhan();
        sharedCtrl.setBool(ACTIVE_LOCATION, true);
        sl<AdhanController>().onInit();
      });
      log('Location services are already enabled.');
    }
    sl<AdhanController>().update();
  }

  void selectScreenToggleView() {
    showSelectScreenPage.value = !showSelectScreenPage.value;
  }

  checkRtlLayout(var rtl, var ltr) {
    if (sl<ShareController>().isRtlLanguage('lang'.tr)) {
      return rtl;
    } else {
      return ltr;
    }
  }

  final cacheManager = CacheManager(Config(
      'https://raw.githubusercontent.com/alheekmahlib/alquranalkareem/main/assets/app_icon.png'));

  Future<Uri> getCachedArtUri(String imageUrl) async {
    final file = await cacheManager.getSingleFile(imageUrl);
    return await file.exists()
        ? file.uri
        : Uri.parse(
            imageUrl); // Use cached URI if available, otherwise use the original URL
  }

  Future<void> getLastPageAndFontSize() async {
    try {
      currentPageNumber.value = await sharedCtrl.getInt(MSTART_PAGE) ?? 1;
      lastReadSurahNumber.value = await sharedCtrl.getInt(MLAST_URAH) ?? 1;
      double fontSizeFromPref = await sharedCtrl.getDouble(FONT_SIZE) ?? 24.0;
      if (fontSizeFromPref != 0.0 && fontSizeFromPref > 0) {
        fontSizeArabic.value = fontSizeFromPref;
      } else {
        fontSizeArabic.value = 24.0;
      }
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }

  Future<void> pageChanged(int index) async {
    currentPageNumber.value = index + 1;
    sl<PlayListController>().reset();
    isShowControl.value = false;
    sl<AyatController>().isSelected.value = (-1.0);
    sl<AudioController>().pageAyahNumber = '0';
    sl<BookmarksController>().getBookmarks();
    lastReadSurahNumber.value =
        sl<QuranController>().getSurahNumberFromPage(index);
    sharedCtrl.setInt(MSTART_PAGE, index + 1);
    sharedCtrl.setInt(MLAST_URAH, lastReadSurahNumber.value);
    // khatmahCtrl.saveLastKhatmah(
    //     surahNumber: lastReadSurahNumber.value, pageNumber: index);
    // sl<QuranController>().selectedAyahIndexes.clear();
  }

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }

  scrollToSurah(int surahNumber) {
    double position = (surahNumber - 1) * surahItemHeight;
    surahListController.jumpTo(position);
  }

  // int get surahNumber => sl<QuranController>()
  //     .allAyahs
  //     .firstWhere((s) => s.page == currentPageNumber.value)
  //     .surahNum;

  // surahPosition() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     scrollToSurah(surahNumber);
  //   });
  // }

  scrollToAyah(int ayahNumber) {
    if (ayahListController.hasClients) {
      double position = (ayahNumber - 1) * ayahItemWidth;
      ayahListController.jumpTo(position);
    } else {
      print("Controller not attached to any scroll views.");
    }
  }

  ayahPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToAyah(sl<AyatController>().isSelected.value.toInt());
    });
  }

  PageController get pageController {
    return quranPageController = PageController(
        viewportFraction: Responsive.isDesktop(Get.context!) ? 1 / 2 : 1,
        initialPage: sl<GeneralController>().currentPageNumber.value - 1,
        keepPage: true);
  }

  String convertNumbers(String inputStr) {
    Map<String, Map<String, String>> numberSets = {
      'العربية': {
        '0': '٠',
        '1': '١',
        '2': '٢',
        '3': '٣',
        '4': '٤',
        '5': '٥',
        '6': '٦',
        '7': '٧',
        '8': '٨',
        '9': '٩',
      },
      'English': {
        '0': '0',
        '1': '1',
        '2': '2',
        '3': '3',
        '4': '4',
        '5': '5',
        '6': '6',
        '7': '7',
        '8': '8',
        '9': '9',
      },
      'বাংলা': {
        '0': '০',
        '1': '১',
        '2': '২',
        '3': '৩',
        '4': '৪',
        '5': '৫',
        '6': '৬',
        '7': '৭',
        '8': '৮',
        '9': '৯',
      },
      'اردو': {
        '0': '۰',
        '1': '۱',
        '2': '۲',
        '3': '۳',
        '4': '۴',
        '5': '۵',
        '6': '۶',
        '7': '۷',
        '8': '۸',
        '9': '۹',
      },
    };

    Map<String, String>? numSet = numberSets['lang'.tr];

    if (numSet == null) {
      return inputStr;
    }

    for (var entry in numSet.entries) {
      inputStr = inputStr.replaceAll(entry.key, entry.value);
    }

    return inputStr;
  }

  Widget screenSelect() {
    switch (screenSelectedValue.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return QuranHome();
      case 3:
        return const AzkarView();
      case 4:
        return const AudioScreen();
      default:
        return const HomeScreen();
    }
  }

  double screenWidth(double smallWidth, double largeWidth) {
    final size = Get.width;
    if (size <= 600) {
      return smallWidth;
    }
    return largeWidth;
  }

  bool isRtlLanguage(String languageName) {
    return rtlLang.contains(languageName);
  }

  RotatedBox checkWidgetRtlLayout(Widget myWidget) {
    if (isRtlLanguage('lang'.tr)) {
      return RotatedBox(quarterTurns: 0, child: myWidget);
    } else {
      return RotatedBox(quarterTurns: 2, child: myWidget);
    }
  }

  dynamic checkDirectionRtlLayout(var textDirection, var textDirection2) {
    if (isRtlLanguage('lang'.tr)) {
      return textDirection;
    } else {
      return textDirection2;
    }
  }

  Future<void> launchEmail() async {
    const String subject = "تطبيق القرآن الكريم - مكتبة الحكمة";
    const String stringText =
        "يرجى كتابة أي ملاحظة أو إستفسار\n| جزاكم الله خيرًا |";
    String uri =
        'mailto:haozo89@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No email client found");
    }
  }

  Future<void> launchFacebookUrl() async {
    String uri = 'https://www.facebook.com/alheekmahlib';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No url client found");
    }
  }

  Future<void> share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final ByteData bytes =
        await rootBundle.load('assets/images/quran_banner.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/quran_banner.png').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'تطبيق "القرآن الكريم - مكتبة الحكمة" التطبيق الأمثل لقراءة القرآن.\n\nللتحميل:\nalheekmahlib.com/#/download/app/0',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  List get eidDaysList =>
      ['1-10', '2-10', '3-10', '10-12', '11-12', '12-12', '13-12'];

  String get eidGreetingContent =>
      today.hMonth == 10 ? 'eidGreetingContent'.tr : 'eidGreetingContent2'.tr;

  bool get eidDays {
    String todayString = '${today.hDay}-${today.hMonth}';
    return eidDaysList.contains(todayString);
  }

  Future<void> ramadhanOrEidGreeting() async {
    final String ramadhan;
    final String eid;
    bool isRamadhan = false;
    isRamadhan = sharedCtrl.getBool(IS_RAMADAN) ?? false;
    bool isEid = false;
    isEid = sharedCtrl.getBool(IS_EID) ?? false;
    if (themeCtrl.isBlueMode) {
      ramadhan = 'ramadan_blue';
      eid = 'eid_blue';
    } else if (themeCtrl.isBrownMode) {
      ramadhan = 'ramadan_brown';
      eid = 'eid_brown';
    } else {
      ramadhan = 'ramadan_white';
      eid = 'eid_white';
    }
    if (today.hMonth == 9 && isRamadhan == false) {
      await Future.delayed(const Duration(seconds: 2));
      Get.bottomSheet(
              RamadanGreeting(
                lottieFile: ramadhan,
                title: 'رمضان مبارك - ${'ramadhanMubarak'.tr}',
                content:
                    'عَنْ أَبِي هُرَيْرَةَ، قَالَ قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم ‏ "‏ أَتَاكُمْ رَمَضَانُ شَهْرٌ مُبَارَكٌ فَرَضَ اللَّهُ عَزَّ وَجَلَّ عَلَيْكُمْ صِيَامَهُ تُفْتَحُ فِيهِ أَبْوَابُ السَّمَاءِ وَتُغْلَقُ فِيهِ أَبْوَابُ الْجَحِيمِ وَتُغَلُّ فِيهِ مَرَدَةُ الشَّيَاطِينِ لِلَّهِ فِيهِ لَيْلَةٌ خَيْرٌ مِنْ أَلْفِ شَهْرٍ مَنْ حُرِمَ خَيْرَهَا فَقَدْ حُرِمَ ‏"‏ ‏.‏\nسنن النسائي - كتاب الصيام - ٢١٠٦\n\n"The Messenger of Allah said: There has come to you Ramadan, a blessed month, which Allah, the Mighty and Sublime, has enjoined you to fast. In it the gates of heavens are opened and the gates of Hell are closed, and every devil is chained up. In it Allah has a night which is better than a thousand months; whoever is deprived of its goodness is indeed deprived.”\nSunan an-Nasai - The Book of Fasting - 2106',
              ),
              isScrollControlled: true)
          .then((value) => sharedCtrl.setBool(IS_RAMADAN, true));
    }
    if (eidDays && isEid == false) {
      await Future.delayed(const Duration(seconds: 2));
      Get.bottomSheet(
              RamadanGreeting(
                lottieFile: eid,
                title: 'عيدكم مبارك - ${'eidGreetingTitle'.tr}',
                content: eidGreetingContent,
              ),
              isScrollControlled: true)
          .then((value) => sharedCtrl.setBool(IS_EID, true));
    }
    if (today.hMonth == 10) sharedCtrl.setBool(IS_RAMADAN, false);
    if (today.hMonth == 11) sharedCtrl.setBool(IS_EID, false);
    if (today.hMonth == 1) sharedCtrl.setBool(IS_EID, false);
  }

  double customSize(
      double mobile, double largeMobile, double tablet, double desktop) {
    if (Responsive.isMobile(Get.context!)) {
      return mobile;
    } else if (Responsive.isMobileLarge(Get.context!)) {
      return largeMobile;
    } else if (Responsive.isTablet(Get.context!)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  double ifBigScreenSize(double s, double l) {
    return Get.width >= 1025.0 ? s : l;
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

  // TODO: need fixed
  double calculateProgress2(
      int currentDay, int daysUntilEvent, double totalWidth) {
    // Assuming currentDay is the day of the month and daysUntilEvent is the total days remaining until the event
    double progressFraction = currentDay / (currentDay + daysUntilEvent);
    return progressFraction * totalWidth;
  }

  String daysArabicConvert(int day) {
    final List<int> daysList = [3, 4, 5, 6, 7, 8, 9, 10];
    if ('lang'.tr == 'العربية') {
      if (day == 1) {
        return 'يوم';
      } else if (day == 2) {
        return 'يومان';
      } else if (daysList.contains(day)) {
        return 'أيام';
      } else {
        return 'Day';
      }
    } else {
      return day == 1 ? 'Day' : 'Days';
    }
  }

  double calculateDaysProgress(int year, int month, int day) {
    HijriCalendar hijriCalendar = HijriCalendar();
    DateTime start = DateTime.now();
    DateTime end = hijriCalendar.hijriToGregorian(year, month, day);
    int total = !start.isAfter(end)
        ? DateTimeRange(start: start, end: end).duration.inDays
        : DateTimeRange(start: end, end: start).duration.inDays;
    int today = HijriCalendar.now().hDay;
    int totalDays = total;
    if (today < 1) {
      return 0.0;
    }
    if (today > totalDays) {
      return 100.0;
    }
    return (today / totalDays) * Get.width;
  }

  // TODO: need fixed
  int calculateDaysUntilSpecificDate(int year, int month, int day) {
    HijriCalendar hijriCalendar = HijriCalendar();
    DateTime start = DateTime.now();
    DateTime end = hijriCalendar.hijriToGregorian(year, month, day);
    if (!start.isAfter(end)) {
      // this if the end date is after the start date will do this logic
      return DateTimeRange(start: start, end: end).duration.inDays;
    } else {
      // this if the end date is before the start date will do the else logic
      end = end.copyWith(year: end.year + 1);
      // return DateTimeRange(start: end, end: start).duration.inDays;
      return DateTimeRange(start: start, end: end).duration.inDays;
      // return start * end;
    }
  }

  void pageModeOnTap(bool value) {
    isPageMode.value = value;
    sharedCtrl.setBool(PAGE_MODE, value);
    update();
    Get.back();
  }
}
