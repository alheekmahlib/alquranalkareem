import 'package:drift/drift.dart';

@DataClassName('Khatmah')
class Khatmahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get surahName => text().nullable()();
  IntColumn get currentPage => integer().nullable()();
  IntColumn get startAyahNumber => integer().nullable()();
  IntColumn get endAyahNumber => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
