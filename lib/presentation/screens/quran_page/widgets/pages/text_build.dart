part of '../../quran.dart';

class TextBuild extends StatelessWidget {
  final int pageIndex;

  TextBuild({super.key, required this.pageIndex});

  final audioCtrl = AudioCtrl.instance;
  final quranCtrl = QuranController.instance;
  final bookmarkCtrl = BookmarksController.instance;
  final themeCtrl = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetBuilder<QuranController>(
        id: 'clearSelection',
        builder: (quranCtrl) => QuranLibraryScreen(
          parentContext: context,
          isDark: themeCtrl.isDarkMode,
          isFontsLocal: true,
          withPageView: false,
          useDefaultAppBar: false,
          isShowAudioSlider: false,
          pageIndex: pageIndex,
          appLanguageCode: Get.locale!.languageCode,
          bookmarkList: BookmarksController.instance.bookmarkTextList,
          fontsName: 'page${pageIndex + 1}',
          backgroundColor: Colors.transparent,
          textColor: Get.theme.colorScheme.inversePrimary,
          ayahSelectedBackgroundColor: Get.theme.highlightColor,
          bookmarksColor: const Color(0xffCD9974).withValues(alpha: .4),
          ayahBookmarked: BookmarksController.instance.hasBookmark2(pageIndex),
          ayahIconColor: Get.theme.colorScheme.inverseSurface,
          topBottomQuranStyle:
              TopBottomQuranStyle.defaults(
                isDark: themeCtrl.isDarkMode,
                context: context,
              ).copyWith(
                juzName: 'juz'.tr,
                sajdaName: 'sajda'.tr,
                topTitleChild: GestureDetector(
                  onTap: () => bookmarkCtrl.addPageBookmarkOnTap(pageIndex),
                  child: _BookmarkIcon(
                    height: context.customOrientation(30.h, 40.h),
                    pageNum: pageIndex + 1,
                  ),
                ),
              ),
          basmalaStyle: BasmalaStyle(
            basmalaColor: Get.theme.colorScheme.inversePrimary.withValues(
              alpha: .8,
            ),
            basmalaFontSize: context.customOrientation(90.h, 150.h),
            verticalPadding: 0.0,
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
          onPagePress: () {
            QuranController.instance.clearSelection();
          },
          onAyahLongPress: (details, ayah) {
            final surah = QuranLibrary().getCurrentSurahDataByAyah(ayah: ayah);
            context.showAyahMenu(
              surahNum: surah.surahNumber,
              ayahNum: ayah.ayahNumber,
              ayahText: ayah.text,
              pageIndex: pageIndex,
              ayahTextNormal: ayah.ayaTextEmlaey,
              ayahUQNum: ayah.ayahUQNumber,
              surahName: surah.arabicName,
              details: details,
            );
            log('ayahUQNumber: ${ayah.ayahUQNumber}');
            quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
          },
          tafsirStyle:
              TafsirStyle.defaults(
                isDark: themeCtrl.isDarkMode,
                context: context,
              ).copyWith(
                backgroundColor: Get.theme.colorScheme.primary,
                textColor: Get.theme.colorScheme.inversePrimary,
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
                footnotesName: 'footnotes'.tr,
                tafsirName: 'tafseer'.tr,
                translateName: 'translation'.tr,
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
    return GetBuilder<QuranController>(
      id: 'pageBookmarked',
      builder: (bookmarkCtrl) {
        return Semantics(
          button: true,
          enabled: true,
          label: 'Add Bookmark',
          child: customSvg(
            BookmarksController.instance
                    .hasPageBookmark(
                      pageNum ??
                          QuranController
                              .instance
                              .state
                              .currentPageNumber
                              .value,
                    )
                    .value
                ? SvgPath.svgBookmarked
                : Get.context!.bookmarkPageIconPath(),
            height: height,
          ),
        );
      },
    );
  }
}
