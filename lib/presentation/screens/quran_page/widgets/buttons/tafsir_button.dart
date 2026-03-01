part of '../../quran.dart';

class TafsirButton extends StatelessWidget {
  final AyahModel ayah;
  final int pageIndex;
  final Function? cancel;
  const TafsirButton({
    super.key,
    required this.ayah,
    required this.pageIndex,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgQuranTafsir,
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
          ayahNum: ayah.ayahNumber,
          pageIndex: pageIndex,
          ayahUQNum: ayah.ayahUQNumber,
          ayahNumber: ayah.ayahNumber,
          isDark: ThemeController.instance.isDarkMode,
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
                downloadIconColor: Get.theme.canvasColor,
              ),
        );
      },
    );
  }
}
