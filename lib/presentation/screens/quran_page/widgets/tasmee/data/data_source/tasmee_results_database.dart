import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'tasmee_results_database.g.dart';

/// نتائج تسميع الصفحات — صف واحد لكل صفحة مصحف (أحدث نتيجة، upsert
/// عبر [TasmeeResultsDatabase.saveLatest]).
class TasmeeResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pageNumber => integer().unique()();
  TextColumn get mode => text().withDefault(const Constant('tasmee'))();
  IntColumn get completedAt => integer()();
  IntColumn get startSura => integer()();
  IntColumn get startAya => integer()();
  IntColumn get endSura => integer()();
  IntColumn get endAya => integer()();
  IntColumn get totalWords => integer().withDefault(const Constant(0))();
  IntColumn get correctWords => integer().withDefault(const Constant(0))();
  IntColumn get tajweedErrors => integer().withDefault(const Constant(0))();
  IntColumn get normalErrors => integer().withDefault(const Constant(0))();
  IntColumn get tashkeelErrors => integer().withDefault(const Constant(0))();
  BoolColumn get isFullyCorrect =>
      boolean().withDefault(const Constant(false))();
  TextColumn get errorsJson => text().withDefault(const Constant('[]'))();
}

@DriftDatabase(tables: [TasmeeResults])
class TasmeeResultsDatabase extends _$TasmeeResultsDatabase {
  TasmeeResultsDatabase._internal() : super(_openConnection());

  /// يسمح بحقن منفّذ بديل (ذاكرة) في الاختبارات.
  TasmeeResultsDatabase.forTesting(QueryExecutor executor) : super(executor);

  static final TasmeeResultsDatabase _instance =
      TasmeeResultsDatabase._internal();

  factory TasmeeResultsDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (Migrator m) async => await m.createAll());

  /// upsert على pageNumber — أي حفظ جديد لصفحة يستبدل نتيجتها السابقة
  /// (الأحدث فقط). لا يصلح insertOnConflictUpdate هنا لأنه يتعارض على
  /// المفتاح id وليس على عمود التفرد pageNumber.
  Future<void> saveLatest(TasmeeResultsCompanion entry) =>
      into(tasmeeResults).insert(
        entry,
        onConflict: DoUpdate((_) => entry, target: [tasmeeResults.pageNumber]),
      );

  Future<TasmeeResult?> getByPage(int pageNumber) => (select(
    tasmeeResults,
  )..where((tbl) => tbl.pageNumber.equals(pageNumber))).getSingleOrNull();

  /// الصفحات المنجزة — الأحدث إنجازًا أولًا.
  Future<List<TasmeeResult>> allPages() => (select(
    tasmeeResults,
  )..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)])).get();

  Future<void> deleteByPage(int pageNumber) => (delete(
    tasmeeResults,
  )..where((tbl) => tbl.pageNumber.equals(pageNumber))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tasmee_results.sqlite'));
    return NativeDatabase(file);
  });
}
