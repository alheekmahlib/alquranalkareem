import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../controllers/adhan_controller.dart';
import 'prayer_build.dart';

class PrayerWidget extends StatelessWidget {
  PrayerWidget({super.key});

  final adhanCtrl = sl<AdhanController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ArcProgressBar(
              percentage: adhanCtrl.timeProgress.value,
              arcThickness: 10,
              innerPadding: 48,
              strokeCap: StrokeCap.round,
              bottomCenterWidget: Column(
                children: [
                  Text(
                    prayerNameList[adhanCtrl.nextPrayer]['title'],
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                  Text(
                    prayerNameList[adhanCtrl.nextPrayer]['time'],
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                  SlideCountdown(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    slideDirection: SlideDirection.up,
                    duration: adhanCtrl.getTimeLeftForNextPrayer(),
                  ),
                ],
              ),
              handleSize: 120,
              handleWidget: adhanCtrl.LottieWidget,
              foregroundColor: const Color(0xffa22c08).withOpacity(.6),
              backgroundColor: Theme.of(context).canvasColor,
            )),
        PrayerBuild(),
      ],
    );
  }
}
