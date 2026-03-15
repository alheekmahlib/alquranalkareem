part of '../whats_new.dart';

class WhatsNewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> newFeatures;
  WhatsNewScreen({super.key, required this.newFeatures});

  final controller = PageController(viewportFraction: 1, keepPage: true);
  final whatsNewCtrl = WhatsNewController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Text('skip'.tr, style: AppTextStyles.titleMedium()),
                  onTap: () {
                    Get.offAll(
                      const HomeScreen(),
                      transition: Transition.fadeIn,
                    );
                    whatsNewCtrl.saveLastShownIndex(newFeatures.last['index']);
                  },
                ),
                SmoothPageIndicatorWidget(
                  controller: controller,
                  newFeatures: newFeatures,
                ),
              ],
            ),
          ),
          const Gap(16),
          TitleWidget(
            title: "What's New".tr,
            textStyle: AppTextStyles.titleLarge(),
          ),
          PageViewBuild(controller: controller, newFeatures: newFeatures),
          ButtonWidget(controller: controller, newFeatures: newFeatures),
        ],
      ),
    );
  }
}
