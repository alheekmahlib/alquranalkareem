part of '../books.dart';

class BookBookmarksScreen extends StatelessWidget {
  final booksBookmarksCtrl = BooksBookmarksController.instance;
  final booksCtrl = BooksController.instance;

  BookBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var groupedBookmarks = booksBookmarksCtrl.groupByBookName(
        booksBookmarksCtrl.bookmarks,
      );

      return booksBookmarksCtrl.bookmarks.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(64),
                  Text(
                    'bookmarks'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.theme.canvasColor,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  customLottieWithColor(
                    LottieConstants.assetsLottieSearch,
                    height: 150.0,
                    width: 150.0,
                  ),
                  const Gap(64),
                ],
              ),
            )
          : Column(
              children: [
                const Gap(32),
                customSvg(SvgPath.svgBooksBookmarkIcon, width: 200.0),
                const Gap(32),
                Flexible(
                  child: ListView.builder(
                    itemCount: groupedBookmarks.length,
                    itemBuilder: (context, index) {
                      var bookName = groupedBookmarks.keys.elementAt(index);
                      var bookmarks = groupedBookmarks[bookName]!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              customSvgWithColor(
                                SvgPath.svgBooksOpenBook,
                                width: 24.0,
                                height: 24.0,
                                color: context.theme.canvasColor,
                              ),
                              const Gap(24.0),
                              Expanded(
                                child: Text(
                                  bookName,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'kufi',
                                    color: context.theme.canvasColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          collapsedIconColor: context.theme.canvasColor,
                          iconColor: context.theme.canvasColor,
                          backgroundColor: context.theme.canvasColor.withValues(
                            alpha: .1,
                          ),
                          collapsedBackgroundColor: context.theme.canvasColor
                              .withValues(alpha: .1),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          children: bookmarks.map((bookmark) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: context.theme.canvasColor.withValues(
                                  alpha: .1,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${'page'.tr}: ${bookmark.currentPage}'
                                      .convertNumbersToCurrentLang(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'kufi',
                                    color: context.theme.canvasColor,
                                  ),
                                ),
                                trailing: CustomButton(
                                  width: 40,
                                  backgroundColor: Colors.transparent,
                                  isCustomSvgColor: true,
                                  svgPath: SvgPath.svgHomeRemove,
                                  iconSize: 25,
                                  onPressed: () {
                                    booksBookmarksCtrl
                                        .deleteBookmark(
                                          bookmark.bookNumber!,
                                          bookmark.currentPage!,
                                        )
                                        .then(
                                          (_) => Get.context!
                                              .showCustomErrorSnackBar(
                                                'deletedBookmark'.tr,
                                              ),
                                        );
                                    // booksBookmarksCtrl.deleteBookmark(
                                    //     bookmark.id, bookmark.currentPage!);
                                    log('bookmark deleted');
                                  },
                                ),
                                onTap: () async =>
                                    await booksCtrl.moveToBookPage(
                                      bookmark.currentPage! - 1,
                                      bookmark.bookNumber ?? 0,
                                    ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
    });
  }
}
