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

  // أعمدة مزامنة الأجهزة عبر QR — انظر docs/superpowers/specs
  TextColumn get syncUuid => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [BooksBookmark])
class BooksBookmarkDatabase extends _$BooksBookmarkDatabase {
  BooksBookmarkDatabase._internal() : super(_openConnection());

  static final BooksBookmarkDatabase _instance =
      BooksBookmarkDatabase._internal();

  factory BooksBookmarkDatabase() => _instance;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // أعمدة مزامنة الأجهزة: مفتاح مستقر + طابع زمني LWW + حذف ناعم.
        await _addColumnIfMissing('books_bookmark', 'syncUuid', 'TEXT');
        await _addColumnIfMissing(
          'books_bookmark',
          'updatedAt',
          'INTEGER NOT NULL DEFAULT 0',
        );
        await _addColumnIfMissing(
          'books_bookmark',
          'deleted',
          'INTEGER NOT NULL DEFAULT 0',
        );
        // ختم الصفوف القائمة حتى تُدفع في أول مزامنة.
        await customStatement(
          'UPDATE books_bookmark SET "updatedAt" = ${DateTime.now().millisecondsSinceEpoch}',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static int _nowMs() => DateTime.now().millisecondsSinceEpoch;

  Future<void> _addColumnIfMissing(
    String table,
    String column,
    String ddl,
  ) async {
    final columns = await customSelect('PRAGMA table_info($table)').get();
    final exists = columns.any((row) => row.read<String>('name') == column);
    if (!exists) {
      await customStatement('ALTER TABLE $table ADD COLUMN $column $ddl');
    }
  }

  Future<List<BooksBookmarkData>> getAllBookmarks() =>
      (select(booksBookmark)..where((tbl) => tbl.deleted.equals(false))).get();

  Future insertBookmark(Insertable<BooksBookmarkData> bookmark) =>
      into(booksBookmark).insert(
        bookmark is BooksBookmarkCompanion
            ? bookmark.copyWith(updatedAt: Value(_nowMs()))
            : bookmark,
      );

  Future updateBookmark(Insertable<BooksBookmarkData> bookmark) =>
      (update(booksBookmark)).replace(
        bookmark is BooksBookmarkCompanion
            ? bookmark.copyWith(updatedAt: Value(_nowMs()))
            : bookmark,
      );

  /// حذف ناعم (tombstone) حتى تنتقل عملية الحذف إلى بقية الأجهزة.
  Future deleteBookmark(Insertable<BooksBookmarkData> bookmark) async {
    if (bookmark is BooksBookmarkCompanion && bookmark.id.present) {
      await _softDeleteById(bookmark.id.value);
    } else if (bookmark is BooksBookmarkData) {
      await _softDeleteById(bookmark.id);
    }
  }

  Future<void> deleteBookmarkById(int bookNumber, int currentPage) async {
    await (update(booksBookmark)
          ..where((t) => t.bookNumber.equals(bookNumber))
          ..where((tt) => tt.currentPage.equals(currentPage)))
        .write(
          BooksBookmarkCompanion(
            deleted: const Value(true),
            updatedAt: Value(_nowMs()),
          ),
        );
  }

  Future<void> _softDeleteById(int id) async {
    await (update(booksBookmark)..where((t) => t.id.equals(id))).write(
      BooksBookmarkCompanion(
        deleted: const Value(true),
        updatedAt: Value(_nowMs()),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'books_bookmark.sqlite'));
    return NativeDatabase(file);
  });
}
