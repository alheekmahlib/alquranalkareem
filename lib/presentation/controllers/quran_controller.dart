import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/constants/svg_picture.dart';
import '../screens/quran_page/data/model/surahs_model.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/controllers/theme_controller.dart';

class QuranController extends GetxController {
  // RxInt currentPage = 1.obs;
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
  RxBool isMoreOptions = false.obs;
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  final scrollOffsetController = ScrollOffsetController();
  var moreOptionsMap = <String, bool>{}.obs;
  RxInt selectMushafSettingsPage = 0.obs;
  RxDouble ayahsWidgetHeight = 0.0.obs;
  List<int> lastPlaceBannerPageIndex = [
    75,
    206,
    330,
    340,
    348,
    365,
    375,
    413,
    415,
    434,
    450,
    496,
    504,
    523,
    546,
    554,
    556,
    583
  ];
  List<int> firstPlaceBannerPageIndex = [
    76,
    207,
    331,
    341,
    349,
    366,
    376,
    414,
    416,
    435,
    451,
    497,
    505,
    524,
    547,
    554,
    555,
    557,
    583,
    584
  ];

  final generalCtrl = sl<GeneralController>();
  final themeCtrl = sl<ThemeController>();

  @override
  void onInit() async {
    super.onInit();
    await loadQuran();
  }

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    surahs = surahsJson.map((s) => Surah.fromJson(s)).toList();

    for (final surah in surahs) {
      allAyahs.addAll(surah.ayahs);
      log('Added ${surah.arabicName} ayahs');
      update();
    }
    List.generate(604, (pageIndex) {
      pages.add(allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList());
    });
    log('Pages Length: ${pages.length}', name: 'Quran Controller');
  }

  List<List<Ayah>> getCurrentPageAyahsSeparatedForBasmalah(int pageIndex) =>
      pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<Ayah> getCurrentPageAyahs(int pageIndex) => pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => surahs
      .firstWhere(
          (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first))
      .surahNumber;

  Surah getCurrentSurahByPage(int pageNumber) => surahs.firstWhere(
      (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first));

  String getSurahNameFromPage(int pageNumber) {
    try {
      return surahs
          .firstWhere(
              (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first))
          .arabicName;
    } catch (e) {
      return "Surah not found";
    }
  }

  int getSurahNumberByAyah(Ayah ayah) =>
      surahs.firstWhere((s) => s.ayahs.contains(ayah)).surahNumber;

  Surah getSurahDataByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  String getSurahByAyahUQ(int ayah) => surahs
      .firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah))
      .arabicName;

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

  double getSajdaPosition(int pageIndex) {
    final sajdaAyah = _getAyahWithSajdaInPage(pageIndex);
    final newLineRegex = RegExp(r'\n');
    // final List<Ayah> ayahsAfterSajda = currentPageAyahs
    //     .where((a) => a.ayahUQNumber > sajdaAyah.ayahUQNumber)
    //     .toList();
    // final currentPageAyahsTexts =  currentPageAyahs.map((a)=>a.text);
    // return .indexWhere((ayah) => ayah ==sajdaAyah)+1;
    isSajda.value = sajdaAyah != null ? true : false;
    final lines = pages[pageIndex]
        .map((a) {
          if (a.text.contains('۩')) {
            return '${a.code_v2}۩';
          }
          return a.code_v2;
        })
        .join()
        .split('\n');
    // final lines =newLineRegex
    //     .allMatches(currentPageAyahs.map((a) {
    //   if(a.text.contains('۩')){
    //     return '${a.code_v2}۩';
    //   }
    //   return a.code_v2;
    // }).join()).toList();
    double position =
        (lines.indexWhere((line) => line.contains('۩')) + 1).toDouble();
    log("Sajda Position is: $position");

    return position;
  }

  Ayah? _getAyahWithSajdaInPage(int pageIndex) =>
      pages[pageIndex].firstWhereOrNull((ayah) {
        if (ayah.sajda != false && ayah.sajda is Map) {
          var sajdaDetails = ayah.sajda;
          if (sajdaDetails['recommended'] == true ||
              sajdaDetails['obligatory'] == true) {
            return true;
          }
        }
        return false;
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

  void showVerseToast(int pageIndex) {
    double convertedNumber = getSajdaPosition(pageIndex) / 10.0;
    isSajda.value
        ? BotToast.showCustomText(
            align: Alignment(.8, (convertedNumber + .02)),
            toastBuilder: (void Function() cancelFunc) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sajda_icon(height: 15.0),
                    const Gap(8),
                    Text(
                      'sajda'.tr,
                      style: TextStyle(
                        color: Get.theme.canvasColor,
                        fontFamily: 'kufi',
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              );
            },
          )
        : const SizedBox.shrink();
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
    isPages.value = await sl<SharedPreferences>().getInt(SWITCH_VALUE) ?? 0;
  }

  void switchMode(int newMode) {
    isPages.value = newMode;
    selectMushafSettingsPage.value = newMode;
    sl<SharedPreferences>().setInt(SWITCH_VALUE, newMode);
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
    generalCtrl.drawerKey.currentState!.closeSlider();
  }
}
