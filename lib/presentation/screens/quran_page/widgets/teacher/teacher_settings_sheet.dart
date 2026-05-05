import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/helpers/app_text_styles.dart';
import '../../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../../core/widgets/animated_counter_button.dart';
import '../../../../../core/widgets/container_button.dart';
import '../../controllers/teacher_controller.dart';

class TeacherSettingsSheet {
  TeacherSettingsSheet._();

  static void show(BuildContext context) {
    final teacherCtrl = TeacherController.instance;

    // Get current page ayahs from injected callback
    final allAyahs = teacherCtrl.getAllAyahs?.call() ?? [];
    final firstUQ = allAyahs.isNotEmpty ? allAyahs.first.ayahUQNumber : 1;
    final lastUQ = allAyahs.isNotEmpty ? allAyahs.last.ayahUQNumber : 1;

    if (!teacherCtrl.isPlaying.value) {
      teacherCtrl.startAyahUQNumber.value = firstUQ;
      teacherCtrl.endAyahUQNumber.value = lastUQ;
    }

    BottomSheetExtension(null).customBottomSheet(
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.school_outlined,
                  color: Get.theme.colorScheme.primary,
                  size: 28,
                ),
                const Gap(8),
                Text(
                  'teacherMode'.tr,
                  style: AppTextStyles.titleMedium(),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Get.theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Get.theme.primaryColorLight.withValues(alpha: .3),
          ),

          // Repeat count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Get.theme.primaryColorLight.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'repeatCount'.tr,
                    style: AppTextStyles.titleMedium().copyWith(height: 2),
                  ),
                  Obx(() => AnimatedCounterButton(
                        value: teacherCtrl.repeatCount.value,
                        min: 1,
                        max: 20,
                        height: 32,
                        onChanged: (v) => teacherCtrl.setRepeatCount(v),
                      )),
                ],
              ),
            ),
          ),

          // Delay between words
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Get.theme.primaryColorLight.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'delayBetween'.tr,
                    style: AppTextStyles.titleMedium().copyWith(height: 2),
                  ),
                  Obx(() => AnimatedCounterButton(
                        value: teacherCtrl.delayBetweenWords.value,
                        min: 0,
                        max: 50,
                        height: 32,
                        counterType: CounterType.decimal,
                        onChanged: (v) {
                          if (v < 0.2) return;
                          teacherCtrl.setDelay(v);
                        },
                      )),
                ],
              ),
            ),
          ),

          const Gap(12),

          // Ayah range
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Get.theme.primaryColorLight.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'ayahRange'.tr,
                    style: AppTextStyles.titleSmall(),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'from'.tr,
                              style: AppTextStyles.bodySmall(),
                            ),
                            const Gap(4),
                            Obx(() => AnimatedCounterButton(
                                  value: teacherCtrl.startAyahUQNumber.value,
                                  min: 1,
                                  max: 6236,
                                  height: 32,
                                  onChanged: (v) {
                                    teacherCtrl.startAyahUQNumber.value = v;
                                    if (v > teacherCtrl.endAyahUQNumber.value) {
                                      teacherCtrl.endAyahUQNumber.value = v;
                                    }
                                  },
                                )),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'to'.tr,
                              style: AppTextStyles.bodySmall(),
                            ),
                            const Gap(4),
                            Obx(() => AnimatedCounterButton(
                                  value: teacherCtrl.endAyahUQNumber.value,
                                  min: 1,
                                  max: 6236,
                                  height: 32,
                                  onChanged: (v) {
                                    teacherCtrl.endAyahUQNumber.value = v;
                                    if (v < teacherCtrl.startAyahUQNumber.value) {
                                      teacherCtrl.startAyahUQNumber.value = v;
                                    }
                                  },
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Gap(16),

          // Start button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ContainerButton(
              onPressed: () {
                Get.back();
                teacherCtrl.play();
              },
              height: 45,
              title: 'start'.tr,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
