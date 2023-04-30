import 'package:sqflite/sqflite.dart';
import '../model/ayat.dart';
import '../model/translate.dart';
import '../tafseer_data_client.dart';

class TranslateRepository {
  TafseerDataBaseClient? _client;
  TranslateRepository() {
    _client = TafseerDataBaseClient.instance;
  }
  List<Ayat>? ayaListNotFut;

  Future<List<Ayat>> getPageTranslate(int pageNum) async {
print("in getPageTrans");
    if(ayaListNotFut==null){ print('tester page translate');
      Database? database = await _client?.database;
      List<Map>? results =
      await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
          "LEFT JOIN ${Translate.tableName} "
          "ON (${Translate.tableName}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName}.sura = ${Ayat.tableName}.SuraNum) "
          "WHERE PageNum = $pageNum"));
      List<Ayat> ayaList = [];
      results?.forEach((result) {
        ayaList.add(Ayat.fromMap(result));
      });

      ayaListNotFut=ayaList;
      return ayaList;
    }else{
      return ayaListNotFut!;
    }
  }

  Future<List<Ayat>> getAyahTranslate(int AID) async {
    Database? database = await _client?.database;
    List<Map>? results =
    await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
        "LEFT JOIN ${Translate.tableName} "
        "ON (${Translate.tableName}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName}.sura = ${Ayat.tableName}.SuraNum) "
        "WHERE SuraNum = $AID"));
    List<Ayat> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
}
