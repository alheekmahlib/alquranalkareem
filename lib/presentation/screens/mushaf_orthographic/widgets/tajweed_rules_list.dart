import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controller/waqf_tajweed_screen_controller.dart';

class TajweedRulesListWidget extends StatelessWidget {
  const TajweedRulesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final rules = WaqfTajweedScreenController.instance.tajweedRules;
      if (rules.isEmpty) {
        return Center(
          child: Text(
            'tajweedRules'.tr,
            style: TextStyle(
              fontFamily: 'kufi',
              color: theme.colorScheme.primary,
            ),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: rules.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, index) {
          final rule = rules[index];
          final ruleColor = Color(rule.color);

          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: .15),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: .06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Color indicator bar
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: ruleColor,
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(12),
                        bottomStart: Radius.circular(12),
                      ),
                    ),
                  ),
                  const Gap(16),
                  // Color circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ruleColor.withValues(alpha: .15),
                      shape: BoxShape.circle,
                      border: Border.all(color: ruleColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${(rule.index ?? index) + 1}',
                        style: AppTextStyles.titleSmall(height: 1.1),
                      ),
                    ),
                  ),
                  const Gap(12),
                  // Rule name
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        rule.displayText,
                        style: AppTextStyles.titleMedium(),
                      ),
                    ),
                  ),
                  const Gap(12),
                  // Color sample swatch
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: ruleColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
