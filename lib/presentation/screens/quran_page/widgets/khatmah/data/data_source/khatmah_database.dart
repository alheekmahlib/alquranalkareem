import 'package:alquranalkareem/database/bookmark_db/connection/connection.dart';
import 'package:drift/drift.dart';

part 'khatmah_database.g.dart';

class Khatmahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get currentPage => integer().nullable()();
  IntColumn get startAyahNumber => integer().nullable()();
  IntColumn get endAyahNumber => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get daysCount => integer().withDefault(const Constant(30))();
  BoolColumn get isTahzibSahabah =>
      boolean().withDefault(const Constant(false))();
  IntColumn get color => integer().nullable()();
  IntColumn get startPage => integer().nullable()();
  IntColumn get endPage => integer().nullable()();
}

class KhatmahDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get khatmahId => integer().customConstraint(
    'REFERENCES khatmahs(id) ON DELETE CASCADE NOT NULL',
  )();
  IntColumn get day => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get startPage => integer().nullable()(); // إضافة حقل startPage
  IntColumn get endPage => integer().nullable()(); // إضافة حقل endPage
}

@DriftDatabase(tables: [Khatmahs, KhatmahDays])
class KhatmahDatabase extends _$KhatmahDatabase {
  KhatmahDatabase._internal() : super(openConnection('khatmah.sqlite'));

  static final KhatmahDatabase _instance = KhatmahDatabase._internal();

  factory KhatmahDatabase() => _instance;

  @override
  int get schemaVersion => 1;

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
        await m.addColumn(khatmahs, khatmahs.color);
      }
      if (from < 5) {
        await m.addColumn(khatmahDays, khatmahDays.startPage);
        await m.addColumn(khatmahDays, khatmahDays.endPage);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<List<Khatmah>> getAllKhatmas() => select(khatmahs).get();
  Future<List<KhatmahDay>> getDaysForKhatmah(int khatmahId) => (select(
    khatmahDays,
  )..where((tbl) => tbl.khatmahId.equals(khatmahId))).get();

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
    await (delete(
      khatmahDays,
    )..where((t) => t.khatmahId.equals(khatmahId))).go();
  }
}
