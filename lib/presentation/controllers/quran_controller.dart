import 'dart:convert';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/global_key_manager.dart';
import '../screens/quran_page/data/model/surahs_model.dart';

// late GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

class QuranController extends GetxController {
  static QuranController get instance => Get.isRegistered<QuranController>()
      ? Get.find<QuranController>()
      : Get.put<QuranController>(QuranController());
  List<Surah> surahs = [];
  List<List<Ayah>> pages = [];
  List<Ayah> allAyahs = [];

  var selectedAyahIndexes = <int>[].obs;
  bool isSelected = false;
  final ScrollController scrollIndicatorController = ScrollController();
  final ScrollController ayahsScrollController = ScrollController();
  RxInt selectedIndicatorIndex = 0.obs;
  PreferDirection preferDirection = PreferDirection.topCenter;
  RxDouble textWidgetPosition = (-240.0).obs;
  RxBool isPlayExpanded = false.obs;
  RxBool isSajda = false.obs;
  RxInt isPages = 0.obs;
  RxInt isBold = 0.obs;
  RxBool isMoreOptions = false.obs;
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  final scrollOffsetController = ScrollOffsetController();
  var moreOptionsMap = <String, bool>{}.obs;
  RxInt selectMushafSettingsPage = 0.obs;
  RxDouble ayahsWidgetHeight = 0.0.obs;
  RxInt currentListPage = 1.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxDouble baseScaleFactor = 1.0.obs;
  final box = GetStorage();

  Widget textScale(dynamic widget1, dynamic widget2) {
    if (scaleFactor.value <= 1.0) {
      return widget1;
    } else {
      return widget2;
    }
  }

  List<int> downThePageIndex = [
    75,
    206,
    330,
    340,
    348,
    365,
    375,
    413,
    416,
    444,
    451,
    497,
    505,
    524,
    547,
    554,
    556,
    583
  ];
  List<int> topOfThePageIndex = [
    76,
    207,
    331,
    341,
    349,
    366,
    376,
    414,
    417,
    435,
    445,
    452,
    498,
    506,
    525,
    548,
    554,
    555,
    557,
    583,
    584
  ];

  final generalCtrl = GeneralController.instance;
  final themeCtrl = ThemeController.instance;

  @override
  void onInit() async {
    super.onInit();
    await loadQuran();
    itemPositionsListener.itemPositions.addListener(_updatePageNumber);
    itemPositionsListener.itemPositions.addListener(currentListPageNumber);
    isBold.value = box.read(IS_BOLD) ?? 0;
  }

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    surahs = surahsJson.map((s) => Surah.fromJson(s)).toList();

    for (final surah in surahs) {
      allAyahs.addAll(surah.ayahs);
      // log('Added ${surah.arabicName} ayahs');
      update();
    }
    List.generate(604, (pageIndex) {
      pages.add(allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList());
    });
    // log('Pages Length: ${pages.length}', name: 'Quran Controller');
  }

  List<List<Ayah>> getCurrentPageAyahsSeparatedForBasmalah(int pageIndex) =>
      pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<Ayah> getPageAyahsByIndex(int pageIndex) => pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => surahs
      .firstWhere(
          (s) => s.ayahs.contains(getPageAyahsByIndex(pageNumber).first))
      .surahNumber;

  Surah getCurrentSurahByPage(int pageNumber) => surahs.firstWhere(
      (s) => s.ayahs.contains(getPageAyahsByIndex(pageNumber).first));

  String getSurahNameFromPage(int pageNumber) {
    try {
      return surahs
          .firstWhere(
              (s) => s.ayahs.contains(getPageAyahsByIndex(pageNumber).first))
          .arabicName;
    } catch (e) {
      return "Surah not found";
    }
  }

  int getSurahNumberByAyah(Ayah ayah) =>
      surahs.firstWhere((s) => s.ayahs.contains(ayah)).surahNumber;

  Surah getSurahDataByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  Ayah getJuzByPage(int page) => allAyahs.firstWhere((a) => a.page == page + 1);

  String getSurahByAyahUQ(int ayah) => surahs
      .firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah))
      .arabicName;

  // Assuming `lastDisplayedHizbQuarter` is a class variable that keeps track of the last displayed Hizb quarter.
  int? lastDisplayedHizbQuarter;
  Map<int, int> pageToHizbQuarterMap = {};

  String getHizbQuarterDisplayByPage(int pageNumber) {
    final List<Ayah> currentPageAyahs =
        allAyahs.where((ayah) => ayah.page == pageNumber).toList();
    if (currentPageAyahs.isEmpty) return "";

    // Find the highest Hizb quarter on the current page
    int? currentMaxHizbQuarter =
        currentPageAyahs.map((ayah) => ayah.hizbQuarter).reduce(math.max);

    // Store/update the highest Hizb quarter for this page
    pageToHizbQuarterMap[pageNumber] = currentMaxHizbQuarter;

    // For displaying the Hizb quarter, check if this is a new Hizb quarter different from the previous page's Hizb quarter
    // For the first page, there is no "previous page" to compare, so display its Hizb quarter
    if (pageNumber == 1 ||
        pageToHizbQuarterMap[pageNumber - 1] != currentMaxHizbQuarter) {
      int hizbNumber = ((currentMaxHizbQuarter - 1) ~/ 4) + 1;
      int quarterPosition = (currentMaxHizbQuarter - 1) % 4;

      switch (quarterPosition) {
        case 0:
          return "الحزب ${'$hizbNumber'.convertNumbers()}";
        case 1:
          return "١/٤ الحزب ${'$hizbNumber'.convertNumbers()}";
        case 2:
          return "١/٢ الحزب ${'$hizbNumber'.convertNumbers()}";
        case 3:
          return "٣/٤ الحزب ${'$hizbNumber'.convertNumbers()}";
        default:
          return "";
      }
    }

    // If the page's Hizb quarter is the same as the previous page, do not display it again
    return "";
  }

  bool getSajdaInfoForPage(List<Ayah> pageAyahs) {
    for (var ayah in pageAyahs) {
      if (ayah.sajda != false && ayah.sajda is Map) {
        var sajdaDetails = ayah.sajda;
        if (sajdaDetails['recommended'] == true ||
            sajdaDetails['obligatory'] == true) {
          return isSajda.value = true;
        }
      }
    }
    // No sajda found on this page
    return isSajda.value = false;
  }

  List<Ayah> get currentPageAyahs =>
      pages[generalCtrl.currentPageNumber.value - 1];

  Ayah? getAyahWithSajdaInPage(int pageIndex) =>
      pages[pageIndex].firstWhereOrNull((ayah) {
        if (ayah.sajda != false) {
          if (ayah.sajda is Map) {
            var sajdaDetails = ayah.sajda;
            if (sajdaDetails['recommended'] == true ||
                sajdaDetails['obligatory'] == true) {
              return isSajda.value = true;
            }
          } else {
            return ayah.sajda == true;
          }
        }
        return isSajda.value = false;
      });

  void toggleAyahSelection(int index) {
    if (selectedAyahIndexes.contains(index)) {
      selectedAyahIndexes.remove(index);
    } else {
      selectedAyahIndexes.clear();
      selectedAyahIndexes.add(index);
      selectedAyahIndexes.refresh();
    }
    selectedAyahIndexes.refresh();
  }

  void clearAndAddSelection(int index) {
    selectedAyahIndexes.clear();
    selectedAyahIndexes.add(index);
    selectedAyahIndexes.refresh();
  }

  void indicatorOnTap(int pageNumber, int itemWidth, double screenWidth) {
    sl<GeneralController>().currentPageNumber.value = pageNumber;
    selectedIndicatorIndex.value = pageNumber;
    final targetOffset =
        itemWidth * pageNumber - (screenWidth * .69 / 2) + itemWidth / 2;
    scrollIndicatorController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    generalCtrl.quranPageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void indicatorScroll(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 80;
    selectedIndicatorIndex.value =
        sl<GeneralController>().currentPageNumber.value;
    if (scrollIndicatorController.hasClients) {
      final targetOffset =
          itemWidth * sl<GeneralController>().currentPageNumber.value -
              (screenWidth * .69 / 2) +
              itemWidth / 2;
      scrollIndicatorController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      // Handle the case where the scroll view is not ready
    }
  }

  showControl() {
    generalCtrl.isShowControl.value = !generalCtrl.isShowControl.value;
  }

  void toggleMenu(String verseKey) {
    var currentState = moreOptionsMap[verseKey] ?? false;
    moreOptionsMap[verseKey] = !currentState;
    moreOptionsMap.forEach((key, value) {
      if (key != verseKey) moreOptionsMap[key] = false;
    });
    update();
  }

  Future<void> loadSwitchValue() async {
    isPages.value = await box.read(SWITCH_VALUE) ?? 0;
  }

  void switchMode(int newMode) {
    isPages.value = newMode;
    selectMushafSettingsPage.value = newMode;
    box.write(SWITCH_VALUE, newMode);
    Get.back();
    update();
    if (newMode == 1) {
      Future.delayed(const Duration(milliseconds: 600)).then((_) {
        if (itemScrollController.isAttached) {
          itemScrollController.jumpTo(
            index: generalCtrl.currentPageNumber.value - 1,
          );
        }
      });
    } else {
      generalCtrl.currentPageNumber.value =
          itemPositionsListener.itemPositions.value.last.index + 1;
    }
  }

  void changeSurahListOnTap(int page) {
    sl<GeneralController>().currentPageNumber.value = page - 1;
    if (isPages == 1) {
      itemScrollController.jumpTo(
        index: page - 1,
      );
    } else {
      sl<GeneralController>().quranPageController.animateToPage(
            page - 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
    }
    GlobalKeyManager().drawerKey.currentState!.closeSlider();
  }

  void currentListPageNumber() {
    final positions = itemPositionsListener.itemPositions.value;
    final filteredPositions =
        positions.where((position) => position.itemLeadingEdge >= 0);
    if (filteredPositions.isNotEmpty) {
      final firstItemIndex = filteredPositions
          .reduce((minPosition, position) =>
              position.itemLeadingEdge < minPosition.itemLeadingEdge
                  ? position
                  : minPosition)
          .index;
      currentListPage.value = firstItemIndex;
    }
  }

  void _updatePageNumber() {
    final positions = itemPositionsListener.itemPositions.value;
    final filteredPositions =
        positions.where((position) => position.itemLeadingEdge >= 0);
    if (filteredPositions.isNotEmpty) {
      final firstItemIndex = filteredPositions
          .reduce((minPosition, position) =>
              position.itemLeadingEdge < minPosition.itemLeadingEdge
                  ? position
                  : minPosition)
          .index;
      box.write(MSTART_PAGE, firstItemIndex + 1);
    } else {}
  }

  @override
  void onClose() {
    itemPositionsListener.itemPositions.removeListener(_updatePageNumber);
    itemPositionsListener.itemPositions.removeListener(currentListPageNumber);
    super.onClose();
  }
}
