import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/widgets/time_now.dart';
import '../screens/athkar/screens/alzkar_view.dart';
import '../screens/quran_page/screens/quran_home.dart';
import '../screens/surah_audio_screen/audio_surah.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/share_controller.dart';
import '/presentation/screens/home/home_screen.dart';
import 'audio_controller.dart';
import 'ayat_controller.dart';
import 'bookmarks_controller.dart';
import 'playList_controller.dart';

class GeneralController extends GetxController {
  final GlobalKey<NavigatorState> navigatorNotificationKey =
      GlobalKey<NavigatorState>();

  /// Slide and Scroll Controller
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelTextController = SlidingUpPanelController();
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
  int? onboardingPageNumber;
  bool isReversed = false;
  RxBool showSettings = true.obs;
  RxDouble widgetPosition = (-240.0).obs;
  RxDouble textWidgetPosition = (-240.0).obs;
  RxDouble audioWidgetPosition = (70.0).obs;
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

  RxBool showSelectScreenPage = false.obs;
  RxInt screenSelectedValue = 0.obs;
  final GlobalKey<SliderDrawerState> drawerKey =
      GlobalKey<SliderDrawerState>(debugLabel: 'SliderDrawerStateKey');

  double get scr_height => _screenSize!.value.height;

  double get scr_width => _screenSize!.value.width;

  double get positionBottom => _fabSize + _fabPosition * 4;

  double get positionRight => _fabPosition;

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
    return file != null
        ? file.uri
        : Uri.parse(
            imageUrl); // Use cached URI if available, otherwise use the original URL
  }

  void setScreenSize(Size newSize, BuildContext context) {
    if (_screenSize?.value == null || _screenSize?.value != newSize) {
      _screenSize = newSize.obs;

      xScale = context.customOrientation(
          (60 + _fabPosition * 5) * 120 / scr_width,
          (60 + _fabPosition * 5) * 100 / scr_width);
      yScale = (60 + _fabPosition * 2) * 100 / scr_height;
      update();
    }
  }

  Future<void> getLastPageAndFontSize() async {
    try {
      currentPageNumber.value =
          await sl<SharedPreferences>().getInt(MSTART_PAGE) ??
              1; // Set a default value
      lastReadSurahNumber.value =
          await sl<SharedPreferences>().getInt(MLAST_URAH) ??
              1; // Set a default value
      double fontSizeFromPref =
          await sl<SharedPreferences>().getDouble(FONT_SIZE) ?? 24.0;
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
    panelController.hide();
    isShowControl.value = false;
    audioWidgetPosition.value = -240;
    sl<AyatController>().isSelected.value = (-1.0);
    sl<AudioController>().pageAyahNumber = '0';

    sl<BookmarksController>().getBookmarks();
    lastReadSurahNumber.value =
        sl<QuranController>().getSurahNumberFromPage(index + 1);
    sl<SharedPreferences>().setInt(MSTART_PAGE, index + 1);
    sl<SharedPreferences>().setInt(MLAST_URAH, lastReadSurahNumber.value);
    // sl<QuranController>().selectedAyahIndexes.clear();
  }

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }

  closeSlider() {
    sl<GeneralController>().widgetPosition.value =
        sl<GeneralController>().widgetPosition.value == 0.0 ? -220.0 : 0.0;
  }

  scrollToSurah(int surahNumber) {
    double position = (surahNumber - 1) * surahItemHeight;
    surahListController.jumpTo(position);
  }

  int get surahNumber => sl<AyatController>()
      .ayatList
      .firstWhere((s) => s.pageNum == currentPageNumber.value)
      .surahNum;

  surahPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSurah(surahNumber);
    });
  }

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

  void slideHandle() {
    if (SlidingUpPanelStatus.anchored == panelController.status) {
      panelController.collapse();
    } else {
      panelController.anchor();
    }
  }

  void slideOpen() {
    if (SlidingUpPanelStatus.collapsed == panelController.status) {
      panelController.anchor();
    }
  }

  void slideClose() {
    if (SlidingUpPanelStatus.anchored == panelController.status) {
      panelController.hide();
    }
  }

  PageController get pageController {
    return quranPageController = PageController(
        initialPage: sl<GeneralController>().currentPageNumber.value - 1,
        keepPage: true);
  }

  PageController dPageController({double? viewport}) {
    return quranPageController = PageController(
        viewportFraction: viewport!,
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
      case 2:
        return const AudioScreen();
      case 3:
        return const AzkarView();
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
        await rootBundle.load('assets/images/AlQuranAlKareem.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/AlQuranAlKareem.jpg').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'تطبيق "القرآن الكريم - مكتبة الحكمة" التطبيق الأمثل لقراءة القرآن.\n\nللتحميل:\nalheekmahlib.com/#/download/app/0',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
