import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/utils/constants/lottie_constants.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../controllers/audio_controller.dart';
import '../../../../controllers/quran_controller.dart';

class PlayAyah extends StatelessWidget {
  const PlayAyah({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = AudioController.instance;
    return Obx(
      () => SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SquarePercentIndicator(
              width: 35,
              height: 35,
              startAngle: StartAngle.topRight,
              // reverse: true,
              borderRadius: 8,
              shadowWidth: 1.5,
              progressWidth: 2,
              shadowColor: Colors.transparent,
              progressColor: sl<AudioController>().downloading.value
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              progress: sl<AudioController>().progress.value,
            ),
            StreamBuilder<PlayerState>(
              stream: audioCtrl.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering ||
                    (audioCtrl.downloading.value &&
                        audioCtrl.progress.value == 0)) {
                  return customLottie(LottieConstants.assetsLottiePlayButton,
                      width: 20.0, height: 20.0);
                } else if (playerState != null && !playerState.playing) {
                  return GestureDetector(
                    child: customSvg(
                      SvgPath.svgPlayArrow,
                      height: 25,
                    ),
                    onTap: () async {
                      sl<QuranController>().isPlayExpanded.value = true;
                      sl<AudioController>().playAyah();
                    },
                  );
                }
                return GestureDetector(
                  child: customSvg(
                    SvgPath.svgPauseArrow,
                    height: 25,
                  ),
                  onTap: () {
                    sl<QuranController>().isPlayExpanded.value = true;
                    sl<AudioController>().playAyah();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
