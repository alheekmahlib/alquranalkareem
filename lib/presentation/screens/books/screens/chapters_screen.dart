part of '../books.dart';

class ChaptersPage extends StatelessWidget {
  final Book book;
  final bool isSixthBooks;
  final bool isNinthBooks;

  ChaptersPage({
    super.key,
    required this.book,
    this.isSixthBooks = false,
    this.isNinthBooks = false,
  });

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isTitled: false,
        isFontSize: false,
        searchButton: CustomButton(
          onPressed: () => customBottomSheet(
            SearchScreen(
              onSubmitted: (_) =>
                  booksCtrl.searchBooks(booksCtrl.state.searchController.text),
            ),
          ),
          width: 50,
          isCustomSvgColor: true,
          svgColor: context.theme.primaryColorLight,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          svgPath: SvgPath.svgHomeSearch,
        ),
        isNotifi: true,
        isBooks: false,
      ),
      body: SafeArea(
        child: context.customOrientation(
          SingleChildScrollView(
            child: Column(
              children: [
                const Gap(16),
                BookDetails(
                  book: book,
                  isSixthBooks: isSixthBooks,
                  isNinthBooks: isNinthBooks,
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BooksChapterBuild(bookNumber: book.bookNumber),
                ),
                const Gap(16),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: context.definePlatform(0.0, 32.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: BookDetails(
                      book: book,
                      isSixthBooks: isSixthBooks,
                      isNinthBooks: isNinthBooks,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: BooksChapterBuild(bookNumber: book.bookNumber),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
