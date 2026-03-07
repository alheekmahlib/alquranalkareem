part of '../surah_audio.dart';

class SurahSeekBar extends StatelessWidget {
  final Color? customColor;
  final Color? activeTrackColor;
  final Color? thumbColor;
  const SurahSeekBar({
    super.key,
    this.customColor,
    this.activeTrackColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCtrl>(
      id: 'surahDownloadManager_id',
      builder: (c) => c.state.isDownloading.value
          ? GetX<AudioCtrl>(
              builder: (c) {
                return SliderWidget.downloading(
                  currentPosition: c.state.downloadProgress.value.toInt(),
                  filesCount: c.state.fileSize.value,
                  horizontalPadding: 32.0,
                );
              },
            )
          : StreamBuilder<PackagePositionData>(
              stream: c.positionDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  c.state.positionData?.value = snapshot.data!;
                  final positionData = snapshot.data!;

                  return SliderWidget.player(
                    horizontalPadding: 32.0,
                    duration: positionData.duration,
                    position: c.state.lastTime != null
                        ? Duration(seconds: c.state.lastPosition.value.toInt())
                        : positionData.position,
                    // bufferedPosition: positionData.bufferedPosition,
                    onChangeEnd: (newPosition) {
                      c.state.audioPlayer.seek(newPosition);
                      // c.saveLastSurahListen(
                      //     c.state.currentAudioListSurahNum.value);
                      c.state.seekNextSeconds.value =
                          positionData.position.inSeconds;
                    },
                    activeTrackColor:
                        activeTrackColor ??
                        Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).canvasColor,
                    timeBackgroundColor: customColor,
                    timeShow: true,
                    thumbColor:
                        thumbColor ?? Theme.of(context).colorScheme.primary,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}
