import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

import '../screens/books/data/data_sources/books_bookmark_database.dart';

class BooksBookmarksController extends GetxController {
  static BooksBookmarksController get instance =>
      Get.isRegistered<BooksBookmarksController>()
          ? Get.find<BooksBookmarksController>()
          : Get.put(BooksBookmarksController());

  /// -------[BooksBookmarks]--------

  final db = BooksBookmarkDatabase();
  final RxList<BooksBookmarkData> bookmarks = <BooksBookmarkData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  Map<String, List<BooksBookmarkData>> groupByBookName(
      List<BooksBookmarkData> bookmarks) {
    var grouped = <String, List<BooksBookmarkData>>{};

    for (var bookmark in bookmarks) {
      var bookName = bookmark.bookName ?? 'Unknown Book';
      if (!grouped.containsKey(bookName)) {
        grouped[bookName] = [];
      }
      grouped[bookName]!.add(bookmark);
    }

    return grouped;
  }

  Future<void> fetchBookmarks() async {
    final allBookmarks = await db.getAllBookmarks();
    bookmarks.assignAll(allBookmarks);
  }

  Future<void> addBookmark(
      String bookName, int bookNumber, int currentPage) async {
    final bookmark = BooksBookmarkCompanion(
      bookName: drift.Value(bookName),
      bookNumber: drift.Value(bookNumber),
      currentPage: drift.Value(currentPage),
    );
    await db.insertBookmark(bookmark);
    fetchBookmarks();
  }

  Future<void> updateBookmark(
      int id, String bookName, int bookNumber, int currentPage) async {
    final bookmark = BooksBookmarkCompanion(
      id: drift.Value(id),
      bookName: drift.Value(bookName),
      bookNumber: drift.Value(bookNumber),
      currentPage: drift.Value(currentPage),
    );
    await db.updateBookmark(bookmark);
    fetchBookmarks();
  }

  Future<void> deleteBookmark(int id) async {
    await db.deleteBookmarkById(id);
    fetchBookmarks();
  }
}
