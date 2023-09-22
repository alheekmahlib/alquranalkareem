import 'package:sqflite/sqflite.dart';

import '../../../shared/services/controllers_put.dart';
import '../model/ayat.dart';
import '../tafseer_data_client.dart';

List<Ayat>? ayaListNotFut;

class TranslateRepository {
  TafseerDataBaseClient? _client;
  TranslateRepository() {
    _client = TafseerDataBaseClient.instance;
  }
  List<Ayat>? ayaListNotFut;
  String? tableName;

  Future<List<Ayat>> getPageTranslate(int pageNum) async {
    if (ayaListNotFut == null) {
      print('isReloading');
      Database? database = await _client?.database;
      List<Map>? results =
          await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
              "LEFT JOIN ${ayatController.tableName} "
              "ON (${ayatController.tableName}.aya = ${Ayat.tableName}.Verse) AND (${ayatController.tableName}.sura = ${Ayat.tableName}.SuraNum) "
              "WHERE PageNum = $pageNum"));
      List<Ayat> ayaList = [];
      results?.forEach((result) {
        ayaList.add(Ayat.fromMap(result));
      });

      ayaListNotFut = ayaList;
      return ayaList;
    } else {
      return ayaListNotFut!;
    }
  }

  Future<List<Ayat>> getAyahTranslate(int surahNumber) async {
    Database? database = await _client?.database;
    List<Map>? results =
        await database?.rawQuery(("SELECT * FROM ${Ayat.tableName} "
            "LEFT JOIN ${ayatController.tableName} "
            "ON (${ayatController.tableName}.aya = ${Ayat.tableName}.Verse) AND (${ayatController.tableName}.sura = ${Ayat.tableName}.SuraNum) "
            "WHERE SuraNum = $surahNumber"));
    List<Ayat> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
}
