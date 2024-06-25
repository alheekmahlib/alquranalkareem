import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'books_bookmark_database.g.dart';

class BooksBookmark extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookName => text().nullable()();
  IntColumn get bookNumber => integer().nullable()();
  IntColumn get currentPage => integer().nullable()();
}

@DriftDatabase(tables: [BooksBookmark])
class BooksBookmarkDatabase extends _$BooksBookmarkDatabase {
  BooksBookmarkDatabase._internal() : super(_openConnection());

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

  Future<void> deleteBookmarkById(int id) async {
    await (delete(booksBookmark)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'books_bookmark.sqlite'));
    return NativeDatabase(file);
  });
}
