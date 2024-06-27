import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
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
        height: 170,
        width: MediaQuery.sizeOf(Get.context!).width,
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.sizeOf(Get.context!).width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xff404C6E),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 6,
              color: Theme.of(Get.context!).colorScheme.surface,
            ),
            // boxShadow: [
            //   const BoxShadow(
            //     color: Colors.black45,
            //     blurRadius: 5,
            //     spreadRadius: 3,
            //     offset: Offset(0, -5),
            //   )
            // ],
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
                adhanCtrl.prayerNameList.length,
                (index) => index == 0
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 65,
                            width: 140,
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  adhanCtrl.prayerNameList[adhanCtrl.nextPrayer]
                                      ['icon']!,
                                  color: Theme.of(Get.context!).canvasColor,
                                  size: 30,
                                ),
                                const Gap(8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Gap(4),
                                    Text(
                                      adhanCtrl.getNextPrayerName().tr,
                                      style: TextStyle(
                                        fontFamily: 'kufi',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      adhanCtrl.getNextPrayerDisplayName(),
                                      style: TextStyle(
                                        fontFamily: 'kufi',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 110,
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(Get.context!).colorScheme.surface,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0))),
                          ),
                        ],
                      )
                    : index == 7
                        ? const SizedBox.shrink()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 140,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      adhanCtrl.prayerNameList[index - 1]
                                          ['icon']!,
                                      size: 20,
                                      color:
                                          adhanCtrl.currentPrayer == index - 1
                                              ? Theme.of(Get.context!)
                                                  .colorScheme
                                                  .surface
                                                  .withOpacity(.7)
                                              : Theme.of(Get.context!)
                                                  .canvasColor
                                                  .withOpacity(.2),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 55,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '${adhanCtrl.prayerNameList[index - 1]['title']}'
                                                  .tr,
                                              style: TextStyle(
                                                fontFamily: 'kufi',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    adhanCtrl.currentPrayer ==
                                                            index - 1
                                                        ? Theme.of(Get.context!)
                                                            .colorScheme
                                                            .surface
                                                        : Theme.of(Get.context!)
                                                            .canvasColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          adhanCtrl.prayerNameList[index - 1]
                                              ['time']!,
                                          style: TextStyle(
                                            fontFamily: 'kufi',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: adhanCtrl.currentPrayer ==
                                                    index - 1
                                                ? Theme.of(Get.context!)
                                                    .colorScheme
                                                    .surface
                                                : Theme.of(Get.context!)
                                                    .canvasColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -3),
                                child: context.hDivider(
                                    width: 100,
                                    height: 1,
                                    color: adhanCtrl.currentPrayer == index - 1
                                        ? Theme.of(Get.context!)
                                            .colorScheme
                                            .surface
                                            .withOpacity(.5)
                                        : Theme.of(Get.context!)
                                            .canvasColor
                                            .withOpacity(.5)),
                              )
                            ],
                          )),
          ),
        ),
      ),
    );
  }
}
