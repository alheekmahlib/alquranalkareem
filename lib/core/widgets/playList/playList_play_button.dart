import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../presentation/controllers/playList_controller.dart';

class PlayListPlayButton extends StatelessWidget {
  const PlayListPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return SizedBox(
      height: 120,
      child: Column(
        // alignment: Alignment.center,
        children: [
          SizedBox(
            height: 30,
            child: StreamBuilder<LoopMode>(
              stream: playList.playlistAudioPlayer.loopModeStream,
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
                    playList.playlistAudioPlayer.setLoopMode(cycleModes[
                        (cycleModes.indexOf(loopMode) + 1) %
                            cycleModes.length]);
                  },
                );
              },
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Obx(
                () => SquarePercentIndicator(
                  width: 50,
                  height: 50,
                  borderRadius: 8,
                  shadowWidth: 1.5,
                  progressWidth: 4,
                  shadowColor: Theme.of(context).dividerColor.withOpacity(.8),
                  progressColor: ThemeProvider.themeOf(context).id == 'dark'
                      ? Theme.of(context).dividerColor
                      : Theme.of(context).primaryColorLight,
                  progress: playList.progress.value,
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      // border: Border.all(
                      //     width: 2, color: Theme.of(context).dividerColor),
                    ),
                  ),
                ),
              ),
              StreamBuilder<PlayerState>(
                stream: playList.playlistAudioPlayer.playerStateStream,
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
                        // playList.cancelDownload();
                        // playList.isDownloading.value =
                        //     false;
                        // playList.isPlaying.value = true;
                        // print(
                        //     'isDownloading: ${playList.isDownloading.value}');
                        // await playList
                        //     .downAudioPlayer
                        //     .pause();
                        await playList.playlistAudioPlayer.play();
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
                        // playList.isPlaying.value = false;
                        playList.playlistAudioPlayer.pause();
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
                      onPressed: () => playList.playlistAudioPlayer.seek(
                          Duration.zero,
                          index: playList
                              .playlistAudioPlayer.effectiveIndices!.first),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
