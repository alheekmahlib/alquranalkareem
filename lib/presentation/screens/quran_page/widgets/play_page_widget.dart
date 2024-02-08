import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/general_controller.dart';
import '/core/utils/constants/svg_picture.dart';
import '/presentation/controllers/quran_controller.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

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
            //   shadowColor: Get.theme.colorScheme.surface.withOpacity(.15),
            //   progressColor: sl<AudioController>().downloadingPage.value
            //       ? Get.theme.colorScheme.primary
            //       : Colors.transparent,
            //   progress: sl<AudioController>().progressPage.value,
            // ),
            sl<AudioController>().downloadingPage.value
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      sl<AudioController>().progressPageString.value,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'kufi',
                          color: Get.theme.hintColor),
                    ),
                  )
                : StreamBuilder<PlayerState>(
                    stream: audioCtrl.pageAudioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return playButtonLottie(20.0, 20.0);
                      } else if (!audioCtrl.isPagePlay.value) {
                        return GestureDetector(
                          child: play_page(height: 25.0),
                          onTap: () async {
                            audioCtrl.cancelDownload();
                            sl<QuranController>().isPlayExpanded.value = true;
                            sl<AudioController>().isPlay.value = false;
                            sl<AudioController>().playPage(
                                sl<GeneralController>().currentPage.value);
                          },
                        );
                      }
                      return GestureDetector(
                        child: pause_arrow(height: 25.0),
                        onTap: () {
                          sl<QuranController>().isPlayExpanded.value = true;
                          sl<AudioController>().isPlay.value = false;
                          sl<AudioController>().playPage(
                              sl<GeneralController>().currentPage.value);
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
