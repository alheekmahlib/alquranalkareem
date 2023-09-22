import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../shared/services/controllers_put.dart';
import '../../shared/utils/constants/lottie.dart';

class DownloadPlayButton extends StatelessWidget {
  const DownloadPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: StreamBuilder<LoopMode>(
              stream: surahAudioController.downAudioPlayer.loopModeStream,
              builder: (context, snapshot) {
                final loopMode = snapshot.data ?? LoopMode.off;
                List<Widget> icons = [
                  Icon(Icons.repeat,
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(.4)),
                  Icon(Icons.repeat,
                      color: Theme.of(context).colorScheme.surface),
                ];
                const cycleModes = [
                  LoopMode.off,
                  LoopMode.all,
                ];
                final index = cycleModes.indexOf(loopMode);
                return IconButton(
                  icon: icons[index],
                  onPressed: () {
                    surahAudioController.downAudioPlayer.setLoopMode(cycleModes[
                        (cycleModes.indexOf(loopMode) + 1) %
                            cycleModes.length]);
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(
                  () => SquarePercentIndicator(
                    width: 40,
                    height: 40,
                    borderRadius: 8,
                    shadowWidth: 1.5,
                    progressWidth: 4,
                    shadowColor: Colors.grey,
                    progressColor: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white
                        : Theme.of(context).primaryColorLight,
                    progress: surahAudioController.progress.value,
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        // border: Border.all(
                        //     width: 2, color: Theme.of(context).dividerColor)
                      ),
                    ),
                  ),
                ),
                StreamBuilder<PlayerState>(
                  stream:
                      surahAudioController.downAudioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return playButtonLottie(20.0, 20.0);
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(Icons.download_outlined),
                        iconSize: 24.0,
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: () async {
                          surahAudioController.isDownloading.value = true;
                          print(
                              'isDownloading.value: ${surahAudioController.isDownloading.value}');
                          await surahAudioController.audioPlayer.pause();
                          await surahAudioController.downloadSurah();
                          // surahAudioController.downAudioPlayer.play();
                        },
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 24.0,
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: () {
                          surahAudioController.downAudioPlayer.pause();
                          surahAudioController.isDownloading.value = false;
                        },
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.replay),
                        iconSize: 24.0,
                        onPressed: () {
                          surahAudioController.isDownloading.value = true;
                          surahAudioController.downAudioPlayer.seek(
                              Duration.zero,
                              index: surahAudioController
                                  .downAudioPlayer.effectiveIndices!.first);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
