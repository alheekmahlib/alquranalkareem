import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import 'occasions.dart';

class HijriDate extends StatelessWidget {
  HijriDate({super.key});

  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    generalCtrl.updateGreeting();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () =>
            Get.bottomSheet(OccasionsWidget(), isScrollControlled: true),
        child: ContainerButton(
          height: 170,
          width: 250,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.surface,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 8.0),
                //     child: Text(
                //       '| ${sl<GeneralController>().greeting.value} |',
                //       style: TextStyle(
                //         fontSize: 16.0,
                //         fontFamily: 'kufi',
                //         color: Theme.of(context).hintColor,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            child: Transform.translate(
                              offset: const Offset(0, 4),
                              child: Text(
                                generalCtrl.convertNumbers(
                                    '${generalCtrl.today.hDay}'),
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontFamily: 'kufi',
                                  color: Theme.of(context).canvasColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${generalCtrl.today.dayWeName}'.tr,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'kufi',
                                    color: Theme.of(context).canvasColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  generalCtrl.convertNumbers(
                                      '${generalCtrl.today.hYear} هـ'),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'kufi',
                                    color: Theme.of(context).canvasColor,
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
                      child: SvgPicture.asset(
                          'assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
                          height: 90,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).canvasColor, BlendMode.srcIn)),
                    ),
                  ],
                ),
                Container(
                  height: 23,
                  width: MediaQuery.sizeOf(context).width,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      Container(
                        width: generalCtrl.calculateProgress2(
                            generalCtrl.today.hDay,
                            generalCtrl.today.lengthOfMonth -
                                generalCtrl.today.hDay,
                            330),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
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
                                      fontSize: 14.0,
                                      fontFamily: 'kufi',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
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
                                      fontSize: 14.0,
                                      fontFamily: 'kufi',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
