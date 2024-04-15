import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../../core/services/location/locations.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/adhan_controller.dart';
import '../../../../controllers/general_controller.dart';
import 'prayer_build.dart';

class PrayerWidget extends StatelessWidget {
  PrayerWidget({super.key});

  final adhanCtrl = sl<AdhanController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 80,
                    color: Theme.of(context).canvasColor.withOpacity(.1),
                  ),
                  Column(
                    children: [
                      Text(
                        Location.instance.city,
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      Text(
                        Location.instance.country,
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 12,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Obx(() => ArcProgressBar(
                  percentage: adhanCtrl.timeProgress.value,
                  arcThickness: 10,
                  innerPadding: 48,
                  strokeCap: StrokeCap.round,
                  bottomCenterWidget: Column(
                    children: [
                      Text(
                        adhanCtrl.getNextPrayerName(),
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      Text(
                        adhanCtrl.getNextPrayerDisplayName().toString(),
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
                  handleSize: 100,
                  handleWidget: adhanCtrl.LottieWidget,
                  foregroundColor: const Color(0xffa22c08).withOpacity(.6),
                  backgroundColor: Theme.of(context).canvasColor,
                )),
          ],
        ),
        PrayerBuild(),
      ],
    );
  }
}
