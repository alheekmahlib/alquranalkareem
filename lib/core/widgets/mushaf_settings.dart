import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '../../presentation/screens/quran_page/controllers/teacher_controller.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../utils/constants/extensions/alignment_rotated_extension.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '../utils/helpers/app_text_styles.dart';
import 'animated_counter_button.dart';
import 'container_button.dart';
import 'custom_switch_widget.dart';

class MushafSettings extends StatelessWidget {
  MushafSettings({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('choseQuran'.tr, style: AppTextStyles.titleMedium()),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                const Gap(8),
                withTajweedWidget(context),
                const Gap(8),
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                  endIndent: 32.0,
                  indent: 32.0,
                  color: Theme.of(
                    context,
                  ).primaryColorLight.withValues(alpha: .5),
                ),
                const Gap(8),
                _changeFontSize(context),
                const Gap(8),
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                  endIndent: 32.0,
                  indent: 32.0,
                  color: Theme.of(
                    context,
                  ).primaryColorLight.withValues(alpha: .5),
                ),
                const Gap(8),
                _changeBackgroundColor(context),
                const Gap(8),
                _teacherModeToggle(context),
                const Gap(8),
                const AutoScrollSettings(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeFontSize(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: .15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'fontSize'.tr,
            style: AppTextStyles.titleMedium().copyWith(height: 2),
          ),
          GetBuilder<QuranCtrl>(
            id: '_pageViewBuild',
            builder: (ctr) => AnimatedCounterButton(
              value: ctr.state.scaleFactor.value,
              height: 32,
              counterType: CounterType.decimal,
              onChanged: (newValue) {
                if (newValue < 1) return;
                ctr.state.scaleFactor.value = newValue;
                ctr.state.baseScaleFactor.value = newValue;
                ctr.update(['_pageViewBuild']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget withTajweedWidget(BuildContext context) {
    final quran = QuranCtrl.instance.state;
    return CustomSwitchListTile(
      title: 'tajweed'.tr,
      value: quran.isTajweedEnabled.value,
      onChanged: (_) {
        quran.isTajweedEnabled.toggle();
        quranCtrl.state.box.write('isTajweed', quran.isTajweedEnabled.value);
        Get.forceAppUpdate();
      },
    );
  }

  Widget _teacherModeToggle(BuildContext context) {
    final teacherCtrl = TeacherController.instance;
    return Obx(
      () => CustomSwitchListTile(
        title: 'teacherMode'.tr,
        value: teacherCtrl.isTeacherModeEnabled.value,
        onChanged: (_) {
          teacherCtrl.toggleTeacherMode();
        },
      ),
    );
  }

  Widget _changeBackgroundColor(BuildContext context) {
    return Obx(
      () => ContainerButton(
        onPressed: () {
          Get.dialog(
            Dialog(
              alignment: Alignment.center,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              surfaceTintColor: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                height: 380,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      ColorPicker(
                        hasBorder: true,
                        wheelHasBorder: true,
                        wheelDiameter: 150,
                        color: Color(
                          quranCtrl.state.backgroundPickerColor.value,
                        ),
                        borderColor: context.theme.colorScheme.primary,
                        onColorChanged: (Color color) =>
                            quranCtrl.state.temporaryBackgroundColor.value =
                                color.toARGB32(),
                        pickersEnabled: {
                          ColorPickerType.wheel: true,
                          ColorPickerType.both: false,
                          ColorPickerType.primary: false,
                          ColorPickerType.accent: false,
                          ColorPickerType.custom: true,
                        },
                        customColorSwatchesAndNames: {
                          const MaterialColor(0xffFFFBF8, <int, Color>{
                            50: Color(0xffffffff),
                            100: Color(0xfffffbfb),
                            200: Color(0xffFFFBF8),
                            300: Color(0xfffff9f5),
                            400: Color(0xfffff7f1),
                            500: Color(0xfffff6e2),
                            600: Color(0xffefe3d1),
                            700: Color(0xffdacdba),
                            800: Color(0xffc8bba6),
                            900: Color(0xffe3d0ac),
                          }): 'Brown',
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ContainerButton(
                              onPressed: () {
                                quranCtrl.state.backgroundPickerColor.value =
                                    context.theme.colorScheme.primaryContainer
                                        .toARGB32();
                                quranCtrl.state.box.remove(
                                  BACKGROUND_PICKER_COLOR,
                                );
                                quranCtrl.update(['backgroundColor']);
                                Get.back();
                              },
                              height: 35,
                              title: 'reset',
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ContainerButton(
                              onPressed: () => Get.back(),
                              height: 35,
                              title: 'cancel',
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            flex: 3,
                            child: ContainerButton(
                              onPressed: () {
                                quranCtrl.state.backgroundPickerColor.value =
                                    quranCtrl
                                        .state
                                        .temporaryBackgroundColor
                                        .value;
                                quranCtrl.state.box.write(
                                  BACKGROUND_PICKER_COLOR,
                                  quranCtrl.state.backgroundPickerColor.value,
                                );
                                quranCtrl.update(['backgroundColor']);
                                Get.back();
                              },
                              height: 35,
                              title: 'ok',
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        value: true.obs,
        height: 45,
        width: double.infinity,
        borderRadius: 8,
        selectedColor: Color(quranCtrl.state.backgroundPickerColor.value),
        backgroundColor: context.theme.primaryColorLight.withValues(alpha: .4),
        title: 'choiceBackgroundColor',
      ),
    );
  }
}

/// إعدادات السكرول التلقائي — تُضاف داخل FontsDownloadWidget
///
/// [AutoScrollSettings] settings section for auto-scroll:
/// stop condition selector, page count input, and initial speed slider.
class AutoScrollSettings extends StatelessWidget {
  const AutoScrollSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final autoScrollCtrl = AutoScrollCtrl.instance;

    return Obx(() {
      final selectedCondition = autoScrollCtrl.state.stopCondition.value;
      final speed = autoScrollCtrl.state.speed.value;
      final pageCount = autoScrollCtrl.state.targetPageCount.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          // العنوان
          Center(
            child: Text(
              'autoScrollSettings'.tr,
              style: AppTextStyles.titleMedium(),
            ),
          ),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(10),

          // شرط التوقف
          Text(
            'stopCondition'.tr,
            style: AppTextStyles.bodySmall().copyWith(
              color: context.theme.colorScheme.inversePrimary.withValues(
                alpha: .7,
              ),
            ),
          ),
          const Gap(6),
          Wrap(
            children: AutoScrollStopCondition.values.map((condition) {
              final isSelected = selectedCondition == condition;
              final chipLabel =
                  QuranController
                      .instance
                      .autoScrollStyle
                      .stopConditionLabels?[condition] ??
                  condition.labelAr;
              return ContainerButton(
                title: chipLabel,
                titleColor: context.theme.colorScheme.inversePrimary,
                value: isSelected.obs,
                horizontalPadding: 8.0,
                verticalPadding: 8.0,
                horizontalMargin: 4.0,
                verticalMargin: 4.0,
                onPressed: () => autoScrollCtrl.updateStopCondition(condition),
              );
            }).toList(),
          ),

          // حقل عدد الصفحات (يظهر فقط عند اختيار pageCount)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: selectedCondition == AutoScrollStopCondition.pageCount
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColorLight.withValues(alpha: .15),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'pageCount'.tr,
                          style: AppTextStyles.titleMedium().copyWith(
                            height: 2,
                          ),
                        ),
                        AnimatedCounterButton(
                          value: pageCount,
                          height: 32,
                          counterType: CounterType.integer,
                          onChanged: (newValue) {
                            autoScrollCtrl.updateTargetPageCount(newValue);
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // سرعة البداية
          const Gap(10),
          Row(
            children: [
              Text('speed'.tr, style: AppTextStyles.titleSmall()),
              const SizedBox(width: 4),
              Text(
                speed.toStringAsFixed(1).convertNumbersAccordingToLang(),
                style: AppTextStyles.titleSmall().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.theme.colorScheme.surface,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            width: MediaQuery.sizeOf(context).width,
            child: FlutterSlider(
              values: [speed],
              min: 0.1,
              max: 5.0,
              rtl: alignmentLayout(true, false),
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBarHeight: 5,
                activeTrackBarHeight: 5,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Get.theme.colorScheme.surface.withValues(alpha: .2),
                ),
                activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Get.theme.colorScheme.surface,
                ),
              ),
              handlerAnimation: const FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: null,
                duration: Duration(milliseconds: 700),
                scale: 1.4,
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                autoScrollCtrl.updateSpeed(lowerValue);
              },
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: Material(
                  type: MaterialType.circle,
                  color: Colors.transparent,
                  elevation: 3,
                  child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                ),
              ),
            ),
          ),
          // تسميات بطيء / سريع
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('slow'.tr, style: AppTextStyles.titleSmall()),
                Text('fast'.tr, style: AppTextStyles.titleSmall()),
              ],
            ),
          ),
          const Gap(8),
        ],
      );
    });
  }
}
