import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../controllers/adhan_controller.dart';
import '../../../../controllers/general_controller.dart';

class HijriWidget extends StatelessWidget {
  HijriWidget({super.key});

  final adhanCtrl = AdhanController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )),
                  child: Text(
                    '${generalCtrl.today.hDay}'.convertNumbers(),
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'kufi',
                      color: Theme.of(context).canvasColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${generalCtrl.today.dayWeName}'.tr,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'kufi',
                        color: Theme.of(context).canvasColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${'${generalCtrl.today.hYear}'.convertNumbers()} هـ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'kufi',
                        color: Theme.of(context).canvasColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset('assets/svg/hijri/${generalCtrl.today.hMonth}.svg',
                width: 120,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).canvasColor, BlendMode.srcIn)),
            const Gap(32),
          ],
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              LinearProgressIndicator(
                minHeight: 40,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                value:
                    (generalCtrl.today.hDay / generalCtrl.today.lengthOfMonth),
                backgroundColor: Theme.of(context).canvasColor,
                color: Theme.of(context).colorScheme.surface,
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
                              color: Theme.of(context).disabledColor,
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
                            '${generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay} ${'${generalCtrl.daysArabicConvert(generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay)}'.tr}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'kufi',
                              color: Theme.of(context).disabledColor,
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
        ),
      ],
    );
  }
}