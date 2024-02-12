import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../../core/widgets/widgets.dart';
import '../../database/databaseHelper.dart';
import '../screens/quran_text/data/models/bookmark_text.dart';
import '/presentation/controllers/quranText_controller.dart';

class BookmarksTextController extends GetxController {
  final RxList<BookmarksText> BookmarkTextList = <BookmarksText>[].obs;

  Future<int?> addBookmarksText(BookmarksText? bookmarksText) {
    BookmarkTextList.add(bookmarksText!);
    sl<QuranTextController>().update();
    return DatabaseHelper.addBookmarkText(bookmarksText!);
  }

  Future<void> getBookmarksText() async {
    final List<Map<String, dynamic>> bookmarksText =
        await DatabaseHelper.queryT();
    BookmarkTextList.assignAll(
        bookmarksText.map((data) => BookmarksText.fromJson(data)).toList());
  }

  Future<bool> deleteBookmarksText(int ayahNum) async {
    // Find the bookmark with the given pageNum
    BookmarksText? bookmarkToDelete = BookmarkTextList.firstWhereOrNull(
        (bookmark) => bookmark.ayahNum == ayahNum);

    if (bookmarkToDelete != null) {
      int result = await DatabaseHelper.deleteBookmarkText(bookmarkToDelete);
      sl<QuranTextController>().update();
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
}
