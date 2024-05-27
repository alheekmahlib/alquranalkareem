import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/controllers/adhan_controller.dart';
import '../../../services/services_locator.dart';

class PrayersHomeWidget extends StatelessWidget {
  PrayersHomeWidget({super.key});

  final adhanCtrl = sl<AdhanController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.sizeOf(Get.context!).width,
        color: const Color(0xff404C6E),
        child: Container(
          width: MediaQuery.sizeOf(Get.context!).width,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xff404C6E),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 1,
              color: Theme.of(Get.context!).colorScheme.surface,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      adhanCtrl.prayerNameList[adhanCtrl.nextPrayer]['icon']!,
                      color: Theme.of(Get.context!).canvasColor.withOpacity(.2),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            adhanCtrl.getNextPrayerName().tr,
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                        Text(
                          adhanCtrl.getNextPrayerDisplayName(),
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Wrap(
                  children: List.generate(
                      adhanCtrl.prayerNameList.length,
                      (index) => Container(
                            height: 28,
                            width: 85,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: adhanCtrl.currentPrayer == index
                                  ? Theme.of(Get.context!).colorScheme.surface
                                  : Theme.of(Get.context!)
                                      .canvasColor
                                      .withOpacity(.2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    adhanCtrl.prayerNameList[index]['icon']!,
                                    color: Theme.of(Get.context!)
                                        .canvasColor
                                        .withOpacity(.2),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${adhanCtrl.prayerNameList[index]['title']}'
                                            .tr,
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        adhanCtrl.prayerNameList[index]
                                            ['time']!,
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
