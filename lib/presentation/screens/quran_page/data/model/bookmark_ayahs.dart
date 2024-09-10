import 'package:drift/drift.dart';

class BookmarksAyahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get surahName => text()();
  IntColumn get surahNumber => integer()();
  IntColumn get pageNumber => integer()();
  IntColumn get ayahNumber => integer()();
  IntColumn get ayahUQNumber => integer()();
  TextColumn get lastRead => text()();
}
