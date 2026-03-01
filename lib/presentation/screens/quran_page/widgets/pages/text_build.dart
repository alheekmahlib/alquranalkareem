part of '../../quran.dart';

class TextBuild extends StatelessWidget {
  TextBuild({super.key});

  final audioCtrl = AudioCtrl.instance;
  final quranCtrl = QuranController.instance;
  final bookmarkCtrl = BookmarksController.instance;
  final themeCtrl = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    final bookmarkTextList = BookmarksController.instance.bookmarkTextList;
    bool isAyahBookmarked(AyahModel ayah) =>
        BookmarksController.instance.hasBookmark(
              ayah.surahNumber!,
              ayah.ayahUQNumber,
            ) ==
            true
        ? true
        : false;
    return Center(
      child: GetBuilder<QuranController>(
        id: 'clearSelection',
        builder: (quranCtrl) => QuranLibraryScreen(
          parentContext: context,
          isDark: themeCtrl.isDarkMode,
          isShowTabBar: true,
          withPageView: true,
          isFontsLocal: false,
          useDefaultAppBar: false,
          isShowAudioSlider: false,
          enableWordSelection: false,
          showAyahBookmarkedIcon: true,
          bookmarkList: bookmarkTextList,
          backgroundColor: Colors.transparent,
          appLanguageCode: Get.locale!.languageCode,
          onPagePress: () => quranCtrl.clearSelection(),
          textColor: Get.theme.colorScheme.inversePrimary,
          ayahIconColor: Get.theme.colorScheme.inverseSurface,
          ayahSelectedBackgroundColor: Get.theme.highlightColor,
          bookmarksColor: const Color(0xffCD9974).withValues(alpha: .4),
          isAyahBookmarked: (ayah) => isAyahBookmarked(ayah),
          topBottomQuranStyle:
              TopBottomQuranStyle.defaults(
                isDark: themeCtrl.isDarkMode,
                context: context,
              ).copyWith(
                juzName: 'juz'.tr,
                sajdaName: 'sajda'.tr,
                hizbName: 'hizb'.tr,
                customChildBuilder: (context, pageIndex) => GestureDetector(
                  onTap: () => bookmarkCtrl.addPageBookmarkOnTap(pageIndex),
                  child: _BookmarkIcon(
                    height: context.customOrientation(30.h, 40.h),
                    pageNum: pageIndex + 1,
                  ),
                ),
              ),
          surahInfoStyle: SurahInfoStyle(
            ayahCount: 'aya_count'.tr,
            backgroundColor: Get.theme.colorScheme.primaryContainer,
            closeIconColor: Get.theme.colorScheme.inversePrimary,
            firstTabText: 'surahNames'.tr,
            secondTabText: 'aboutSurah'.tr,
            indicatorColor: Get.theme.colorScheme.surface,
            primaryColor: Get.theme.colorScheme.surface.withValues(alpha: .2),
            surahNameColor: Get.theme.colorScheme.primary,
            surahNumberColor: Get.theme.hintColor,
            textColor: Get.theme.colorScheme.inversePrimary,
            titleColor: Get.theme.hintColor,
          ),
          onAyahLongPress: (details, ayah) {
            final surah = QuranLibrary().getCurrentSurahDataByAyah(ayah: ayah);
            AyahMenuHelper.show(
              context,
              surah: surah,
              ayah: ayah,
              pageIndex: ayah.page - 1,
            );
            log('ayahUQNumber: ${ayah.ayahUQNumber}');
            // quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
          },
          tafsirStyle:
              TafsirStyle.defaults(
                isDark: themeCtrl.isDarkMode,
                context: context,
              ).copyWith(
                backgroundColor: Get.theme.colorScheme.primary,
                textColor: Get.theme.canvasColor,
                backgroundTitleColor: Get.theme.colorScheme.surface.withValues(
                  alpha: .5,
                ),
                fontSizeWidget: fontSizeDropDownWidget(),
                fontSize: GeneralController.instance.state.fontSizeArabic.value,
                currentTafsirColor: Get.theme.colorScheme.surface,
                selectedTafsirBorderColor: Get.theme.colorScheme.surface,
                selectedTafsirColor: Get.theme.colorScheme.surface,
                unSelectedTafsirColor: Get.theme.canvasColor.withValues(
                  alpha: .8,
                ),
                selectedTafsirTextColor: Get.theme.colorScheme.surface,
                unSelectedTafsirTextColor: Get.theme.canvasColor.withValues(
                  alpha: .8,
                ),
                unSelectedTafsirBorderColor: Colors.transparent,
                dividerColor: Get.theme.colorScheme.surface.withValues(
                  alpha: .5,
                ),
                textTitleColor: context.theme.canvasColor,
                horizontalMargin: 16.0,
                tafsirBackgroundColor: Get.theme.colorScheme.primaryContainer,
                tafsirNameWidget: customSvgWithCustomColor(
                  SvgPath.svgTafseerWhite,
                  color: Get.theme.canvasColor,
                  height: 25,
                ),
                dialogCloseIconColor: context.theme.canvasColor,
                dialogHeaderBackgroundGradient: LinearGradient(
                  colors: [
                    Get.theme.colorScheme.surface,
                    Get.theme.colorScheme.surface.withValues(alpha: .7),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                dialogHeaderTitleColor: context.theme.canvasColor,
                footnotesName: 'footnotes'.tr,
                tafsirName: 'tafseer'.tr,
                translateName: 'translation'.tr,
                dialogHeaderTitle: 'chapterTafsir'.tr,
              ),
        ),
      ),
    );
  }
}

class _BookmarkIcon extends StatelessWidget {
  final int? pageNum;
  final double? height;
  const _BookmarkIcon({this.pageNum, this.height});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Semantics(
        button: true,
        enabled: true,
        label: 'Add Bookmark',
        child: customSvg(
          BookmarksController.instance
                  .hasPageBookmark(
                    pageNum ?? QuranCtrl.instance.state.currentPageNumber.value,
                  )
                  .value
              ? SvgPath.svgBookmarked
              : Get.context!.bookmarkPageIconPath(),
          height: height,
        ),
      );
    });
  }
}
