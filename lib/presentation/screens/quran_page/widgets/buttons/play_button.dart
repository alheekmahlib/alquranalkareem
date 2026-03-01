part of '../../quran.dart';

class PlayButton extends StatelessWidget {
  final SurahModel surah;
  final AyahModel ayah;
  final VoidCallback? cancel;

  /// just play the selected ayah.
  final bool singleAyahOnly;
  PlayButton({
    super.key,
    required this.surah,
    required this.ayah,
    this.singleAyahOnly = false,
    this.cancel,
  });
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: singleAyahOnly
          ? SvgPath.svgAudioPlayArrow
          : SvgPath.svgQuranPlayAll,
      svgColor: context.theme.canvasColor,
      onPressed: () async {
        // AudioCtrl.instance.startPlayingToggle();
        GeneralController.instance.showAudioWidgetFor();
        QuranController.instance.state.isPlayExpanded.value = true;
        AudioCtrl.instance.state.isDirectPlaying.value = false;
        debugPrint('SurahNum: ${surah.surahNumber}');

        await QuranLibrary().playAyah(
          context: Get.context!,
          currentAyahUniqueNumber: ayah.ayahUQNumber,
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
