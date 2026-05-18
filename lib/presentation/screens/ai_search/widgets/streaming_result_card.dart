part of '../ai_search.dart';

/// Single result card
class _StreamingResultCard extends StatelessWidget {
  final SearchResult result;
  final Color color;
  final String query;
  final String cardKey;

  const _StreamingResultCard({
    super.key,
    required this.result,
    required this.color,
    required this.query,
    required this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = AiSearchController.instance;
    final meta = result.metadata;
    final isQuran = meta.type == 'quran';
    final baseStyle = AppTextStyles.titleMedium(
      fontFamily: isQuran ? 'uthmanic2' : null,
      fontSize: isQuran ? 20 : 14,
      height: isQuran ? 2.0 : 1.5,
      color: context.theme.canvasColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        final isCompleted = ctrl.state.isCardCompleted(cardKey);
        final isStreaming = ctrl.state.isCardStreaming(cardKey);
        final isPending = !isCompleted && !isStreaming;

        Widget textWidget;

        if (isCompleted) {
          if (query.isNotEmpty) {
            textWidget = _buildHighlightedText(
              meta.preview,
              baseStyle,
              isQuran,
            );
          } else {
            textWidget = Text(
              meta.preview,
              maxLines: isQuran ? 3 : 5,
              overflow: TextOverflow.ellipsis,
              style: baseStyle,
            );
          }
        } else if (isStreaming) {
          textWidget = StreamingTextMarkdown(
            text: meta.preview,
            wordByWord: true,
            latexEnabled: true,
            chunkSize: 1,
            // fadeInEnabled: true,
            styleSheet: baseStyle,
            latexStyle: baseStyle,
            textDirection: TextDirection.rtl,
            markdownEnabled: true,
            onComplete: () {
              ctrl.state.markCardCompleted(cardKey);
            },
          );
        } else {
          textWidget = Text(
            meta.preview,
            maxLines: isQuran ? 3 : 5,
            overflow: TextOverflow.ellipsis,
            style: baseStyle.copyWith(color: Colors.transparent),
          );
        }

        return AnimatedOpacity(
          opacity: isPending ? 0.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: 0.03),
              border: Border(
                right: BorderSide(
                  color: color.withValues(alpha: 0.4),
                  width: 3,
                ),
              ),
            ),
            child: InkWell(
              onTap: isPending ? null : () => _navigateToSource(context, meta),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget,
                    const Gap(6),
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 12,
                          color: color.withValues(alpha: 0.6),
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            meta.reference,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium(
                              color: context.theme.colorScheme.surface
                                  .withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHighlightedText(String text, TextStyle baseStyle, bool isQuran) {
    final queryWords = query
        .replaceAll(
          RegExp(r'[^\u0600-\u06FF\u0750-\u077F\u08A0-\u08FFa-zA-Z0-9\s]'),
          '',
        )
        .split(' ')
        .where((w) => w.length > 1)
        .toList();

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    int currentPos = 0;

    while (currentPos < text.length) {
      int? earliestMatch;
      int? matchLength;

      for (final word in queryWords) {
        final idx = lowerText.indexOf(word.toLowerCase(), currentPos);
        if (idx >= 0 && (earliestMatch == null || idx < earliestMatch)) {
          earliestMatch = idx;
          matchLength = word.length;
        }
      }

      if (earliestMatch == null) {
        spans.add(TextSpan(text: text.substring(currentPos), style: baseStyle));
        break;
      }

      if (earliestMatch > currentPos) {
        spans.add(
          TextSpan(
            text: text.substring(currentPos, earliestMatch),
            style: baseStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(earliestMatch, earliestMatch + matchLength!),
          style: AppTextStyles.titleMedium(
            color: color,
            fontWeight: FontWeight.bold,
            // backgroundColor: color.withValues(alpha: 0.15),
          ),
        ),
      );

      currentPos = earliestMatch + matchLength;
    }

    return RichText(
      maxLines: isQuran ? 3 : 5,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans, style: baseStyle),
    );
  }

  void _navigateToSource(BuildContext context, SearchMetadata meta) {
    final quranCtrl = QuranController.instance;
    quranCtrl.state.tabBarController.close();

    if (meta.type == 'quran') {
      final page = meta.details['page'] as int? ?? 1;
      quranCtrl.changeSurahListOnTap(page);
      return;
    }

    // Book navigation
    final bookNumber = meta.details['book_number'] as int?;
    final pageNumber = meta.details['page_number'] as int? ?? 1;
    if (bookNumber == null) return;

    final booksCtrl = BooksController.instance;
    if (booksCtrl.isBookDownloaded(bookNumber)) {
      booksCtrl.moveToBookPageByNumber(pageNumber - 1, bookNumber);
    } else {
      _showBookDownloadDialog(context, bookNumber);
    }
  }

  void _showBookDownloadDialog(BuildContext context, int bookNumber) {
    final booksCtrl = BooksController.instance;
    final book = booksCtrl.state.booksList.firstWhereOrNull(
      (b) => b.bookNumber == bookNumber,
    );
    if (book == null) return;

    Get.dialog(
      Obx(
        () => Dialog(
          backgroundColor: context.theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book.bookName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.surface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  'يجب تحميل الكتاب أولاً للمتابعة',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                // Download button + progress bar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed:
                            booksCtrl.state.downloading[bookNumber] == true
                            ? () {}
                            : () async {
                                await booksCtrl.downloadBook(
                                  bookNumber,
                                  book.bookType,
                                );
                                // Close dialog and navigate after download
                                if (booksCtrl.isBookDownloaded(bookNumber)) {
                                  final meta = result.metadata;
                                  final pageNumber =
                                      meta.details['page_number'] as int? ?? 1;
                                  Get.back();
                                  await booksCtrl.moveToBookPageByNumber(
                                    pageNumber - 1,
                                    bookNumber,
                                  );
                                }
                              },
                        height: 44,
                        width: Get.width,
                        verticalPadding: 0.0,
                        horizontalPadding: 0.0,
                        isCustomSvgColor: true,
                        svgPath: SvgPath.svgAudioDownload,
                        backgroundColor: context.theme.colorScheme.surface,
                        svgColor: context.theme.colorScheme.secondaryContainer,
                        title: booksCtrl.state.downloading[bookNumber] == true
                            ? 'downloading'.tr
                            : 'download'.tr,
                      ),
                    ),
                    if (booksCtrl.state.downloading[bookNumber] == true)
                      RoundedProgressBar(
                        height: 44,
                        style: RoundedProgressBarStyle(
                          borderWidth: 0,
                          widthShadow: 5,
                          backgroundProgress: context.theme.colorScheme.surface,
                          colorProgress: context.theme.colorScheme.primary,
                          colorProgressDark: context.theme.primaryColorLight
                              .withValues(alpha: 0.5),
                          colorBorder: context.theme.colorScheme.surface
                              .withValues(alpha: 0.1),
                          colorBackgroundIcon: Colors.transparent,
                        ),
                        margin: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(8),
                        percent:
                            booksCtrl.state.downloadProgress[bookNumber] ?? 0,
                      ),
                  ],
                ),
                const Gap(16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'إغلاق',
                    style: TextStyle(
                      color: context.theme.colorScheme.surface.withValues(
                        alpha: 0.5,
                      ),
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
