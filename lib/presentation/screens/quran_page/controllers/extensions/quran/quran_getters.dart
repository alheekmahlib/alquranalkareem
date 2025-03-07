part of '../../../quran.dart';

extension QuranGetters on QuranController {
  /// -------- [Getter] ----------

  List<List<AyahFontsModel>> getCurrentPageAyahsSeparatedForBasmalah(
          int pageIndex) =>
      QuranLibrary()
          .quranCtrl
          .state
          .pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<AyahFontsModel> getPageAyahsByIndex(int pageIndex) =>
      QuranLibrary().quranCtrl.state.pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => QuranLibrary()
      .quranCtrl
      .state
      .surahs
      .firstWhere(
          (s) => s.ayahs.firstWhereOrNull((a) => a.page == pageNumber) != null)
      .surahNumber;

  SurahFontsModel getCurrentSurahByPage(int pageNumber) =>
      QuranLibrary().getCurrentSurahDataByPageNumber(pageNumber: pageNumber);

  SurahFontsModel getSurahDataByAyah(AyahFontsModel ayah) =>
      QuranLibrary().getCurrentSurahDataByAyah(ayah: ayah);

  SurahFontsModel getSurahDataByAyahUQ(int ayah) => QuranLibrary()
      .getCurrentSurahDataByAyahUniqueNumber(ayahUniqueNumber: ayah);

  AyahFontsModel getJuzByPage(int page) =>
      QuranLibrary().getJuzByPageNumber(pageNumber: page);

  List<AyahFontsModel> get currentPageAyahs =>
      state.pages[state.currentPageNumber.value - 1];

  RxBool getCurrentJuzNumber(int juzNum) =>
      getJuzByPage(state.currentPageNumber.value).juz - 1 == juzNum
          ? true.obs
          : false.obs;

  PageController get pageController {
    return state.quranPageController = PageController(
        viewportFraction:
            (Responsive.isDesktop(Get.context!) && Get.context!.isLandscape)
                ? 1 / 2
                : 1,
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
