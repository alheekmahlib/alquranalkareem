part of '../../whats_new.dart';

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
    whatsNewCtrl.state.currentPageIndex.value = controller.page?.toInt() ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: Obx(() {
        return ElevatedButtonWidget(
          onClick: () {
            if (whatsNewCtrl.state.currentPageIndex.value ==
                newFeatures.length - 1) {
              whatsNewCtrl.saveLastShownIndex(newFeatures.last['index']);
              GetStorage().read(IS_SCREEN_SELECTED_VALUE) == true
                  ? Get.off(() => ScreenTypeL())
                  : generalCtrl.state.showSelectScreenPage.value = true;
            } else {
              controller.animateToPage(controller.page!.toInt() + 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn);
            }
          },
          index: 1,
          height: 40,
          width: size.width * .6,
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: whatsNewCtrl.state.currentPageIndex.value ==
                    newFeatures.length - 1
                ? Text('start'.tr,
                    style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 18,
                        color: Theme.of(context).canvasColor))
                : Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ),
        );
      }),
    );
  }
}
