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
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Show Tafseer',
        child: customSvgWithCustomColor(
          SvgPath.svgTafsirIcon,
          height: 20,
        ),
      ),
      onTap: () async {
        await TafsirCtrl.instance.fetchData(pageIndex + 1);
        sl<TafsirCtrl>().showTafsirOnTap(
            surahNum, ayahNum, ayahText, pageIndex, ayahTextNormal, ayahUQNum);
        quranCtrl.state.isPages.value == 1 ? null : cancel!();
      },
    );
  }
}
