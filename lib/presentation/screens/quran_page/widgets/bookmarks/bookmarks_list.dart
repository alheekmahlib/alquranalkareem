part of '../../quran.dart';

class BookmarksList extends StatelessWidget {
  BookmarksList({Key? key}) : super(key: key);

  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: GetBuilder<BookmarksController>(
        builder: (bookmarkCtrl) => DefaultTabController(
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
                    Tab(text: 'pages'.tr),
                    Tab(text: 'ayahs'.tr),
                  ],
                ),
              ),
              const Gap(16),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    GetBuilder<BookmarksController>(
                      id: 'bookmarked',
                      builder: (bookmarkCtrl) {
                        return bookmarkCtrl.bookmarksList.isEmpty
                            ? _emptyWidget(context)
                            : BookmarkPagesBuild();
                      },
                    ),
                    GetBuilder<BookmarksController>(
                      id: 'ayah_bookmarked',
                      builder: (bookmarkCtrl) {
                        return bookmarkCtrl.bookmarkTextList.isEmpty
                            ? _emptyWidget(context)
                            : BookmarkAyahsBuild();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customLottieWithColor(
            LottieConstants.assetsLottieSearch,
            height: 150.0,
            width: 150.0,
          ),
          const Gap(16),
          Text(
            'bookmarks'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
