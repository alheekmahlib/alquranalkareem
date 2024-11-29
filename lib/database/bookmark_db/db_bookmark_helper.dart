import 'package:drift/drift.dart' as drift;

import 'bookmark_database.dart';

class DbBookmarkHelper {
  /// -------[AdhkarBookmark]--------

  static Future<int?> addAdhkar(AdhkarCompanion adhkar) async {
    print('Save Adhkar Bookmarks');
    final db = BookmarkDatabase(); // قم بتهيئة قاعدة البيانات
    try {
      return await db.into(db.adhkar).insert(adhkar);
    } catch (e) {
      print('Error adding Adhkar bookmark: $e');
      return 90000;
    }
  }

  /// -------[BookmarkPage]--------
  static Future<int?> addBookmark(BookmarksCompanion bookmark) async {
    print('Save Text Bookmarks');
    final db = BookmarkDatabase(); // قم بتهيئة قاعدة البيانات
    try {
      return await db.into(db.bookmarks).insert(bookmark);
    } catch (e) {
      print('Error adding bookmark: $e');
      return 90000;
    }
  }

  /// -------[BookmarkAyah]--------

  static Future<int?> addBookmarkText(
      BookmarksAyahsCompanion bookmarkText) async {
    print('Save Text Bookmarks');
    final db = BookmarkDatabase(); // قم بتهيئة قاعدة البيانات
    try {
      return await db.into(db.bookmarksAyahs).insert(bookmarkText);
    } catch (e) {
      print('Error adding bookmark: $e');
      return 90000;
    }
  }

  static Future<int> deleteAdhkar(String category, String zekr) async {
    print('Delete Azkar');
    final db = BookmarkDatabase();
    return await (db.delete(db.adhkar)
          ..where((t) => t.zekr.equals(zekr) & t.category.equals(category)))
        .go();
  }

  static Future<int> deleteBookmark(Bookmark bookmark) async {
    print('Delete Text Bookmarks');
    final db = BookmarkDatabase();

    try {
      return await (db.delete(db.bookmarks)
            ..where((t) => t.id.equals(bookmark.id)))
          .go();
    } catch (e) {
      print('Error deleting bookmark: $e');
      return 0;
    }
  }

  static Future<int> deleteBookmarkText(BookmarksAyah bookmarkText) async {
    print('Delete Text Bookmarks');
    final db = BookmarkDatabase();

    try {
      return await (db.delete(db.bookmarksAyahs)
            ..where((t) => t.id.equals(bookmarkText.id)))
          .go();
    } catch (e) {
      print('Error deleting bookmark: $e');
      return 0;
    }
  }

  static Future<List<AdhkarData>> getAllAdhkar() async {
    final db = BookmarkDatabase();
    return await db
        .select(db.adhkar)
        .get(); // استرجاع الأذكار من قاعدة البيانات
  }

  static Future<List<Bookmark>> queryB() async {
    final db = BookmarkDatabase();

    // استرجاع العلامات المرجعية من قاعدة البيانات
    return await db.getBookmarks();
  }

  static Future<List<AdhkarData>> queryC() async {
    print('Get Azkar');
    final db = BookmarkDatabase();
    return await db.select(db.adhkar).get();
  }

  static Future<List<BookmarksAyah>> queryT() async {
    print('Get Text Bookmarks');
    final db = BookmarkDatabase();
    return await db.getAllBookmarkAyahs();
  }

  static Future<int> updateAdhkar(AdhkarCompanion adhkar, int id) async {
    print('Update Azkar');
    final db = BookmarkDatabase();
    return await (db.update(db.adhkar)..where((t) => t.id.equals(id)))
        .write(adhkar);
  }

  static Future<int> updateBookmarks(Bookmark bookmark) async {
    final db = BookmarkDatabase();

    // استخدام BookmarksCompanion للتحديث
    return await db.updateBookmark(
      BookmarksCompanion(
        sorahName: drift.Value(bookmark.sorahName), // تمرير القيم الصحيحة
        pageNum: drift.Value(bookmark.pageNum), // تمرير القيم الصحيحة
        lastRead: drift.Value(bookmark.lastRead), // تمرير القيم الصحيحة
      ),
      bookmark.id, // تمرير معرف العلامة المرجعية (ID)
    );
  }

  static Future<int> updateBookmarksText(BookmarksAyah bookmarkText) async {
    print('Update Text Bookmarks');
    final db = BookmarkDatabase();
    return await db.updateBookmarkAyah(
      BookmarksAyahsCompanion(
        surahName: drift.Value(bookmarkText.surahName),
        surahNumber: drift.Value(bookmarkText.surahNumber),
        pageNumber: drift.Value(bookmarkText.pageNumber),
        ayahNumber: drift.Value(bookmarkText.ayahNumber),
        ayahUQNumber: drift.Value(bookmarkText.ayahUQNumber),
        lastRead: drift.Value(bookmarkText.lastRead),
      ),
      bookmarkText.id,
    );
  }
}
