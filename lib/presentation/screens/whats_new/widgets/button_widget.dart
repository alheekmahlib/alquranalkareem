import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/container_button.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/whats_new_controller.dart';
import '../../screen_type.dart';

class ButtonWidget extends StatelessWidget {
  final PageController controller;
  final List<Map<String, dynamic>> newFeatures;

  ButtonWidget(
      {super.key, required this.controller, required this.newFeatures});

  final whatsNewCtrl = WhatsNewController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    whatsNewCtrl.currentPageIndex.value = controller.page?.toInt() ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: Obx(() {
        return GestureDetector(
          child: ContainerButton(
            height: 40,
            width: size.width,
            color: Theme.of(context).canvasColor,
            child: Center(
              child:
                  whatsNewCtrl.currentPageIndex.value == newFeatures.length - 1
                      ? Text('start'.tr,
                          style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary))
                      : Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.primary,
                        ),
            ),
          ),
          onTap: () async {
            if (whatsNewCtrl.currentPageIndex.value == newFeatures.length - 1) {
              whatsNewCtrl.saveLastShownIndex(newFeatures.last['index']);
              GetStorage().read(IS_SCREEN_SELECTED_VALUE) == true
                  ? Get.off(() => ScreenTypeL())
                  : generalCtrl.showSelectScreenPage.value = true;
            } else {
              controller.animateToPage(controller.page!.toInt() + 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn);
            }
          },
        );
      }),
    );
  }
}
