import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/lists.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../utils/constants/shared_preferences_constants.dart';

class MushafSettings extends StatelessWidget {
  MushafSettings({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'choseQuran'.tr,
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
            child: Column(
              children: [
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      mushafSettingsList.length,
                      (index) => Obx(() {
                            return AnimatedOpacity(
                              opacity: quranCtrl.state.isPages.value == index
                                  ? 1
                                  : .5,
                              duration: const Duration(milliseconds: 300),
                              child: GestureDetector(
                                onTap: () => quranCtrl.switchMode(index),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 1),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      child: Image.asset(
                                        mushafSettingsList[index]['imageUrl'],
                                        width: 50,
                                      ),
                                    ),
                                    const Gap(6),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      child:
                                          quranCtrl.state.isPages.value == index
                                              ? const Icon(Icons.done,
                                                  size: 14, color: Colors.white)
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                const Gap(8),
                _page(context),
                const Gap(8),
                // context.hDivider(width: MediaQuery.sizeOf(context).width),
                // const Gap(8),
                // _fontsBuild(context),
                // QuranLibrary().getFontsDownloadWidget(context,
                //     languageCode: Get.locale!.languageCode,
                //     isFontsLocal: true,
                //     downloadFontsDialogStyle: DownloadFontsDialogStyle(
                //       defaultFontText: 'defaultFontText'.tr,
                //       downloadedFontsText: 'downloadedFontsText'.tr,
                //       title: 'fonts'.tr,
                //       notes: 'fontsNotes'.tr,
                //       downloadingText: 'downloading'.tr,
                //       linearProgressColor: Get.theme.colorScheme.surface,
                //       linearProgressBackgroundColor:
                //           Get.theme.colorScheme.surface.withValues(alpha: .2),
                //       titleColor: Get.theme.colorScheme.inversePrimary,
                //       notesColor: Get.theme.colorScheme.inversePrimary,
                //       iconColor: Get.theme.colorScheme.surface,
                //       downloadButtonBackgroundColor:
                //           Get.theme.colorScheme.surface,
                //       dividerColor: Get.theme.colorScheme.surface,
                //     )),
                // const Gap(8),
                context.hDivider(width: MediaQuery.sizeOf(context).width),
                const Gap(8),
                Column(
                  children: List.generate(
                      2,
                      (index) => Obx(() => GestureDetector(
                            onTap: () {
                              quranCtrl.state.isBold.value = index;
                              GetStorage().write(IS_BOLD, index);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        width: 2),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: quranCtrl.state.isBold.value == index
                                      ? const Icon(Icons.done,
                                          size: 14, color: Colors.white)
                                      : null,
                                ),
                                const Gap(6),
                                Text(
                                  'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلۡحَيُّ ٱلۡقَيُّومُ',
                                  style: TextStyle(
                                    fontFamily: 'uthmanic2',
                                    fontSize: 18,
                                    height: 1.9,
                                    fontWeight: index == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ))),
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

  Widget _page(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedOpacity(
          opacity: quranCtrl.state.isPageMode.value ? 1 : .5,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () => quranCtrl.pageModeOnTap(true),
            child: Column(
              children: [
                GetX<QuranController>(
                  builder: (quranCtrl) => Container(
                    height: 100,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Container(
                        margin: context.customOrientation(
                            const EdgeInsets.only(right: 4.0),
                            const EdgeInsets.only(right: 4.0)),
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Theme.of(context)
                                    .primaryColorDark
                                    .withValues(alpha: .5)
                                : Theme.of(context)
                                    .dividerColor
                                    .withValues(alpha: .5),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Container(
                          margin: const EdgeInsets.only(right: 4.0),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Theme.of(context)
                                      .primaryColorDark
                                      .withValues(alpha: .7)
                                  : Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: .7),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12))),
                          child: Container(
                            margin: const EdgeInsets.only(right: 4.0),
                            decoration: BoxDecoration(
                                color: quranCtrl.backgroundColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                          ),
                        )),
                  ),
                ),
                const Gap(6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface, width: 2),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: quranCtrl.state.isPageMode.value
                      ? const Icon(Icons.done, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: !quranCtrl.state.isPageMode.value ? 1 : .5,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () => quranCtrl.pageModeOnTap(false),
            child: Column(
              children: [
                GetX<QuranController>(
                  builder: (quranCtrl) => Container(
                    height: 100,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1),
                      color: quranCtrl.backgroundColor,
                    ),
                  ),
                ),
                const Gap(6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface, width: 2),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: !quranCtrl.state.isPageMode.value
                      ? const Icon(Icons.done, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _changeBackgroundColor(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(Dialog(
          alignment: Alignment.center,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          child: SizedBox(
            height: 240,
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                children: [
                  ColorPicker(
                    wheelHasBorder: true,
                    wheelDiameter: 300,
                    color: Color(quranCtrl.state.backgroundPickerColor.value),
                    onColorChanged: (Color color) => quranCtrl
                        .state.temporaryBackgroundColor.value = color.value,
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
                        child: GestureDetector(
                          onTap: () {
                            quranCtrl.state.backgroundPickerColor.value =
                                0xfffaf7f3;
                            quranCtrl.state.box.remove(BACKGROUND_PICKER_COLOR);
                            quranCtrl.update();
                            Get.back();
                          },
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: .1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.surface,
                                )),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'reset'.tr,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontFamily: 'kufi',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: .1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.surface,
                                )),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'cancel'.tr,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontFamily: 'kufi',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            quranCtrl.state.backgroundPickerColor.value =
                                quranCtrl.state.temporaryBackgroundColor.value;
                            quranCtrl.state.box.write(BACKGROUND_PICKER_COLOR,
                                quranCtrl.state.backgroundPickerColor.value);
                            quranCtrl.update();
                            Get.back();
                          },
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: .1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.surface,
                                )),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'ok'.tr,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontFamily: 'kufi',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      },
      child: Container(
        height: 40,
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: .2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.surface)),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'choiceBackgroundColor'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontFamily: 'kufi',
                  ),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 1,
              child: Obx(() => Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: Color(quranCtrl.state.backgroundPickerColor.value),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _fontsBuild(BuildContext context) {
  //   List<String> titleList = [
  //     'defaultFontText',
  //     'downloadedFontsText',
  //   ];
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           'fonts'.tr,
  //           style: TextStyle(
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.bold,
  //             fontFamily: 'kufi',
  //             color: Get.theme.colorScheme.inversePrimary,
  //           ),
  //           textAlign: TextAlign.start,
  //         ),
  //         const Gap(8.0),
  //         context.horizontalDivider(
  //           width: Get.width,
  //           color: Get.theme.colorScheme.surface,
  //         ),
  //         const Gap(8.0),
  //         Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: List.generate(
  //             titleList.length,
  //             (i) => Container(
  //               margin: const EdgeInsets.symmetric(vertical: 2.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: Get.theme.colorScheme.surface.withValues(alpha: .2),
  //                   width: 1.0,
  //                 ),
  //                 borderRadius: BorderRadius.circular(8.0),
  //               ),
  //               child: Container(
  //                 height: 50,
  //                 margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                 color:
  //                     QuranLibrary().quranCtrl.state.fontsSelected2.value == i
  //                         ? Get.theme.colorScheme.surface.withValues(alpha: .05)
  //                         : null,
  //                 child: CheckboxListTile(
  //                   value:
  //                       (QuranLibrary().quranCtrl.state.fontsSelected2.value ==
  //                               i)
  //                           ? true
  //                           : false,
  //                   activeColor: Get.theme.colorScheme.surface,
  //                   title: Text(
  //                     titleList[i].tr,
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontFamily: 'naskh',
  //                       color: Get.theme.colorScheme.inversePrimary,
  //                     ),
  //                   ),
  //                   onChanged: (_) {
  //                     QuranLibrary().quranCtrl.state.fontsSelected2.value = i;
  //                     GetStorage().write('fontsSelected2', i);
  //                     log('fontsSelected: $i');
  //                     Get.forceAppUpdate();
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
