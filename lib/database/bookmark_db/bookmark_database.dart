import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../presentation/screens/adhkar/models/dheker_model.dart';
import '../../presentation/screens/quran_page/data/model/bookmark.dart';
import '../../presentation/screens/quran_page/data/model/bookmark_ayahs.dart';

part 'bookmark_database.g.dart';

@DriftDatabase(tables: [Bookmarks, BookmarksAyahs, Adhkar])
class BookmarkDatabase extends _$BookmarkDatabase {
  BookmarkDatabase._internal() : super(_openConnection());

  static final BookmarkDatabase _instance = BookmarkDatabase._internal();

  factory BookmarkDatabase() => _instance;

  @override
  int get schemaVersion => 10;

  Future<bool> _shouldRunUpgrade() async {
    bool hasUpgraded = GetStorage().read('db_upgrade_9') ?? false;

    if (!hasUpgraded) {
      await GetStorage().write('db_upgrade_9', true);
      return true;
    }
    return false;
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 9) {
        final shouldRun = await _shouldRunUpgrade();
        if (shouldRun) {
          await m.renameTable(bookmarks, 'bookmarkTable');
          await m.renameTable(adhkar, 'azkarTable');
          await m.renameTable(bookmarksAyahs, 'bookmarkTextTable');

          await m.renameColumn(bookmarks, 'sorahName', bookmarks.sorahName);
          await m.renameColumn(bookmarks, 'pageNum', bookmarks.pageNum);
          await m.renameColumn(bookmarks, 'lastRead', bookmarks.lastRead);

          await m.renameColumn(
            bookmarksAyahs,
            'sorahName',
            bookmarksAyahs.surahName,
          );
          await m.renameColumn(
            bookmarksAyahs,
            'sorahNum',
            bookmarksAyahs.surahNumber,
          );
          await m.renameColumn(
            bookmarksAyahs,
            'pageNum',
            bookmarksAyahs.pageNumber,
          );
          await m.renameColumn(
            bookmarksAyahs,
            'ayahNum',
            bookmarksAyahs.ayahNumber,
          );
          await m.renameColumn(
            bookmarksAyahs,
            'nomPageF',
            bookmarksAyahs.ayahUQNumber,
          );
          await m.renameColumn(
            bookmarksAyahs,
            'lastRead',
            bookmarksAyahs.lastRead,
          );
        }
      }
      if (from < 10) {
        // أعمدة مزامنة الأجهزة: مفتاح مستقر + طابع زمني LWW + حذف ناعم.
        await m.addColumn(bookmarks, bookmarks.syncUuid);
        await m.addColumn(bookmarks, bookmarks.updatedAt);
        await m.addColumn(bookmarks, bookmarks.deleted);
        await m.addColumn(bookmarksAyahs, bookmarksAyahs.syncUuid);
        await m.addColumn(bookmarksAyahs, bookmarksAyahs.updatedAt);
        await m.addColumn(bookmarksAyahs, bookmarksAyahs.deleted);
        await m.addColumn(adhkar, adhkar.syncUuid);
        await m.addColumn(adhkar, adhkar.updatedAt);
        await m.addColumn(adhkar, adhkar.deleted);
        // ختم الصفوف القائمة حتى تُدفع في أول مزامنة.
        final now = DateTime.now().millisecondsSinceEpoch;
        await (update(
          bookmarks,
        )).write(BookmarksCompanion(updatedAt: Value(now)));
        await (update(
          bookmarksAyahs,
        )).write(BookmarksAyahsCompanion(updatedAt: Value(now)));
        await (update(adhkar)).write(AdhkarCompanion(updatedAt: Value(now)));
      }
    },
  );

  static int _nowMs() => DateTime.now().millisecondsSinceEpoch;

  /// -------[BookmarkPage]--------
  Future<int> addBookmark(BookmarksCompanion bookmark) =>
      into(bookmarks).insert(bookmark.copyWith(updatedAt: Value(_nowMs())));

  /// حذف ناعم (tombstone) حتى تنتقل عملية الحذف إلى بقية الأجهزة.
  Future<int> deleteBookmark(int id) =>
      (update(bookmarks)..where((tbl) => tbl.id.equals(id))).write(
        BookmarksCompanion(
          deleted: const Value(true),
          updatedAt: Value(_nowMs()),
        ),
      );

  Future<int> updateBookmark(BookmarksCompanion bookmark, int id) =>
      (update(bookmarks)..where((tbl) => tbl.id.equals(id))).write(
        bookmark.copyWith(updatedAt: Value(_nowMs())),
      );

  Future<List<Bookmark>> getBookmarks() =>
      (select(bookmarks)..where((tbl) => tbl.deleted.equals(false))).get();

  /// -------[BookmarkAyah]--------
  Future<int> addBookmarkAyah(BookmarksAyahsCompanion bookmarkAyah) => into(
    bookmarksAyahs,
  ).insert(bookmarkAyah.copyWith(updatedAt: Value(_nowMs())));

  Future<int> deleteBookmarkAyah(int id) =>
      (update(bookmarksAyahs)..where((tbl) => tbl.id.equals(id))).write(
        BookmarksAyahsCompanion(
          deleted: const Value(true),
          updatedAt: Value(_nowMs()),
        ),
      );

  Future<int> updateBookmarkAyah(
    BookmarksAyahsCompanion bookmarkAyah,
    int id,
  ) => (update(bookmarksAyahs)..where((tbl) => tbl.id.equals(id))).write(
    bookmarkAyah.copyWith(updatedAt: Value(_nowMs())),
  );

  Future<List<BookmarksAyah>> getAllBookmarkAyahs() =>
      (select(bookmarksAyahs)..where((tbl) => tbl.deleted.equals(false))).get();

  /// -------[Adhkar]--------
  Future<int> addAdhkar(AdhkarCompanion dhekr) =>
      into(adhkar).insert(dhekr.copyWith(updatedAt: Value(_nowMs())));

  Future<int> deleteAdhkar(int id) =>
      (update(adhkar)..where((tbl) => tbl.id.equals(id))).write(
        AdhkarCompanion(deleted: const Value(true), updatedAt: Value(_nowMs())),
      );

  Future<int> updateAdhkar(AdhkarCompanion dhekr, int id) =>
      (update(adhkar)..where((tbl) => tbl.id.equals(id))).write(
        dhekr.copyWith(updatedAt: Value(_nowMs())),
      );

  Future<List<AdhkarData>> getAllAdhkar() =>
      (select(adhkar)..where((tbl) => tbl.deleted.equals(false))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notesBookmarks.db'));
    return NativeDatabase(file);
  });
}
