part of '../../quran.dart';

class CopyButton extends StatelessWidget {
  final int ayahNum;
  final String surahName;
  final String ayahText;
  final Function? cancel;
  const CopyButton(
      {super.key,
      required this.ayahNum,
      required this.surahName,
      required this.ayahText,
      this.cancel});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      width: 30,
      svgPath: SvgPath.svgCopyIcon,
      svgColor: context.theme.canvasColor,
      onPressed: () async {
        await Clipboard.setData(ClipboardData(
                text:
                    '﴿${ayahText}﴾ [$surahName-${sl<GeneralController>().state.arabicNumber.convert(ayahNum)}]'))
            .then((value) => context.showCustomErrorSnackBar('copyAyah'.tr));
        cancel!();
        sl<QuranController>().state.selectedAyahIndexes.clear();
      },
    );
  }
}
