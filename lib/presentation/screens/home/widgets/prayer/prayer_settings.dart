import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/controllers/adhan_controller.dart';
import '/presentation/screens/home/widgets/prayer/adhan_sounds.dart';
import 'detect_location.dart';
import 'set_timing_calculations.dart';

class PrayerSettings extends StatelessWidget {
  PrayerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return Container(
        height: Get.height * .8,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: context.customClose(height: 40),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'إعدادات الصلاة',
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: ListView(
                children: [
                  DetectLocation(),
                  AdhanSounds(),
                  const Gap(8),
                  SetTimingCalculations()
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
