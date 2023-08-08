import 'package:alquranalkareem/quran_page/data/repository/sorah_bookmark_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/databaseHelper.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../model/bookmark.dart';
import '../model/sorah_bookmark.dart';

class BookmarksController extends GetxController {
  final RxList<Bookmarks> bookmarksList = <Bookmarks>[].obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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
    final List<Map<String, dynamic>> bookmarks = await DatabaseHelper.queryB();
    bookmarksList
        .assignAll(bookmarks.map((data) => Bookmarks.fromJson(data)).toList());
  }

  Future<bool> deleteBookmarkByPageNum(
      int pageNum, BuildContext context) async {
    // Find the bookmark with the given pageNum
    Bookmarks? bookmarkToDelete = bookmarksList
        .firstWhereOrNull((bookmark) => bookmark.pageNum == pageNum);

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
    Bookmarks? bookmarkToDelete = bookmarksList
        .firstWhereOrNull((bookmark) => bookmark.pageNum == pageNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmark(bookmarkToDelete);
      if (result > 0) {
        customSnackBar(context, AppLocalizations.of(context)!.deletedBookmark);
        await getBookmarks();
        update();
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

  int? id;
  addBookmark(int pageNum, String sorahName, String lastRead) async {
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

  /// Bookmarks
  SorahBookmarkRepository sorahBookmarkRepository = SorahBookmarkRepository();
  List<SoraBookmark>? soraBookmarkList;

  getBookmarksList() async {
    await sorahBookmarkRepository.all().then((values) {
      soraBookmarkList = values;
    });
  }

  // Save & Load Last Bookmark
  savelastBookmark(int Value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("last_bookmark", Value);
    update();
  }

  Future<int> loadlastBookmark() async {
    SharedPreferences prefs = await _prefs;
    lastBook = prefs.getInt('last_bookmark') ?? 0;
    print('get last_bookmark ${prefs.getInt('last_bookmark')}');
    print('get radioValue $lastBook');
    // emit(SharedPreferencesState());
    return lastBook;
  }
}
