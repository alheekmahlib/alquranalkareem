import 'package:sqflite/sqflite.dart';
import '../model/ayat.dart';
import '../model/translate.dart';
import '../tafseer_data_client.dart';
List<Ayat>? ayaListNotFut;

class TranslateRepository2 {
  TafseerDataBaseClient? _client;
  TranslateRepository2() {
    _client = TafseerDataBaseClient.instance;
  }

  Future<List<Ayat>> getPageTranslate(int pageNum) async {

    if(ayaListNotFut==null){
      {
        print("inpage trans2");
        Database? database = await _client?.database;
        List<Map>? results =
        await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
            "LEFT JOIN ${Translate.tableName2} "
            "ON (${Translate.tableName2}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName2}.sura = ${Ayat.tableName}.SuraNum) "
            "WHERE PageNum = $pageNum"));
        List<Ayat> ayaList = [];
        results?.forEach((result) {
          ayaList.add(Ayat.fromMap(result));
        });
        ayaListNotFut=ayaList;
        return ayaList;
      }
    }else
      {return ayaListNotFut!;}
  }
<<<<<<< Updated upstream
=======


  Future<List<Ayat>> getAyahTranslate(int AID) async {
    Database? database = await _client?.database;
    List<Map>? results =
    await database?.rawQuery((" SELECT * FROM ${Ayat.tableName} "
        "LEFT JOIN ${Translate.tableName2} "
        "ON (${Translate.tableName2}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName2}.sura = ${Ayat.tableName}.SuraNum) "
        "WHERE SuraNum = $AID"));
    List<Ayat> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
>>>>>>> Stashed changes
}
