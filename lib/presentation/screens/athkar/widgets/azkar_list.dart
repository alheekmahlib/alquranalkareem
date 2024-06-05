import 'package:alquranalkareem/core/utils/constants/extensions/svg_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/azkar_controller.dart';
import '../screens/azkar_item.dart';

class AzkarList extends StatelessWidget {
  const AzkarList({super.key});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    return context.customOrientation(
        Column(
          children: [
            const Gap(32),
            customLottie(LottieConstants.assetsLottieAzkar,
                height: 120, isRepeat: false),
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
                      controller: azkarCtrl.listController,
                      itemCount: azkarCtrl.categories.length,
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
                                      azkarCtrl.categories[index]);
                                  Get.to(() => const AzkarItem(),
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
                                        .withOpacity(.1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: customSvg(
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
                                                    azkarCtrl.categories[index]
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
                      controller: azkarCtrl.listController,
                      itemCount: azkarCtrl.categories.length,
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
                                      azkarCtrl.categories[index]);
                                  Get.to(const AzkarItem(),
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
                                        .withOpacity(.1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: customSvg(
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
                                                    azkarCtrl.categories[index]
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
                child: customLottie(LottieConstants.assetsLottieAzkar,
                    height: 120, isRepeat: false)),
          ],
        ));
  }
}
