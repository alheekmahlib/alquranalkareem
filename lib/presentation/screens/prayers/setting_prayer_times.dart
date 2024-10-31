import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import 'controller/adhan/adhan_controller.dart';
import 'controller/adhan/extensions/adhan_ui.dart';

class SettingPrayerTimes extends StatelessWidget {
  SettingPrayerTimes({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(
        init: Get.find<AdhanController>(),
        builder: (adhanCtrl) {
          return Column(
            children: [
              Text(
                'ضبط مواقيت الصلاة'.tr,
                style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const Gap(4),
              SizedBox(
                height: 690,
                child: ListView.builder(
                  primary: false,
                  itemCount: adhanCtrl.prayerNameList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${adhanCtrl.prayerNameList[index]['title']!}'.tr,
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Gap(4),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).canvasColor.withOpacity(.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    adhanCtrl.prayerNameList[index]['time']!,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(.7),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${'${adhanCtrl.state.adjustments[index].value}'.convertNumbers()}',
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .canvasColor
                                              .withOpacity(.7),
                                        ),
                                      ),
                                      const Gap(8),
                                      Container(
                                        height: 30,
                                        width: 80,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  await adhanCtrl
                                                      .addOnTap(index);
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  size: 18,
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                )),
                                            context.vDivider(
                                                height: 20,
                                                color: Theme.of(context)
                                                    .canvasColor),
                                            GestureDetector(
                                                onTap: () async {
                                                  await adhanCtrl
                                                      .removeOnTap(index);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
