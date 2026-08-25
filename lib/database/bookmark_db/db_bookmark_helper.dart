import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

import '../../core/services/sync/sync_controller.dart';
import 'bookmark_database.dart';

class DbBookmarkHelper {
  /// إشعار محرك المزامنة بعد أي كتابة محلية (يعمل فقط عند الإقران).
  static void _notifySync() {
    if (Get.isRegistered<SyncController>()) {
      Get.find<SyncController>().onLocalChange();
    }
  }

  /// -------[AdhkarBookmark]--------

  static Future<int?> addAdhkar(AdhkarCompanion adhkar) async {
    print('Save Adhkar Bookmarks');
    final db = BookmarkDatabase(); // قم بتهيئة قاعدة البيانات
    try {
      final result = await db.addAdhkar(adhkar);
      _notifySync();
      return result;
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
      final result = await db.addBookmark(bookmark);
      _notifySync();
      return result;
    } catch (e) {
      print('Error adding bookmark: $e');
      return 90000;
    }
  }

  /// -------[BookmarkAyah]--------

  static Future<int?> addBookmarkText(
    BookmarksAyahsCompanion bookmarkText,
  ) async {
    print('Save Text Bookmarks');
    final db = BookmarkDatabase(); // قم بتهيئة قاعدة البيانات
    try {
      final result = await db.addBookmarkAyah(bookmarkText);
      _notifySync();
      return result;
    } catch (e) {
      print('Error adding bookmark: $e');
      return 90000;
    }
  }

  /// حذف ناعم حتى ينتقل الحذف إلى بقية الأجهزة عبر المزامنة.
  static Future<int> deleteAdhkar(String category, String zekr) async {
    print('Delete Azkar');
    final db = BookmarkDatabase();
    final now = DateTime.now().millisecondsSinceEpoch;
    final result =
        await (db.update(db.adhkar)
              ..where((t) => t.zekr.equals(zekr) & t.category.equals(category)))
            .write(
              AdhkarCompanion(
                deleted: const drift.Value(true),
                updatedAt: drift.Value(now),
              ),
            );
    _notifySync();
    return result;
  }

  static Future<int> deleteBookmark(Bookmark bookmark) async {
    print('Delete Text Bookmarks');
    final db = BookmarkDatabase();

    try {
      final result = await db.deleteBookmark(bookmark.id);
      _notifySync();
      return result;
    } catch (e) {
      print('Error deleting bookmark: $e');
      return 0;
    }
  }

  static Future<int> deleteBookmarkText(BookmarksAyah bookmarkText) async {
    print('Delete Text Bookmarks');
    final db = BookmarkDatabase();

    try {
      final result = await db.deleteBookmarkAyah(bookmarkText.id);
      _notifySync();
      return result;
    } catch (e) {
      print('Error deleting bookmark: $e');
      return 0;
    }
  }

  static Future<List<AdhkarData>> getAllAdhkar() async {
    final db = BookmarkDatabase();
    return await db.getAllAdhkar(); // استرجاع الأذكار من قاعدة البيانات
  }

  static Future<List<Bookmark>> queryB() async {
    final db = BookmarkDatabase();

    // استرجاع العلامات المرجعية من قاعدة البيانات
    return await db.getBookmarks();
  }

  static Future<List<AdhkarData>> queryC() async {
    print('Get Azkar');
    final db = BookmarkDatabase();
    return await db.getAllAdhkar();
  }

  static Future<List<BookmarksAyah>> queryT() async {
    print('Get Text Bookmarks');
    final db = BookmarkDatabase();
    return await db.getAllBookmarkAyahs();
  }

  static Future<int> updateAdhkar(AdhkarCompanion adhkar, int id) async {
    print('Update Azkar');
    final db = BookmarkDatabase();
    final result = await db.updateAdhkar(adhkar, id);
    _notifySync();
    return result;
  }

  static Future<int> updateBookmarks(Bookmark bookmark) async {
    final db = BookmarkDatabase();

    // استخدام BookmarksCompanion للتحديث
    final result = await db.updateBookmark(
      BookmarksCompanion(
        sorahName: drift.Value(bookmark.sorahName), // تمرير القيم الصحيحة
        pageNum: drift.Value(bookmark.pageNum), // تمرير القيم الصحيحة
        lastRead: drift.Value(bookmark.lastRead), // تمرير القيم الصحيحة
      ),
      bookmark.id, // تمرير معرف العلامة المرجعية (ID)
    );
    _notifySync();
    return result;
  }

  static Future<int> updateBookmarksText(BookmarksAyah bookmarkText) async {
    print('Update Text Bookmarks');
    final db = BookmarkDatabase();
    final result = await db.updateBookmarkAyah(
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
    _notifySync();
    return result;
  }
}
