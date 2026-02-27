part of '../../../quran.dart';

extension QuranGetters on QuranController {
  /// -------- [Getter] ----------

  List<List<AyahModel>> getCurrentPageAyahsSeparatedForBasmalah(
    int pageIndex,
  ) => QuranLibrary.quranCtrl.state.pages[pageIndex]
      .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
      .toList();

  List<AyahModel> getPageAyahsByIndex(int pageIndex) =>
      QuranLibrary.quranCtrl.state.pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => QuranLibrary.quranCtrl.surahs
      .firstWhere(
        (s) => s.ayahs.firstWhereOrNull((a) => a.page == pageNumber) != null,
      )
      .surahNumber;

  SurahModel getCurrentSurahByPage(int pageNumber) => QuranLibrary()
      .getCurrentSurahDataByPageNumber(pageNumber: pageNumber + 1);

  SurahModel getSurahDataByAyah(AyahModel ayah) =>
      QuranLibrary().getCurrentSurahDataByAyah(ayah: ayah);

  SurahModel getSurahDataByAyahUQ(int ayah) => QuranLibrary()
      .getCurrentSurahDataByAyahUniqueNumber(ayahUniqueNumber: ayah);

  AyahModel getJuzByPage(int page) =>
      QuranLibrary().getJuzByPageNumber(pageNumber: page);

  List<AyahModel> get currentPageAyahs =>
      state.pages[QuranCtrl.instance.state.currentPageNumber.value - 1];

  RxBool getCurrentJuzNumber(int juzNum) =>
      getJuzByPage(QuranCtrl.instance.state.currentPageNumber.value).juz - 1 ==
          juzNum
      ? true.obs
      : false.obs;

  // PageController get pageController {
  //   return state.quranPageController = PageController(
  //     viewportFraction:
  //         (Responsive.isDesktop(Get.context!) && Get.context!.isLandscape)
  //         ? 1 / 2
  //         : 1,
  //     initialPage: state.box.read(MSTART_PAGE) ?? 0,
  //     keepPage: true,
  //   );
  // }

  /// فهرس السورة الحالية (0-based) بناءً على الصفحة المعروضة
  int get currentSurahIndex {
    try {
      final currentPage = QuranCtrl.instance.state.currentPageNumber.value;
      final surahNumber = getCurrentSurahByPage(currentPage - 1).surahNumber;
      return (surahNumber - 1).clamp(0, 113);
    } catch (_) {
      return 0;
    }
  }

  ScrollController get surahController {
    final suraNumber = currentSurahIndex;
    if (state.surahController == null) {
      state.surahController = ScrollController(
        initialScrollOffset: state.surahItemHeight * suraNumber,
      );
    }
    return state.surahController!;
  }

  /// تمرير قائمة السور إلى السورة الحالية
  void scrollToCurrentSurah() {
    final ctrl = surahController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctrl.hasClients) {
        final max = ctrl.position.maxScrollExtent;
        final desired =
            (currentSurahIndex * state.surahItemHeight) -
            (state.surahItemHeight * 1.5);
        final target = desired.clamp(0.0, max);
        ctrl.animateTo(
          target,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// فهرس الجزء الحالي (0-based)
  int get currentJuzIndex =>
      getJuzByPage(QuranCtrl.instance.state.currentPageNumber.value).juz - 1;

  ScrollController get juzController {
    if (state.juzListController == null) {
      final juzIdx = currentJuzIndex.clamp(0, 29);
      state.juzListController = ScrollController(
        initialScrollOffset: state.juzItemHeight * juzIdx,
      );
    }
    return state.juzListController!;
  }

  /// تمرير قائمة الأجزاء إلى الجزء الحالي
  void scrollToCurrentJuz() {
    final ctrl = juzController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctrl.hasClients) {
        final max = ctrl.position.maxScrollExtent;
        final juzIdx = currentJuzIndex.clamp(0, 29);
        final desired =
            (juzIdx * state.juzItemHeight) - (state.juzItemHeight * 1.0);
        final target = desired.clamp(0.0, max);
        ctrl.animateTo(
          target,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
    } else if (themeCtrl.isGreenMode) {
      return SvgPath.svgSurahBanner4;
    } else {
      return SvgPath.svgSurahBanner3;
    }
  }
}
