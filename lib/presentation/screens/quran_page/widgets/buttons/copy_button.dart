part of '../../quran.dart';

class CopyButton extends StatelessWidget {
  final int ayahNum;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  const CopyButton(
      {super.key,
      required this.ayahNum,
      required this.surahName,
      required this.ayahTextNormal,
      this.cancel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Copy Ayah',
        child: customSvg(
          SvgPath.svgCopyIcon,
          height: 20,
        ),
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(
                text:
                    '﴿${ayahTextNormal}﴾ [$surahName-${sl<GeneralController>().state.arabicNumber.convert(ayahNum)}]'))
            .then((value) => context.showCustomErrorSnackBar('copyAyah'.tr));
        cancel!();
        sl<QuranController>().state.selectedAyahIndexes.clear();
      },
    );
  }
}
