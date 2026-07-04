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
    return GetBuilder<BooksController>(
      id: 'booksList',
      builder: (booksCtrl) {
        if (booksCtrl.state.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final allBooks = booksCtrl.getFilteredBooks(
          booksCtrl.state.booksList,
          isDownloadedBooks: isDownloadedBooks,
          filterBookType: filterBookType,
          title: title,
        );

        if (allBooks.isEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(64),
              customSvgWithCustomColor(_getEmptyIcon(), height: 70),
              const Gap(16),
              Text(
                booksCtrl.state.searchQuery.value.isNotEmpty
                    ? 'noBooksFoundForSearch'.tr
                    : _getEmptyStateMessage(),
                style: AppTextStyles.titleMedium(),
              ),
              const Gap(64),
            ],
          );
        }

        final isiPad = Responsive.isDesktop(context);
        final crossAxisCount = isiPad ? 4 : 3;

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: Gap(16.0)),
            SliverToBoxAdapter(
              child: Hero(
                tag: 'lastReadBooks',
                child: BooksLastRead(
                  horizontalMargin: 16.0,
                  horizontalPadding: 0.0,
                  verticalMargin: 16.0,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(16.0)),
            SliverToBoxAdapter(child: SectionSearchWidget(title: title)),
            const SliverToBoxAdapter(child: Gap(4)),
            if (filterBookType == 'hadiths')
              ..._buildPriorityBooksSlivers(
                context,
                allBooks,
                true,
                crossAxisCount,
              ),
            if (filterBookType == 'hadiths')
              ..._buildPriorityBooksSlivers(
                context,
                allBooks,
                false,
                crossAxisCount,
              ),
            _buildRegularBooksSliver(allBooks, crossAxisCount),
          ],
        );
      },
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

  // ── Shared grid builder — used by both priority & regular books ──
  Widget _buildBooksGrid(
    List<Book> books,
    int crossAxisCount, {
    required String heroPrefix,
    bool isSixthBooks = false,
    bool isNinthBooks = false,
  }) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 87 / 110,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final book = books[index];
        return Hero(
          tag: '$heroPrefix-${book.bookNumber}',
          child: BookCoverWidget(
            book: book,
            bookNumber: book.bookNumber,
            isSixthBooks: isSixthBooks,
            isNinthBooks: isNinthBooks,
          ),
        );
      }, childCount: books.length),
    );
  }

  // ── Priority books (sixth/ninth) as slivers: title + grid + divider ──
  List<Widget> _buildPriorityBooksSlivers(
    BuildContext context,
    List<Book> allBooks,
    bool isSixthBooks,
    int crossAxisCount,
  ) {
    final priorityBooks = booksCtrl.getCustomBookNumber(
      allBooks,
      isSixthBooks ? booksCtrl.sixthBooksNumbers : booksCtrl.ninthBooksNumbers,
    );

    if (priorityBooks.isEmpty) return const [];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Row(
            children: [
              customSvgWithColor(
                SvgPath.svgSliderIc2,
                color: context.theme.primaryColorLight,
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
      ),
      const SliverToBoxAdapter(child: Gap(8)),
      _buildBooksGrid(
        priorityBooks,
        crossAxisCount,
        heroPrefix: isSixthBooks ? 'sixthBookCover' : 'ninthBookCover',
        isSixthBooks: isSixthBooks,
        isNinthBooks: !isSixthBooks,
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Container(
              height: 4,
              width: Get.width * .8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: context.theme.primaryColorLight,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // ── Regular books as sliver grid ──
  Widget _buildRegularBooksSliver(List<Book> allBooks, int crossAxisCount) {
    final regularBooks = filterBookType == 'hadiths'
        ? allBooks
              .where(
                (book) =>
                    !booksCtrl.sixthBooksNumbers.contains(book.bookNumber) &&
                    !booksCtrl.ninthBooksNumbers.contains(book.bookNumber),
              )
              .toList()
        : allBooks;

    if (regularBooks.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    // إزالة الكتب المكررة بناءً على bookNumber
    final seenNumbers = <int>{};
    final uniqueBooks = <Book>[];
    for (final book in regularBooks) {
      if (seenNumbers.add(book.bookNumber)) {
        uniqueBooks.add(book);
      }
    }

    return _buildBooksGrid(
      uniqueBooks,
      crossAxisCount,
      heroPrefix: 'bookCover',
    );
  }
}
