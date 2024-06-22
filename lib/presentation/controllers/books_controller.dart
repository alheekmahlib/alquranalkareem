import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/books/data/models/books_model.dart';
import '../screens/books/data/models/chapter_model.dart';
import '../screens/books/data/models/page_model.dart';
import '../screens/books/data/models/part_model.dart';

class BooksController extends GetxController {
  static BooksController get instance => Get.isRegistered<BooksController>()
      ? Get.find<BooksController>()
      : Get.put(BooksController());

  final box = GetStorage();

  var booksList = <Book>[].obs;
  var isLoading = true.obs;
  var downloading = <int, bool>{}.obs;
  var downloaded = <int, bool>{}.obs;
  var downloadProgress = <int, double>{}.obs;
  var searchResults = <PageContent>[].obs;
  final TextEditingController searchController = TextEditingController();

  /// Books getters----------
  int get currentPage => box.read(PAGE_NUMBER) ?? 0;
  String get bookName => '${box.read(BOOK_NAME) ?? ''}'.replaceAll('=', '');
  int get bookNumber => box.read(BOOK_NUMBER) ?? 0;
  double get pageProgress => (box.read(PAGE_NUMBER) / box.read(TOTAL_PAGES));

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      String jsonString =
          await rootBundle.loadString('assets/json/collections.json');
      var booksJson = json.decode(jsonString) as List;
      booksList.value = booksJson.map((book) => Book.fromJson(book)).toList();
      _loadDownloadedBooks();
    } catch (e) {
      print(e);
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
      print(e);
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

  void searchBooks(String query) async {
    searchResults.clear();
    if (query.isEmpty) {
      return;
    }

    log('Starting search for: $query');

    for (var book in booksList) {
      final pages = await getPages(book.bookNumber);
      for (var page in pages) {
        var pageContent = PageContent.fromJson(
            page as Map<String, dynamic>, book.bookName); // تمرير اسم الكتاب
        if (pageContent.content.contains(query) ||
            pageContent.title.contains(query)) {
          log('Match found in book ${book.bookName}, page title: ${pageContent.title}');
          searchResults.add(pageContent);
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
      if (downloadedBooks != null && downloadedBooks is List<dynamic>) {
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

  void saveLastRead(
          int pageNumber, String bookName, int bookNumber, int totalPages) =>
      box
        ..write(PAGE_NUMBER, pageNumber)
        ..write(BOOK_NAME, bookName)
        ..write(BOOK_NUMBER, bookNumber)
        ..write(TOTAL_PAGES, totalPages);
}
