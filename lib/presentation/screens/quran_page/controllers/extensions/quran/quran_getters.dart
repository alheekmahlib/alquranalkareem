part of '../../../quran.dart';

final themeCtrl = ThemeController.instance;

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

  WordInfoBottomSheetStyle get wordInfoStyle =>
      WordInfoBottomSheetStyle.defaults(
        isDark: ThemeController.instance.isDarkMode,
        context: Get.context!,
      ).copyWith(
        backgroundColor: Colors.transparent,
        innerBorderColor: Colors.transparent,
        innerShadowColor: Colors.transparent,
        tafsirBackgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        horizontalMargin: 0.0,
        dividerHeight: 0.0,
        verticalMargin: 0.0,
        textBackgroundColor: Colors.transparent,
        downloadText: 'download'.tr,
        downloadingText: 'downloading'.tr,
        loadErrorText: 'load_error'.tr,
        noDataText: 'no_data'.tr,
        unavailableDataTemplate: 'unavailableDataTemplate'.trParams({
          'kind': '${WordInfoCtrl.instance.selectedKind.value.name}'.tr,
        }),
        tabRecitationsText: 'recitations'.tr,
        tabTasreefText: 'tasreef'.tr,
        tabEerabText: 'eerab'.tr,
        withTitle: false,
        withWordText: false,
        withWordAudioButton: false,
        handleWidget: const SizedBox.shrink(),
        tabIndicatorColor: Get.theme.colorScheme.surface.withValues(alpha: .5),
        tabIndicatorPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        innerContainerPadding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        tabBackgroundColor: Colors.transparent,
        tabLabelStyle: AppTextStyles.titleSmall(),
        innerContainerBoxShadow: const [],
        tabBarHeight: 40.0,
        innerBorderWidth: .1,
        borderRadius: 8.0,
        tabIndicatorRadius: 8.0,
        innerContainerBorderRadius: 8.0,
        downloadButtonWidget: (context, kind) {
          final ctrl = WordInfoCtrl.instance;
          final isDownloading =
              ctrl.isDownloading.value && ctrl.downloadingKind.value == kind;
          return ContainerButton(
            onPressed: () async {
              isDownloading ? null : await ctrl.downloadKind(kind);
            },
            height: 40.0,
            width: 250.0,
            isTitleCentered: true,
            title: isDownloading ? 'downloading'.tr : 'download'.tr,
            horizontalPadding: 16.0,
            verticalPadding: 2.0,
            backgroundColor: Get.theme.colorScheme.surface,
            progressColor: Get.theme.colorScheme.primary.withValues(alpha: .2),
            isDownloading: isDownloading,
            downloadProgress: ctrl.downloadProgress.value.toStringAsFixed(0),
            isPreparingDownload:
                ctrl.isPreparingDownload.value &&
                ctrl.downloadingKind.value == kind,
          );
        },
      );

  DisplayModeBarStyle get displayModeBarStyle =>
      DisplayModeBarStyle.defaults(
        isDark: themeCtrl.isDarkMode,
        context: Get.context!,
      ).copyWith(
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        selectedIconColor: Get.theme.canvasColor,
        unselectedIconColor: Get.theme.primaryColorLight,
        borderRadius: 16.0,
        position: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      );

  AyahTafsirInlineStyle get ayahTafsirInlineStyle =>
      AyahTafsirInlineStyle.defaults(
        isDark: themeCtrl.isDarkMode,
        context: Get.context!,
      ).copyWith(
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        tafsirBackgroundColor: Get.theme.colorScheme.surface.withValues(
          alpha: .2,
        ),
        ayahTextColor: Get.theme.colorScheme.inversePrimary,
        fontSizeWidget: const SizedBox().fontSizeDropDownWidget(),
        ayahFontSize: TafsirCtrl.instance.fontSizeArabic.value,
        tafsirFontSize: TafsirCtrl.instance.fontSizeArabic.value,
        dividerColor: Get.theme.colorScheme.surface.withValues(alpha: .5),
        optionsBarWidget: (ayah, surah, pageIndex) =>
            AyahsMenu(ayah: ayah, surah: surah, pageIndex: pageIndex),
      );

  TafsirStyle get tafsirStyle {
    final tajweedCtrl = TajweedAyaCtrl.instance;
    final isDownloading = tajweedCtrl.isDownloading.value;
    return TafsirStyle.defaults(
      context: Get.context!,
      isDark: ThemeController.instance.isDarkMode,
    ).copyWith(
      handleWidget: const SizedBox.shrink(),
      backgroundColor: Get.theme.colorScheme.primary,
      textColor: Get.theme.colorScheme.inversePrimary,
      backgroundTitleColor: Get.theme.colorScheme.surface.withValues(alpha: .5),
      fontSizeWidget: const SizedBox().fontSizeDropDownWidget(),
      // fontSize: generalCtrl.state.fontSizeArabic.value,
      currentTafsirColor: Get.theme.colorScheme.surface,
      selectedTafsirBorderColor: Get.theme.colorScheme.surface,
      selectedTafsirColor: Get.theme.colorScheme.surface,
      unSelectedTafsirColor: Get.theme.primaryColorLight.withValues(alpha: .8),
      selectedTafsirTextColor: Get.theme.colorScheme.surface,
      unSelectedTafsirTextColor: Get.theme.canvasColor.withValues(alpha: .8),
      unSelectedTafsirBorderColor: Colors.transparent,
      dividerColor: Get.theme.colorScheme.surface.withValues(alpha: .5),
      textTitleColor: Get.theme.canvasColor,
      horizontalMargin: 6.0,
      tafsirBackgroundColor: Get.theme.colorScheme.primaryContainer,
      fontSize: TafsirCtrl.instance.fontSizeArabic.value,
      tafsirNameWidget: const SizedBox().customSvgWithCustomColor(
        SvgPath.svgTafseerWhite,
        color: Get.theme.canvasColor,
        height: 25,
      ),
      footnotesName: 'footnotes'.tr,
      tafsirName: 'tafseer'.tr,
      translateName: 'translation'.tr,
      widthOfBottomSheet: 500,
      heightOfBottomSheet: Get.height * .9,
      downloadIconColor: Get.theme.canvasColor,
      tabBarLabelStyle: AppTextStyles.titleMedium(
        fontSize: 18,
        color: Get.theme.canvasColor,
      ),
      changeTafsirDialogWidth: 350.0,
      dialogCloseIconColor: Get.theme.colorScheme.inversePrimary,
      dialogHeaderBackgroundGradient: LinearGradient(
        colors: [
          Get.theme.colorScheme.surface.withValues(alpha: .5),
          Get.theme.colorScheme.primaryContainer,
        ],
        begin: AlignmentDirectional.centerEnd,
        end: AlignmentDirectional.centerStart,
      ),
      dialogHeaderTitleColor: Get.theme.colorScheme.inversePrimary,
      dialogHeaderTitle: 'changeTafsir'.tr,
      currentTafsirTextStyle: AppTextStyles.titleMedium(
        fontSize: 18,
        color: Get.theme.canvasColor,
      ),
      tabBarUnselectedLabelStyle: AppTextStyles.titleMedium(
        fontSize: 16,
        color: Get.theme.canvasColor.withValues(alpha: .6),
      ),
      dialogHeaderTitleTextStyle: AppTextStyles.titleMedium(),
      dialogTypeTextStyle: AppTextStyles.titleMedium(),
      tafsirTextTextStyle: AppTextStyles.titleMedium(fontSize: 17),
      tajweedUnavailableText:
          'tajweedUnavailableText'.tr, // بيانات أحكام التجويد غير محمّلة.
      tajweedSurahNumberErrorText:
          'tajweedSurahNumberErrorText'.tr, // تعذّر تحديد رقم السورة
      tajweedLoadErrorText:
          'tajweedLoadErrorText'.tr, // تعذّر تحميل بيانات أحكام التجويد
      tajweedNoDataText:
          'tajweedNoDataText'.tr, // لا توجد بيانات تجويد لهذه الآية.
      tajweedStatusTextStyle: AppTextStyles.titleSmall(),
      tafsirIsEmptyNote: 'noTafsirForThisAyah'.tr, // لا يوجد تفسير لهذه الآية
      tajweedDownloadButtonWidget: ContainerButton(
        onPressed: () async {
          isDownloading ? null : await tajweedCtrl.download();
        },
        height: 40.0,
        width: 250.0,
        isTitleCentered: true,
        title: isDownloading ? 'downloading'.tr : 'download'.tr,
        horizontalPadding: 16.0,
        verticalPadding: 2.0,
        backgroundColor: Get.theme.colorScheme.surface,
        progressColor: Get.theme.colorScheme.primary.withValues(alpha: .2),
        isDownloading: isDownloading,
        downloadProgress: tajweedCtrl.downloadProgress.value.toStringAsFixed(0),
        isPreparingDownload:
            isDownloading || tajweedCtrl.isPreparingDownload.value,
      ),
      tajweedMarkedTextStyle: AppTextStyles.titleMedium(),
      tafsirDropdownWidget: const SizedBox().customSvgWithColor(
        SvgPath.svgHomeArrowDown,
        color: Get.theme.colorScheme.surface,
        height: 10,
      ),
      dialogBackgroundColor: Get.theme.colorScheme.primaryContainer,
      downloadTafsirIconWidget: const SizedBox().customSvgWithColor(
        height: 25,
        width: 25,
        SvgPath.svgAudioDownload,
        color: Get.theme.colorScheme.primary,
      ),
      removeTafsirIconWidget: const SizedBox().customSvgWithColor(
        height: 25,
        width: 25,
        SvgPath.svgHomeRemove,
        color: Get.theme.colorScheme.error,
      ),
    );
  }
}
