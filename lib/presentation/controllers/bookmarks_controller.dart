import '../../core/utils/constants/extensions/custom_error_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../../database/databaseHelper.dart';
import '../screens/quran_page/data/model/bookmark.dart';
import '../screens/quran_page/data/model/bookmark_ayahs.dart';
import 'general_controller.dart';
import 'quran_controller.dart';

class BookmarksController extends GetxController {
  final RxList<Bookmarks> bookmarksList = <Bookmarks>[].obs;
  final RxList<BookmarksAyahs> bookmarkTextList = <BookmarksAyahs>[].obs;
  late int lastBook;
  final quranCtrl = sl<QuranController>();
  final generalCtrl = sl<GeneralController>();

  @override
  void onInit() {
    getBookmarks();
    getBookmarksText();
    super.onInit();
  }

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
        context.showCustomErrorSnackBar('deletedBookmark'.tr);
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

  Future<int?> addBookmarksText(BookmarksAyahs? bookmarksText) {
    bookmarkTextList.add(bookmarksText!);
    return DatabaseHelper.addBookmarkText(bookmarksText);
  }

  Future<void> getBookmarksText() async {
    final List<Map<String, dynamic>> bookmarksText =
        await DatabaseHelper.queryT();
    bookmarkTextList.assignAll(
        bookmarksText.map((data) => BookmarksAyahs.fromJson(data)).toList());
  }

  bool deleteBookmarksText(int ayahUQNum) {
    // Find the bookmark with the given pageNum
    BookmarksAyahs? bookmarkToDelete = bookmarkTextList
        .firstWhereOrNull((bookmark) => bookmark.ayahUQNumber == ayahUQNum);

    if (bookmarkToDelete != null) {
      DatabaseHelper.deleteBookmarkText(bookmarkToDelete).then((value) {
        int result = value;
        if (result > 0) {
          Get.context!.showCustomErrorSnackBar('deletedBookmark'.tr);
          getBookmarksText();
          sl<QuranController>().update();
          return true;
        }
      });
    }
    return false;
    // await DatabaseHelper.deleteBookmarkText(bookmarksText!).then((value) =>
    //     context.showCustomErrorSnackBar(
    //         context, AppLocalizations.of(context)!.deletedBookmark));
    // getBookmarksText();
  }

  void updateBookmarksText(BookmarksAyahs? bookmarksText) async {
    await DatabaseHelper.updateBookmarksText(bookmarksText!);
    getBookmarksText();
  }

  RxBool hasBookmark(int surahNum, int ayahNum) {
    return (bookmarkTextList.obs.value
                    .firstWhereOrNull(((element) =>
                        element.surahNumber == surahNum &&
                        element.ayahUQNumber == ayahNum))
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
        BookmarksAyahs(
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

  void addPageBookmarkOnTap(BuildContext context, int index) {
    if (isPageBookmarked(index + 1)) {
      deleteBookmarks(index + 1, context);
    } else {
      addAyahBookmark(index + 1, quranCtrl.getSurahNameFromPage(index),
              generalCtrl.timeNow.dateNow)
          .then((value) => context.showCustomErrorSnackBar('addBookmark'.tr));
    }
  }
}
