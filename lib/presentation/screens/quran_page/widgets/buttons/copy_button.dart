part of '../../quran.dart';

class CopyButton extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final Color? iconColor;
  const CopyButton({
    super.key,
    required this.ayah,
    required this.surah,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgQuranCopy,
      svgColor: iconColor ?? context.theme.canvasColor,
      onPressed: () async {
        await Clipboard.setData(
          ClipboardData(
            text:
                '﴿${ayah.text}﴾ '
                '[${surah.arabicName}-'
                '${ayah.ayahNumber}]\n\n'
                '${'appName'.tr}\n'
                '${ApiConstants.quranShareUrl}${QuranCtrl.instance.state.currentPageNumber.value}&ayah=${ayah.ayahUQNumber}',
          ),
        ).then((value) => context.showCustomErrorSnackBar('copyAyah'.tr));
        sl<QuranController>().state.selectedAyahIndexes.clear();
      },
    );
  }
}
