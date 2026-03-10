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
                    style: AppTextStyles.titleLarge(),
                  ),
                  customLottieWithColor(
                    LottieConstants.assetsLottieSearch,
                    height: 150.0,
                    width: 150.0,
                    color: context.theme.colorScheme.surface,
                  ),
                  const Gap(64),
                ],
              ),
            )
          : Column(
              children: [
                const Gap(32),
                customSvgWithCustomColor(
                  SvgPath.svgBooksBookmarks,
                  width: 200.0,
                  color: context.theme.colorScheme.surface,
                ),
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
                        child: ExpansionTileWidget(
                          getxCtrl: booksBookmarksCtrl,
                          manager:
                              GeneralController.instance.state.expansionManager,
                          name: 'language_expansion_tile',
                          backgroundColor: context.theme.primaryColorLight
                              .withValues(alpha: .2),
                          titleChild: Row(
                            children: [
                              customSvgWithColor(
                                SvgPath.svgBooksOpenBook,
                                width: 24.0,
                                height: 24.0,
                                color: context.theme.colorScheme.inversePrimary,
                              ),
                              const Gap(24.0),
                              Expanded(
                                child: Text(
                                  bookName,
                                  style: AppTextStyles.titleMedium(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          child: Column(
                            children: bookmarks.map((bookmark) {
                              return ListTile(
                                title: Text(
                                  '${'page'.tr}: ${bookmark.currentPage}'
                                      .convertNumbersToCurrentLang(),
                                  style: AppTextStyles.titleMedium(),
                                ),
                                trailing: CustomButton(
                                  width: 40,
                                  backgroundColor: context
                                      .theme
                                      .primaryColorLight
                                      .withValues(alpha: .1),
                                  isCustomSvgColor: true,
                                  svgPath: SvgPath.svgHomeRemove,
                                  svgColor: context.theme.colorScheme.surface,
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
                              );
                            }).toList(),
                          ),
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
