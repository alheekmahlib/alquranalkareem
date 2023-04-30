import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../bookmarks_notes_db/databaseHelper.dart';
import '../../../shared/widgets/widgets.dart';
import '../model/bookmark.dart';
import 'package:collection/collection.dart' as collection;


class BookmarksController extends GetxController {
  final RxList<Bookmarks> bookmarksList = <Bookmarks>[].obs;

  // Future<int?> addBookmarks(Bookmarks? bookmarks) {
  //   return DatabaseHelper.addBookmark(bookmarks!);
  // }

  Future<int?> addBookmarks(int pageNum, String sorahName, String lastRead) async {
    // Check if there's a bookmark for the current page
    Bookmarks? existingBookmark = bookmarksList.firstWhereOrNull(
            (bookmark) => bookmark.pageNum == pageNum);

    if (existingBookmark == null) {
      // If there's no bookmark for the current page, add a new one
      Bookmarks newBookmark = Bookmarks(
          pageNum: pageNum, sorahName: sorahName, lastRead: lastRead);

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
    return bookmarksList.any((bookmark) => bookmark.pageNum == pageNum);
  }


  Future<void> getBookmarks() async {
    final List<Map<String, dynamic>> bookmarks = await DatabaseHelper.queryB();
    bookmarksList
        .assignAll(bookmarks.map((data) => Bookmarks.fromJson(data)).toList());
  }

  Future<bool> deleteBookmarkByPageNum(int pageNum, BuildContext context) async {
    // Find the bookmark with the given pageNum
    Bookmarks? bookmarkToDelete = bookmarksList.firstWhereOrNull(
            (bookmark) => bookmark.pageNum == pageNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmark(bookmarkToDelete);
      if (result > 0) {
        customSnackBar(context, AppLocalizations.of(context)!.deletedBookmark);
        await getBookmarks();
        return true;
      }
    } else {
      print('Bookmark not found for pageNum: $pageNum');
    }
    return false;
  }

  Future<bool> deleteBookmarks(int pageNum, BuildContext context) async {
    // Find the bookmark with the given pageNum
    Bookmarks? bookmarkToDelete = bookmarksList.firstWhereOrNull(
            (bookmark) => bookmark.pageNum == pageNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmark(bookmarkToDelete);
      if (result > 0) {
        customSnackBar(context, AppLocalizations.of(context)!.deletedBookmark);
        await getBookmarks();
        return true;
      }
    }
    return false;
  }

  BookmarksController() {
    getBookmarks();
  }

  void updateBookmarks(Bookmarks? bookmarks) async {
    await DatabaseHelper.updateBookmarks(bookmarks!);
    getBookmarks();
  }
}
