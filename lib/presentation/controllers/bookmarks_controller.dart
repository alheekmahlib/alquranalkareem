import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../../core/widgets/widgets.dart';
import '../../database/databaseHelper.dart';
import '../screens/quran_page/data/model/bookmark.dart';
import '../screens/quran_text/data/models/bookmark_text.dart';
import 'quranText_controller.dart';

class BookmarksController extends GetxController {
  final RxList<Bookmarks> bookmarksList = <Bookmarks>[].obs;
  final RxList<BookmarksText> BookmarkTextList = <BookmarksText>[].obs;
  late int lastBook;

  Future<int?> addBookmarks(
      int pageNum, String sorahName, String lastRead) async {
    // Check if there's a bookmark for the current page
    Bookmarks? existingBookmark = bookmarksList
        .firstWhereOrNull((bookmark) => bookmark.pageNum == pageNum);

    if (existingBookmark == null) {
      // If there's no bookmark for the current page, add a new one
      Bookmarks newBookmark =
          Bookmarks(pageNum: pageNum, sorahName: sorahName, lastRead: lastRead);

      return DatabaseHelper.addBookmark(newBookmark).then((value) {
        getBookmarks();
        return value;
      });
    } else {
      // If there's already a bookmark for the current page, return an error code
      return Future.value(-1);
    }
  }

  int findBookmarkIndex(int pageNum) {
    return bookmarksList.indexWhere((bookmark) => bookmark.pageNum == pageNum);
  }

  bool isPageBookmarked(int pageNum) {
    return bookmarksList
            .firstWhereOrNull((bookmark) => bookmark.pageNum == pageNum) !=
        null;
  }

  Future<void> getBookmarks() async {
    final List<Map<String, dynamic>>? bookmarks = await DatabaseHelper.queryB();
    if (bookmarks != null) {
      bookmarksList.assignAll(
          bookmarks.map((data) => Bookmarks.fromJson(data)).toList());
    } else {
      // Handle the case when bookmarks is null
    }
  }

  Future<bool> deleteBookmarks(int pageNum, BuildContext context) async {
    // Find the bookmark with the given pageNum
    Bookmarks? bookmarkToDelete = bookmarksList
        .firstWhereOrNull((bookmark) => bookmark.pageNum == pageNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmark(bookmarkToDelete);
      if (result > 0) {
        customErrorSnackBar('deletedBookmark'.tr);
        await getBookmarks();
        update();
        return true;
      }
    }
    return false;
  }

  void updateBookmarks(Bookmarks? bookmarks) async {
    await DatabaseHelper.updateBookmarks(bookmarks!);
    getBookmarks();
  }

  int? id;
  addAyahBookmark(int pageNum, String sorahName, String lastRead) async {
    try {
      int? bookmark = await addBookmarks(
        pageNum,
        sorahName,
        lastRead,
      );
      update();
      print('$bookmark');
    } catch (e) {
      print('Error');
    }
  }

  Future<int?> addBookmarksText(BookmarksText? bookmarksText) {
    BookmarkTextList.add(bookmarksText!);
    sl<QuranTextController>().update();
    return DatabaseHelper.addBookmarkText(bookmarksText);
  }

  Future<void> getBookmarksText() async {
    final List<Map<String, dynamic>> bookmarksText =
        await DatabaseHelper.queryT();
    BookmarkTextList.assignAll(
        bookmarksText.map((data) => BookmarksText.fromJson(data)).toList());
  }

  Future<bool> deleteBookmarksText(int ayahUQNum) async {
    // Find the bookmark with the given pageNum
    BookmarksText? bookmarkToDelete = BookmarkTextList.firstWhereOrNull(
        (bookmark) => bookmark.ayahUQNum == ayahUQNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmarkText(bookmarkToDelete);
      if (result > 0) {
        customErrorSnackBar('deletedBookmark'.tr);
        await getBookmarksText();
        update();
        return true;
      }
    }
    return false;
    // await DatabaseHelper.deleteBookmarkText(bookmarksText!).then((value) =>
    //     customErrorSnackBar(
    //         context, AppLocalizations.of(context)!.deletedBookmark));
    // getBookmarksText();
  }

  void updateBookmarksText(BookmarksText? bookmarksText) async {
    await DatabaseHelper.updateBookmarksText(bookmarksText!);
    getBookmarksText();
  }

  RxBool hasBookmark(int surahNum, int ayahNum) {
    return (BookmarkTextList.obs.value
                    .firstWhereOrNull(((element) =>
                        element.sorahNum == surahNum &&
                        element.ayahNum == ayahNum))
                    .obs)
                .value ==
            null
        ? false.obs
        : true.obs;
  }

  addBookmarkText(
    String surahName,
    int surahNum,
    pageNum,
    ayahNum,
    ayahUQNum,
    lastRead,
  ) async {
    try {
      int? bookmark = await addBookmarksText(
        BookmarksText(
          id,
          surahName,
          surahNum,
          pageNum,
          ayahNum,
          ayahUQNum,
          lastRead,
        ),
      );
      print('bookmark number: ${bookmark!}');
    } catch (e) {
      print('Error');
    }
  }
}
