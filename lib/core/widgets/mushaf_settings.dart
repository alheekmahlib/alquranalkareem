import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '../../presentation/screens/quran_page/quran.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '../utils/helpers/app_text_styles.dart';
import 'container_button.dart';

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
                pageModeWidget(context),
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
                _changeBackgroundColor(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget withTajweedWidget(BuildContext context) {
    final quran = QuranCtrl.instance.state;
    return ContainerButton(
      onPressed: () {
        quran.isTajweedEnabled.toggle();
        quranCtrl.state.box.write('isTajweed', quran.isTajweedEnabled.value);
        Get.forceAppUpdate();
      },
      height: 45,
      width: double.infinity,
      borderRadius: 8,
      value: quran.isTajweedEnabled,
      backgroundColor: context.theme.primaryColorLight.withValues(
        alpha: quran.isTajweedEnabled.value ? .4 : .2,
      ),
      // selectedColor: context.theme.colorScheme.primaryContainer,
      title: 'tajweed'.tr,
    );
  }

  Widget pageModeWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        2,
        (i) => Obx(
          () => ContainerButton(
            onPressed: () => quranCtrl.switchMode(i),
            borderRadius: 8,
            value: (quranCtrl.state.selectMushafSettingsPage.value == i)
                .obs, // quranCtrl.state.box.read(SWITCH_VALUE),
            backgroundColor: context.theme.primaryColorLight.withValues(
              alpha: .4,
            ),
            // selectedColor: context.theme.colorScheme.primaryContainer,
            child: Container(
              height: 100,
              width: 65,
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  i == 1 ? 5 : 15,
                  (index) => Container(
                    height: i == 1 ? 6 : 3,
                    width: Get.width,
                    margin: EdgeInsets.symmetric(vertical: i == 1 ? 6 : 1.5),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary.withValues(
                        alpha: .5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
                height: 240,
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
                        wheelDiameter: 300,
                        color: Color(
                          quranCtrl.state.backgroundPickerColor.value,
                        ),
                        borderColor: context.theme.colorScheme.primary,
                        onColorChanged: (Color color) =>
                            quranCtrl.state.temporaryBackgroundColor.value =
                                color.toARGB32(),
                        pickersEnabled: {
                          ColorPickerType.wheel: false,
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
                                    0xfffaf7f3;
                                quranCtrl.state.box.remove(
                                  BACKGROUND_PICKER_COLOR,
                                );
                                quranCtrl.update();
                                Get.back();
                              },
                              height: 35,
                              title: 'reset'.tr,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ContainerButton(
                              onPressed: () => Get.back(),
                              height: 35,
                              title: 'cancel'.tr,
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
                                quranCtrl.update();
                                Get.back();
                              },
                              height: 35,
                              title: 'ok'.tr,
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
        title: 'choiceBackgroundColor'.tr,
      ),
    );
  }
}
