import 'dart:developer';

import 'package:alquranalkareem/core/utils/constants/extensions/alignment_rotated_extension.dart';
import 'package:alquranalkareem/core/utils/constants/extensions/bottom_sheet_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../controller/adhkar_controller.dart';
import '../screens/adhkar_item.dart';
import 'azkar_reminder_widget.dart';

class AdhkarList extends StatelessWidget {
  const AdhkarList({super.key});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    return context.customOrientation(
        Column(
          children: [
            const Gap(32),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
                    onTap: () => customBottomSheet(AdhkarReminderWidget()),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -2),
                          child: RotatedBox(
                            quarterTurns: alignmentLayout(1, 3),
                            child: customSvgWithColor(SvgPath.svgButtonCurve,
                                height: 45.0,
                                width: 45.0,
                                color: Get.theme.colorScheme.primary),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          child: Icon(
                            Icons.alarm,
                            size: 25,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                customLottieWithColor(LottieConstants.assetsLottieAzkar,
                    height: 120, isRepeat: false),
              ],
            ),
            const Gap(32),
            Flexible(
              child: Container(
                height: 600,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1)),
                child: AnimationLimiter(
                  child: Obx(() {
                    return ListView.builder(
                      controller: azkarCtrl.state.listController,
                      itemCount: azkarCtrl.state.categories.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 450),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  azkarCtrl.filterByCategory(
                                      azkarCtrl.state.categories[index]);
                                  Get.to(() => const AdhkarItem(),
                                      transition: Transition.leftToRight);
                                  log('filterByCategory: $index');
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: .1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: customSvgWithCustomColor(
                                          SvgPath.svgSliderIc2,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  width: 1)),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Text(
                                                    azkarCtrl
                                                        .state.categories[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 22,
                                                      fontFamily: 'naskh',
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                height: 600,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1)),
                child: AnimationLimiter(
                  child: Obx(() {
                    return ListView.builder(
                      controller: azkarCtrl.state.listController,
                      itemCount: azkarCtrl.state.categories.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 450),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  azkarCtrl.filterByCategory(
                                      azkarCtrl.state.categories[index]);
                                  Get.to(const AdhkarItem(),
                                      transition: Transition.leftToRight);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: .1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: customSvgWithCustomColor(
                                          SvgPath.svgSliderIc2,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  width: 1)),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Text(
                                                    azkarCtrl
                                                        .state.categories[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Theme.of(context)
                                                              .primaryColorDark,
                                                      fontSize: 22,
                                                      fontFamily: 'naskh',
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () => customBottomSheet(AdhkarReminderWidget()),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -2),
                            child: RotatedBox(
                              quarterTurns: alignmentLayout(1, 3),
                              child: customSvgWithColor(SvgPath.svgButtonCurve,
                                  height: 45.0,
                                  width: 45.0,
                                  color: Get.theme.colorScheme.primary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        Theme.of(context).colorScheme.surface)),
                            child: Icon(
                              Icons.alarm,
                              size: 25,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  customLottie(LottieConstants.assetsLottieAzkar,
                      height: 120, isRepeat: false),
                ],
              ),
            ),
          ],
        ));
  }
}
