import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../bookmarks_notes_db/databaseHelper.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/widgets.dart';
import 'model/bookmark_text_ayah.dart';


class BookmarksTextAyahController extends GetxController {
  final RxList<BookmarksTextAyah> BookmarkAyahList = <BookmarksTextAyah>[].obs;

  Future<int?> addBookmarksTextAyah(BookmarksTextAyah? bookmarksTextAyah) {
    return DatabaseHelper.addBookmarkAyahText(bookmarksTextAyah!);
  }

  Future<void> getBookmarksTextAyah() async{
    final List<Map<String, dynamic>> bookmarksTextAyah = await DatabaseHelper.queryA();
    BookmarkAyahList.assignAll(bookmarksTextAyah.map((data) => BookmarksTextAyah.fromJson(data)).toList());
  }

  void deleteBookmarksTextAyah(BookmarksTextAyah? bookmarksTextAyah, BuildContext context) async{
    await DatabaseHelper.deleteBookmarkAyahText(bookmarksTextAyah!).then((value) =>
        customSnackBar(context, AppLocalizations.of(context)!.deletedBookmark));
    getBookmarksTextAyah();
  }

  void updateBookmarksTextAyah(BookmarksTextAyah? bookmarksTextAyah) async{
    await DatabaseHelper.updateBookmarksAyahText(bookmarksTextAyah!);
    getBookmarksTextAyah();
  }
}