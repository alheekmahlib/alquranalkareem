import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/general_controller.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              shadowColor: Get.theme.dividerColor.withOpacity(.5),
              progressColor: sl<AudioController>().downloadingPage.value
                  ? Get.theme.colorScheme.surface
                  : Colors.transparent,
              progress: sl<AudioController>().progressPage.value,
            ),
            sl<AudioController>().downloadingPage.value
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      sl<AudioController>().progressPageString.value,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'kufi',
                          color: Get.theme.colorScheme.surface),
                    ),
                  )
                : Obx(
                    () => IconButton(
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Play Page',
                        child: Icon(
                          sl<AudioController>().isPagePlay.value
                              ? Icons.pause
                              : Icons.playlist_play_sharp,
                          size: 25,
                        ),
                      ),
                      color: Get.theme.colorScheme.surface,
                      onPressed: () {
                        print(sl<AudioController>().progressPageString.value);

                        sl<AudioController>().isPlay.value = false;
                        sl<AudioController>().playPage(
                            context, sl<GeneralController>().currentPage.value);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
