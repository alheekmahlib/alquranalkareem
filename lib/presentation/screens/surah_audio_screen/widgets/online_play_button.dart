import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../controllers/surah_audio_controller.dart';

class OnlinePlayButton extends StatelessWidget {
  final bool isRepeat;
  const OnlinePlayButton({super.key, required this.isRepeat});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          isRepeat
              ? Align(
                  alignment: Alignment.topCenter,
                  child: StreamBuilder<LoopMode>(
                    stream: surahAudioCtrl.audioPlayer.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      List<Widget> icons = [
                        Icon(Icons.repeat,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.4)),
                        Icon(Icons.repeat,
                            color: Theme.of(context).colorScheme.primary),
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
                          surahAudioCtrl.audioPlayer.setLoopMode(cycleModes[
                              (cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<PlayerState>(
              stream: surahAudioCtrl.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.buffering) {
                  return customLottie(LottieConstants.assetsLottiePlayButton,
                      width: 20.0, height: 20.0);
                } else if (!surahAudioCtrl.isPlaying.value) {
                  return GestureDetector(
                    child: play_arrow(height: 30.0),
                    onTap: () async {
                      surahAudioCtrl.cancelDownload();
                      surahAudioCtrl.isDownloading.value = false;
                      surahAudioCtrl.isPlaying.value = true;
                      surahAudioCtrl.boxController.openBox();
                      print(
                          'isDownloading: ${surahAudioCtrl.isDownloading.value}');
                      // await surahAudioCtrl.audioPlayer.pause();
                      surahAudioCtrl.surahDownloadStatus
                                  .value[surahAudioCtrl.surahNum.value] ??
                              false
                          ? await surahAudioCtrl.startDownload()
                          : await surahAudioCtrl.audioPlayer.play();
                    },
                  );
                } else if (processingState != ProcessingState.completed) {
                  return GestureDetector(
                    child: pause_arrow(height: 30.0),
                    onTap: () {
                      surahAudioCtrl.isPlaying.value = false;
                      surahAudioCtrl.audioPlayer.pause();
                    },
                  );
                } else {
                  return IconButton(
                    icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'replaySurah'.tr,
                        child: const Icon(Icons.replay)),
                    iconSize: 24.0,
                    color: Theme.of(context).canvasColor,
                    onPressed: () => surahAudioCtrl.audioPlayer.seek(
                        Duration.zero,
                        index:
                            surahAudioCtrl.audioPlayer.effectiveIndices!.first),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
