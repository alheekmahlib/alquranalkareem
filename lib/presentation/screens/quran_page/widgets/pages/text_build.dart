part of '../../quran.dart';

class TextBuild extends StatelessWidget {
  final int pageIndex;

  TextBuild({super.key, required this.pageIndex});

  final audioCtrl = AudioController.instance;
  final quranCtrl = QuranController.instance;
  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GetBuilder<QuranController>(
      id: 'clearSelection',
      builder: (quranCtrl) => QuranLibraryScreen(
        parentContext: context,
        withPageView: false,
        pageIndex: pageIndex,
        useDefaultAppBar: false,
        isDark: false,
        languageCode: Get.locale!.languageCode,
        bookmarkList: BookmarksController.instance.bookmarkTextList,
        juzName: 'juz'.tr,
        sajdaName: 'sajda'.tr,
        backgroundColor: Colors.transparent,
        textColor: Get.theme.colorScheme.inversePrimary,
        ayahSelectedBackgroundColor: Get.theme.highlightColor,
        bookmarksColor: const Color(0xffCD9974).withValues(alpha: .4),
        isFontsLocal: true,
        fontsName: 'page${pageIndex + 1}',
        ayahBookmarked: BookmarksController.instance.hasBookmark2(pageIndex),
        ayahIconColor: Get.theme.colorScheme.inverseSurface,
        bannerStyle: BannerStyle(
          isImage: false,
          bannerSvgHeight: context.customOrientation(120.h, 150.h),
          bannerSvgPath: quranCtrl.surahBannerPath,
        ),
        basmalaStyle: BasmalaStyle(
          basmalaColor: Get.theme.cardColor.withValues(alpha: .8),
          basmalaHeight: context.customOrientation(120.h, 150.h),
        ),
        topTitleChild: GestureDetector(
          onTap: () => bookmarkCtrl.addPageBookmarkOnTap(pageIndex),
          child: bookmarkIcon(
              height: context.customOrientation(30.h, 40.h),
              pageNum: pageIndex + 1),
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
        surahNameStyle: SurahNameStyle(
          surahNameColor: Get.theme.hintColor,
          surahNameSize: 120.sp,
        ),
        onPagePress: () {
          audioCtrl.clearSelection();
        },
        onAyahLongPress: (details, ayah) {
          context.showAyahMenu(
            surahNum: QuranLibrary()
                .getCurrentSurahDataByAyahUniqueNumber(
                    ayahUniqueNumber: ayah.ayahUQNumber)
                .surahNumber,
            ayahNum: ayah.ayahNumber,
            ayahText: ayah.text,
            pageIndex: pageIndex,
            ayahTextNormal: ayah.ayaTextEmlaey,
            ayahUQNum: ayah.ayahUQNumber,
            surahName: QuranLibrary()
                .getCurrentSurahDataByAyahUniqueNumber(
                    ayahUniqueNumber: ayah.ayahUQNumber)
                .arabicName,
            details: details,
          );
          log('ayahUQNumber: ${ayah.ayahUQNumber}');
          quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
        },
      ),
    ));
  }

  Widget bookmarkIcon({double? height, double? width, int? pageNum}) {
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
                          pageNum ?? quranCtrl.state.currentPageNumber.value)
                      .value
                  ? SvgPath.svgBookmarked
                  : Get.context!.bookmarkPageIconPath(),
              width: width,
              height: height,
            ),
          );
        });
  }
}
