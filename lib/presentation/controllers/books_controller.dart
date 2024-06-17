import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/books/data/models/books_model.dart';
import '../screens/books/data/models/chapter_model.dart';
import '../screens/books/data/models/page_model.dart';

class BooksController extends GetxController {
  static BooksController get instance => Get.isRegistered<BooksController>()
      ? Get.find<BooksController>()
      : Get.put<BooksController>(BooksController());

  var booksList = <Book>[].obs;
  var isLoading = true.obs;
  var downloading = <int, bool>{}.obs;
  var downloaded = <int, bool>{}.obs;
  var downloadProgress = <int, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      isLoading(true);
      String jsonString =
          await rootBundle.loadString('assets/json/collections.json');
      var booksJson = json.decode(jsonString) as List;
      booksList.value = booksJson.map((book) => Book.fromJson(book)).toList();
      await _loadDownloadedBooks();
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
      await _saveDownloadedBooks();
    } catch (e) {
      print(e);
    } finally {
      downloading[bookNumber] = false;
    }
  }

  Future<void> _saveDownloadedBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedBooks = downloaded.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toString())
        .toList();
    await prefs.setStringList('downloadedBooks', downloadedBooks);
  }

  Future<void> _loadDownloadedBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? downloadedBooks = prefs.getStringList('downloadedBooks');
    if (downloadedBooks != null) {
      for (var bookNumber in downloadedBooks) {
        downloaded[int.parse(bookNumber)] = true;
      }
    }
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
              var pageContent = PageContent.fromJson(page);
              if (pageContent.title == chapterName) {
                return pageContent.pageNumber - 1;
              }
            }
          }
        }
      }
      return 0; // إذا لم يتم العثور على الفصل
    } catch (e) {
      log('Error in getChapterStartPage: $e');
      return 0; // في حالة حدوث خطأ
    }
  }

  Future<List<PageContent>> getPages(int bookNumber) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$bookNumber.json');
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      var bookJson = json.decode(jsonString);
      var parts = bookJson['parts'] as List<dynamic>;
      var pages =
          parts.expand((part) => part['pages'] as List<dynamic>).toList();
      return pages.map((page) => PageContent.fromJson(page)).toList();
    } else {
      return [];
    }
  }
}
