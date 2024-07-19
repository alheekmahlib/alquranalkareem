import 'dart:io';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/presentation/screens/home/home_screen.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/responsive.dart';
import '../../core/widgets/ramadan_greeting.dart';
import '../../core/widgets/time_now.dart';
import '../screens/adhkar/screens/adhkar_view.dart';
import '../screens/books/screens/books_screen.dart';
import '../screens/quran_page/controllers/ayat_controller.dart';
import '../screens/quran_page/screens/quran_home.dart';
import '../screens/surah_audio/audio_surah.dart';
import 'theme_controller.dart';

class GeneralController extends GetxController {
  static GeneralController get instance => Get.isRegistered<GeneralController>()
      ? Get.find<GeneralController>()
      : Get.put<GeneralController>(GeneralController());
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
  // final sl<ThemeController>() = sl<ThemeController>();
  RxBool showSelectScreenPage = false.obs;
  RxInt screenSelectedValue = 0.obs;
  var today = HijriCalendar.now();
  var now = DateTime.now();
  RxBool isPageMode = false.obs;

  final ItemScrollController waqfScrollController = ItemScrollController();

  // final khatmahCtrl = sl<KhatmahController>();

  @override
  Future<void> onInit() async {
    isPageMode.value = box.read(PAGE_MODE) ?? false;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void selectScreenToggleView() {
    showSelectScreenPage.value = !showSelectScreenPage.value;
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
      double fontSizeFromPref = box.read(FONT_SIZE) ?? 24.0;
      if (fontSizeFromPref != 0.0 && fontSizeFromPref > 0) {
        fontSizeArabic.value = fontSizeFromPref;
      } else {
        fontSizeArabic.value = 24.0;
      }
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
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

  Widget screenSelect() {
    switch (screenSelectedValue.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return QuranHome();
      case 3:
        return const AdhkarView();
      case 4:
        return const AudioScreen();
      case 5:
        return BooksScreen();
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
    isRamadhan = box.read(IS_RAMADAN) ?? false;
    bool isEid = false;
    isEid = box.read(IS_EID) ?? false;
    if (sl<ThemeController>().isBlueMode) {
      ramadhan = 'ramadan_blue';
      eid = 'eid_blue';
    } else if (sl<ThemeController>().isBrownMode) {
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
          .then((value) => box.write(IS_RAMADAN, true));
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
          .then((value) => box.write(IS_EID, true));
    }
    if (today.hMonth == 10) box.write(IS_RAMADAN, false);
    if (today.hMonth == 11) box.write(IS_EID, false);
    if (today.hMonth == 1) box.write(IS_EID, false);
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

  void pageModeOnTap(bool value) {
    isPageMode.value = value;
    box.write(PAGE_MODE, value);
    update();
    Get.back();
  }
}
