import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../presentation/controllers/general_controller.dart';
import '../../../services/services_locator.dart';

class HijriHomeWidget extends StatelessWidget {
  HijriHomeWidget({super.key});

  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.sizeOf(Get.context!).width,
        color: const Color(0xff404C6E),
        child: Container(
          width: MediaQuery.sizeOf(Get.context!).width,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff404C6E),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 1,
              color: Theme.of(Get.context!).colorScheme.surface,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(Get.context!).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Transform.translate(
                            offset: const Offset(0, 4),
                            child: Text(
                              generalCtrl
                                  .convertNumbers('${generalCtrl.today.hDay}'),
                              style: TextStyle(
                                fontSize: 26.0,
                                fontFamily: 'kufi',
                                color: Theme.of(Get.context!).canvasColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${generalCtrl.today.dayWeName}'.tr,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'kufi',
                                  color: Theme.of(Get.context!).canvasColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                generalCtrl.convertNumbers(
                                    '${generalCtrl.today.hYear} هـ'),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'kufi',
                                  color: Theme.of(Get.context!).canvasColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 45,
                      // width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(Get.context!).canvasColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        '${generalCtrl.today.longMonthName}'.tr,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'kufi',
                          color:
                              Theme.of(Get.context!).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 30,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      value: (generalCtrl.today.hDay /
                          generalCtrl.today.lengthOfMonth),
                      backgroundColor: Theme.of(Get.context!).canvasColor,
                      color: Theme.of(Get.context!).colorScheme.surface,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 7,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${'RemainsUntilTheEndOf'.tr} ${'${generalCtrl.today.longMonthName}'.tr}',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'kufi',
                                    color: Theme.of(Get.context!).disabledColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay} ${'${generalCtrl.daysArabicConvert(generalCtrl.today.hDay)}'.tr}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'kufi',
                                    color: Theme.of(Get.context!).disabledColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}
