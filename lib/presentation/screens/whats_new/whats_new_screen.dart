import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/widgets/select_screen_build.dart';
import '../../controllers/splash_screen_controller.dart';
import '../screen_type.dart';
import '/core/widgets/container_button.dart';
import '/presentation/controllers/general_controller.dart';

class WhatsNewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> newFeatures;
  WhatsNewScreen({Key? key, required this.newFeatures}) : super(key: key);

  final controller = PageController(viewportFraction: 1, keepPage: true);
  final splashCtrl = sl<SplashScreenController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
        height: size.height * .94,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => generalCtrl.showSelectScreenPage.value
                ? const SelectScreenBuild(
                    isButtonBack: false,
                    isButton: true,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Text(
                              'skip'.tr,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 16.0,
                                fontFamily: 'kufi',
                              ),
                            ),
                            onTap: () {
                              Get.off(() => const ScreenTypeL());
                            },
                          ),
                          SmoothPageIndicator(
                            controller: controller,
                            count: newFeatures.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 13,
                              paintStyle: PaintingStyle.fill,
                              dotColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                              activeDotColor:
                                  Theme.of(context).colorScheme.primary,
                              // strokeWidth: 5,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Container(
                        width: size.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Text(
                          "What's New".tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20.0,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                      Flexible(
                        child: PageView.builder(
                            controller: controller,
                            itemCount: newFeatures.length,
                            onPageChanged: (page) {
                              splashCtrl.onboardingPageNumber.value = page;
                            },
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Gap(16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Text(
                                        '${newFeatures[index]['title']}'.tr,
                                        style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 16.0,
                                          fontFamily: 'kufi',
                                        ),
                                      ),
                                    ),
                                    const Gap(8),
                                    newFeatures[index]['imagePath'] == ''
                                        ? const SizedBox.shrink()
                                        : Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: Image.asset(
                                                newFeatures[index]['imagePath'],
                                                width:
                                                    context.customOrientation(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            3 /
                                                            4,
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width),
                                              ),
                                            ),
                                          ),
                                    const Gap(8),
                                    newFeatures[index]['details'] == ''
                                        ? const SizedBox.shrink()
                                        : Container(
                                            width: size.width,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withOpacity(.1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4))),
                                            child: Text(
                                              '${newFeatures[index]['details']}'
                                                  .tr,
                                              style: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontSize: 14.0,
                                                fontFamily: 'kufi',
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 8.0),
                        child: GestureDetector(
                          child: ContainerButton(
                            height: 40,
                            width: size.width,
                            child: Center(
                                child: Obx(
                              () => splashCtrl.onboardingPageNumber.value + 1 ==
                                      newFeatures.last['index']
                                  ? Text('start'.tr,
                                      style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 18,
                                          color: Theme.of(context).canvasColor))
                                  : const Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xfff3efdf),
                                    ),
                            )),
                          ),
                          onTap: () {
                            if (splashCtrl.onboardingPageNumber.value + 1 ==
                                newFeatures.last['index']) {
                              splashCtrl.saveLastShownIndex(
                                  newFeatures.last['index']);
                              generalCtrl.showSelectScreenPage.value = true;
                              // Get.off(() => const ScreenTypeL());
                            } else {
                              controller.animateToPage(
                                  controller.page!.toInt() + 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
