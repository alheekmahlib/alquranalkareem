import 'dart:math' as math;

import 'package:alquranalkareem/presentation/controllers/theme_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/utils/helpers/responsive.dart';
import '../../data/model/surahs_model.dart';
import '../quran/quran_controller.dart';

extension QuranGetters on QuranController {
  /// -------- [Getter] ----------

  List<int> get downThePageIndex => [
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
  List<int> get topOfThePageIndex => [
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

  List<List<Ayah>> getCurrentPageAyahsSeparatedForBasmalah(int pageIndex) =>
      state.pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<Ayah> getPageAyahsByIndex(int pageIndex) => state.pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => state.surahs
      .firstWhere(
          (s) => s.ayahs.firstWhereOrNull((a) => a.page == pageNumber) != null)
      .surahNumber;

  List<Surah> getSurahsByPage(int pageNumber) {
    List<Ayah> pageAyahs = getPageAyahsByIndex(pageNumber);
    List<Surah> surahsOnPage = [];
    for (Ayah ayah in pageAyahs) {
      Surah surah = state.surahs.firstWhere((s) => s.ayahs.contains(ayah),
          orElse: () => Surah(
              surahNumber: -1,
              arabicName: 'Unknown',
              englishName: 'Unknown',
              revelationType: 'Unknown',
              surahNames: 'Unknown',
              surahNamesFromBook: 'Unknown',
              surahInfo: 'Unknown',
              surahInfoFromBook: 'Unknown',
              ayahs: []));
      if (!surahsOnPage.any((s) => s.surahNumber == surah.surahNumber) &&
          surah.surahNumber != -1) {
        surahsOnPage.add(surah);
      }
    }
    return surahsOnPage;
  }

  Surah getCurrentSurahByPage(int pageNumber) => state.surahs.firstWhere(
      (s) => s.ayahs.contains(getPageAyahsByIndex(pageNumber).first));

  Surah getSurahDataByAyah(Ayah ayah) =>
      state.surahs.firstWhere((s) => s.ayahs.contains(ayah));

  Surah getSurahDataByAyahUQ(int ayah) => state.surahs
      .firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  Ayah getJuzByPage(int page) =>
      state.allAyahs.firstWhere((a) => a.page == page + 1);

  String getHizbQuarterDisplayByPage(int pageNumber) {
    final List<Ayah> currentPageAyahs =
        state.allAyahs.where((ayah) => ayah.page == pageNumber).toList();
    if (currentPageAyahs.isEmpty) return "";

    // Find the highest Hizb quarter on the current page
    int? currentMaxHizbQuarter =
        currentPageAyahs.map((ayah) => ayah.hizbQuarter).reduce(math.max);

    // Store/update the highest Hizb quarter for this page
    state.pageToHizbQuarterMap[pageNumber] = currentMaxHizbQuarter;

    // For displaying the Hizb quarter, check if this is a new Hizb quarter different from the previous page's Hizb quarter
    // For the first page, there is no "previous page" to compare, so display its Hizb quarter
    if (pageNumber == 1 ||
        state.pageToHizbQuarterMap[pageNumber - 1] != currentMaxHizbQuarter) {
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
          return state.isSajda.value = true;
        }
      }
    }
    // No sajda found on this page
    return state.isSajda.value = false;
  }

  List<Ayah> get currentPageAyahs =>
      state.pages[state.currentPageNumber.value - 1];

  Ayah? getAyahWithSajdaInPage(int pageIndex) =>
      state.pages[pageIndex].firstWhereOrNull((ayah) {
        if (ayah.sajda != false) {
          if (ayah.sajda is Map) {
            var sajdaDetails = ayah.sajda;
            if (sajdaDetails['recommended'] == true ||
                sajdaDetails['obligatory'] == true) {
              return state.isSajda.value = true;
            }
          } else {
            return ayah.sajda == true;
          }
        }
        return state.isSajda.value = false;
      });

  RxBool getCurrentSurahNumber(int surahNum) =>
      getCurrentSurahByPage(state.currentPageNumber.value).surahNumber - 1 ==
              surahNum
          ? true.obs
          : false.obs;

  RxBool getCurrentJuzNumber(int juzNum) =>
      getJuzByPage(state.currentPageNumber.value).juz - 1 == juzNum
          ? true.obs
          : false.obs;

  PageController get pageController {
    return state.quranPageController = PageController(
        viewportFraction: Responsive.isDesktop(Get.context!) ? 1 / 2 : 1,
        initialPage: state.currentPageNumber.value - 1,
        keepPage: true);
  }

  ScrollController get surahController {
    final suraNumber =
        getCurrentSurahByPage(state.currentPageNumber.value - 1).surahNumber -
            1;
    if (state.surahController == null) {
      state.surahController = ScrollController(
        initialScrollOffset: state.surahItemHeight * suraNumber,
      );
    }
    return state.surahController!;
  }

  ScrollController get juzController {
    if (state.juzListController == null) {
      state.juzListController = ScrollController(
        initialScrollOffset: state.surahItemHeight *
            getJuzByPage(state.currentPageNumber.value).juz,
      );
    }
    return state.juzListController!;
  }

  Color get backgroundColor => state.backgroundPickerColor.value == 0xfffaf7f3
      ? Get.theme.colorScheme.surfaceContainer
      : ThemeController.instance.isDarkMode
          ? Get.theme.colorScheme.surfaceContainer
          : Color(state.backgroundPickerColor.value);

  String get surahBannerPath {
    if (themeCtrl.isBlueMode) {
      return SvgPath.svgSurahBanner1;
    } else if (themeCtrl.isBrownMode) {
      return SvgPath.svgSurahBanner2;
    } else if (themeCtrl.isOldMode) {
      return SvgPath.svgSurahBanner4;
    } else {
      return SvgPath.svgSurahBanner3;
    }
  }
}
