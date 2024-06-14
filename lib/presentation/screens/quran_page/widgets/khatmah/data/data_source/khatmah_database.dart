import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'khatmah_database.g.dart';

class Khatmahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get currentPage => integer().nullable()();
  IntColumn get startAyahNumber => integer().nullable()();
  IntColumn get endAyahNumber => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
  IntColumn get daysCount => integer().withDefault(Constant(30))();
  BoolColumn get isTahzibSalaf => boolean().withDefault(Constant(false))();
  IntColumn get color => integer().nullable()(); // إضافة العمود الجديد
}

class KhatmahDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get khatmahId => integer()
      .customConstraint('REFERENCES khatmahs(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get day => integer()();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
}

@DriftDatabase(tables: [Khatmahs, KhatmahDays])
class KhatmahDatabase extends _$KhatmahDatabase {
  KhatmahDatabase._internal() : super(_openConnection());

  static final KhatmahDatabase _instance = KhatmahDatabase._internal();

  factory KhatmahDatabase() => _instance;

  @override
  int get schemaVersion => 4; // تحديث رقم الإصدار

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(khatmahDays);
          }
          if (from < 3) {
            await m.addColumn(
                khatmahs, khatmahs.color); // إضافة العمود الجديد في الترقية
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<List<Khatmah>> getAllKhatmas() => select(khatmahs).get();
  Future<List<KhatmahDay>> getDaysForKhatmah(int khatmahId) =>
      (select(khatmahDays)..where((tbl) => tbl.khatmahId.equals(khatmahId)))
          .get();

  Future insertKhatma(Insertable<Khatmah> khatma) =>
      into(khatmahs).insert(khatma);
  Future insertKhatmahDay(Insertable<KhatmahDay> day) =>
      into(khatmahDays).insert(day);

  Future updateKhatma(Insertable<Khatmah> khatma) =>
      update(khatmahs).replace(khatma);
  Future updateKhatmahDay(Insertable<KhatmahDay> day) =>
      update(khatmahDays).replace(day);

  Future deleteKhatma(Insertable<Khatmah> khatma) =>
      delete(khatmahs).delete(khatma);
  Future<void> deleteKhatmaById(int id) async {
    await (delete(khatmahs)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteKhatmahDaysByKhatmahId(int khatmahId) async {
    await (delete(khatmahDays)..where((t) => t.khatmahId.equals(khatmahId)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'khatmah.sqlite'));
    return NativeDatabase(file);
  });
}
