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
        await QuranController.instance.showTafsirOnTap(
          surahNum: surahNum - 1,
          ayahNum: ayahNum,
          ayahText: ayahText,
          pageIndex: pageIndex,
          ayahTextN: ayahTextNormal,
          ayahUQNum: ayahUQNum,
        );
        // await QuranLibrary().showTafsir(
        //   context: context,
        //   surahNum: surahNum,
        //   ayahNum: ayahNum,
        //   ayahText: ayahText,
        //   pageIndex: pageIndex,
        //   ayahTextN: ayahTextNormal,
        //   ayahUQNum: ayahUQNum,
        //   ayahNumber: ayahNum,
        // );
        quranCtrl.state.isPages.value == 1 ? null : cancel!();
      },
    );
  }
}
