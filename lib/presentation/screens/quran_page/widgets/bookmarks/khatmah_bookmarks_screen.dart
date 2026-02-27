part of '../../quran.dart';

class KhatmahBookmarksScreen extends StatelessWidget {
  const KhatmahBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).primaryColorDark.withValues(alpha: .3),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TabBar(
                  unselectedLabelColor:
                      context.theme.colorScheme.inversePrimary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelStyle: AppTextStyles.titleSmall(),
                  unselectedLabelStyle: AppTextStyles.titleSmall(),
                  indicator: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  tabs: [
                    Tab(text: 'bookmarks'.tr),
                    Tab(text: 'khatmah'.tr),
                  ],
                ),
              ),
              const Gap(8),
              Expanded(
                child: TabBarView(
                  children: <Widget>[BookmarksList(), KhatmasScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
