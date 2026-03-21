import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/widgets/animated_counter_button.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../events.dart';

class CalenderSettings extends StatelessWidget {
  const CalenderSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('calenderSettings'.tr, style: AppTextStyles.titleMedium()),
          const Gap(4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withValues(alpha: .2),
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
                      style: AppTextStyles.titleMedium(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GetBuilder<EventController>(
                      builder: (eventCtrl) => AnimatedCounterButton(
                        value: eventCtrl.adjustHijriDays.value,
                        height: 32,
                        onChanged: (newValue) {
                          if (newValue > eventCtrl.adjustHijriDays.value) {
                            eventCtrl.increaseDay();
                          } else {
                            eventCtrl.decreaseDay();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
