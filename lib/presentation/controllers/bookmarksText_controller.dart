import 'package:alquranalkareem/presentation/controllers/quranText_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/services/l10n/app_localizations.dart';
import '../../core/services/services_locator.dart';
import '../../core/widgets/widgets.dart';
import '../../database/databaseHelper.dart';
import '../screens/quran_text/data/models/bookmark_text.dart';

class BookmarksTextController extends GetxController {
  final RxList<BookmarksText> BookmarkList = <BookmarksText>[].obs;

  Future<int?> addBookmarksText(BookmarksText? bookmarksText) {
    BookmarkList.add(bookmarksText!);
    sl<QuranTextController>().update();
    return DatabaseHelper.addBookmarkText(bookmarksText!);
  }

  Future<void> getBookmarksText() async {
    final List<Map<String, dynamic>> bookmarksText =
        await DatabaseHelper.queryT();
    BookmarkList.assignAll(
        bookmarksText.map((data) => BookmarksText.fromJson(data)).toList());
  }

  Future<bool> deleteBookmarksText(int ayahNum, BuildContext context) async {
    // Find the bookmark with the given pageNum
    BookmarksText? bookmarkToDelete = BookmarkList.firstWhereOrNull(
        (bookmark) => bookmark.ayahNum == ayahNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmarkText(bookmarkToDelete);
      sl<QuranTextController>().update();
      if (result > 0) {
        customSnackBar(context, AppLocalizations.of(context)!.deletedBookmark);
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
    return (BookmarkList.obs.value
                    .firstWhereOrNull(((element) =>
                        element.sorahNum == surahNum &&
                        element.ayahNum == ayahNum))
                    .obs)
                .value ==
            null
        ? false.obs
        : true.obs;
  }
}
