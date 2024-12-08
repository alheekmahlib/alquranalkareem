part of '../../quran.dart';

class PlayListPlayButton extends StatelessWidget {
  const PlayListPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = PlayListController.instance;
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: StreamBuilder<LoopMode>(
            stream: playList.playlistAudioPlayer.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.off;
              List<Widget> icons = [
                Icon(Icons.repeat,
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.4)),
                Icon(Icons.repeat,
                    color: Theme.of(context).colorScheme.surface),
              ];
              const cycleModes = [
                LoopMode.off,
                LoopMode.all,
              ];
              final index = cycleModes.indexOf(loopMode);
              return IconButton(
                icon: Semantics(
                    button: true,
                    enabled: true,
                    label: 'repeatSurah'.tr,
                    child: icons[index]),
                onPressed: () {
                  playList.playlistAudioPlayer.setLoopMode(cycleModes[
                      (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // SquarePercentIndicator(
              //   width: 35,
              //   height: 35,
              //   startAngle: StartAngle.topRight,
              //   // reverse: true,
              //   borderRadius: 8,
              //   shadowWidth: 1.5,
              //   progressWidth: 2,
              //   shadowColor: Theme.of(context).colorScheme.surface.withOpacity(.15),
              //   progressColor: sl<AudioController>().downloading.value
              //       ? Theme.of(context).colorScheme.primary
              //       : Colors.transparent,
              //   progress: sl<AudioController>().progress.value,
              // ),
              StreamBuilder<PlayerState>(
                stream: playList.playlistAudioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return customLottie(LottieConstants.assetsLottiePlayButton,
                        width: 20.0, height: 20.0);
                  } else if (playing != true) {
                    return GestureDetector(
                      child: customSvg(
                        SvgPath.svgPlayArrow,
                        height: 25,
                      ),
                      onTap: () async {
                        await playList.playlistAudioPlayer.play();
                      },
                    );
                  }
                  return GestureDetector(
                    child: customSvg(
                      SvgPath.svgPauseArrow,
                      height: 25,
                    ),
                    onTap: () async {
                      playList.playlistAudioPlayer.pause();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
