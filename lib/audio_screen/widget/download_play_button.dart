import 'package:alquranalkareem/audio_screen/controller/surah_audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lottie.dart';

class DownloadPlayButton extends StatelessWidget {
  late final SurahAudioController surahAudioController =
      Get.put(SurahAudioController());

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
              children: [
                SquarePercentIndicator(
                  width: 50,
                  height: 50,
                  borderRadius: 8,
                  shadowWidth: 1.5,
                  progressWidth: 4,
                  shadowColor: Colors.grey,
                  progressColor: ThemeProvider.themeOf(context).id == 'dark'
                      ? Colors.white
                      : Theme.of(context).primaryColorLight,
                  progress: surahAudioController.progress.value,
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                        border: Border.all(
                            width: 2, color: Theme.of(context).dividerColor)),
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
                          await surahAudioController.downloadSurah();
                          surahAudioController.isDownloading == true;
                          // surahAudioController.downAudioPlayer.play();
                        },
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 24.0,
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: surahAudioController.downAudioPlayer.pause,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.replay),
                        iconSize: 24.0,
                        onPressed: () => surahAudioController.downAudioPlayer
                            .seek(Duration.zero,
                                index: surahAudioController
                                    .downAudioPlayer.effectiveIndices!.first),
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
              AppLocalizations.of(context)!.download,
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
