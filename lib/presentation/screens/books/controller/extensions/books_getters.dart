import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../books_controller.dart';

extension BooksGetters on BooksController {
  /// -------- [Getter] ----------

  PageController get pageController {
    return state.bookPageController = PageController(
        initialPage: state.currentPageNumber.value, keepPage: true);
  }

  bool isBookDownloaded(int bookNumber) =>
      state.downloaded[bookNumber] == true ? true : false;

  RxBool collapsedHeight(int bookNumber) =>
      BooksController.instance.getParts(bookNumber).length < 4
          ? true.obs
          : false.obs;
}
