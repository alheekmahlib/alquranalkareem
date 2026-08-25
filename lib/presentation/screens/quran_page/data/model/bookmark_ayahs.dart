import 'package:drift/drift.dart';

class BookmarksAyahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get surahName => text()();
  IntColumn get surahNumber => integer()();
  IntColumn get pageNumber => integer()();
  IntColumn get ayahNumber => integer()();
  IntColumn get ayahUQNumber => integer()();
  TextColumn get lastRead => text()();

  // أعمدة مزامنة الأجهزة عبر QR — انظر docs/superpowers/specs
  TextColumn get syncUuid => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
}
