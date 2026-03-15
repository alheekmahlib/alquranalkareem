part of '../../whats_new.dart';

class ButtonWidget extends StatelessWidget {
  final PageController controller;
  final List<Map<String, dynamic>> newFeatures;

  ButtonWidget({
    super.key,
    required this.controller,
    required this.newFeatures,
  });

  final whatsNewCtrl = WhatsNewController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    whatsNewCtrl.state.currentPageIndex.value = controller.page?.toInt() ?? 0;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Obx(
          () => ContainerButton(
            onPressed: () {
              if (whatsNewCtrl.state.currentPageIndex.value ==
                  newFeatures.length - 1) {
                whatsNewCtrl.saveLastShownIndex(newFeatures.last['index']);
                Get.offAll(const HomeScreen(), transition: Transition.fadeIn);
              } else {
                controller.animateToPage(
                  controller.page!.toInt() + 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                );
              }
            },
            height: 45,
            width: Get.width * .5,
            horizontalMargin: 0,
            isTitleCentered: true,
            backgroundColor: context.theme.primaryColorLight.withValues(
              alpha: .5,
            ),
            // icon:
            //     whatsNewCtrl.state.currentPageIndex.value ==
            //         newFeatures.length - 1
            //     ? null
            //     : Icons.arrow_forward,
            title:
                whatsNewCtrl.state.currentPageIndex.value ==
                    newFeatures.length - 1
                ? 'start'.tr
                : null,
          ),
        ),
      ),
    );
  }
}
