import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/surah_audio_controller.dart';

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
              stream: sl<SurahAudioController>().audioPlayer.loopModeStream,
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
                  icon: Semantics(
                      button: true,
                      enabled: true,
                      label: AppLocalizations.of(context)!.repeatSurah,
                      child: icons[index]),
                  onPressed: () {
                    sl<SurahAudioController>().audioPlayer.setLoopMode(
                        cycleModes[(cycleModes.indexOf(loopMode) + 1) %
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
                  stream:
                      sl<SurahAudioController>().audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return playButtonLottie(20.0, 20.0);
                    } else if (playing != true) {
                      return IconButton(
                        icon: Semantics(
                            button: true,
                            enabled: true,
                            label: AppLocalizations.of(context)!.online,
                            child: const Icon(Icons.play_arrow_outlined)),
                        iconSize: 30.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: () async {
                          sl<SurahAudioController>().cancelDownload();
                          sl<SurahAudioController>().isDownloading.value =
                              false;
                          sl<SurahAudioController>().isPlaying.value = true;
                          print(
                              'isDownloading: ${sl<SurahAudioController>().isDownloading.value}');
                          await sl<SurahAudioController>()
                              .downAudioPlayer
                              .pause();
                          await sl<SurahAudioController>().audioPlayer.play();
                        },
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: Semantics(
                            button: true,
                            enabled: true,
                            label: AppLocalizations.of(context)!.pauseSurah,
                            child: const Icon(Icons.pause)),
                        iconSize: 24.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: () {
                          sl<SurahAudioController>().isPlaying.value = false;
                          sl<SurahAudioController>().audioPlayer.pause();
                        },
                      );
                    } else {
                      return IconButton(
                        icon: Semantics(
                            button: true,
                            enabled: true,
                            label: AppLocalizations.of(context)!.replaySurah,
                            child: const Icon(Icons.replay)),
                        iconSize: 24.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: () => sl<SurahAudioController>()
                            .audioPlayer
                            .seek(Duration.zero,
                                index: sl<SurahAudioController>()
                                    .audioPlayer
                                    .effectiveIndices!
                                    .first),
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
