part of '../../quran.dart';

class CopyButton extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  const CopyButton({super.key, required this.ayah, required this.surah});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgQuranCopy,
      svgColor: context.theme.canvasColor,
      onPressed: () async {
        await Clipboard.setData(
          ClipboardData(
            text:
                '﴿${ayah.text}﴾ [${surah.arabicName}-${sl<GeneralController>().state.arabicNumber.convert(ayah.ayahNumber)}]',
          ),
        ).then((value) => context.showCustomErrorSnackBar('copyAyah'.tr));
        sl<QuranController>().state.selectedAyahIndexes.clear();
      },
    );
  }
}
