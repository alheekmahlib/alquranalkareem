import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/services/services_locator.dart';
import '/presentation/controllers/adhan_controller.dart';

class PrayerBuild extends StatelessWidget {
  PrayerBuild({super.key});

  final sharedCtrl = sl<SharedPreferences>();
  // final adhanCtrl = sl<AdhanController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return SizedBox(
        height: 300,
        child: Wrap(
          children: List.generate(
              adhanCtrl.prayerNameList.length,
              (index) => GestureDetector(
                    onTap: () => adhanCtrl.prayerAlarmSwitch(index),
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Theme.of(Get.context!).colorScheme.primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(
                            color:
                                adhanCtrl.getcurrentSelectedPrayer(index).value
                                    ? const Color(0xfff16938)
                                    : Theme.of(Get.context!).canvasColor,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignInside,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 110,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: Theme.of(Get.context!)
                                  .canvasColor
                                  .withOpacity(.2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${adhanCtrl.prayerNameList[index]['title']}'
                                        .tr,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(Get.context!).canvasColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  adhanCtrl.prayerNameList[index]['time']!,
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(Get.context!).canvasColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12),
                            child: Icon(
                              adhanCtrl.getPrayerSelected(
                                  index,
                                  Icons.alarm_on_outlined,
                                  Icons.alarm_off_outlined),
                              color: adhanCtrl.getPrayerSelected(
                                  index,
                                  Theme.of(context).canvasColor,
                                  Theme.of(context)
                                      .canvasColor
                                      .withOpacity(.2)),
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      );
    });
  }
}
