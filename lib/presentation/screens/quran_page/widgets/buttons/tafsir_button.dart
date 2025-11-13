part of '../../quran.dart';

class TafsirButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahText;
  final int pageIndex;
  final String ayahTextNormal;
  final int ayahUQNum;
  final Function? cancel;
  const TafsirButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahText,
    required this.pageIndex,
    required this.ayahTextNormal,
    required this.ayahUQNum,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      width: 30,
      svgPath: SvgPath.svgTafsirIcon,
      svgColor: context.theme.canvasColor,
      onPressed: () async {
        // await QuranLibrary().initTafsir();
        // await QuranLibrary().fetchTafsir(pageNumber: pageIndex);
        // await QuranController.instance.showTafsirOnTap(
        //   pageIndex: pageIndex,
        //   ayahUQNum: ayahUQNum,
        // );
        await QuranLibrary().showTafsirOnTap(
          context: Get.context!,
          ayahNum: ayahNum,
          pageIndex: pageIndex,
          ayahUQNum: ayahUQNum,
          ayahNumber: ayahNum,
          externalTafsirStyle:
              TafsirStyle.defaults(
                context: context,
                isDark: ThemeController.instance.isDarkMode,
              ).copyWith(
                backgroundColor: Get.theme.colorScheme.primary,
                textColor: Get.theme.colorScheme.inversePrimary,
                backgroundTitleColor: Get.theme.colorScheme.surface.withValues(
                  alpha: .5,
                ),
                fontSizeWidget: fontSizeDropDownWidget(),
                // fontSize: generalCtrl.state.fontSizeArabic.value,
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
                horizontalMargin: 8.0,
                tafsirBackgroundColor: Get.theme.colorScheme.primaryContainer,
                fontSize: TafsirCtrl.instance.fontSizeArabic.value,
                tafsirNameWidget: customSvgWithCustomColor(
                  SvgPath.svgTafseerWhite,
                  color: Get.theme.canvasColor,
                  height: 25,
                ),
                footnotesName: 'footnotes'.tr,
                tafsirName: 'tafseer'.tr,
                translateName: 'translation'.tr,
                widthOfBottomSheet: 500,
                heightOfBottomSheet: Responsive.isDesktop(context)
                    ? Get.height * .9
                    : context.customOrientation(Get.height * .9, Get.height),
              ),
        );
        quranCtrl.state.isPages.value == 1 ? null : cancel!();
      },
    );
  }
}
