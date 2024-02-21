import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../controllers/audio_controller.dart';
import '../../../../controllers/quran_controller.dart';
import '/core/utils/constants/svg_picture.dart';

class PlayAyah extends StatelessWidget {
  const PlayAyah({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = sl<AudioController>();
    return Obx(
      () => SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // SquarePercentIndicator(
            //   width: 35,
            //   height: 35,
            //   startAngle: StartAngle.topRight,
            //   // reverse: true,
            //   borderRadius: 8,
            //   shadowWidth: 1.5,
            //   progressWidth: 2,
            //   shadowColor: Theme.of(context).colorScheme.surface.withOpacity(.15),
            //   progressColor: sl<AudioController>().downloading.value
            //       ? Theme.of(context).colorScheme.primary
            //       : Colors.transparent,
            //   progress: sl<AudioController>().progress.value,
            // ),
            sl<AudioController>().downloading.value
                ? Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      sl<AudioController>().progressString.value,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'kufi',
                          color: Theme.of(context).hintColor),
                    ),
                  )
                : StreamBuilder<PlayerState>(
                    stream: audioCtrl.audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return playButtonLottie(20.0, 20.0);
                      } else if (!audioCtrl.isPlay.value) {
                        return GestureDetector(
                          child: play_arrow(height: 25.0),
                          onTap: () async {
                            sl<QuranController>().isPlayExpanded.value = true;
                            sl<AudioController>().playAyah();
                          },
                        );
                      }
                      return GestureDetector(
                        child: pause_arrow(height: 25.0),
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
