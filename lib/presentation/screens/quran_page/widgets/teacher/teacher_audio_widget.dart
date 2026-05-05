import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/container_button.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../controllers/teacher_controller.dart';
import 'teacher_settings_sheet.dart';

class TeacherAudioWidget extends StatelessWidget {
  TeacherAudioWidget({super.key});

  final teacherCtrl = TeacherController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0, right: 32.0, left: 32.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 3,
              spreadRadius: 3,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: .15),
            ),
          ],
        ),
        child: Obx(() {
          final isPlaying = teacherCtrl.isPlaying.value;
          final isLoading = teacherCtrl.isLoading.value;
          final currentRepeat = teacherCtrl.repeatCount.value > 0
              ? teacherCtrl.currentRepeatIndex.value + 1
              : 0;
          final totalRepeats = teacherCtrl.repeatCount.value;
          final wordProgress = teacherCtrl.totalWords.value > 0
              ? '${teacherCtrl.currentWordIndex.value + 1}/${teacherCtrl.totalWords.value}'
                  .convertNumbersToCurrentLang()
              : '';

          return SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Play/Pause button
                  ContainerButton(
                    height: 36,
                    width: 36,
                    isPreparingDownload: isLoading,
                    svgWithColorPath: isPlaying
                        ? SvgPath.svgAudioPauseArrow
                        : SvgPath.svgAudioPlayWord,
                    svgColor: Get.theme.hintColor,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      if (isPlaying) {
                        teacherCtrl.pause();
                      } else {
                        if (teacherCtrl.isPaused.value) {
                          teacherCtrl.play();
                        } else {
                          teacherCtrl.play();
                        }
                      }
                    },
                  ),

                  // Stop button
                  ContainerButton(
                    height: 36,
                    width: 36,
                    svgWithColorPath: SvgPath.svgHomeClose,
                    svgColor: Get.theme.hintColor,
                    backgroundColor: Colors.transparent,
                    onPressed: () => teacherCtrl.stop(),
                  ),

                  // Replay word - use previous as replay
                  ContainerButton(
                    height: 36,
                    width: 36,
                    svgWithColorPath: SvgPath.svgAudioPreviousIcon,
                    svgColor: Get.theme.hintColor,
                    backgroundColor: Colors.transparent,
                    onPressed: () => teacherCtrl.replayWord(),
                  ),

                  // Skip next
                  ContainerButton(
                    height: 36,
                    width: 36,
                    svgWithColorPath: SvgPath.svgAudioNextIcon,
                    svgColor: Get.theme.hintColor,
                    backgroundColor: Colors.transparent,
                    onPressed: () => teacherCtrl.skipNext(),
                  ),

                  // Progress info
                  if (wordProgress.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        wordProgress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Get.theme.colorScheme.inversePrimary
                              .withValues(alpha: .7),
                        ),
                      ),
                    ),

                  // Repeat indicator
                  if (isPlaying && totalRepeats > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '×${currentRepeat.toString().convertNumbersToCurrentLang()}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Get.theme.colorScheme.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Settings button
                  CustomButton(
                    height: 36,
                    width: 36,
                    iconSize: 20,
                    icon: Icons.settings_outlined,
                    svgColor: Get.theme.hintColor,
                    onPressed: () {
                      TeacherSettingsSheet.show(Get.context!);
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
