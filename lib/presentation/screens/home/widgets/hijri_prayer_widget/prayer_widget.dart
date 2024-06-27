import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../../controllers/adhan_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/prayer_progress_controller.dart';
import 'vertical_progress_bar.dart';

class PrayerWidget extends StatelessWidget {
  PrayerWidget({super.key});

  final prayerPBCtrl = PrayerProgressController.instance;
  final adhanCtrl = AdhanController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    final stepTimes = [
      adhanCtrl.prayerTimes.fajr,
      adhanCtrl.prayerTimes.dhuhr,
      adhanCtrl.prayerTimes.asr,
      adhanCtrl.prayerTimes.maghrib,
      adhanCtrl.prayerTimes.isha,
    ];

    final stepIcons = [
      SolarIconsBold.moonFog,
      SolarIconsBold.sun,
      SolarIconsBold.sun2,
      SolarIconsBold.sunset,
      SolarIconsBold.moon,
    ];
    return Container(
      // width: 40,
      height: 160,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 1,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.surface,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      adhanCtrl.prayerNameList[adhanCtrl.currentPrayer + 1]
                          ['icon']!,
                      color: Theme.of(context).canvasColor.withOpacity(.2),
                      size: 70,
                    ),
                    Text(
                      adhanCtrl.getNextPrayerName().tr,
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      adhanCtrl.getNextPrayerDisplayName(),
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Theme.of(Get.context!).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 2),
                          child: SlideCountdown(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 22,
                              color: Theme.of(context).canvasColor,
                            ),
                            slideDirection: SlideDirection.up,
                            duration: adhanCtrl.getTimeLeftForNextPrayer(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Gap(8),
            Obx(() => Row(
                  children: [
                    VerticalProgressBar(
                      progress: prayerPBCtrl.progress.value,
                      backgroundColor:
                          Theme.of(context).canvasColor.withOpacity(.2),
                      progressColor: Theme.of(context).colorScheme.surface,
                      borderWidth: 3,
                      widthShadow: 6,
                      borderRadius: BorderRadius.circular(8),
                      stepTimes: stepTimes,
                      stepIcons: stepIcons,
                      startTime: prayerPBCtrl.adhanCtrl.prayerTimes.fajr
                          .subtract(const Duration(hours: 3)),
                      endTime: prayerPBCtrl.adhanCtrl.prayerTimes.isha
                          .add(const Duration(hours: 4)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
