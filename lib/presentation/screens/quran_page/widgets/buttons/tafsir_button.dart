part of '../../quran.dart';

class TafsirButton extends StatelessWidget {
  final AyahModel ayah;
  final int pageIndex;
  final bool? withBack;
  TafsirButton({
    super.key,
    required this.ayah,
    required this.pageIndex,
    this.withBack = false,
  });

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TajweedAyaCtrl>(
      init: TajweedAyaCtrl.instance,
      id: 'tajweed_download',
      builder: (tajweedCtrl) {
        return CustomButton(
          height: 40,
          width: 35,
          iconSize: 35,
          isCustomSvgColor: true,
          svgPath: SvgPath.svgQuranTafsir,
          svgColor: context.theme.canvasColor,
          onPressed: () async {
            if (withBack == true) {
              Get.back();
            }
            // await QuranLibrary().initTafsir();
            // await QuranLibrary().fetchTafsir(pageNumber: pageIndex);
            // await QuranController.instance.showTafsirOnTap(
            //   pageIndex: pageIndex,
            //   ayahUQNum: ayahUQNum,
            // );
            customBottomSheet(
              backgroundColor: context.theme.colorScheme.primary,
              handleBackgroundColor: context.theme.canvasColor,
              handleDotsColor: context.theme.colorScheme.primary,
              ShowTafseer(
                context: context,
                ayahUQNumber: ayah.ayahUQNumber,
                ayahNumber: ayah.ayahNumber,
                pageIndex: pageIndex,
                isDark: ThemeController.instance.isDarkMode,
                tafsirStyle: quranCtrl.tafsirStyle,
              ),
            );
          },
        );
      },
    );
  }
}
