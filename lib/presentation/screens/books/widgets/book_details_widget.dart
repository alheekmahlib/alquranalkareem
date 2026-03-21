part of '../books.dart';

class BookDetails extends StatelessWidget {
  final Book book;
  final bool? isSixthBooks;
  final bool? isNinthBooks;

  BookDetails({
    super.key,
    required this.book,
    this.isSixthBooks = false,
    this.isNinthBooks = false,
  });

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    // OverlayTooltipScaffold.of(context)?.controller.start(3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: 290,
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: .1,
                child: customSvg(
                  SvgPath.svgHomeQuranLogo,
                  height: Get.width * .6,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Hero(
                      tag: isSixthBooks!
                          ? 'sixthBookCover-${book.bookName}'
                          : isNinthBooks!
                          ? 'ninthBookCover-${book.bookName}'
                          : 'bookCover-${book.bookName}',
                      child: BookCoverWidget(isInDetails: true, book: book),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      book.bookName,
                      style: AppTextStyles.titleMedium(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: context.theme.primaryColorLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TitleWidget(
                      title: book.author,
                      horizontalPadding: 0.0,
                    ),
                  ),
                  const Gap(16),
                  Obx(
                    () => booksCtrl.isBookDownloaded(book.bookNumber)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: CustomButton(
                              onPressed: () async {
                                await booksCtrl.deleteBook(book.bookNumber);
                                booksCtrl.state.tocCache[book.bookNumber]!
                                    .clear();
                              },
                              height: 40,
                              width: Get.width,
                              title: 'delete',
                              backgroundColor: Colors.red.withValues(alpha: .7),
                              svgPath: SvgPath.svgHomeRemove,
                              isCustomSvgColor: true,
                              svgColor:
                                  context.theme.colorScheme.secondaryContainer,
                            ),
                          )
                        : _notDownloadFontsWidget(context),
                  ),
                  const Gap(8.0),
                ],
              ),
            ],
          ),
        ),
        const Gap(8),
        const TitleWidget(title: 'aboutBook'),
        Container(
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface.withValues(alpha: .15),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 8.0,
            ),
            child: Obx(
              () => ReadMoreLess(
                text: book.aboutBook.buildHtmlTextSpans(),
                maxLines: booksCtrl.isBookDownloaded(book.bookNumber) ? 1 : 50,
                collapsedHeight:
                    booksCtrl.collapsedHeight(book.bookNumber).value ? 130 : 60,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'naskh',
                  color: context.theme.colorScheme.inversePrimary,
                ),
                textAlign: TextAlign.justify,
                readMoreText: 'readMore'.tr,
                readLessText: 'readLess'.tr,
                buttonTextStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.surface,
                ),
                iconColor: context.theme.colorScheme.surface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _notDownloadFontsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            child: CustomButton(
              onPressed: () async =>
                  await booksCtrl.downloadBook(book.bookNumber),
              height: 40,
              width: Get.width,
              verticalPadding: 0.0,
              horizontalPadding: 0.0,
              isCustomSvgColor: true,
              svgPath: SvgPath.svgHomeRemove,
              backgroundColor: context.theme.colorScheme.surface,
              svgColor: context.theme.colorScheme.secondaryContainer,
              title: booksCtrl.state.downloading[book.bookNumber] == true
                  ? 'downloading'.tr
                  : 'download'.tr,
            ),
          ),
          Obx(
            () => booksCtrl.state.downloading[book.bookNumber] == true
                ? RoundedProgressBar(
                    height: 40,
                    style: RoundedProgressBarStyle(
                      borderWidth: 0,
                      widthShadow: 5,
                      backgroundProgress: context.theme.colorScheme.surface,
                      colorProgress: context.theme.colorScheme.primary,
                      colorProgressDark: context.theme.primaryColorLight
                          .withValues(alpha: 0.5),
                      colorBorder: context.theme.colorScheme.surface.withValues(
                        alpha: 0.1,
                      ),
                      colorBackgroundIcon: Colors.transparent,
                    ),
                    margin: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(8),
                    percent:
                        booksCtrl.state.downloadProgress[book.bookNumber] ?? 0,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
