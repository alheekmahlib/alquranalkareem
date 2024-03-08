import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../model/tafsir.dart';
import '/presentation/controllers/ayat_controller.dart';

class TafseerRepository {
  String? tableName;
  var dBName;

  Future<List<Tafsir>> getPageTafseer(int pageNum) async {
    print('Reloading Tafseer');
    Database? database = await dBName;
    // Fixed query: removed the unnecessary JOIN
    List<Map>? results = await database?.rawQuery(
        "SELECT * FROM ${sl<AyatController>().selectedDBName} WHERE PageNum = ?",
        [pageNum]);

    List<Tafsir> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Tafsir.fromMap(result));
    });

    return ayaList;
  }

  Future<List<Tafsir>> getAyahTafseer(int ayahUQNumber, int surahNumber) async {
    Database? database = await dBName;
    List<Map<String, Object?>>? results = await database?.rawQuery(
        "SELECT * FROM ${sl<AyatController>().selectedDBName} WHERE \"index\" = ? AND sura = ?",
        [ayahUQNumber, surahNumber]);
    List<Tafsir> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Tafsir.fromMap(result));
    });
    return ayaList;
  }
}
