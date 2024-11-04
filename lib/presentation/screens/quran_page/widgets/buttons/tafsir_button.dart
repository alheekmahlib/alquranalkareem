part of '../../quran.dart';

class TafsirButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahText;
  final int pageIndex;
  final String ayahTextNormal;
  final int ayahUQNum;
  final int index;
  final Function? cancel;
  const TafsirButton(
      {super.key,
      required this.surahNum,
      required this.ayahNum,
      required this.ayahText,
      required this.pageIndex,
      required this.ayahTextNormal,
      required this.ayahUQNum,
      this.cancel,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Show Tafseer',
        child: customSvg(
          SvgPath.svgTafsirIcon,
          height: 20,
        ),
      ),
      onTap: () async {
        await TafsirCtrl.instance.fetchData(pageIndex + 1);
        sl<TafsirCtrl>().showTafsirOnTap(surahNum, ayahNum, ayahText, pageIndex,
            ayahTextNormal, ayahUQNum, index);
        cancel!();
      },
    );
  }
}
