import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../controllers/tafsir_ctrl.dart';
import '../model/tafsir.dart';

part 'tafsir_database.g.dart';

@DriftDatabase(tables: [TafsirTable])
class TafsirDatabase extends _$TafsirDatabase {
  TafsirDatabase(String dbFileName) : super(_openConnection(dbFileName));

  @override
  int get schemaVersion => 1;

  Future<List<TafsirTableData>> getTafsirByPage(int pageNum) async {
    final results = await customSelect(
      'SELECT * FROM ${TafsirCtrl.instance.selectedTableName.value} WHERE PageNum = ?',
      variables: [Variable.withInt(pageNum)],
    ).get();

    return results.map((row) {
      return TafsirTableData(
        id: row.read<int>('index'),
        surahNum: row.read<int>('sura'),
        ayahNum: row.read<int>('aya'),
        tafsirText: row.read<String>('text'),
        pageNum: row.read<int>('PageNum'),
      );
    }).toList();
  }

  Future<List<TafsirTableData>> getTafsirByAyah(int ayahUQNumber) async {
    final results = await customSelect(
      'SELECT * FROM ${TafsirCtrl.instance.selectedTableName.value} WHERE \"index\" = ?',
      variables: [Variable.withInt(ayahUQNumber)],
    ).get();

    return results.map((row) {
      return TafsirTableData(
        id: row.read<int>('index'),
        surahNum: row.read<int>('sura'),
        ayahNum: row.read<int>('aya'),
        tafsirText: row.read<String>('text'),
        pageNum: row.read<int>('PageNum'),
      );
    }).toList();
  }
}

LazyDatabase _openConnection(String dbFileName) {
  log('Starting _openConnection for database: $dbFileName');
  return LazyDatabase(() async {
    log('Inside LazyDatabase for: $dbFileName');
    final dbFolder = await getApplicationDocumentsDirectory();
    log('Application documents directory: ${dbFolder.path}');

    final file = File(p.join(dbFolder.path, dbFileName));

    if (!await file.exists()) {
      log('Database file does not exist, copying from assets');
      try {
        ByteData data = await rootBundle.load('assets/$dbFileName');
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await file.writeAsBytes(bytes, flush: true);
        log('Tafsir Database copied to ${file.path}');
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
