import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/surah_audio_controller.dart';

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
              stream: sl<SurahAudioController>().downAudioPlayer.loopModeStream,
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
                    sl<SurahAudioController>().downAudioPlayer.setLoopMode(
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
                Obx(
                  () => SquarePercentIndicator(
                    width: 40,
                    height: 40,
                    borderRadius: 8,
                    shadowWidth: 1.5,
                    progressWidth: 4,
                    shadowColor: Theme.of(context).dividerColor.withOpacity(.5),
                    progressColor: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white
                        : Theme.of(context).primaryColorLight,
                    progress: sl<SurahAudioController>().progress.value,
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
                  stream: sl<SurahAudioController>()
                      .downAudioPlayer
                      .playerStateStream,
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
                            label: AppLocalizations.of(context)!.download,
                            child: const Icon(Icons.download_outlined)),
                        iconSize: 24.0,
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: () async {
                          sl<SurahAudioController>().isDownloading.value = true;
                          var surahAudioController = sl<SurahAudioController>();
                          if (surahAudioController.onDownloading.value) {
                            surahAudioController.cancelDownload();
                          } else {
                            await surahAudioController.startDownload();
                          }
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
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: () {
                          sl<SurahAudioController>().downAudioPlayer.pause();
                          sl<SurahAudioController>().isDownloading.value =
                              false;
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
                        onPressed: () {
                          sl<SurahAudioController>().isDownloading.value = true;
                          sl<SurahAudioController>().downAudioPlayer.seek(
                              Duration.zero,
                              index: sl<SurahAudioController>()
                                  .downAudioPlayer
                                  .effectiveIndices!
                                  .first);
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
