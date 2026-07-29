part of '../books.dart';

/// المتحكم الرئيسي للكتب - Main Books Controller
class BooksController extends GetxController {
  static BooksController get instance =>
      GetInstance().putOrFind(() => BooksController());

  final BooksState state = BooksState();

  // ============ Lifecycle ============

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  void _initializeController() {
    fetchBooks().then((_) => loadLastRead());
    loadFromGetStorage();
    getApplicationDocumentsDirectory().then((dir) {
      state.dir = dir;
      if (!state.dirInitialized.isCompleted) state.dirInitialized.complete();
    });
    _setupSearchListener();
  }

  void _setupSearchListener() {
    ever(state.searchQuery, (query) {
      state.isSearch.value = query.isNotEmpty;
    });
  }

  void _disposeResources() {
    state.bookPageController.dispose();
    state.bookRLFocusNode.dispose();
    state.searchController.dispose();
  }

  // ============ Data Loading ============

  Future<void> fetchBooks() async {
    try {
      state.isLoading(true);
      final jsonString = await rootBundle.loadString(
        'assets/json/collections_v2.json',
      );
      final collectionsJson = json.decode(jsonString) as List;
      // الهيكلية الجديدة: مصفوفة من مجموعات الكتب حسب النوع
      // New structure: array of book collections grouped by type
      final allBooks = <Book>[];
      final allBooksInfo = <BookCollection>[];
      for (var collection in collectionsJson) {
        final booksType = collection['booksType'] as List?;
        if (booksType != null) {
          allBooks.addAll(booksType.map((book) => Book.fromJson(book)));
        }
        allBooksInfo.add(BookCollection.fromJson(collection));
      }
      state.booksList.value = allBooks;
      state.booksInfo.value = allBooksInfo;
      // حفظ أنواع الكتب من collections.json - Save book types from collections.json
      state.bookTypes.value = collectionsJson
          .map((c) => c['type'] as String? ?? '')
          .where((t) => t.isNotEmpty)
          .toList();
      log('Books loaded: ${state.booksList.length}', name: 'BooksController');
      loadDownloadedBooks();
    } catch (e) {
      log('Error fetching books: $e', name: 'BooksController');
    } finally {
      state.isLoading(false);
      update(['booksList']);
    }
  }

  // ============ Download Management ============

  Future<void> downloadBook(
    int bookNumber,
    String bookType,
    String bookUrlType,
  ) async {
    if (!InternetConnectionController.instance.isConnected) {
      return Get.context!.showCustomErrorSnackBar(
        'noInternet'.tr,
        isDone: false,
      );
    }

    try {
      _setDownloadState(bookNumber, downloading: true, progress: 0.0);

      final result = await ApiClient().downloadFile(
        url: _getBookDownloadUrl(bookNumber, bookType, bookUrlType),
        fallbackUrl: _getBookDownloadUrl(
          bookNumber,
          bookType,
          bookUrlType,
          useGitLab: true,
        ),
        onProgress: (received, total) {
          state.downloadProgress[bookNumber] = (received / total * 100).clamp(
            0.0,
            100.0,
          );
        },
      );

      result.fold(
        (failure) {
          log(
            'Error downloading book: ${failure.message}',
            name: 'BooksController',
          );
          Get.context!.showCustomErrorSnackBar(
            'downloadError'.tr,
            isDone: false,
          );
        },
        (data) async {
          await _saveBookToFile(bookNumber, data);
          state.downloaded[bookNumber] = true;
          saveDownloadedBooks();
          update(['downloadedBooks']);
          log(
            'Book $bookNumber downloaded successfully',
            name: 'BooksController',
          );
        },
      );
    } catch (e) {
      log('Error downloading book: $e', name: 'BooksController');
      Get.context!.showCustomErrorSnackBar('downloadError'.tr, isDone: false);
    } finally {
      state.downloading[bookNumber] = false;
    }
  }

  void _setDownloadState(
    int bookNumber, {
    required bool downloading,
    required double progress,
  }) {
    state.downloading[bookNumber] = downloading;
    state.downloadProgress[bookNumber] = progress;
  }

  String _getBookDownloadUrl(
    int bookNumber,
    String bookType,
    String bookUrlType, {
    bool useGitLab = false,
  }) {
    log(
      'Getting download URL for book $bookNumber (type: $bookType, urlType: $bookUrlType, useGitLab: $useGitLab)',
      name: 'BooksController',
    );
    String baseUrl;
    baseUrl = useGitLab
        ? ApiConstants.booksGitLabUrl + '${bookUrlType}/1.0.0'
        : ApiConstants.booksGithubUrl + '/${bookUrlType}';
    // if (bookType == 'tafsir') {
    //   baseUrl = useGitLab
    //       ? ApiConstants.tafsirGitLabUrl
    //       : ApiConstants.tafsirUrl;
    // } else if (bookType == 'hadiths') {
    //   baseUrl = useGitLab
    //       ? ApiConstants.hadithsGitLabUrl
    //       : ApiConstants.hadithsUrl;
    // } else if (bookType == 'aqeedah') {
    //   baseUrl = useGitLab
    //       ? ApiConstants.aqeedahGitLabUrl
    //       : ApiConstants.aqeedahUrl;
    // } else if (bookType == 'asul_el-feqh') {
    //   baseUrl = useGitLab
    //       ? ApiConstants.asulElfqhGitLabUrl
    //       : ApiConstants.asulElfqhUrl;
    // } else if (bookType == 'eulum_alfiqh_wal_awaeid_alfiqhia') {
    //   baseUrl = useGitLab
    //       ? ApiConstants.eulumFiqhGitLabUrl
    //       : ApiConstants.eulumFiqhUrl;
    // } else {
    //   baseUrl = useGitLab
    //       ? ApiConstants.tafsirGitLabUrl
    //       : ApiConstants.tafsirUrl;
    // }
    return '$baseUrl/${bookNumber.toString()}.json';
  }

  Future<void> _saveBookToFile(int bookNumber, dynamic data) async {
    final file = File('${state.dir.path}/$bookNumber.json');
    final content = data is String ? data : json.encode(data);
    await file.writeAsString(content);
  }

  bool isBookDownloaded(int bookNumber) =>
      state.downloaded[bookNumber] ?? false;

  // ============ Book Data Retrieval ============

  Future<List<Volume>> getVolumes(int bookNumber) async {
    // تحقق من الكاش أولاً - Check cache first
    if (state.volumesCache.containsKey(bookNumber)) {
      return state.volumesCache[bookNumber]!;
    }

    try {
      final bookJson = await _readBookJson(bookNumber);
      if (bookJson == null) return [];

      final info = bookJson['info'];
      if (info == null || !info.containsKey('volumes')) return [];

      final volumes = (info['volumes'] as Map<String, dynamic>).entries
          .map((e) => Volume.fromJson(e.key, List<int>.from(e.value)))
          .toList();

      state.volumesCache[bookNumber] = volumes;
      return volumes;
    } catch (e) {
      return [];
    }
  }

  Future<List<TocItem>> getTocs(int bookNumber) async {
    try {
      // Check cache first
      if (state.tocCache.containsKey(bookNumber)) {
        return state.tocCache[bookNumber]!;
      }

      final bookJson = await _readBookJson(bookNumber);
      if (bookJson == null) return [];

      final toc = bookJson['info']?['toc'];
      if (toc == null) return [];

      final flatToc = _flattenToc(toc);
      state.tocCache[bookNumber] = flatToc;
      return flatToc;
    } catch (e) {
      return [];
    }
  }

  /// الحصول على فصول كل جزء مع كاش - Get chapters per volume with cache
  Map<int, List<TocItem>> getVolumeChapters(
    int bookNumber,
    List<Volume> volumes,
    List<TocItem> allToc,
  ) {
    if (state.volumeChaptersCache.containsKey(bookNumber)) {
      return state.volumeChaptersCache[bookNumber]!;
    }

    final Map<int, List<TocItem>> mapping = {};
    for (final volume in volumes) {
      mapping[volume.startPage] = allToc
          .where((tocItem) =>
              tocItem.page >= volume.startPage &&
              tocItem.page <= volume.endPage)
          .toList();
    }
    state.volumeChaptersCache[bookNumber] = mapping;
    return mapping;
  }

  Future<int> getTocItemStartPage(int bookNumber, String itemText) async {
    try {
      final bookJson = await _readBookJson(bookNumber);
      if (bookJson == null) return 0;

      final toc = bookJson['info']?['toc'];
      return toc != null ? _findPageInToc(toc, itemText) : 0;
    } catch (e) {
      return 0;
    }
  }

  Future<List<PageContent>> getPages(int bookNumber) async {
    try {
      final bookJson = await _readBookJson(bookNumber, tryAssets: true);
      if (bookJson == null) return [];

      final bookTitle = bookJson['info']?['title'] ?? '';
      final pages = bookJson['pages'] as List<dynamic>?;

      return pages
              ?.map((p) => PageContent.fromJson(p, bookTitle, bookNumber))
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  // ============ JSON Helpers ============

  Future<Map<String, dynamic>?> _readBookJson(
    int bookNumber, {
    bool tryAssets = false,
  }) async {
    try {
      await state.dirInitialized.future;
      String jsonString;

      if (tryAssets) {
        try {
          jsonString = await rootBundle.loadString(
            'assets/json/$bookNumber.json',
          );
        } catch (_) {
          final file = File('${state.dir.path}/$bookNumber.json');
          if (!await file.exists()) return null;
          jsonString = await file.readAsString();
        }
      } else {
        final file = File('${state.dir.path}/$bookNumber.json');
        if (!await file.exists()) return null;
        jsonString = await file.readAsString();
      }

      var bookJson = json.decode(jsonString);
      if (bookJson is List && bookJson.isNotEmpty) {
        bookJson = bookJson.first;
      }
      return bookJson as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  List<TocItem> _flattenToc(dynamic tocData) {
    if (tocData is! List) return [];

    return tocData.expand<TocItem>((item) {
      if (item is Map<String, dynamic> &&
          item.containsKey('text') &&
          item.containsKey('page')) {
        return [TocItem.fromJson(item)];
      } else if (item is List) {
        return _flattenToc(item);
      }
      return [];
    }).toList();
  }

  int _findPageInToc(dynamic toc, String searchText) {
    if (toc is! List) return 0;

    final normalizedSearch = _normalizeText(searchText);

    for (var item in toc) {
      if (item is Map<String, dynamic>) {
        final itemText = _normalizeText(item['text'] ?? '');
        final itemPage = item['page'] ?? 0;

        if (itemText == normalizedSearch ||
            itemText.contains(normalizedSearch) ||
            normalizedSearch.contains(itemText)) {
          return itemPage;
        }
      } else if (item is List) {
        final result = _findPageInToc(item, searchText);
        if (result > 0) return result;
      }
    }
    return 0;
  }

  String _normalizeText(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(
          RegExp(
            r'[^\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s\w\d:،.]',
          ),
          '',
        )
        .toLowerCase();
  }

  // ============ Search ============

  // ═══════════════════════════════════════════
  // البحث الموضوعي - Subject Search (سريع من الكاش)
  // ═══════════════════════════════════════════

  /// بحث فوري في عناوين الفصول من الكاش - Instant TOC search from cache
  Future<void> searchSubjects(String query) async {
    if (query.trim().length < 2) {
      state.subjectSearchResults.clear();
      return;
    }

    try {
      state.subjectSearchResults.clear();
      final cleanQuery = _normalizeSearchQuery(query);
      final downloadedBooks = _getBooksToSearch(null);

      for (var book in downloadedBooks) {
        final tocs = await getTocs(book.bookNumber);
        for (var toc in tocs) {
          if (_cleanTextForSearch(toc.text).contains(cleanQuery)) {
            state.subjectSearchResults.add(
              SubjectSearchResult(
                text: toc.text,
                page: toc.page,
                bookNumber: book.bookNumber,
                bookName: book.bookName,
                bookType: book.bookType,
              ),
            );
          }
        }
      }
    } catch (e) {
      log('Error in subject search: $e', name: 'BooksController_Search');
    }
  }

  // ═══════════════════════════════════════════
  // البحث الرئيسي - Main Search Entry Point
  // ═══════════════════════════════════════════

  /// نقطة الدخول الرئيسية للبحث - Main search entry
  /// 1. يعرض نتائج موضوعية فوراً من الكاش
  /// 2. يبدأ البحث النصي في Isolate واحد لكل الكتب
  Future<void> searchBooks(String query, {int? bookNumber}) async {
    // إلغاء بحث سابق نشط - Cancel previous active search
    _cancelActiveSearch();

    if (query.trim().length < 2) {
      state.searchResults.clear();
      state.subjectSearchResults.clear();
      state.searchedBookTypes.clear();
      state.sectionVisibleCount.clear();
      update(['searchResults']);
      return;
    }

    // حفظ الاستعلام النشط - Track active query
    state.activeSearchQuery = query;

    // تفعيل مؤشر البحث فوراً - Show searching indicator immediately
    state.isTextSearching.value = true;
    state.searchResults.clear();
    state.subjectSearchResults.clear();
    state.searchedBookTypes.clear();

    // 1. البحث الموضوعي فوراً من الكاش (سريع)
    await searchSubjects(query);

    // 2. البحث النصي في Isolate واحد
    _startTextSearch(query, bookNumber: bookNumber);
  }

  /// إلغاء البحث النشط - Cancel active search
  void _cancelActiveSearch() {
    state.activeSearchQuery = null;
    state.isTextSearching.value = false;
  }

  // ═══════════════════════════════════════════
  // كاش صفحات الكتب - Pages Cache
  // ═══════════════════════════════════════════

  /// تحميل صفحات كتاب + كاشها - Load and cache book pages
  Future<List<Map<String, dynamic>>> _getBookPages(int bookNumber) async {
    if (state._pagesCache.containsKey(bookNumber)) {
      return state._pagesCache[bookNumber]!;
    }

    final bookJson = await _readBookJson(bookNumber, tryAssets: true);
    if (bookJson == null) return [];

    final bookTitle = bookJson['info']?['title'] ?? '';
    final pagesJson = bookJson['pages'] as List<dynamic>?;
    if (pagesJson == null) return [];

    final pagesData = pagesJson
        .map(
          (p) => <String, dynamic>{
            'text': p['text'] ?? '',
            'page_number': p['page_number'] ?? 0,
            'page': p['page'] ?? 0,
            'book_title': bookTitle,
            'book_number': bookNumber,
          },
        )
        .toList();

    state._pagesCache[bookNumber] = pagesData;
    return pagesData;
  }

  // ═══════════════════════════════════════════
  // البحث النصي - Text Search (Isolate واحد)
  // ═══════════════════════════════════════════

  /// بحث نصي — Isolate واحد يبحث في كل الكتب
  Future<void> _startTextSearch(String query, {int? bookNumber}) async {
    final cleanQuery = _normalizeSearchQuery(query);
    final booksToSearch = _getBooksToSearch(bookNumber);

    if (booksToSearch.isEmpty) {
      log('No downloaded books found for search', name: 'BooksController');
      state.isTextSearching.value = false;
      return;
    }

    state.isLoading.value = true;

    log(
      'Starting text search for: $query (${booksToSearch.length} books)',
      name: 'BooksController_Search',
    );

    try {
      // تحميل كل الكتب من الكاش أو من disk
      final allPagesData = <Map<String, dynamic>>[];
      for (var book in booksToSearch) {
        if (state.activeSearchQuery != query) return;
        final pages = await _getBookPages(book.bookNumber);
        allPagesData.addAll(pages);
      }

      if (state.activeSearchQuery != query) return;

      // بحث واحد في isolate لكل الصفحات
      final receivePort = ReceivePort();
      await Isolate.spawn(
        _searchAllPagesEntryPoint,
        _SearchIsolateParams(
          sendPort: receivePort.sendPort,
          pagesData: allPagesData,
          cleanQuery: cleanQuery,
          originalQuery: query,
        ),
      );

      final results = await receivePort.first as List<Map<String, dynamic>>;

      if (state.activeSearchQuery != query) return;

      // تحويل النتائج لـ PageContent + تحديث مرة واحدة
      final pageContents = results
          .map(
            (r) => PageContent(
              text: r['text'] as String,
              pageNumber: r['page_number'] as int,
              page: r['page'] as int,
              bookTitle: r['book_title'] as String,
              bookNumber: r['book_number'] as int,
            ),
          )
          .toList();

      state.searchResults.assignAll(pageContents);

      // تحديث أنواع الكتب اللي فيها نتائج
      final types = <String>{};
      for (var r in pageContents) {
        final book = state.booksList
            .where((b) => b.bookNumber == r.bookNumber)
            .firstOrNull;
        if (book != null) types.add(book.bookType);
      }
      state.searchedBookTypes.assignAll(types);

      log(
        'Text search completed. Total: ${state.searchResults.length}',
        name: 'BooksController_Search',
      );
    } catch (e, stackTrace) {
      log(
        'Error during text search: $e',
        name: 'BooksController_Search',
        error: e,
        stackTrace: stackTrace,
      );
      if (state.activeSearchQuery == query) {
        Get.context?.showCustomErrorSnackBar('searchError'.tr, isDone: false);
      }
    } finally {
      if (state.activeSearchQuery == query) {
        state.isLoading.value = false;
        state.isTextSearching.value = false;
        update(['searchResults']);
      }
    }
  }

  /// نقطة دخول Isolate — بحث في كل الصفحات دفعة واحدة
  static void _searchAllPagesEntryPoint(_SearchIsolateParams params) {
    final results = <Map<String, dynamic>>[];

    for (final page in params.pagesData) {
      final text = page['text'] as String;
      final cleaned = _isolateCleanText(text);
      if (cleaned.contains(params.cleanQuery)) {
        results.add({
          'text': _isolateCreateSnippet(text, params.originalQuery),
          'page_number': page['page_number'],
          'page': page['page'],
          'book_title': page['book_title'] ?? '',
          'book_number': page['book_number'] ?? 0,
        });
      }
    }

    params.sendPort.send(results);
  }

  /// تنظيف النص داخل Isolate (بدون extensions)
  /// يطابق تماماً ما يفعله removeDiacriticsQuran + تنظيف HTML
  static String _isolateCleanText(String text) {
    // 1. إزالة HTML tags
    String clean = text.replaceAll(RegExp(r'<[^>]*>'), ' ');

    // 2. إزالة كل التشكيل + التطويل (ـ)
    // يطابق مجموعة removeDiacriticsQuran بالكامل
    // U+064B–0652, U+0653–065E, U+0670, U+0640, U+06D6–06E2
    clean = clean.replaceAll(
      RegExp(r'[\u064B-\u065E\u0670\u0640\u06D6-\u06E2]'),
      '',
    );

    // 3. توحيد أشكال الألف (مثل removeDiacriticsQuran)
    clean = clean.replaceAll('أ', 'ا');
    clean = clean.replaceAll('إ', 'ا');
    clean = clean.replaceAll('آ', 'ا');

    // 4. توحيد المسافات + trim + lowercase
    return clean.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  }

  /// إنشاء snippet داخل Isolate
  static String _isolateCreateSnippet(String text, String query) {
    final cleanText = text
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final words = cleanText.split(' ');
    final queryLower = query.toLowerCase();

    final matchIndex = words.indexWhere((word) {
      return word
          .toLowerCase()
          .replaceAll(RegExp(r'[َُِّْٰٖٕٗٓۖۗۘۙۚۛۜ۝۞ًٌٍ۟۠ۡۢ]'), '')
          .contains(queryLower);
    });

    if (matchIndex == -1) {
      return words.take(21).join(' ') + (words.length > 21 ? '...' : '');
    }

    final start = (matchIndex - 10).clamp(0, words.length);
    final end = (matchIndex + 11).clamp(0, words.length);

    return '${start > 0 ? '...' : ''}${words.sublist(start, end).join(' ')}${end < words.length ? '...' : ''}';
  }

  // ═══════════════════════════════════════════
  // مساعدات البحث - Search Helpers
  // ═══════════════════════════════════════════

  List<Book> _getBooksToSearch(int? bookNumber) {
    if (bookNumber != null) {
      return state.booksList
          .where(
            (b) => b.bookNumber == bookNumber && isBookDownloaded(b.bookNumber),
          )
          .toList();
    }
    return state.booksList
        .where((b) => isBookDownloaded(b.bookNumber))
        .toList();
  }

  String _normalizeSearchQuery(String query) {
    return query.removeDiacriticsQuran(query).trim().toLowerCase();
  }

  String _cleanTextForSearch(String text) {
    // إزالة HTML tags
    String clean = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    // إزالة كل التشكيل + التطويل (يطابق removeDiacriticsQuran)
    clean = clean.replaceAll(
      RegExp(r'[\u064B-\u065E\u0670\u0640\u06D6-\u06E2]'),
      '',
    );
    // توحيد أشكال الألف
    clean = clean
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا');
    return clean.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  }

  void searchBookNames(String query) {
    state.searchQuery.value = query;
    update(['booksList']);
    log('Searching book names with query: $query', name: 'BooksController');
  }

  // ============ Filtering ============

  List<Book> getFilteredBooks(
    List<Book> booksList, {
    bool isDownloadedBooks = false,
    String? filterBookType,
    String title = '',
  }) {
    var filtered = _filterByCategory(
      booksList,
      isDownloadedBooks: isDownloadedBooks,
      filterBookType: filterBookType,
    );

    filtered = _filterBySearchQuery(filtered);

    // ترتيب خاص لكتب الأحاديث - Special sort for hadith books
    if (filterBookType == 'hadiths') {
      filtered = _sortHadithBooks(filtered);
    }

    // ترتيب الكتب - Sort books
    filtered = _sortBooks(filtered);

    return filtered;
  }

  List<Book> _filterByCategory(
    List<Book> books, {
    required bool isDownloadedBooks,
    String? filterBookType,
  }) {
    if (isDownloadedBooks) {
      return books
          .where((b) => state.downloaded[b.bookNumber] == true)
          .toList();
    }
    if (filterBookType != null) {
      return books.where((b) => b.bookType == filterBookType).toList();
    }
    return books;
  }

  List<Book> _filterBySearchQuery(List<Book> books) {
    if (state.searchQuery.value.isEmpty) return books;

    final normalizedQuery = _normalizeForBookSearch(state.searchQuery.value);
    return books.where((b) {
      return _normalizeForBookSearch(b.bookName).contains(normalizedQuery) ||
          _normalizeForBookSearch(b.bookFullName).contains(normalizedQuery) ||
          _normalizeForBookSearch(b.author).contains(normalizedQuery);
    }).toList();
  }

  /// توحيد النص لغرض البحث في أسماء الكتب
  /// يزيل التشكيل ويوحّد الحروف المتشابهة (ه/ة، ا/أ/إ/آ، و/ؤ، ي/ى)
  String _normalizeForBookSearch(String text) {
    return text
        .toLowerCase()
        // توحيد التشكيل
        .replaceAll(RegExp(r'[\u064B-\u065E\u0670\u0640\u06D6-\u06E2]'), '')
        // توحيد أشكال الألف
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        // ه بدل ة والعكس
        .replaceAll('ة', 'ه')
        // و بدل ؤ
        .replaceAll('ؤ', 'و')
        // ي بدل ى
        .replaceAll('ى', 'ي')
        // توحيد المسافات
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<Book> _sortHadithBooks(List<Book> books) {
    final priority = <Book>[];
    final others = <Book>[];

    for (var book in books) {
      (sixthBooksNumbers.contains(book.bookNumber) ? priority : others).add(
        book,
      );
    }
    return [...priority, ...others];
  }

  /// ترتيب الكتب حسب النوع المختار - Sort books by selected type
  List<Book> _sortBooks(List<Book> books) {
    final sorted = List<Book>.from(books);
    final ascending = state.sortAscending.value;
    switch (state.sortType.value) {
      case BookSortType.deathYear:
        sorted.sort((a, b) {
          final aYear = a.authorDeathYear ?? 9999;
          final bYear = b.authorDeathYear ?? 9999;
          return ascending ? aYear.compareTo(bYear) : bYear.compareTo(aYear);
        });
      case BookSortType.nameAlpha:
        sorted.sort((a, b) {
          final cmp = a.bookName.compareTo(b.bookName);
          return ascending ? cmp : -cmp;
        });
      case BookSortType.authorAlpha:
        sorted.sort((a, b) {
          final cmp = a.author.compareTo(b.author);
          return ascending ? cmp : -cmp;
        });
      case BookSortType.defaultOrder:
        break;
    }
    return sorted;
  }

  RxBool collapsedHeight(int bookNumber) {
    final key = bookNumber - 1;
    return state.collapsedHeightMap[key] ??= false.obs;
  }

  // ============ Pagination ============

  void initBooksPagination(int totalBooks, String pageKey) {
    if (state.booksPaginationCounts.containsKey(pageKey)) return;

    state.booksPaginationCounts[pageKey] = BooksState.booksItemsPerPage.clamp(
      0,
      totalBooks,
    );
    state.booksIsLoadingMore[pageKey] = false;

    final controller = ScrollController()
      ..addListener(() => _onBooksPaginationScroll(pageKey, totalBooks));
    state.booksScrollControllers[pageKey] = controller;
  }

  ScrollController getBooksPaginationScrollController(String pageKey) =>
      state.booksScrollControllers[pageKey] ?? ScrollController();

  void _onBooksPaginationScroll(String pageKey, int totalBooks) {
    if (state.booksIsLoadingMore[pageKey] == true) return;

    final controller = state.booksScrollControllers[pageKey];
    if (controller == null || !controller.hasClients) return;

    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 300) {
      _loadMoreBooks(pageKey, totalBooks);
    }
  }

  int getBooksPaginationCount(String pageKey) =>
      state.booksPaginationCounts[pageKey] ?? BooksState.booksItemsPerPage;

  void _loadMoreBooks(String pageKey, int totalBooks) {
    if (state.booksIsLoadingMore[pageKey] == true) return;

    final currentCount =
        state.booksPaginationCounts[pageKey] ?? BooksState.booksItemsPerPage;
    if (currentCount >= totalBooks) return;

    state.booksIsLoadingMore[pageKey] = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      state.booksPaginationCounts[pageKey] =
          (currentCount + BooksState.booksItemsPerPage).clamp(0, totalBooks);
      state.booksIsLoadingMore[pageKey] = false;
      update(['booksPagination_$pageKey']);
    });
  }

  void resetBooksPagination(String pageKey) {
    state.booksPaginationCounts.remove(pageKey);
    state.booksIsLoadingMore.remove(pageKey);
    state.booksScrollControllers[pageKey]?.dispose();
    state.booksScrollControllers.remove(pageKey);
  }
}

/// معاملات البحث في Isolate - Isolate search parameters
class _SearchIsolateParams {
  final SendPort sendPort;
  final List<Map<String, dynamic>> pagesData;
  final String cleanQuery;
  final String originalQuery;

  _SearchIsolateParams({
    required this.sendPort,
    required this.pagesData,
    required this.cleanQuery,
    required this.originalQuery,
  });
}
