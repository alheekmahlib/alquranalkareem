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
    final surahAudioCtrl = sl<SurahAudioController>();
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: StreamBuilder<LoopMode>(
              stream: surahAudioCtrl.audioPlayer.loopModeStream,
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
                    surahAudioCtrl.audioPlayer.setLoopMode(cycleModes[
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
                  stream: surahAudioCtrl.audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return playButtonLottie(20.0, 20.0);
                    } else if (!surahAudioCtrl.isPlaying.value) {
                      return IconButton(
                        icon: Semantics(
                            button: true,
                            enabled: true,
                            label: AppLocalizations.of(context)!.online,
                            child: const Icon(Icons.play_arrow_outlined)),
                        iconSize: 30.0,
                        color: Theme.of(context).canvasColor,
                        onPressed: () async {
                          surahAudioCtrl.cancelDownload();
                          surahAudioCtrl.isDownloading.value = false;
                          surahAudioCtrl.isPlaying.value = true;
                          print(
                              'isDownloading: ${surahAudioCtrl.isDownloading.value}');
                          await surahAudioCtrl.audioPlayer.pause();
                          await surahAudioCtrl.audioPlayer.play();
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
                          surahAudioCtrl.isPlaying.value = false;
                          surahAudioCtrl.audioPlayer.pause();
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
                        onPressed: () => surahAudioCtrl.audioPlayer.seek(
                            Duration.zero,
                            index: surahAudioCtrl
                                .audioPlayer.effectiveIndices!.first),
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
