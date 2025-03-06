import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '../events.dart';

class CalenderSettings extends StatelessWidget {
  const CalenderSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'calenderSettings'.tr,
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontFamily: 'kufi',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.surface.withValues(alpha: .2),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'editHijriDay'.tr,
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 18,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GetBuilder<EventController>(
                          builder: (eventCtrl) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${eventCtrl.adjustHijriDays.value}'
                                        .convertNumbers(),
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withValues(alpha: .7),
                                    ),
                                  ),
                                  const Gap(16),
                                  Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: ElevatedButton(
                                              onPressed: () =>
                                                  eventCtrl.increaseDay(),
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                        EdgeInsets.zero),
                                                elevation:
                                                    WidgetStateProperty.all(0),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              )),
                                        ),
                                        context.vDivider(
                                            height: 20,
                                            color:
                                                Theme.of(context).canvasColor),
                                        SizedBox(
                                          width: 30,
                                          child: ElevatedButton(
                                              onPressed: () =>
                                                  eventCtrl.decreaseDay(),
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                        EdgeInsets.zero),
                                                elevation:
                                                    WidgetStateProperty.all(0),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
