import 'package:flutter/material.dart';

import '../books_controller.dart';

extension BooksGetters on BooksController {
  /// -------- [Getter] ----------

  PageController get pageController {
    return state.quranPageController = PageController(
        initialPage: state.currentPageNumber.value, keepPage: true);
  }

  bool isBookDownloaded(int bookNumber) =>
      state.downloaded[bookNumber] == true ? true : false;
}
