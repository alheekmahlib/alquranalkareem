import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../../controllers/general_controller.dart';

class OccasionWidget extends StatelessWidget {
  final String name;
  final int month;
  final int day;
  OccasionWidget(
      {super.key, required this.month, required this.day, required this.name});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    int daysUntilEvent = generalCtrl.calculateDaysUntilSpecificDate(
        generalCtrl.today.hYear, month, day);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Container(
        height: 70,
        width: 380,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              height: 70,
              width: generalCtrl.calculateProgress2(
                  generalCtrl.today.hDay,
                  generalCtrl.today.hMonth == month
                      ? generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay
                      : daysUntilEvent,
                  380),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                  color: generalCtrl.today.hMonth == month
                      ? const Color(0xffa22c08).withOpacity(.5)
                      : Theme.of(context).colorScheme.surface.withOpacity(.5),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        generalCtrl.today.hMonth == month
                            ? '${'RemainsUntilTheEndOf'.tr}\n$name'
                            : name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'kufi',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        generalCtrl.today.hMonth == month
                            ? '${(generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay).toString().convertNumbers()}\n${'${generalCtrl.daysArabicConvert(generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay)}'.tr}'
                            : '${daysUntilEvent.toString().convertNumbers()}\n${'${generalCtrl.daysArabicConvert(generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay)}'.tr}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OccasionNextWidget extends StatelessWidget {
  final String name;
  final int month;
  final int day;
  OccasionNextWidget(
      {super.key, required this.month, required this.day, required this.name});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    int daysUntilEvent = generalCtrl.calculateDaysUntilSpecificDate(
        generalCtrl.today.hYear + 1, month, day);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Container(
        height: 70,
        width: 380,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              height: 70,
              width: generalCtrl.calculateProgress2(
                  generalCtrl.today.hDay,
                  generalCtrl.today.hYear + 1 != generalCtrl.today.hYear
                      ? daysUntilEvent
                      : generalCtrl.today.hMonth == month
                          ? generalCtrl.today.lengthOfMonth -
                              generalCtrl.today.hDay
                          : daysUntilEvent,
                  380),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                  color: generalCtrl.today.hYear + 1 != generalCtrl.today.hYear
                      ? Theme.of(context).colorScheme.surface.withOpacity(.5)
                      : generalCtrl.today.hMonth == month
                          ? const Color(0xffa22c08).withOpacity(.5)
                          : Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.5),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        generalCtrl.today.hYear + 1 != generalCtrl.today.hYear
                            ? name
                            : generalCtrl.today.hMonth == month
                                ? '${'RemainsUntilTheEndOf'.tr}\n$name'
                                : name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'kufi',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        generalCtrl.today.hYear + 1 != generalCtrl.today.hYear
                            ? '${daysUntilEvent.toString().convertNumbers()}\n${'${generalCtrl.daysArabicConvert(generalCtrl.today.hDay)}'.tr}'
                            : generalCtrl.today.hMonth == month
                                ? '${(generalCtrl.today.lengthOfMonth - generalCtrl.today.hDay).toString().convertNumbers()}\n${'${generalCtrl.daysArabicConvert(generalCtrl.today.hDay)}'.tr}'
                                : '${daysUntilEvent.toString().convertNumbers()}\n${'${generalCtrl.daysArabicConvert(generalCtrl.today.hDay)}'.tr}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
