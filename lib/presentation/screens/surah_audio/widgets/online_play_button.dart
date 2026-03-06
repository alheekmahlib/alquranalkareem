part of '../surah_audio.dart';

class OnlinePlayButton extends StatelessWidget {
  final bool isRepeat;
  const OnlinePlayButton({super.key, required this.isRepeat});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = AudioCtrl.instance;
    return SizedBox(
      height: 50,
      child: StreamBuilder<PlayerState>(
        stream: surahAudioCtrl.state.audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          if (processingState == ProcessingState.buffering) {
            return customLottie(
              LottieConstants.assetsLottiePlayButton,
              width: 20.0,
              height: 20.0,
            );
          } else if (playerState != null && !playerState.playing) {
            return CustomButton(
              svgPath: SvgPath.svgAudioPlayArrow,
              height: 50,
              width: 50,
              iconSize: 38,
              horizontalPadding: 10.0,
              isCustomSvgColor: true,
              backgroundColor: context.theme.colorScheme.primary,
              svgColor: context.theme.colorScheme.surface,
              onPressed: () async {
                NotificationManager().updateBookProgress(
                  'quranAudio'.tr,
                  'notifyListenBody'.tr,
                  surahAudioCtrl.state.currentAudioListSurahNum.value,
                );
                surahAudioCtrl.playSurah(
                  context: context,
                  surahNumber:
                      surahAudioCtrl.state.currentAudioListSurahNum.value,
                );
              },
            );
          } else if (processingState != ProcessingState.completed ||
              !playerState!.playing) {
            return CustomButton(
              svgPath: SvgPath.svgAudioPauseArrow,
              height: 50,
              width: 50,
              iconSize: 38,
              horizontalPadding: 10.0,
              isCustomSvgColor: true,
              backgroundColor: context.theme.colorScheme.primary,
              svgColor: context.theme.colorScheme.surface,
              onPressed: () {
                surahAudioCtrl.state.isPlaying.value = false;
                surahAudioCtrl.state.audioPlayer.pause();
              },
            );
          } else {
            return IconButton(
              icon: Semantics(
                button: true,
                enabled: true,
                label: 'replaySurah'.tr,
                child: Icon(Icons.replay, color: Get.theme.colorScheme.surface),
              ),
              iconSize: 24.0,
              color: Theme.of(context).canvasColor,
              onPressed: () => surahAudioCtrl.state.audioPlayer.seek(
                Duration.zero,
                index: surahAudioCtrl.state.audioPlayer.effectiveIndices.first,
              ),
            );
          }
        },
      ),
    );
  }
}
