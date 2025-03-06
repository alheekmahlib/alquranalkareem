import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/aya.dart';

part 'quran_database.g.dart';

@DriftDatabase(tables: [QuranTable])
class QuranDatabase extends _$QuranDatabase {
  QuranDatabase._internal() : super(_openConnection());

  static final QuranDatabase _instance = QuranDatabase._internal();

  factory QuranDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  Future<List<QuranTableData>> searchAyahs(String searchText) async {
    final results = await customSelect(
      'SELECT * FROM Quran WHERE SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?',
      variables: [
        Variable.withString('%$searchText%'), // SearchText
        Variable.withString(searchText), // PageNum
        Variable.withString('%$searchText%'), // SoraNameSearch
        Variable.withString('%$searchText%'), // SoraName_En
      ],
    ).get();

    // تحويل النتائج إلى نموذج QuranTableData
    return results.map((row) {
      return QuranTableData(
        id: row.read<int>('ID'),
        partNum: row.read<int>('PartNum'),
        pageNum: row.read<int>('PageNum'),
        surahNum: row.read<int>('SoraNum'),
        sorahNameEn: row.read<String>('SoraName_En'),
        sorahName: row.read<String>('SoraName_ar'),
        ayaNum: row.read<int>('AyaNum'),
        ayaText: row.read<String>('AyaDiac'),
        searchTextColumn: row.read<String>('SearchText'),
        soraNameSearch: row.read<String>('SoraNameSearch'),
      );
    }).toList();
  }

  Future<List<QuranTableData>> searchSurah(String searchText) async {
    final results = await customSelect(
      'SELECT * FROM Quran WHERE SoraNameSearch LIKE ? OR SoraName_En LIKE ? OR PageNum LIKE ? OR SoraNum LIKE ?',
      variables: [
        Variable.withString('%$searchText%'), // SearchText
        Variable.withString(searchText), // PageNum
        Variable.withString('%$searchText%'), // SoraNameSearch
        Variable.withString('%$searchText%'), // SoraName_En
      ],
    ).get();

    // تحويل النتائج إلى نموذج QuranTableData
    return results.map((row) {
      return QuranTableData(
        id: row.read<int>('ID'),
        partNum: row.read<int>('PartNum'),
        pageNum: row.read<int>('PageNum'),
        surahNum: row.read<int>('SoraNum'),
        sorahNameEn: row.read<String>('SoraName_En'),
        sorahName: row.read<String>('SoraName_ar'),
        ayaNum: row.read<int>('AyaNum'),
        ayaText: row.read<String>('AyaDiac'),
        searchTextColumn: row.read<String>('SearchText'),
        soraNameSearch: row.read<String>('SoraNameSearch'),
      );
    }).toList();
  }

  Future<List<QuranTableData>> fetchAyahsByPage(int offset, int limit) {
    return (select(quranTable)..limit(limit, offset: offset)).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'QuranV3.sqlite'));

    // تحقق مما إذا كان الملف موجودًا
    if (!await file.exists()) {
      log('Database file not found! Copying from assets...');

      // قم بنسخ قاعدة البيانات من assets إلى مجلد المستندات
      try {
        ByteData data = await rootBundle.load('assets/QuranV3.sqlite');
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await file.writeAsBytes(bytes, flush: true);
        log('Database file copied to ${file.path}');
      } catch (e) {
        log('Error copying database: $e');
        throw Exception('Failed to copy database from assets.');
      }
    } else {
      log('Database file already exists at ${file.path}');
    }

    return NativeDatabase(file);
  });
}
