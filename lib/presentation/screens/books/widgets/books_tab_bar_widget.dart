part of '../books.dart';

// كنترولر GetX لإدارة التاب الحالي مع نمط الكائن الوحيد
// GetX controller to manage current tab with singleton pattern
class BooksTabBarController extends GetxController {
  // نمط الكائن الوحيد مع GetX
  // Singleton pattern with GetX
  static BooksTabBarController get instance =>
      Get.isRegistered<BooksTabBarController>()
      ? Get.find<BooksTabBarController>()
      : Get.put(BooksTabBarController());

  RxInt currentIndex = 0.obs;

  // تغيير التاب الحالي
  // Change current tab
  void changeTab(int index) {
    currentIndex.value = index;
    update();
  }
}

class BooksTabBarWidget extends StatelessWidget {
  final List<BooksTabConfig> tabs;
  final Widget? topChild;
  final double? topPadding;

  const BooksTabBarWidget({
    super.key,
    required this.tabs,
    this.topChild,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    final screens = tabs.map((tab) => tab.buildChild()).toList();

    return SizedBox(
      height: Get.height,
      child: Column(
        children: [
          const Gap(8),
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.secondaryContainer.withValues(
                alpha: .05,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: GetBuilder<BooksTabBarController>(
              init: BooksTabBarController.instance,
              builder: (tabCtrl) => Row(
                children: [
                  const Gap(8),
                  Get.locale!.languageCode == 'ar'
                      ? customSvgWithCustomColor(
                          SvgPath.svgBooksIslamicLibrary,
                          height: 60,
                          color: context.theme.colorScheme.surface.withValues(
                            alpha: .7,
                          ),
                        )
                      : Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'islamicLibrary'.tr.replaceAll(' ', '\n'),
                              style: AppTextStyles.titleMedium(
                                color: context.theme.colorScheme.surface,
                                fontSize: 20,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  const Gap(2),
                  Container(
                    height: 60,
                    width: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColorLight,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  const Gap(2),
                  Flexible(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: List.generate(tabs.length, (index) {
                        return buttomBuild(
                          tabCtrl,
                          context,
                          index,
                          tabs[index].svgPath,
                          tabs[index].title,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: GetBuilder<BooksTabBarController>(
              init: BooksTabBarController.instance,
              builder: (tabCtrl) => screens[tabCtrl.currentIndex.value],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttomBuild(
    BooksTabBarController tabCtrl,
    BuildContext context,
    int index,
    String svgPath,
    String title,
  ) {
    return GestureDetector(
      onTap: () => tabCtrl.changeTab(index),
      child: Container(
        height: 45,
        // width: 75,
        // alignment: .center,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: tabCtrl.currentIndex.value == index
              ? context.theme.primaryColorLight.withValues(alpha: .7)
              : context.theme.primaryColorLight.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title.tr.replaceAll('Saved', ''),
          style: AppTextStyles.titleMedium(
            color: context.theme.canvasColor,
            fontSize: 20,
            height: 2.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
