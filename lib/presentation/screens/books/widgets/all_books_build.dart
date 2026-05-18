part of '../books.dart';

class AllBooksBuild extends StatelessWidget {
  final bool isDownloadedBooks;
  final String? filterBookType;
  final String title;
  AllBooksBuild({
    super.key,
    this.isDownloadedBooks = false,
    this.filterBookType,
    required this.title,
  });

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Gap(16.0),
        Hero(
          tag: 'lastReadBooks',
          child: BooksLastRead(
            horizontalMargin: 16.0,
            horizontalPadding: 0.0,
            verticalMargin: 16.0,
          ),
        ),
        const Gap(16.0),
        Obx(() {
          if (booksCtrl.state.isLoading.value) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final allBooks = booksCtrl.getFilteredBooks(
            booksCtrl.state.booksList,
            isDownloadedBooks: isDownloadedBooks,
            filterBookType: filterBookType,
            title: title,
          );

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: title.tr),
                  _searchBuild(context),
                ],
              ),
              const Gap(4),
              allBooks.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Gap(64),
                        customSvgWithCustomColor(
                          _getEmptyIcon(),
                          height: 70,
                        ),
                        const Gap(16),
                        Text(
                          booksCtrl.state.searchQuery.value.isNotEmpty
                              ? 'noBooksFoundForSearch'.tr
                              : _getEmptyStateMessage(),
                          style: AppTextStyles.titleMedium(),
                        ),
                        const Gap(64),
                      ],
                    )
                  : Column(
                      children: [
                        // قسم خاص لكتب الأحاديث المهمة
                        if (filterBookType == 'hadiths') ...[
                          _buildSixthBooksSection(context, allBooks, true),
                          Container(
                            height: 4,
                            width: Get.width * .8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: context.theme.primaryColorLight,
                            ),
                          ),
                          const Gap(8),
                          _buildSixthBooksSection(context, allBooks, false),
                          Container(
                            height: 4,
                            width: Get.width * .8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: context.theme.primaryColorLight,
                            ),
                          ),
                          const Gap(8),
                        ],
                        _buildRegularBooksSection(allBooks),
                      ],
                    ),
            ],
          );
        }),
      ],
    );
  }

  String _getEmptyIcon() {
    if (isDownloadedBooks) return SvgPath.svgBooksMyLibrary;
    return _typeSvgMap[filterBookType] ?? SvgPath.svgBooksAllBooks;
  }

  String _getEmptyStateMessage() {
    if (isDownloadedBooks) return 'noBooksDownloaded'.tr;
    return 'noBooks'.tr;
  }

  SizedBox _searchBuild(BuildContext context) {
    return SizedBox(
      height: 40,
      width: Get.width * .6,
      child: AnimatedSearchBar(
        height: 40,
        textInputAction: TextInputAction.search,
        closeIcon: customSvgWithColor(
          SvgPath.svgHomeClose,
          color: context.theme.primaryColorLight,
          width: 25,
          height: 25,
        ),
        searchIcon: customSvgWithColor(
          SvgPath.svgHomeSearch,
          color: context.theme.primaryColorLight,
          width: 35,
          height: 35,
        ),
        searchDecoration: InputDecoration(
          hintText: 'search'.tr,
          hintStyle: AppTextStyles.bodySmall(
            color: context.theme.primaryColorLight.withValues(alpha: .5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: context.theme.primaryColorLight.withValues(alpha: .5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: context.theme.primaryColorLight.withValues(alpha: .5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: context.theme.primaryColorLight.withValues(alpha: .5),
            ),
          ),
          constraints: const BoxConstraints(maxHeight: 40.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
        searchStyle: AppTextStyles.bodySmall(
          color: context.theme.primaryColorLight,
        ),
        onClose: () {
          booksCtrl.state.isSearch.value = false;
          booksCtrl.state.searchQuery.value = '';
        },
        onChanged: (value) {
          booksCtrl.searchBookNames(value);
        },
      ),
    );
  }

  Widget _buildSixthBooksSection(
    BuildContext context,
    List<Book> allBooks,
    bool isSixthBooks,
  ) {
    final priorityBooks = booksCtrl.getCustomBookNumber(
      allBooks,
      isSixthBooks ? booksCtrl.sixthBooksNumbers : booksCtrl.ninthBooksNumbers,
    );

    if (priorityBooks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              customSvgWithColor(
                SvgPath.svgSliderIc2,
                color: Get.context!.theme.primaryColorLight,
                width: 20,
                height: 20,
              ),
              const Gap(8),
              Text(
                isSixthBooks ? 'sixthBooks'.tr : 'ninthBooks'.tr,
                style: AppTextStyles.titleMedium(
                  color: context.theme.primaryColorLight,
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(priorityBooks.length, (index) {
            final book = priorityBooks[index];
            return Hero(
              tag: isSixthBooks
                  ? 'sixthBookCover-${book.bookNumber}'
                  : 'ninthBookCover-${book.bookNumber}',
              child: BookCoverWidget(
                book: book,
                bookNumber: book.bookNumber,
                isSixthBooks: isSixthBooks,
                isNinthBooks: !isSixthBooks ? true : false,
              ),
            );
          }),
        ),
        const Gap(8),
        context.hDivider(
          color: context.theme.canvasColor.withValues(alpha: .5),
          height: 1,
          width: Get.width * .7,
        ),
      ],
    );
  }

  Widget _buildRegularBooksSection(List<Book> allBooks) {
    final regularBooks = filterBookType == 'hadiths'
        ? allBooks
              .where(
                (book) =>
                    !booksCtrl.sixthBooksNumbers.contains(book.bookNumber),
              )
              .toList()
        : allBooks;

    if (regularBooks.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(regularBooks.length, (index) {
        final book = regularBooks[index];
        return Hero(
          tag: 'bookCover-${book.bookNumber}',
          child: BookCoverWidget(book: book, bookNumber: book.bookNumber),
        );
      }),
    );
  }
}
