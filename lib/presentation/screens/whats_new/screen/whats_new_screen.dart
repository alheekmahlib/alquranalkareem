part of '../whats_new.dart';

class WhatsNewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> newFeatures;
  WhatsNewScreen({Key? key, required this.newFeatures}) : super(key: key);

  final controller = PageController(viewportFraction: 1, keepPage: true);
  final whatsNewCtrl = WhatsNewController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Obx(
        () => generalCtrl.state.showSelectScreenPage.value
            ? const SelectScreenBuild(
                isButtonBack: false,
                isButton: true,
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          'skip'.tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 12.0.sp,
                            fontFamily: 'kufi',
                          ),
                        ),
                        onTap: () {
                          Get.off(() => ScreenTypeL());
                          whatsNewCtrl
                              .saveLastShownIndex(newFeatures.last['index']);
                        },
                      ),
                      SmoothPageIndicatorWidget(
                        controller: controller,
                        newFeatures: newFeatures,
                      ),
                    ],
                  ),
                  const Gap(16),
                  const WhatsNewWidget(),
                  PageViewBuild(
                    controller: controller,
                    newFeatures: newFeatures,
                  ),
                  ButtonWidget(
                    controller: controller,
                    newFeatures: newFeatures,
                  ),
                ],
              ),
      ),
    );
  }
}
