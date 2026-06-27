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

  // التابات داخل الـ bottom sheet (بدون الفواصل)
  late List<BooksTabConfig> sheetTabs;
  // index تبويب الفواصل
  late int bookmarksIndex;

  // تهيئة التابات (تُستدعى من الـ build الأول)
  void initTabs(List<BooksTabConfig> tabs) {
    sheetTabs = tabs.where((t) => t.title != 'bookmarks').toList();
    bookmarksIndex = tabs.indexWhere((t) => t.title == 'bookmarks');
  }

  // تغيير التاب الحالي
  // Change current tab
  void changeTab(int index) {
    currentIndex.value = index;
    update();
  }

  // عدد الكتب في كل قسم
  int getBookCount(BooksTabConfig tab) {
    try {
      final booksCtrl = Get.find<BooksController>();
      if (tab.title == 'allBooks') {
        return booksCtrl.state.booksList.length;
      } else if (tab.title == 'myLibrary') {
        return booksCtrl.state.downloaded.values.where((v) => v).length;
      } else if (tab.filterBookType != null) {
        final collection = booksCtrl.state.booksInfo.firstWhereOrNull(
          (c) => c.type == tab.filterBookType,
        );
        return collection?.books.length ?? 0;
      }
    } catch (_) {}
    return 0;
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
    final tabCtrl = BooksTabBarController.instance..initTabs(tabs);
    return SizedBox(
      height: Get.height,
      child: Column(
        children: [
          const Gap(8),
          // ── شريط علوي: شعار + اسم القسم الحالي + زر الفواصل ──
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
              init: tabCtrl,
              builder: (tabCtrl) => Row(
                children: [
                  const Gap(8),
                  const IslamicLibraryLogo(),
                  const Gap(2),
                  Container(
                    height: 42,
                    width: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColorLight,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  const Gap(2),
                  // ── اسم القسم الحالي (يفتح الـ bottom sheet عند الضغط) ──
                  Expanded(
                    child: GetBuilder<BooksTabBarController>(
                      id: 'tabDropdown',
                      builder: (tabCtrl) {
                        final selectedTab = tabs[tabCtrl.currentIndex.value];
                        return ContainerButton(
                          onPressed: () {
                            ().customBottomSheet(_tabsBuild(tabCtrl, context));
                          },
                          height: 48,
                          withArrow: true,
                          verticalPadding: 8.0,
                          arrowQuarterTurns: 0,
                          horizontalPadding: 12.0,
                          width: double.infinity,
                          titleOverflow: TextOverflow.ellipsis,
                          title: selectedTab.title.tr,
                          backgroundColor: context.theme.colorScheme.surface
                              .withValues(alpha: .3),
                          titleStyle: AppTextStyles.titleMedium(
                            color: context.theme.colorScheme.inversePrimary,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  ),
                  // ── زر الفواصل (منفصل عن الـ sheet) ──
                  if (tabCtrl.bookmarksIndex != -1) ...[
                    const Gap(8),
                    ContainerButton(
                      onPressed: () =>
                          tabCtrl.changeTab(tabCtrl.bookmarksIndex),
                      backgroundColor: context.theme.colorScheme.surface
                          .withValues(alpha: .3),
                      horizontalPadding: 7.0,
                      verticalPadding: 7.0,
                      child: customSvgWithColor(
                        height: 35,
                        width: 35,
                        SvgPath.svgHomeBookmarkList,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  const Gap(8),
                ],
              ),
            ),
          ),
          // ── المحتوى ──
          Flexible(
            child: GetBuilder<BooksTabBarController>(
              init: tabCtrl,
              builder: (tabCtrl) =>
                  tabs[tabCtrl.currentIndex.value].buildChild(),
            ),
          ),
        ],
      ),
    );
  }

  Column _tabsBuild(BooksTabBarController tabCtrl, BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        TitleWidget(title: 'sections'.tr),
        const Gap(8),
        SizedBox(
          height: Get.height * .5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tabCtrl.sheetTabs.length, (i) {
                final tab = tabCtrl.sheetTabs[i];
                final originalIndex = tabs.indexOf(tab);
                final isSelected = tabCtrl.currentIndex.value == originalIndex;
                return ContainerButton(
                  onPressed: () {
                    tabCtrl.changeTab(originalIndex);
                    Get.back();
                  },
                  width: double.infinity,
                  isButton: false,
                  horizontalMargin: 8.0,
                  horizontalPadding: 8.0,
                  verticalMargin: 2.0,
                  withArrow: true,
                  title: tab.title.tr,
                  value: (isSelected ? true : false).obs,
                  arrowQuarterTurns: 3,
                  subtitle: '${'booksCount'.tr}: ${tabCtrl.getBookCount(tab)}'
                      .convertNumbersToCurrentLang(),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
