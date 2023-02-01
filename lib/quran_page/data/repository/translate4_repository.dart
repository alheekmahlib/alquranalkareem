import 'package:sqflite/sqflite.dart';
import '../model/ayat.dart';
import '../model/translate.dart';
import '../tafseer_data_client.dart';

class TranslateRepository4 {
  TafseerDataBaseClient? _client;
  TranslateRepository4() {
    _client = TafseerDataBaseClient.instance;
  }

  Future<List<Ayat>> getPageTranslate(int pageNum) async {
    Database? database = await _client?.database;
    List<Map>? results =
        await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
            "LEFT JOIN ${Translate.tableName4} "
            "ON (${Translate.tableName4}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName4}.sura = ${Ayat.tableName}.SuraNum) "
            "WHERE PageNum = $pageNum"));
    List<Ayat> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
<<<<<<< HEAD

  Future<List<Ayat>> getAyahTranslate(int AID) async {
    Database? database = await _client?.database;
    List<Map>? results =
    await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
        "LEFT JOIN ${Translate.tableName4} "
        "ON (${Translate.tableName4}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName4}.sura = ${Ayat.tableName}.SuraNum) "
        "WHERE SuraNum = $AID"));
    List<Ayat> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
}
