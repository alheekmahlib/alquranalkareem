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
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get daysCount => integer().withDefault(const Constant(30))();
  BoolColumn get isTahzibSahabah =>
      boolean().withDefault(const Constant(false))();
  IntColumn get color => integer().nullable()();
  IntColumn get startPage => integer().nullable()();
  IntColumn get endPage => integer().nullable()();

  // أعمدة مزامنة الأجهزة عبر QR — انظر docs/superpowers/specs
  TextColumn get syncUuid => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
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

  // أعمدة مزامنة الأجهزة عبر QR — انظر docs/superpowers/specs
  TextColumn get syncUuid => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Khatmahs, KhatmahDays])
class KhatmahDatabase extends _$KhatmahDatabase {
  KhatmahDatabase._internal() : super(_openConnection());

  static final KhatmahDatabase _instance = KhatmahDatabase._internal();

  factory KhatmahDatabase() => _instance;

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 6) {
        // ظل schemaVersion مثبتًا على 1 عبر إصدارات سابقة رغم تغير الجداول،
        // لذا ننفذ خطوات التطور القديمة والحديثة بشكل محمي من التكرار.
        try {
          await m.createTable(khatmahDays);
        } catch (_) {
          // الجدول موجود مسبقًا في قواعد المستخدمين الحاليين.
        }
        await _addColumnIfMissing('khatmahs', 'color', 'INTEGER NULL');
        await _addColumnIfMissing('khatmah_days', 'start_page', 'INTEGER NULL');
        await _addColumnIfMissing('khatmah_days', 'end_page', 'INTEGER NULL');
        await _addColumnIfMissing('khatmahs', 'sync_uuid', 'TEXT');
        await _addColumnIfMissing(
          'khatmahs',
          'updatedAt',
          'INTEGER NOT NULL DEFAULT 0',
        );
        await _addColumnIfMissing(
          'khatmahs',
          'deleted',
          'INTEGER NOT NULL DEFAULT 0',
        );
        await _addColumnIfMissing('khatmah_days', 'sync_uuid', 'TEXT');
        await _addColumnIfMissing(
          'khatmah_days',
          'updatedAt',
          'INTEGER NOT NULL DEFAULT 0',
        );
        await _addColumnIfMissing(
          'khatmah_days',
          'deleted',
          'INTEGER NOT NULL DEFAULT 0',
        );
        // ختم الصفوف القائمة حتى تُدفع في أول مزامنة.
        final now = DateTime.now().millisecondsSinceEpoch;
        await (update(
          khatmahs,
        )).write(KhatmahsCompanion(updatedAt: Value(now)));
        await (update(
          khatmahDays,
        )).write(KhatmahDaysCompanion(updatedAt: Value(now)));
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

  Future<List<Khatmah>> getAllKhatmas() =>
      (select(khatmahs)..where((tbl) => tbl.deleted.equals(false))).get();
  Future<List<KhatmahDay>> getDaysForKhatmah(int khatmahId) =>
      (select(khatmahDays)..where(
            (tbl) =>
                tbl.khatmahId.equals(khatmahId) & tbl.deleted.equals(false),
          ))
          .get();

  Future insertKhatma(Insertable<Khatmah> khatma) => into(khatmahs).insert(
    khatma is KhatmahsCompanion
        ? khatma.copyWith(updatedAt: Value(_nowMs()))
        : khatma,
  );
  Future insertKhatmahDay(Insertable<KhatmahDay> day) =>
      into(khatmahDays).insert(
        day is KhatmahDaysCompanion
            ? day.copyWith(updatedAt: Value(_nowMs()))
            : day,
      );

  Future updateKhatma(Insertable<Khatmah> khatma) => (update(khatmahs)).replace(
    khatma is KhatmahsCompanion
        ? khatma.copyWith(updatedAt: Value(_nowMs()))
        : khatma,
  );
  Future updateKhatmahDay(Insertable<KhatmahDay> day) =>
      (update(khatmahDays)).replace(
        day is KhatmahDaysCompanion
            ? day.copyWith(updatedAt: Value(_nowMs()))
            : day,
      );

  Future deleteKhatma(Insertable<Khatmah> khatma) async {
    if (khatma is KhatmahsCompanion && khatma.id.present) {
      await deleteKhatmaById(khatma.id.value);
    } else if (khatma is Khatmah) {
      await deleteKhatmaById(khatma.id);
    }
  }

  /// حذف ناعم (tombstone) للخطة وأيامها حتى ينتقل الحذف لبقية الأجهزة.
  Future<void> deleteKhatmaById(int id) async {
    final now = _nowMs();
    await (update(khatmahs)..where((t) => t.id.equals(id))).write(
      KhatmahsCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
    await (update(khatmahDays)..where((t) => t.khatmahId.equals(id))).write(
      KhatmahDaysCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
  }

  Future<void> deleteKhatmahDaysByKhatmahId(int khatmahId) async {
    await (update(
      khatmahDays,
    )..where((t) => t.khatmahId.equals(khatmahId))).write(
      KhatmahDaysCompanion(
        deleted: const Value(true),
        updatedAt: Value(_nowMs()),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'khatmah.sqlite'));
    return NativeDatabase(file);
  });
}
