import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:alquranalkareem/presentation/screens/notes/notes_list.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/bookmarks_list.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/quran_search.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/show_tafseer.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/surah_juz_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_pref_services.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/widgets/time_now.dart';
import '../screens/quran_page/data/model/sorah_bookmark.dart';
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

  RxInt currentPage = 1.obs;
  RxString soMName = '1'.obs;
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
  var slideWidget = Rx<Widget>(ShowTafseer());
  final searchTextEditing = TextEditingController();

  double get scr_height => _screenSize!.value.height;

  double get scr_width => _screenSize!.value.width;

  double get positionBottom => _fabSize + _fabPosition * 4;

  double get positionRight => _fabPosition;

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
      currentPage.value = await sl<SharedPrefServices>()
          .getInteger(MSTART_PAGE, defaultValue: 1); // Set a default value
      soMName.value = await sl<SharedPrefServices>()
          .getString(MLAST_URAH, defaultValue: '1'); // Set a default value
      double fontSizeFromPref =
          await sl<SharedPrefServices>().getDouble(FONT_SIZE);
      if (fontSizeFromPref != 0.0 && fontSizeFromPref > 0) {
        fontSizeArabic.value = fontSizeFromPref;
      } else {
        fontSizeArabic.value = 24.0; // Setting to a valid default value
      }
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }

  showControl() {
    isShowControl.value = !isShowControl.value;
    if (SlidingUpPanelStatus.hidden == panelController.status) {
      panelController.collapse();
      slideWidgetSwitch(0);
      audioWidgetPosition.value = 70.0;
    } else {
      audioWidgetPosition.value = -240.0;
      panelController.hide();
    }
  }

  Future<void> pageChanged(int index) async {
    currentPage.value = index + 1;
    sl<PlayListController>().reset();
    panelController.hide();
    isShowControl.value = false;
    audioWidgetPosition.value = -240;
    sl<AyatController>().isSelected.value = (-1.0);
    sl<AudioController>().pageAyahNumber = '0';

    sl<BookmarksController>().getBookmarks();
    SoraBookmark soraBookmark =
        sl<BookmarksController>().soraBookmarkList![index];
    soMName.value = '${soraBookmark.SoraNum! + 1}';
    sl<SharedPrefServices>().saveInteger(MSTART_PAGE, index + 1);
    sl<SharedPreferences>()
        .setString(MLAST_URAH, (soraBookmark.SoraNum! + 1).toString());
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
      .firstWhere((s) => s.pageNum == currentPage.value)
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

  void showTafseerWhenCollapsed() {
    if (SlidingUpPanelStatus.collapsed == panelController.status) {
      slideWidgetSwitch(0);
    }
  }

  slideWidgetSwitch(int val) {
    switch (val) {
      case 0:
        slideWidget.value = ShowTafseer();
        break;
      case 1:
        slideWidget.value = QuranSearch();
        break;
      case 2:
        slideWidget.value = SurahJuzList();
        break;
      case 3:
        slideWidget.value = NotesList();
        break;
      case 4:
        slideWidget.value = const BookmarksList();
        break;
      default:
        slideWidget.value = ShowTafseer();
    }
    return slideWidget.value;
  }

  PageController pageController() {
    return quranPageController = PageController(
        initialPage: sl<GeneralController>().currentPage.value - 1,
        keepPage: true);
  }

  PageController dPageController({double? viewport}) {
    return quranPageController = PageController(
        viewportFraction: viewport!,
        initialPage: sl<GeneralController>().currentPage.value - 1,
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
}
