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
  final Widget firstTabChild;
  final Widget secondTabChild;
  final Widget thirdTabChild;
  final Widget fourthTabChild;
  final Widget fifthTabChild;
  final Widget? topChild;
  final double? topPadding;

  const BooksTabBarWidget({
    super.key,
    required this.firstTabChild,
    required this.secondTabChild,
    this.topChild,
    this.topPadding,
    required this.thirdTabChild,
    required this.fourthTabChild,
    required this.fifthTabChild,
  });

  @override
  Widget build(BuildContext context) {
    // شرح: نستخدم init داخل GetBuilder لإنشاء الكنترولر إذا لم يكن مسجلاً
    // Explanation: Use init in GetBuilder to create controller if not registered
    final screens = <Widget>[
      firstTabChild,
      secondTabChild,
      thirdTabChild,
      fourthTabChild,
      fifthTabChild,
    ];
    return SizedBox(
      height: Get.height,
      child: Column(
        // alignment: Alignment.topCenter,
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
              // استخدام نمط الكائن الوحيد بدلاً من إنشاء نسخة جديدة في كل مرة
              // Use singleton pattern instead of creating a new instance each time
              init: BooksTabBarController.instance,
              builder: (tabCtrl) => Row(
                children: [
                  const Gap(8),
                  customSvgWithCustomColor(
                    SvgPath.svgBooksIslamicLibrary,
                    height: 60,
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: .7,
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buttomBuild(
                            tabCtrl,
                            context,
                            0,
                            SvgPath.svgBooksAllBooks,
                            'allBooks',
                          ),
                          const Gap(8),
                          buttomBuild(
                            tabCtrl,
                            context,
                            1,
                            SvgPath.svgBooksMyLibrary,
                            'myLibrary',
                          ),
                          const Gap(8),
                          buttomBuild(
                            tabCtrl,
                            context,
                            2,
                            SvgPath.svgBooksHadith,
                            'hadiths',
                          ),
                          const Gap(8),
                          buttomBuild(
                            tabCtrl,
                            context,
                            3,
                            SvgPath.svgBooksTafsir,
                            'tafsir',
                          ),
                          const Gap(8),
                          buttomBuild(
                            tabCtrl,
                            context,
                            4,
                            SvgPath.svgBooksBookmarks,
                            'bookmarks',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ), // استخدام GetBuilder لعرض محتوى التاب الحالي مع نمط الكائن الوحيد
          // Use GetBuilder to show current tab content with singleton pattern
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

  CustomButton buttomBuild(
    BooksTabBarController tabCtrl,
    BuildContext context,
    int index,
    String svgPath,
    String title,
  ) {
    return CustomButton(
      onPressed: () => tabCtrl.changeTab(index),
      height: 45,
      width: 75,
      iconSize: 40,
      horizontalPadding: 8.0,
      backgroundColor: tabCtrl.currentIndex.value == index
          ? context.theme.primaryColorLight.withValues(alpha: .7)
          : context.theme.primaryColorLight.withValues(alpha: .5),
      // borderColor: context.theme.primaryColorLight.withValues(alpha: .3),
      iconWidget: Column(
        children: [
          Expanded(
            child: customSvg(
              svgPath,
              // width: 40,
              // color: context.theme.colorScheme.primary,
            ),
          ),
          // const Gap(4),
          // context.hDivider(width: 70, color: context.theme.canvasColor),
          // const Gap(4),
          // Text(
          //   title.tr,
          //   style: AppTextStyles.titleSmall(
          //     color: context.theme.canvasColor,
          //     fontSize: 10,
          //     height: 1.2,
          //   ),
          //   maxLines: 1,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
