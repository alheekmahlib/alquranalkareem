import 'package:drift/drift.dart';

import 'package:alquranalkareem/database/bookmark_db/connection/connection.dart';

part 'books_bookmark_database.g.dart';

class BooksBookmark extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookName => text().nullable()();
  IntColumn get bookNumber => integer().nullable()();
  IntColumn get currentPage => integer().nullable()();
}

@DriftDatabase(tables: [BooksBookmark])
class BooksBookmarkDatabase extends _$BooksBookmarkDatabase {
  BooksBookmarkDatabase._internal()
    : super(openConnection('books_bookmark.sqlite'));

  static final BooksBookmarkDatabase _instance =
      BooksBookmarkDatabase._internal();

  factory BooksBookmarkDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {},
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<List<BooksBookmarkData>> getAllBookmarks() =>
      select(booksBookmark).get();

  Future insertBookmark(Insertable<BooksBookmarkData> bookmark) =>
      into(booksBookmark).insert(bookmark);

  Future updateBookmark(Insertable<BooksBookmarkData> bookmark) =>
      update(booksBookmark).replace(bookmark);

  Future deleteBookmark(Insertable<BooksBookmarkData> bookmark) =>
      delete(booksBookmark).delete(bookmark);

  Future<void> deleteBookmarkById(int bookNumber, int currentPage) async {
    await (delete(booksBookmark)
          ..where((t) => t.bookNumber.equals(bookNumber))
          ..where((tt) => tt.currentPage.equals(currentPage)))
        .go();
  }
}
