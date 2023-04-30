import 'package:sqflite/sqflite.dart';
import '../model/ayat.dart';
import '../model/translate.dart';
import '../tafseer_data_client.dart';

class TranslateRepository3 {
  TafseerDataBaseClient? _client;
  TranslateRepository3() {
    _client = TafseerDataBaseClient.instance;
  }

  Future<List<Ayat>> getPageTranslate(int pageNum) async {
    print("inpage trans3");

    Database? database = await _client?.database;
    List<Map>? results =
        await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
            "LEFT JOIN ${Translate.tableName3} "
            "ON (${Translate.tableName3}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName3}.sura = ${Ayat.tableName}.SuraNum) "
            "WHERE PageNum = $pageNum"));
    List<Ayat> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
}
