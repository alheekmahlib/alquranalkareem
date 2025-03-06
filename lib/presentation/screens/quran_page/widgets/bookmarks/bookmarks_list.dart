part of '../../quran.dart';

class BookmarksList extends StatelessWidget {
  BookmarksList({Key? key}) : super(key: key);

  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: GetBuilder<BookmarksController>(
        builder: (bookmarkCtrl) => bookmarkCtrl.bookmarksList.isEmpty &&
                bookmarkCtrl.bookmarkTextList.isEmpty
            ? Center(
                child: Column(
                children: [
                  const Gap(16),
                  Text(
                    'bookmarks'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  customLottie(LottieConstants.assetsLottieSearch,
                      height: 150.0, width: 150.0),
                ],
              ))
            : DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Text(
                      'bookmarks'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    const Gap(8),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: .1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: TabBar(
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        indicator: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Theme.of(context).colorScheme.surface),
                        tabs: [
                          Tab(
                            text: 'pages'.tr,
                          ),
                          Tab(
                            text: 'ayahs'.tr,
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Flexible(
                      flex: 8,
                      child: TabBarView(
                        children: <Widget>[
                          bookmarkCtrl.bookmarksList.isEmpty
                              ? const SizedBox.shrink()
                              : BookmarkPagesBuild(),
                          bookmarkCtrl.bookmarkTextList.isEmpty
                              ? const SizedBox.shrink()
                              : BookmarkAyahsBuild(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
