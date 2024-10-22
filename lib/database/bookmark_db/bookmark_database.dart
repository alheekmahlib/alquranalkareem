import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 9) {
            await m.renameTable(bookmarks, 'bookmarkTable');
            await m.renameTable(adhkar, 'azkarTable');
            await m.renameTable(bookmarksAyahs, 'bookmarkTextTable');

            await m.renameColumn(bookmarks, 'sorahName', bookmarks.sorahName);
            await m.renameColumn(bookmarks, 'pageNum', bookmarks.pageNum);
            await m.renameColumn(bookmarks, 'lastRead', bookmarks.lastRead);

            await m.renameColumn(
                bookmarksAyahs, 'sorahName', bookmarksAyahs.surahName);
            await m.renameColumn(
                bookmarksAyahs, 'sorahNum', bookmarksAyahs.surahNumber);
            await m.renameColumn(
                bookmarksAyahs, 'pageNum', bookmarksAyahs.pageNumber);
            await m.renameColumn(
                bookmarksAyahs, 'ayahNum', bookmarksAyahs.ayahNumber);
            await m.renameColumn(
                bookmarksAyahs, 'nomPageF', bookmarksAyahs.ayahUQNumber);
            await m.renameColumn(
                bookmarksAyahs, 'lastRead', bookmarksAyahs.lastRead);
          }
        },
      );

  /// -------[BookmarkPage]--------
  Future<int> addBookmark(BookmarksCompanion bookmark) =>
      into(bookmarks).insert(bookmark);

  Future<int> deleteBookmark(int id) =>
      (delete(bookmarks)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateBookmark(BookmarksCompanion bookmark, int id) =>
      (update(bookmarks)..where((tbl) => tbl.id.equals(id))).write(bookmark);

  Future<List<Bookmark>> getBookmarks() => select(bookmarks).get();

  /// -------[BookmarkAyah]--------
  Future<int> addBookmarkAyah(BookmarksAyahsCompanion bookmarkAyah) =>
      into(bookmarksAyahs).insert(bookmarkAyah);

  Future<int> deleteBookmarkAyah(int id) =>
      (delete(bookmarksAyahs)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateBookmarkAyah(
          BookmarksAyahsCompanion bookmarkAyah, int id) =>
      (update(bookmarksAyahs)..where((tbl) => tbl.id.equals(id)))
          .write(bookmarkAyah);

  Future<List<BookmarksAyah>> getAllBookmarkAyahs() =>
      select(bookmarksAyahs).get();

  /// -------[Adhkar]--------
  Future<int> addAdhkar(AdhkarCompanion dhekr) => into(adhkar).insert(dhekr);

  Future<int> deleteAdhkar(int id) =>
      (delete(adhkar)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateAdhkar(AdhkarCompanion dhekr, int id) =>
      (update(adhkar)..where((tbl) => tbl.id.equals(id))).write(dhekr);

  Future<List<AdhkarData>> getAllAdhkar() => select(adhkar).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notesBookmarks.db'));
    return NativeDatabase(file);
  });
}
