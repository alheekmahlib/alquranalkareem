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
      child: GetBuilder<BooksController>(
        id: 'searchResults',
        builder: (booksCtrl) {
          final downloadedBooks = booksCtrl.state.booksList
              .where((book) => booksCtrl.isBookDownloaded(book.bookNumber))
              .toList();

          final hasSubjectResults =
              booksCtrl.state.subjectSearchResults.isNotEmpty;
          final hasTextResults = booksCtrl.state.searchResults.isNotEmpty;
          final isSearching = booksCtrl.state.isTextSearching.value;

          if (!hasSubjectResults && !hasTextResults && !isSearching) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(32),
                const IslamicLibraryLogo(logoHeight: 70.0),
                _emptyState(context, downloadedBooks),
              ],
            );
          }

          return ListView(
            children: [
              const Gap(32),
              const IslamicLibraryLogo(logoHeight: 70.0),

              // 1. نص متدفق — يظهر دائما
              _textSearchingIndicator(),
              // 2. البحث الموضوعي
              if (hasSubjectResults) _subjectSearchSection(context),
              // 3. البحث النصي مقسم حسب نوع الكتاب
              if (hasTextResults) ..._textSearchSections(context),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════
  // البحث الموضوعي - Subject Search
  // ═══════════════════════════════════════════

  Widget _subjectSearchSection(BuildContext context) {
    final results = booksCtrl.state.subjectSearchResults;
    final visibleCount = _getVisibleCount('subject');
    final visibleResults = results.take(visibleCount).toList();
    final hasMore = visibleCount < results.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTileWidget<BooksController>(
        name: 'search_subject',
        manager: booksCtrl.state.searchTileManager,
        getxCtrl: booksCtrl,
        title: 'subjectSearch'.tr,
        subtitle: '${results.length} ${'result'.tr}'
            .convertNumbersToCurrentLang(),
        onExpansionChanged: (expanded) {
          if (expanded) _ensureVisible('subject', results.length);
        },
        child: Column(
          children: [
            ...visibleResults.map(
              (result) => _subjectResultItem(context, result),
            ),
            if (hasMore) _showMoreButton('subject', results.length),
          ],
        ),
      ),
    );
  }

  Widget _subjectResultItem(BuildContext context, SubjectSearchResult result) {
    return InkWell(
      onTap: () async {
        await booksCtrl.moveToBookPageByNumber(
          result.page - 1,
          result.bookNumber,
        );
        booksCtrl.state.searchResults.clear();
        booksCtrl.state.subjectSearchResults.clear();
        booksCtrl.state.searchController.clear();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الباب/الفصل
            Text.rich(
              TextSpan(
                children: result.text
                    .highlightLine(booksCtrl.state.searchController.text)
                    .cast<TextSpan>(),
              ),
              style: AppTextStyles.titleMedium(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
            const Gap(4),
            // اسم الكتاب + رقم الصفحة
            _bookAndPageRow(
              context: context,
              bookName: result.bookName,
              pageNumber: result.page,
            ),
            const Divider(thickness: 0.5, height: 16),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // البحث النصي مقسم حسب نوع الكتاب
  // ═══════════════════════════════════════════

  List<Widget> _textSearchSections(BuildContext context) {
    // تجميع النتائج حسب نوع الكتاب - Group results by book type
    final Map<String, List<PageContent>> grouped = {};
    for (var result in booksCtrl.state.searchResults) {
      final book = booksCtrl.state.booksList
          .firstWhereOrNull((b) => b.bookNumber == result.bookNumber);
      if (book == null) continue;
      final type = book.bookType;
      grouped.putIfAbsent(type, () => []).add(result);
    }

    return grouped.entries.map((entry) {
      final type = entry.key;
      final results = entry.value;
      final sectionKey = 'text_$type';
      final visibleCount = _getVisibleCount(sectionKey);
      final visibleResults = results.take(visibleCount).toList();
      final hasMore = visibleCount < results.length;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ExpansionTileWidget<BooksController>(
          name: 'search_$type',
          manager: booksCtrl.state.searchTileManager,
          getxCtrl: booksCtrl,
          title: type.tr,
          subtitle: '${results.length} ${'result'.tr}'
              .convertNumbersToCurrentLang(),
          onExpansionChanged: (expanded) {
            if (expanded) _ensureVisible(sectionKey, results.length);
          },
          child: Column(
            children: [
              ...visibleResults.map(
                (result) => _textResultItem(context, result),
              ),
              if (hasMore) _showMoreButton(sectionKey, results.length),
            ],
          ),
        ),
      );
    }).toList();
  }

  /// نص متدفق — يظهر دائما عند وجود نتائج
  Widget _textSearchingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: StreamingTextMarkdown(
        text: 'searchingText'.tr,
        chunkSize: 1,
        wordByWord: true,
        latexEnabled: true,
        markdownEnabled: true,
        latexStyle: AppTextStyles.titleMedium(
          fontSize: 18,
          height: 1.6,
          color: Get.theme.colorScheme.inversePrimary,
        ),
        styleSheet: AppTextStyles.titleMedium(
          fontSize: 18,
          height: 1.6,
          color: Get.theme.colorScheme.inversePrimary,
        ),
        textAlign: TextAlign.justify,
        textDirection: alignmentLayout(TextDirection.rtl, TextDirection.ltr),
      ),
    );
  }

  Widget _textResultItem(BuildContext context, PageContent result) {
    // القراءة من RxMap تُسجّل كـ dependency داخل Obx
    final cachedToc = booksCtrl.state.tocCache[result.bookNumber];
    final chapterName = cachedToc != null && cachedToc.isNotEmpty
        ? (booksCtrl.getCurrentChapterByPage(
                result.bookNumber,
                result.pageNumber,
              ) ??
              'غير محدد')
        : 'تحميل...';

    if (cachedToc == null || cachedToc.isEmpty) {
      booksCtrl.getTocs(result.bookNumber);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          horizontalPadding: 0.0,
          title: booksCtrl.getCurrentBookName(result.bookNumber),
          textStyle: AppTextStyles.titleSmall(),
        ),
        InkWell(
          onTap: () async {
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
            booksCtrl.state.subjectSearchResults.clear();
            booksCtrl.state.searchController.clear();
          },
          child: _buildTextSnippet(result, context),
        ),
        const Gap(4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _bookAndPageRow(
            context: context,
            bookName: chapterName,
            pageNumber: result.pageNumber,
          ),
        ),
        context.hDivider(width: Get.width),
        const Gap(8),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // Widgets مشتركة - Shared Widgets
  // ═══════════════════════════════════════════

  /// صف اسم الكتاب + رقم الصفحة — بدون Expanded/Flexible/LayoutBuilder
  Widget _bookAndPageRow({
    required BuildContext context,
    required String bookName,
    required int pageNumber,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: context.theme.primaryColorLight.withValues(alpha: .3),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(maxWidth: Get.width * 0.6),
          child: Text(
            bookName,
            style: AppTextStyles.titleSmall(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const Gap(4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${'page'.tr} $pageNumber'.convertNumbersToCurrentLang(),
            style: AppTextStyles.titleSmall(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Padding _buildTextSnippet(PageContent result, BuildContext context) {
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

  // ═══════════════════════════════════════════
  // مساعدات - Helpers
  // ═══════════════════════════════════════════

  int _getVisibleCount(String sectionKey) {
    if (!booksCtrl.state.sectionVisibleCount.containsKey(sectionKey)) {
      booksCtrl.state.sectionVisibleCount[sectionKey] =
          BooksState.searchResultsPerSection.obs;
    }
    return booksCtrl.state.sectionVisibleCount[sectionKey]!.value;
  }

  void _ensureVisible(String sectionKey, int totalCount) {
    _getVisibleCount(sectionKey); // ensure initialized
  }

  Widget _showMoreButton(String sectionKey, int totalCount) {
    return TextButton(
      onPressed: () {
        final current = _getVisibleCount(sectionKey);
        if (!booksCtrl.state.sectionVisibleCount.containsKey(sectionKey)) {
          booksCtrl.state.sectionVisibleCount[sectionKey] =
              BooksState.searchResultsPerSection.obs;
        }
        booksCtrl.state.sectionVisibleCount[sectionKey]!.value =
            (current + BooksState.searchResultsPerSection).clamp(0, totalCount);
        booksCtrl.update(['searchResults']);
      },
      child: Text('showMore'.tr),
    );
  }

  Widget _emptyState(BuildContext context, List<Book> downloadedBooks) {
    return Center(
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
              LottieConstants.assetsLottieSearch,
              height: 200.0,
              width: 200.0,
              color: context.theme.colorScheme.surface,
            ),
    );
  }
}
