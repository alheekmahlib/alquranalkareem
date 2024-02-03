import 'package:sqflite/sqflite.dart';

import '/presentation/controllers/ayat_controller.dart';
import '../../../../../core/services/services_locator.dart';
import '../model/translate.dart';

class TafseerRepository {
  String? tableName;
  var dBName;

  Future<List<Tafseer>> getPageTafseer(int pageNum) async {
    print('Reloading Tafseer');
    Database? database = await dBName;
    // Fixed query: removed the unnecessary JOIN
    List<Map>? results = await database?.rawQuery(
        "SELECT * FROM ${sl<AyatController>().selectedDBName} WHERE PageNum = ?",
        [pageNum]);

    List<Tafseer> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Tafseer.fromMap(result));
    });

    return ayaList;
  }

  Future<List<Tafseer>> getAyahTafseer(int ayahNumber, int surahNumber) async {
    Database? database = await dBName;
    List<Map<String, Object?>>? results = await database?.rawQuery(
        "SELECT * FROM ${sl<AyatController>().selectedDBName} WHERE aya = ? AND sura = ?",
        [ayahNumber, surahNumber]);
    List<Tafseer> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Tafseer.fromMap(result));
    });
    return ayaList;
  }
}
