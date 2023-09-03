import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/controllers_put.dart';
import '../../shared/widgets/lottie.dart';

class OnlinePlayButton extends StatelessWidget {
  const OnlinePlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: StreamBuilder<LoopMode>(
              stream: surahAudioController.audioPlayer.loopModeStream,
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
                  Icon(Icons.repeat_one,
                      color: Theme.of(context).colorScheme.surface),
                ];
                const cycleModes = [
                  LoopMode.off,
                  LoopMode.all,
                  LoopMode.one,
                ];
                final index = cycleModes.indexOf(loopMode);
                return IconButton(
                  icon: icons[index],
                  onPressed: () {
                    surahAudioController.audioPlayer.setLoopMode(cycleModes[
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
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                          width: 2, color: Theme.of(context).dividerColor)),
                ),
                StreamBuilder<PlayerState>(
                  stream: surahAudioController.audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return playButtonLottie(20.0, 20.0);
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(Icons.online_prediction_outlined),
                        iconSize: 24.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: () async {
                          surahAudioController.isDownloading.value = false;
                          print(
                              'surahAudioController.isDownloading.value: ${surahAudioController.isDownloading.value}');
                          await surahAudioController.audioPlayer.play();
                        },
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 24.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: surahAudioController.audioPlayer.pause,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.replay),
                        iconSize: 24.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: () => surahAudioController.audioPlayer.seek(
                            Duration.zero,
                            index: surahAudioController
                                .audioPlayer.effectiveIndices!.first),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              AppLocalizations.of(context)!.online,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'kufi',
                  height: -1.5,
                  color: Theme.of(context).dividerColor),
            ),
          )
        ],
      ),
    );
  }
}
