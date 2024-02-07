import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/general_controller.dart';
import '/core/utils/constants/svg_picture.dart';
import '/presentation/controllers/quran_controller.dart';

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
                : Obx(
                    () => sl<AudioController>().isPagePlay.value
                        ? GestureDetector(
                            child: Semantics(
                              button: true,
                              enabled: true,
                              label: 'Pause Page',
                              child: pause_arrow(height: 25.0),
                            ),
                            onTap: () {
                              sl<QuranController>().isPlayExpanded.value = true;
                              print(sl<AudioController>()
                                  .progressPageString
                                  .value);

                              sl<AudioController>().isPlay.value = false;
                              sl<AudioController>().playPage(context,
                                  sl<GeneralController>().currentPage.value);
                            },
                          )
                        : GestureDetector(
                            child: Semantics(
                              button: true,
                              enabled: true,
                              label: 'Play Page',
                              child: play_page(height: 25.0),
                            ),
                            onTap: () {
                              sl<QuranController>().isPlayExpanded.value = true;
                              print(sl<AudioController>()
                                  .progressPageString
                                  .value);

                              sl<AudioController>().isPlay.value = false;
                              sl<AudioController>().playPage(context,
                                  sl<GeneralController>().currentPage.value);
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
