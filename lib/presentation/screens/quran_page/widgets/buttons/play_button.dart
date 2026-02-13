part of '../../quran.dart';

class PlayButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final VoidCallback? cancel;

  /// just play the selected ayah.
  final bool singleAyahOnly;
  PlayButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahUQNum,
    this.singleAyahOnly = false,
    this.cancel,
  });
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      width: 30,
      isCustomSvgColor: true,
      svgPath: singleAyahOnly ? SvgPath.svgPlayArrow : SvgPath.svgPlayAll,
      svgColor: context.theme.hintColor,
      onPressed: () async {
        // AudioCtrl.instance.startPlayingToggle();
        GeneralController.instance.showAudioWidgetFor();
        QuranController.instance.state.isPlayExpanded.value = true;
        AudioCtrl.instance.state.isDirectPlaying.value = false;
        debugPrint('SurahNum: $surahNum');

        await QuranLibrary().playAyah(
          context: Get.context!,
          currentAyahUniqueNumber: ayahUQNum,
          ayahAudioStyle: AudioCtrl.instance.ayahAudioStyle,
          ayahDownloadManagerStyle: AudioCtrl.instance.ayahDownloadManagerStyle,
          playSingleAyah: singleAyahOnly,
          isDarkMode: ThemeController.instance.isDarkMode,
        );
        if (cancel != null) {
          cancel!();
        }
      },
    );
  }
}
