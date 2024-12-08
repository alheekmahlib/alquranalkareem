part of '../../quran.dart';

class PlayButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final VoidCallback? cancel;

  /// just play the selected ayah.
  final bool singleAyahOnly;
  PlayButton(
      {super.key,
      required this.surahNum,
      required this.ayahNum,
      required this.ayahUQNum,
      this.singleAyahOnly = false,
      this.cancel});
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: singleAyahOnly ? 'Play Ayah' : 'Play Surah',
        child: customSvg(
          singleAyahOnly ? SvgPath.svgPlayArrow : SvgPath.svgPlayAll,
          height: 20,
        ),
      ),
      onTap: () {
        AudioController.instance.startPlayingToggle();
        QuranController.instance.state.isPlayExpanded.value = true;
        AudioController.instance.state.isDirectPlaying.value = false;
        debugPrint('SurahNum: $surahNum');
        AudioController.instance
            .playAyahOnTap(surahNum, ayahNum, ayahUQNum, singleAyahOnly);
        if (cancel != null) {
          cancel!();
        }
      },
    );
  }
}
