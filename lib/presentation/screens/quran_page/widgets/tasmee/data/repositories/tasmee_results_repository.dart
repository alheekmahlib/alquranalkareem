import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import '../data_source/tasmee_results_database.dart';
import '../models/tasmee_page_result.dart';

/// مستودع نتائج تسميع الصفحات — مصدر الحقيقة الوحيد بين قاعدة drift
/// وبقية التطبيق؛ يحوّل الصفوف إلى [TasmeePageResult] والعكس.
class TasmeeResultsRepository {
  TasmeeResultsRepository({TasmeeResultsDatabase? database})
    : _database = database ?? TasmeeResultsDatabase();

  final TasmeeResultsDatabase _database;

  /// يحفظ نتيجة صفحة (يستبدل القديمة — أحدث نتيجة لكل صفحة).
  Future<void> saveLatest(TasmeePageResult result) {
    return _database.saveLatest(
      TasmeeResultsCompanion.insert(
        pageNumber: result.pageNumber,
        mode: Value(result.mode),
        completedAt: result.completedAt.millisecondsSinceEpoch,
        startSura: result.startSura,
        startAya: result.startAya,
        endSura: result.endSura,
        endAya: result.endAya,
        totalWords: Value(result.totalWords),
        correctWords: Value(result.correctWords),
        tajweedErrors: Value(result.tajweedErrors),
        normalErrors: Value(result.normalErrors),
        tashkeelErrors: Value(result.tashkeelErrors),
        isFullyCorrect: Value(result.isFullyCorrect),
        errorsJson: Value(
          jsonEncode(result.errors.map((e) => e.toJson()).toList()),
        ),
      ),
    );
  }

  Future<TasmeePageResult?> getByPage(int pageNumber) async {
    final row = await _database.getByPage(pageNumber);
    return row == null ? null : _mapRow(row);
  }

  /// الصفحات المنجزة — الأحدث أولًا.
  Future<List<TasmeePageResult>> allPages() async {
    final rows = await _database.allPages();
    return rows.map(_mapRow).toList();
  }

  Future<void> deleteByPage(int pageNumber) =>
      _database.deleteByPage(pageNumber);

  TasmeePageResult _mapRow(TasmeeResult row) {
    final errorsJson = const JsonDecoder().convert(row.errorsJson);
    return TasmeePageResult(
      pageNumber: row.pageNumber,
      mode: row.mode,
      completedAt: DateTime.fromMillisecondsSinceEpoch(row.completedAt),
      startSura: row.startSura,
      startAya: row.startAya,
      endSura: row.endSura,
      endAya: row.endAya,
      totalWords: row.totalWords,
      correctWords: row.correctWords,
      isFullyCorrect: row.isFullyCorrect,
      errors: [
        for (final e in (errorsJson as List<dynamic>).whereType<Map>())
          TasmeeErrorSnapshot.fromJson(Map<String, dynamic>.from(e)),
      ],
    );
  }
}
