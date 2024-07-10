import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/books/data/models/books_model.dart';
import '../screens/books/data/models/chapter_model.dart';
import '../screens/books/data/models/page_model.dart';
import '../screens/books/data/models/part_model.dart';
import '../screens/books/screens/read_view_screen.dart';
import '../screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';

class BooksController extends GetxController {
  static BooksController get instance => Get.isRegistered<BooksController>()
      ? Get.find<BooksController>()
      : Get.put(BooksController());

  /// -------- [Variables] ----------
  final box = GetStorage();
  var booksList = <Book>[].obs;
  var isLoading = true.obs;
  var downloading = <int, bool>{}.obs;
  var downloaded = <int, bool>{}.obs;
  var downloadProgress = <int, double>{}.obs;
  var searchResults = <PageContent>[].obs;
  RxBool isDownloaded = false.obs;
  final TextEditingController searchController = TextEditingController();
  PageController quranPageController = PageController();
  RxInt currentPageNumber = 0.obs;
  var lastReadPage = <int, int>{}.obs;
  Map<int, int> bookTotalPages = {};
  RxBool isTashkil = true.obs;

  /// -------- [Getter] ----------

  PageController get pageController {
    return quranPageController =
        PageController(initialPage: currentPageNumber.value, keepPage: true);
  }

  bool isBookDownloaded(int bookNumber) =>
      downloaded[bookNumber] == true ? true : false;

  @override
  void onInit() {
    super.onInit();
    fetchBooks().then((_) {
      _loadLastRead();
    });
    _loadFromGetStorage();
  }

  /// -------- [Methods] ----------

  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      String jsonString =
          await rootBundle.loadString('assets/json/collections.json');
      var booksJson = json.decode(jsonString) as List;
      booksList.value = booksJson.map((book) => Book.fromJson(book)).toList();
      log('Books loaded: ${booksList.length}');
      _loadDownloadedBooks();
    } catch (e) {
      log('Error fetching books: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> downloadBook(int bookNumber) async {
    try {
      downloading[bookNumber] = true;
      downloadProgress[bookNumber] = 0.0;
      var response = await Dio().get(
        'https://raw.githubusercontent.com/alheekmahlib/Tafsir_books/main/$bookNumber.json',
        options: Options(responseType: ResponseType.stream),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress[bookNumber] = (received / total);
          }
        },
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');

      var data = <int>[];
      await for (var value in response.data.stream) {
        data.addAll(value);
      }
      await file.writeAsBytes(data);
      downloaded[bookNumber] = true;
      _saveDownloadedBooks();
    } catch (e) {
      log('Error downloading book: $e');
    } finally {
      downloading[bookNumber] = false;
    }
  }

  List<Part> getParts(int bookNumber) {
    return booksList.firstWhere((book) => book.bookNumber == bookNumber).parts;
  }

  List<Chapter> getChapters(int bookNumber) {
    var book = booksList.firstWhere(
      (book) => book.bookNumber == bookNumber,
      orElse: () => Book.empty(),
    );
    return book.parts.expand((part) => part.chapters).toList();
  }

  Future<int> getChapterStartPage(int bookNumber, String chapterName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        var bookJson = json.decode(jsonString);
        var parts = bookJson['parts'] as List<dynamic>;

        for (var part in parts) {
          var pages = part['pages'] as List<dynamic>?;

          if (pages != null) {
            for (var page in pages) {
              var pageContent = PageContent.fromJson(
                  page as Map<String, dynamic>, bookJson['title']);
              if (pageContent.title == chapterName) {
                log('Chapter found: ${pageContent.title}, Page: ${pageContent.pageNumber}');
                return pageContent.pageNumber - 1;
              }
            }
          }
        }
      }
      return 0;
    } catch (e) {
      log('Error in getChapterStartPage: $e');
      return 0;
    }
  }

  Future<List<PageContent>> getPages(int bookNumber) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        var bookJson = json.decode(jsonString);
        var parts = bookJson['parts'] as List<dynamic>;
        var pages =
            parts.expand((part) => part['pages'] as List<dynamic>).toList();
        return pages
            .map((page) => PageContent.fromJson(
                page as Map<String, dynamic>, bookJson['title']))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      log('Error in getPages: $e');
      return [];
    }
  }

  void searchBooks(String query, {int? bookNumber}) async {
    searchResults.clear();
    if (query.isEmpty) {
      return;
    }

    log('Starting search for: $query');

    String queryWithoutDiacritics = query.removeDiacritics(query);
    List<String> queryWords = queryWithoutDiacritics.split(' ');

    // إذا كان bookNumber موجودًا، ابحث في هذا الكتاب فقط، وإلا ابحث في جميع الكتب
    List<Book> booksToSearch;
    if (bookNumber != null) {
      booksToSearch =
          booksList.where((book) => book.bookNumber == bookNumber).toList();
    } else {
      booksToSearch = booksList;
    }

    for (var book in booksToSearch) {
      final pages = await getPages(book.bookNumber);
      for (var page in pages) {
        String contentWithoutDiacritics =
            page.content.removeDiacritics(page.content);
        String titleWithoutDiacritics = page.title.removeDiacritics(page.title);

        if (queryWords.every((word) =>
            contentWithoutDiacritics.contains(word) ||
            titleWithoutDiacritics.contains(word))) {
          log('Match found in book ${book.bookName}, page title: ${page.title}');

          List<String> words = contentWithoutDiacritics.split(' ');
          int queryIndex =
              words.indexWhere((word) => word.contains(queryWords[0]));

          if (queryIndex != -1) {
            int start = (queryIndex - 5).clamp(0, words.length);
            int end = (queryIndex + 5).clamp(0, words.length);

            List<String> snippet = words.sublist(start, end);
            String snippetText = snippet.join(' ');

            PageContent snippetPage = PageContent(
              title: page.title,
              pageNumber: page.pageNumber,
              content: snippetText,
              footnotes: page.footnotes,
              bookTitle: page.bookTitle,
              bookNumber: book.bookNumber, // تأكد من إضافة رقم الكتاب هنا
            );

            searchResults.add(snippetPage);
          }
        }
      }
    }

    log('Search completed. Total matches: ${searchResults.length}');
  }

  void _saveDownloadedBooks() {
    List<String> downloadedBooks = downloaded.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toString())
        .toList();
    log('Saving downloaded books: $downloadedBooks');
    box.write(DOWNLOADED_BOOKS, downloadedBooks);
  }

  Future<void> _loadDownloadedBooks() async {
    try {
      List<dynamic>? downloadedBooks = box.read(DOWNLOADED_BOOKS);
      log('Loaded downloaded books: $downloadedBooks');
      if (downloadedBooks != null) {
        downloadedBooks.forEach((bookNumber) {
          if (bookNumber is String) {
            downloaded[int.parse(bookNumber)] = true;
          } else {
            log('Invalid book number format: $bookNumber');
          }
        });
      } else {
        log('No downloaded books found or data is in incorrect format.');
      }
    } catch (e) {
      log('Error loading downloaded books: $e');
    }
  }

  Future<void> deleteBook(int bookNumber) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');
      if (await file.exists()) {
        await file.delete();
        downloaded[bookNumber] = false;
        _saveDownloadedBooks();
        log('Book $bookNumber deleted successfully.');

        // حذف آخر قراءة خاصة بالكتاب
        box.remove('lastRead_$bookNumber');
        lastReadPage.remove(bookNumber);
        bookTotalPages.remove(bookNumber);
        log('Last read data for book $bookNumber deleted successfully.');
      }
    } catch (e) {
      log('Error deleting book: $e');
    }
  }

  /// -------- [Save & Load From GetStorage] --------
  void saveLastRead(
      int pageNumber, String bookName, int bookNumber, int totalPages) {
    lastReadPage[bookNumber] = pageNumber;
    bookTotalPages[bookNumber] = totalPages;
    box.write('lastRead_$bookNumber', {
      'pageNumber': pageNumber,
      'bookName': bookName,
      'totalPages': totalPages,
    });
  }

  void _loadLastRead() {
    if (booksList.isNotEmpty) {
      booksList.forEach((book) {
        var lastRead = box.read('lastRead_${book.bookNumber}');
        if (lastRead != null) {
          lastReadPage[book.bookNumber] = lastRead['pageNumber'];
          log('lastReadPage[book.bookNumber]: ${lastReadPage[book.bookNumber]}');
          bookTotalPages[book.bookNumber] = lastRead['totalPages'];
          log('bookTotalPages[book.bookNumber]: ${bookTotalPages[book.bookNumber]}');
        }
      });
    } else {
      log('booksList is empty.');
    }
  }

  void _loadFromGetStorage() {
    isTashkil.value = box.read(IS_TASHKIL) ?? true;
  }

  /// -------- [onTap] --------
  Future<void> moveToBookPage(String chapterName, int bookNumber) async {
    if (isBookDownloaded(bookNumber)) {
      int initialPage = await getChapterStartPage(bookNumber, chapterName);
      currentPageNumber.value = initialPage;
      log('Initial page for chapter $chapterName: $initialPage');
      Get.to(() => PagesPage(bookNumber: bookNumber));
    } else {
      Get.context!.showCustomErrorSnackBar('downloadBookFirst'.tr);
    }
  }

  Future<void> moveToPage(String chapterName, int bookNumber) async {
    if (isBookDownloaded(bookNumber)) {
      int initialPage = await getChapterStartPage(bookNumber, chapterName);
      currentPageNumber.value = initialPage;
      log('Initial page for chapter $chapterName: $initialPage');
      quranPageController.animateToPage(initialPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Get.context!.showCustomErrorSnackBar('downloadBookFirst'.tr);
    }
  }

  void isTashkilOnTap() {
    isTashkil.value = !isTashkil.value;
    box.write(IS_TASHKIL, isTashkil.value);
  }
}
