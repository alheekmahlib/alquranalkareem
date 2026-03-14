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
          isShowTabBar: false,
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
          onSurahBannerPress: (surah) =>
              surahInfoBottomSheet(context, surah.number - 1),
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
          tafsirStyle: quranCtrl.tafsirStyle,
          ayahTafsirInlineStyle: quranCtrl.ayahTafsirInlineStyle,
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
      final isBookmarked = BookmarksController.instance
          .hasPageBookmark(
            pageNum ?? QuranCtrl.instance.state.currentPageNumber.value,
          )
          .value;
      return Semantics(
        button: true,
        enabled: true,
        label: 'Add Bookmark',
        child: customSvgWithCustomColor(
          SvgPath.svgQuranBookmarkIcon,
          color: isBookmarked
              ? Get.theme.colorScheme.surface
              : Get.theme.colorScheme.primary,
          height: height,
        ),
      );
    });
  }
}
