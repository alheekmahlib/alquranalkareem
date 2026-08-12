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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleWidget(
                  title: "What's New".tr,
                  horizontalPadding: 0,
                  containerColor: context.theme.colorScheme.surface,
                  textStyle: AppTextStyles.titleLarge(
                    color: context.theme.canvasColor,
                  ),
                ),
                GestureDetector(
                  child: Text(
                    'skip'.tr,
                    style: AppTextStyles.titleMedium(
                      color: context.theme.canvasColor.withValues(alpha: .5),
                    ),
                  ),
                  onTap: () {
                    Get.offAll(
                      const HomeScreen(),
                      transition: Transition.fadeIn,
                    );
                    whatsNewCtrl.saveLastShownIndex(newFeatures.last['index']);
                  },
                ),
              ],
            ),
          ),
          SmoothPageIndicatorWidget(
            controller: controller,
            newFeatures: newFeatures,
          ),
          const Gap(16),
          Expanded(
            child: Column(
              children: [
                PageViewBuild(controller: controller, newFeatures: newFeatures),
                const Gap(50),
                ButtonWidget(controller: controller, newFeatures: newFeatures),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
