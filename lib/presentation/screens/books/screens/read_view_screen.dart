part of '../books.dart';

class ReadViewScreen extends StatelessWidget {
  final int bookNumber;
  final int initialPage;
  final booksCtrl = BooksController.instance;
  final booksBookmarksCtrl = BooksBookmarksController.instance;
  final generalCtrl = GeneralController.instance;

  ReadViewScreen({super.key, required this.bookNumber, this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primary,
      body: _buildBody(),
    );
  }

  /// بناء الجسم الرئيسي / Build main body
  Widget _buildBody() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: FutureBuilder<List<PageContent>>(
          future: _loadPages(),
          builder: (context, snapshot) => _buildContent(context, snapshot),
        ),
      ),
    );
  }

  /// تحميل الصفحات / Load pages
  Future<List<PageContent>> _loadPages() {
    return Future.delayed(
      const Duration(milliseconds: 600),
    ).then((_) => booksCtrl.getPages(bookNumber));
  }

  /// بناء المحتوى بناءً على حالة البيانات / Build content based on data state
  Widget _buildContent(
    BuildContext context,
    AsyncSnapshot<List<PageContent>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const ShimmerEffectBuild();
    } else if (snapshot.hasError) {
      return _buildErrorWidget(snapshot.error.toString());
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildEmptyWidget();
    } else {
      return _buildPageView(context, snapshot.data!);
    }
  }

  /// بناء عنصر الخطأ / Build error widget
  Widget _buildErrorWidget(String error) {
    return Center(child: Text('Error: $error'));
  }

  /// بناء عنصر الفراغ / Build empty widget
  Widget _buildEmptyWidget() {
    return const Center(child: Text('لم يتم العثور على صفحات لهذا الكتاب.'));
  }

  /// بناء عارض الصفحات / Build page view
  Widget _buildPageView(BuildContext context, List<PageContent> pages) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () => booksCtrl.showControl(),
          child: Focus(
            focusNode: booksCtrl.state.bookRLFocusNode,
            onKeyEvent: (node, event) =>
                booksCtrl.controlRLByKeyboard(node, event),
            child: PageView.builder(
              controller: booksCtrl.getSafePageController(
                pages.length,
                initialPage: initialPage,
              ),
              itemCount: pages.length,
              onPageChanged: (i) {
                booksCtrl.state.currentPageNumber.value = i;

                ChaptersController.instance.onPageChanged(i);
              },
              itemBuilder: (context, index) =>
                  _buildPage(context, pages[index], index, pages.length),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: NavBarWidget(
            handleChild: BooksTopTitleWidget(
              bookNumber: bookNumber,
              index: booksCtrl.state.currentPageNumber.value - 1,
            ),
          ),
        ),
        TopBarWidget(
          isHomeChild: true,
          isQuranSetting: false,
          isNotification: false,
          isBackButton: true,
          bodyChild: SearchBuild(),
          centerChild: TextFieldBarWidget(
            hintText: 'searchInBooks'.tr,
            controller: booksCtrl.state.searchController,
            horizontalPadding: 0.0,
            onPressed: () {
              QuranController.instance.setTopBarType = TopBarType.search;
              QuranController.instance.state.tabBarController.open();
            },
            onButtonPressed: () {
              booksCtrl.state.searchResults.clear();
              booksCtrl.state.searchController.clear();
            },
            onChanged: (query) => booksCtrl.searchBooks(query),
            onSubmitted: (query) => booksCtrl.searchBooks(query),
          ),
        ),
      ],
    );
  }

  /// بناء صفحة واحدة / Build single page
  Widget _buildPage(
    BuildContext context,
    PageContent page,
    int index,
    int totalPages,
  ) {
    _saveLastRead(page, totalPages);
    return GetBuilder<BooksController>(
      init: BooksController.instance,
      builder: (booksCtrl) {
        return Container(
          color: booksCtrl.backgroundColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildPageNumberIndicator(page),
                          ),
                          context.vDivider(
                            color: Get.theme.colorScheme.inversePrimary
                                .withValues(alpha: .2),
                            height: 30,
                          ),
                          Expanded(
                            flex: 10,
                            child: ChaptersDropdownWidget(
                              bookNumber: bookNumber,
                              pageIndex: index,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GetX<BooksBookmarksController>(
                      builder: (booksBookmarksCtrl) => GestureDetector(
                        onTap: () => booksBookmarksCtrl.addBookmarkOnTap(
                          bookNumber,
                          index,
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: customSvgWithColor(
                            SvgPath.svgQuranBookmark,
                            color:
                                booksBookmarksCtrl.isPageBookmarked(
                                  bookNumber,
                                  index + 1,
                                )
                                ? context.theme.colorScheme.surface
                                : context.theme.colorScheme.primary,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(child: _buildPageContent(context, page, index)),
            ],
          ),
        );
      },
    );
  }

  /// حفظ آخر قراءة / Save last read
  void _saveLastRead(PageContent page, int totalPages) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final book = _findCurrentBook();
      booksCtrl.saveLastRead(
        page.pageNumber,
        book.bookName.isNotEmpty ? book.bookName : 'Unknown Book',
        bookNumber,
        totalPages,
      );
    });
  }

  /// البحث عن الكتاب الحالي / Find current book
  Book _findCurrentBook() {
    return booksCtrl.state.booksList.firstWhere(
      (book) => book.bookNumber == bookNumber,
      orElse: () => booksCtrl.state.booksList.isNotEmpty
          ? booksCtrl.state.booksList.first
          : Book.empty(),
    );
  }

  /// بناء محتوى الصفحة / Build page content
  Widget _buildPageContent(BuildContext context, PageContent page, int index) {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: GetX<GeneralController>(
                builder: (generalCtrl) =>
                    _buildTextContent(context, page, generalCtrl),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// بناء محتوى النص / Build text content
  Widget _buildTextContent(
    BuildContext context,
    PageContent page,
    GeneralController generalCtrl,
  ) {
    return GestureDetector(
      onTap: () => booksCtrl.showControl(),
      child: Column(
        children: [
          _buildMainText(page, generalCtrl),
          _buildFootnotes(context, page, generalCtrl),
          const Gap(32),
        ],
      ),
    );
  }

  /// بناء النص الأساسي / Build main text
  Widget _buildMainText(PageContent page, GeneralController generalCtrl) {
    final isDark = ThemeController.instance.isDarkMode;
    final mainText = _getMainText(page.text);
    final processedText = booksCtrl.state.isTashkil.value
        ? mainText
        : mainText.removeDiacriticsQuran(mainText);

    return Text.rich(
      TextSpan(
        children: processedText.toFlutterText(isDark),
        style: _getMainTextStyle(generalCtrl),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
    );
  }

  /// بناء الهوامش / Build footnotes
  Widget _buildFootnotes(
    BuildContext context,
    PageContent page,
    GeneralController generalCtrl,
  ) {
    final footnotes = _getFootnotes(page.text);
    if (footnotes.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const Gap(8),
        context.hDivider(
          color: Get.theme.colorScheme.inversePrimary.withValues(alpha: .2),
          width: context.width,
        ),
        const Gap(10),
        _buildFootnotesText(footnotes, generalCtrl),
      ],
    );
  }

  /// بناء نص الهوامش / Build footnotes text
  Widget _buildFootnotesText(String footnotes, GeneralController generalCtrl) {
    footnotes = _getMainText(footnotes);
    final processedFootnotes = booksCtrl.state.isTashkil.value
        ? footnotes
        : footnotes.removeDiacriticsQuran(footnotes);

    return Text.rich(
      TextSpan(
        text: processedFootnotes,
        style: _getFootnotesTextStyle(generalCtrl),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
    );
  }

  /// بناء مؤشر رقم الصفحة / Build page number indicator
  Widget _buildPageNumberIndicator(PageContent page) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          page.pageNumber.toString().convertNumbersToCurrentLang(),
          style: AppTextStyles.titleSmall(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// الحصول على تنسيق النص الأساسي / Get main text style
  TextStyle _getMainTextStyle(GeneralController generalCtrl) {
    return TextStyle(
      color: Get.theme.colorScheme.inversePrimary,
      height: 1.5,
      fontFamily: 'naskh',
      fontSize: generalCtrl.state.fontSizeArabic.value,
    );
  }

  /// الحصول على تنسيق نص الهوامش / Get footnotes text style
  TextStyle _getFootnotesTextStyle(GeneralController generalCtrl) {
    return TextStyle(
      color: Get.theme.colorScheme.inversePrimary.withValues(alpha: .8),
      height: 1.4,
      fontFamily: 'naskh',
      fontSize: (generalCtrl.state.fontSizeArabic.value * 0.85).roundToDouble(),
    );
  }

  /// استخراج النص الأساسي بدون الهوامش / Extract main text without footnotes
  String _getMainText(String htmlText) {
    // إزالة الهوامش (class="hamesh" أو p class="hamesh")
    String mainText = htmlText;

    // إزالة الـ div و hr
    mainText = mainText.replaceAll(RegExp(r'</?div[^>]*>'), '');
    mainText = mainText.replaceAll(RegExp(r'</?p[^>]*>'), ' ');
    mainText = mainText.replaceAll(RegExp(r'<hr[^>]*>'), '');

    mainText = mainText.replaceAllMapped(
      RegExp(r'<span\s+class="special"[^>]*>(.*?)</span>'),
      (match) => match.group(1) ?? '',
    );

    // mainText = mainText.replaceAll(
    //     RegExp(r'<span\s+class="special"[^>]*>.*</span>'), '\$1');

    // إزالة الهوامش
    mainText = mainText.replaceAll(
      RegExp(r'<p\s+class="hamesh"[^>]*>.*?</p>', dotAll: true),
      '',
    );
    mainText = mainText.replaceAll(
      RegExp(r'<span\s+class="hamesh"[^>]*>.*?</span>', dotAll: true),
      '',
    );

    // تحويل <br> إلى \n / Convert <br> to \n
    mainText = mainText.replaceAll(RegExp(r'<br[^>]*>'), '\n');

    return mainText.trim();
  }

  /// استخراج الهوامش فقط / Extract footnotes only
  String _getFootnotes(String htmlText) {
    String footnotes = '';

    // البحث عن p class="hamesh"
    RegExp pHameshRegex = RegExp(
      r'<p\s+class="hamesh"[^>]*>(.*?)</p>',
      dotAll: true,
    );
    Iterable<Match> pMatches = pHameshRegex.allMatches(htmlText);

    for (Match match in pMatches) {
      String content = match.group(1) ?? '';
      // تحويل <br> إلى \n / Convert <br> to \n
      content = content.replaceAll(RegExp(r'<br[^>]*>'), '\n');
      footnotes += '$content\n\n';
    }

    // البحث عن span class="hamesh"
    RegExp spanHameshRegex = RegExp(
      r'<span\s+class="hamesh"[^>]*>(.*?)</span>',
      dotAll: true,
    );
    Iterable<Match> spanMatches = spanHameshRegex.allMatches(htmlText);

    for (Match match in spanMatches) {
      String content = match.group(1) ?? '';
      // تحويل <br> إلى \n / Convert <br> to \n
      content = content.replaceAll(RegExp(r'<br[^>]*>'), '\n');
      footnotes += '$content\n\n';
    }

    return footnotes.trim();
  }
}
