part of '../../quran.dart';

class PlayAyah extends StatelessWidget {
  const PlayAyah({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = AudioController.instance;
    return SizedBox(
      width: 28,
      height: 28,
      child: StreamBuilder<PlayerState>(
        stream: audioCtrl.state.audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering ||
              (audioCtrl.state.downloading.value &&
                  audioCtrl.state.progress.value == 0)) {
            return customLottie(
              LottieConstants.assetsLottiePlayButton,
              width: 20.0,
              height: 20.0,
            );
          } else if (playerState != null && !playerState.playing) {
            return GestureDetector(
              child: customSvgWithCustomColor(SvgPath.svgPlayArrow, height: 25),
              onTap: () async {
                QuranController.instance.state.selectedAyahIndexes.isNotEmpty
                    ? audioCtrl.state.isDirectPlaying.value = false
                    : audioCtrl.state.isDirectPlaying.value = true;
                QuranController.instance.state.isPlayExpanded.value = true;
                audioCtrl.playAyah();
              },
            );
          }
          return GestureDetector(
            child: customSvgWithCustomColor(SvgPath.svgPauseArrow, height: 25),
            onTap: () {
              QuranController.instance.state.isPlayExpanded.value = true;
              audioCtrl.playAyah();
            },
          );
        },
      ),
    );
  }
}
