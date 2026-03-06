part of '../../quran.dart';

class PlayAyah extends StatelessWidget {
  const PlayAyah({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = AudioCtrl.instance;
    return SizedBox(
      width: 40,
      height: 40,
      child: StreamBuilder<PlayerState>(
        stream: audioCtrl.state.audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering ||
              (audioCtrl.state.isDownloading.value &&
                  audioCtrl.state.progress.value == 0)) {
            return customLottie(
              LottieConstants.assetsLottiePlayButton,
              width: 20.0,
              height: 20.0,
            );
          } else if (playerState != null && !playerState.playing) {
            return CustomButton(
              svgPath: SvgPath.svgAudioPlayArrow,
              height: 40,
              width: 40,
              iconSize: 38,
              isCustomSvgColor: true,
              svgColor: context.theme.colorScheme.surface,
              onPressed: () async {
                GeneralController.instance.showAudioWidgetFor();
                QuranController.instance.state.selectedAyahIndexes.isNotEmpty
                    ? audioCtrl.state.isDirectPlaying.value = false
                    : audioCtrl.state.isDirectPlaying.value = true;
                QuranController.instance.state.isPlayExpanded.value = true;
                QuranLibrary().playAyah(
                  context: context,
                  currentAyahUniqueNumber: audioCtrl.currentAyah.ayahUQNumber,
                  playSingleAyah: true,
                );
              },
            );
          }
          return CustomButton(
            svgPath: SvgPath.svgAudioPauseArrow,
            height: 40,
            width: 40,
            iconSize: 38,
            isCustomSvgColor: true,
            svgColor: context.theme.colorScheme.surface,
            onPressed: () {
              QuranController.instance.state.isPlayExpanded.value = true;
              audioCtrl.pausePlayer();
            },
          );
        },
      ),
    );
  }
}
