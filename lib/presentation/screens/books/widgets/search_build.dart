part of '../books.dart';

class SearchBuild extends StatelessWidget {
  SearchBuild({super.key});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: context.theme.colorScheme.primaryContainer,
      child: Obx(() {
        if (booksCtrl.state.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final downloadedBooks = booksCtrl.state.booksList
            .where((book) => booksCtrl.isBookDownloaded(book.bookNumber))
            .toList();
        if (booksCtrl.state.searchResults.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: booksCtrl.state.searchResults.length,
            itemBuilder: (context, index) {
              final result = booksCtrl.state.searchResults[index];

              // محاولة الحصول على اسم الفصل - Try to get chapter name
              String? chapterName;

              // أولاً: تحميل جدول المحتويات إذا لم يكن محملاً - First: Load TOC if not loaded
              if (!booksCtrl.state.tocCache.containsKey(result.bookNumber)) {
                // تحميل جدول المحتويات بشكل غير متزامن - Load TOC asynchronously
                booksCtrl.getTocs(result.bookNumber).then((tocList) {
                  // لا نحتاج لفعل شيء هنا، البيانات ستُحفظ في الكاش
                  // No need to do anything here, data will be saved in cache
                });
                chapterName = 'تحميل...'; // Loading...
              } else {
                // الحصول على اسم الفصل من الكاش - Get chapter name from cache
                chapterName = booksCtrl.getCurrentChapterByPage(
                  result.bookNumber,
                  result.pageNumber,
                );
              }

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الكتاب - Book name
                      _bookNameBuild(context, result),
                      ContainerButton(
                        onPressed: () async {
                          if (Get.currentRoute == '/ReadViewScreen') {
                            await booksCtrl.moveToPage(
                              result.bookTitle,
                              result.bookNumber,
                              pageNumber: result.page,
                            );
                          } else {
                            await booksCtrl.moveToBookPageByNumber(
                              result.pageNumber - 1,
                              result.bookNumber,
                            );
                          }

                          booksCtrl.state.searchResults.clear();
                          booksCtrl.state.searchController.clear();
                        },
                        value: true.obs,
                        horizontalMargin: 16.0,
                        backgroundColor: context.theme.primaryColorLight
                            .withValues(alpha: .2),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [_textResultBuild(result, context)],
                          ),
                        ),
                      ),
                      const Gap(4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // اسم الفصل - Chapter name
                            _chapterNameBuild(context, chapterName),
                            const Gap(4),
                            // رقم الصفحة - Page number
                            _pageNumberBuild(context, result),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.hDivider(width: Get.width),
                  const Gap(8),
                ],
              );
            },
          );
        } else {
          return !(Get.currentRoute == '/ReadViewScreen')
              ? Center(
                  child: downloadedBooks.isEmpty
                      ? Column(
                          children: [
                            const Gap(64),
                            customSvgWithCustomColor(
                              SvgPath.svgBooksIslamicLibraryIcon,
                              height: 100,
                            ),
                            const Gap(16),
                            Text(
                              'noBooksDownloaded'.tr,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.titleMedium(),
                            ),
                            const Gap(64),
                          ],
                        )
                      : customLottieWithColor(
                          LottieConstants.assetsLottieNotFound,
                          height: 200.0,
                          width: 200.0,
                          color: context.theme.colorScheme.surface,
                        ),
                )
              : const SizedBox.shrink();
        }
      }),
    );
  }

  Expanded _pageNumberBuild(BuildContext context, PageContent result) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${'page'.tr} ${result.pageNumber}'.convertNumbersToCurrentLang(),
          style: AppTextStyles.titleSmall(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Expanded _chapterNameBuild(BuildContext context, String? chapterName) {
    return Expanded(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: context.theme.primaryColorLight.withValues(alpha: .3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          chapterName ?? 'غير محدد',
          style: AppTextStyles.titleSmall(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _bookNameBuild(BuildContext context, PageContent result) {
    return TitleWidget(
      title: booksCtrl.state.booksList[result.bookNumber - 1].bookName,
      textStyle: AppTextStyles.titleSmall(),
    );
  }

  Padding _textResultBuild(PageContent result, BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        TextSpan(
          children: result.text
              .toFlutterText(isDark)
              .cast<TextSpan>()
              .highlightSearchText(booksCtrl.state.searchController.text),
          style: AppTextStyles.titleMedium(),
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
