import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/books_model.dart';
import '../data/models/page_model.dart';

class BooksState {
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
}
