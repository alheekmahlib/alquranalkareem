import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/container_button.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/splash_screen_controller.dart';

class ButtonWidget extends StatelessWidget {
  final PageController controller;
  final List<Map<String, dynamic>> newFeatures;
  ButtonWidget(
      {super.key, required this.controller, required this.newFeatures});

  final splashCtrl = sl<SplashScreenController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
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
            splashCtrl.saveLastShownIndex(newFeatures.last['index']);
            generalCtrl.showSelectScreenPage.value = true;
            // Get.off(() => const ScreenTypeL());
          } else {
            controller.animateToPage(controller.page!.toInt() + 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn);
          }
        },
      ),
    );
  }
}
