part of '../../prayers.dart';

class PlayButton extends StatelessWidget {
  final List<AdhanData> adhanData;
  final int index;
  PlayButton({super.key, required this.adhanData, required this.index});

  final notificationCtrl = PrayersNotificationsCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<PlayerState>(
            stream: notificationCtrl.state.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isCurrentlyPlaying =
                  notificationCtrl.state.downloadedAdhanData.length > index &&
                      notificationCtrl.state.selectedAdhanPath.value ==
                          notificationCtrl
                              .state.downloadedAdhanData[index].path;
              final isPlaying = playerState?.playing ?? false;

              if (playerState?.processingState == ProcessingState.buffering &&
                  isCurrentlyPlaying) {
                return customLottie(LottieConstants.assetsLottiePlayButton,
                    width: 20.0, height: 20.0);
              } else if (isCurrentlyPlaying && isPlaying) {
                return GestureDetector(
                  child: customSvg(
                    SvgPath.svgPauseArrow,
                    height: 25,
                  ),
                  onTap: () {
                    notificationCtrl.state.audioPlayer.pause();
                  },
                );
              } else {
                return GestureDetector(
                  child: customSvg(
                    SvgPath.svgPlayArrow,
                    height: 25,
                  ),
                  onTap: () async =>
                      notificationCtrl.playButtonOnTap(adhanData[index]),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
