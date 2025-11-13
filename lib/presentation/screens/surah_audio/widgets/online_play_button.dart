import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/services/notifications_manager.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../controller/surah_audio_controller.dart';

class OnlinePlayButton extends StatelessWidget {
  final bool isRepeat;
  const OnlinePlayButton({super.key, required this.isRepeat});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = SurahAudioController.instance;
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          isRepeat
              ? Align(
                  alignment: Alignment.topCenter,
                  child: StreamBuilder<LoopMode>(
                    stream: surahAudioCtrl.state.audioPlayer.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      List<Widget> icons = [
                        Icon(
                          Icons.repeat,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .4),
                        ),
                        Icon(
                          Icons.repeat,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ];
                      const cycleModes = [LoopMode.off, LoopMode.all];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: Semantics(
                          button: true,
                          enabled: true,
                          label: 'repeatSurah'.tr,
                          child: icons[index],
                        ),
                        onPressed: () {
                          surahAudioCtrl.state.audioPlayer.setLoopMode(
                            cycleModes[(cycleModes.indexOf(loopMode) + 1) %
                                cycleModes.length],
                          );
                        },
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            alignment: Alignment.center,
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
                  return GestureDetector(
                    child: customSvgWithCustomColor(
                      SvgPath.svgPlayArrow,
                      height: 30,
                    ),
                    onTap: () async {
                      NotificationManager().updateBookProgress(
                        'quranAudio'.tr,
                        'notifyListenBody'.tr,
                        surahAudioCtrl.state.surahNum.value,
                      );
                      surahAudioCtrl.cancelDownload();
                      surahAudioCtrl.state.isPlaying.value = true;
                      surahAudioCtrl.state.boxController.openBox();
                      // await surahAudioCtrl.state.audioPlayer.pause();
                      surahAudioCtrl
                                  .state
                                  .surahDownloadStatus
                                  .value[surahAudioCtrl.state.surahNum.value] ??
                              false
                          ? await surahAudioCtrl.startDownload()
                          : await surahAudioCtrl.state.audioPlayer.play();
                    },
                  );
                } else if (processingState != ProcessingState.completed ||
                    !playerState!.playing) {
                  return GestureDetector(
                    child: customSvgWithCustomColor(
                      SvgPath.svgPauseArrow,
                      height: 30,
                    ),
                    onTap: () {
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
                      child: Icon(
                        Icons.replay,
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                    iconSize: 24.0,
                    color: Theme.of(context).canvasColor,
                    onPressed: () => surahAudioCtrl.state.audioPlayer.seek(
                      Duration.zero,
                      index: surahAudioCtrl
                          .state
                          .audioPlayer
                          .effectiveIndices
                          .first,
                    ),
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
