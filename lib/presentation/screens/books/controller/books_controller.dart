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
    getApplicationDocumentsDirectory().then((dir) => state.dir = dir);
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
        'assets/json/collections.json',
      );
      final booksJson = json.decode(jsonString) as List;
      state.booksList.value = booksJson
          .map((book) => Book.fromJson(book))
          .toList();
      log('Books loaded: ${state.booksList.length}', name: 'BooksController');
      loadDownloadedBooks();
    } catch (e) {
      log('Error fetching books: $e', name: 'BooksController');
    } finally {
      state.isLoading(false);
    }
  }

  // ============ Download Management ============

  Future<void> downloadBook(int bookNumber) async {
    if (!InternetConnectionController.instance.isConnected) {
      return Get.context!.showCustomErrorSnackBar('noInternet'.tr);
    }

    try {
      _setDownloadState(bookNumber, downloading: true, progress: 0.0);

      final result = await ApiClient().downloadFile(
        url: _getBookDownloadUrl(bookNumber),
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
          Get.context!.showCustomErrorSnackBar('downloadError'.tr);
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
      Get.context!.showCustomErrorSnackBar('downloadError'.tr);
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

  String _getBookDownloadUrl(int bookNumber) =>
      'https://raw.githubusercontent.com/alheekmahlib/zad_library/main/${bookNumber.toString().padLeft(3, '0')}.json';

  Future<void> _saveBookToFile(int bookNumber, dynamic data) async {
    final file = File('${state.dir.path}/$bookNumber.json');
    final content = data is String ? data : json.encode(data);
    await file.writeAsString(content);
  }

  bool isBookDownloaded(int bookNumber) =>
      state.downloaded[bookNumber] ?? false;

  // ============ Book Data Retrieval ============

  Future<List<Volume>> getVolumes(int bookNumber) async {
    try {
      final bookJson = await _readBookJson(bookNumber);
      if (bookJson == null) return [];

      final info = bookJson['info'];
      if (info == null || !info.containsKey('volumes')) return [];

      return (info['volumes'] as Map<String, dynamic>).entries
          .map((e) => Volume.fromJson(e.key, List<int>.from(e.value)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<TocItem>> getTocs(int bookNumber) async {
    try {
      // Check cache first
      if (state.tocCache.containsKey(bookNumber - 1)) {
        return state.tocCache[bookNumber - 1]!;
      }

      final bookJson = await _readBookJson(bookNumber);
      if (bookJson == null) return [];

      final toc = bookJson['info']?['toc'];
      if (toc == null) return [];

      final flatToc = _flattenToc(toc);
      state.tocCache[bookNumber - 1] = flatToc;
      return flatToc;
    } catch (e) {
      return [];
    }
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

  Future<void> searchBooks(String query, {int? bookNumber}) async {
    if (query.trim().length < 2) {
      state.searchResults.clear();
      return;
    }

    try {
      state.isLoading.value = true;
      state.searchResults.clear();
      log('Starting search for: $query', name: 'BooksController_Search');

      final cleanQuery = query
          .removeDiacriticsQuran(query)
          .trim()
          .toLowerCase();
      final booksToSearch = _getBooksToSearch(bookNumber);

      if (booksToSearch.isEmpty) {
        log('No downloaded books found for search', name: 'BooksController');
        return;
      }

      await _searchInBooks(booksToSearch, cleanQuery, query);
      log(
        'Search completed. Total matches: ${state.searchResults.length}',
        name: 'BooksController_Search',
      );
    } catch (e, stackTrace) {
      log(
        'Error during search: $e',
        name: 'BooksController_Search',
        error: e,
        stackTrace: stackTrace,
      );
      Get.context?.showCustomErrorSnackBar('حدث خطأ أثناء البحث');
    } finally {
      state.isLoading.value = false;
    }
  }

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

  Future<void> _searchInBooks(
    List<Book> books,
    String cleanQuery,
    String originalQuery,
  ) async {
    for (var book in books) {
      if (!state.tocCache.containsKey(book.bookNumber)) {
        await getTocs(book.bookNumber);
      }

      final pages = await getPages(book.bookNumber);
      for (var page in pages) {
        if (_cleanTextForSearch(page.text).contains(cleanQuery)) {
          state.searchResults.add(
            PageContent(
              text: _createTextSnippet(page.text, originalQuery),
              pageNumber: page.pageNumber,
              page: page.page,
              bookTitle: page.bookTitle,
              bookNumber: page.bookNumber,
            ),
          );
        }
      }
    }
  }

  String _cleanTextForSearch(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'[َُِّْٰٖٕٗٓۖۗۘۙۚۛۜ۝۞ًٌٍ۟۠ۡۢ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase()
        .removeDiacriticsQuran(text);
  }

  String _createTextSnippet(String text, String query) {
    final cleanText = text
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final words = cleanText.split(' ');
    final queryLower = query.toLowerCase();

    final matchIndex = words.indexWhere((word) {
      final cleanWord = word.toLowerCase().replaceAll(
        RegExp(r'[َُِّْٰٖٕٗٓۖۗۘۙۚۛۜ۝۞ًٌٍ۟۠ۡۢ]'),
        '',
      );
      return cleanWord.contains(queryLower);
    });

    if (matchIndex == -1) {
      return words.take(21).join(' ') + (words.length > 21 ? '...' : '');
    }

    final start = (matchIndex - 10).clamp(0, words.length);
    final end = (matchIndex + 11).clamp(0, words.length);

    return '${start > 0 ? '...' : ''}${words.sublist(start, end).join(' ')}${end < words.length ? '...' : ''}';
  }

  void searchBookNames(String query) {
    state.searchQuery.value = query;
    log('Searching book names with query: $query', name: 'BooksController');
  }

  // ============ Filtering ============

  List<Book> getFilteredBooks(
    List<Book> booksList, {
    bool isDownloadedBooks = false,
    bool isHadithsBooks = false,
    bool isTafsirBooks = false,
    String title = '',
  }) {
    var filtered = _filterByCategory(
      booksList,
      isDownloadedBooks: isDownloadedBooks,
      isHadithsBooks: isHadithsBooks,
      isTafsirBooks: isTafsirBooks,
      title: title,
    );

    filtered = _filterBySearchQuery(filtered);

    if (isHadithsBooks) {
      filtered = _sortHadithBooks(filtered);
    }

    return filtered;
  }

  List<Book> _filterByCategory(
    List<Book> books, {
    required bool isDownloadedBooks,
    required bool isHadithsBooks,
    required bool isTafsirBooks,
    required String title,
  }) {
    if (isDownloadedBooks) {
      return books
          .where((b) => state.downloaded[b.bookNumber] == true)
          .toList();
    }
    if (isHadithsBooks || isTafsirBooks) {
      return books.where((b) => b.bookType == title).toList();
    }
    return books;
  }

  List<Book> _filterBySearchQuery(List<Book> books) {
    if (state.searchQuery.value.isEmpty) return books;

    final query = state.searchQuery.value.toLowerCase();
    return books.where((b) {
      return b.bookName.toLowerCase().contains(query) ||
          b.bookFullName.toLowerCase().contains(query) ||
          b.author.toLowerCase().contains(query);
    }).toList();
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
