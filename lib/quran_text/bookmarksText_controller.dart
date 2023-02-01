import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../bookmarks_notes_db/databaseHelper.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/widgets.dart';
import 'model/bookmark_text.dart';


class BookmarksTextController extends GetxController {
  final RxList<BookmarksText> BookmarkList = <BookmarksText>[].obs;

  Future<int?> addBookmarksText(BookmarksText? bookmarksText) {
    return DatabaseHelper.addBookmarkText(bookmarksText!);
  }

  Future<void> getBookmarksText() async{
    final List<Map<String, dynamic>> bookmarksText = await DatabaseHelper.queryT();
    BookmarkList.assignAll(bookmarksText.map((data) => BookmarksText.fromJson(data)).toList());
  }

  void deleteBookmarksText(BookmarksText? bookmarksText, BuildContext context) async{
    await DatabaseHelper.deleteBookmarkText(bookmarksText!).then((value) =>
        customSnackBar(context, AppLocalizations.of(context)!.deletedBookmark));
    getBookmarksText();
  }

  void updateBookmarksText(BookmarksText? bookmarksText) async{
    await DatabaseHelper.updateBookmarksText(bookmarksText!);
    getBookmarksText();
  }
}