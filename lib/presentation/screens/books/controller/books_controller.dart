import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '/presentation/screens/books/controller/extensions/books_storage_getters.dart';
import '../../quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '../data/models/books_model.dart';
import '../data/models/chapter_model.dart';
import '../data/models/page_model.dart';
import '../data/models/part_model.dart';
import 'books_state.dart';

class BooksController extends GetxController {
  static BooksController get instance => Get.isRegistered<BooksController>()
      ? Get.find<BooksController>()
      : Get.put(BooksController());

  BooksState state = BooksState();

  @override
  void onInit() {
    super.onInit();
    fetchBooks().then((_) {
      loadLastRead();
    });
    loadFromGetStorage();
  }

  /// -------- [Methods] ----------

  Future<void> fetchBooks() async {
    try {
      state.isLoading(true);
      String jsonString =
          await rootBundle.loadString('assets/json/collections.json');
      var booksJson = json.decode(jsonString) as List;
      state.booksList.value =
          booksJson.map((book) => Book.fromJson(book)).toList();
      log('Books loaded: ${state.booksList.length}');
      loadDownloadedBooks();
    } catch (e) {
      log('Error fetching books: $e');
    } finally {
      state.isLoading(false);
    }
  }

  Future<void> downloadBook(int bookNumber) async {
    try {
      state.downloading[bookNumber] = true;
      state.downloadProgress[bookNumber] = 0.0;
      var response = await Dio().get(
        'https://raw.githubusercontent.com/alheekmahlib/Tafsir_books/main/$bookNumber.json',
        options: Options(responseType: ResponseType.stream),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            state.downloadProgress[bookNumber] = (received / total);
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
      state.downloaded[bookNumber] = true;
      saveDownloadedBooks();
    } catch (e) {
      log('Error downloading book: $e');
    } finally {
      state.downloading[bookNumber] = false;
    }
  }

  List<Part> getParts(int bookNumber) {
    return state.booksList
        .firstWhere((book) => book.bookNumber == bookNumber)
        .parts;
  }

  List<Chapter> getChapters(int bookNumber) {
    var book = state.booksList.firstWhere(
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
    state.searchResults.clear();
    if (query.isEmpty) {
      return;
    }

    log('Starting search for: $query');

    String queryWithoutDiacritics = query.removeDiacritics(query);
    List<String> queryWords = queryWithoutDiacritics.split(' ');

    // إذا كان bookNumber موجودًا، ابحث في هذا الكتاب فقط، وإلا ابحث في جميع الكتب
    List<Book> booksToSearch;
    if (bookNumber != null) {
      booksToSearch = state.booksList
          .where((book) => book.bookNumber == bookNumber)
          .toList();
    } else {
      booksToSearch = state.booksList;
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

            state.searchResults.add(snippetPage);
          }
        }
      }
    }

    log('Search completed. Total matches: ${state.searchResults.length}');
  }
}
