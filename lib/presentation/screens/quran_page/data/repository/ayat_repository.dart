import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/aya.dart';
import '../model/ayat.dart';

List<Ayat>? ayatListNot;

class AyatRepository {
  List<Aya>? ayatListNot;
  String? tableName;

  Future<List<Aya>> getPageAyat(int pageNum) async {
    // Assuming ayatListNot is some form of cache, we return cached data if available
    if (ayatListNot != null) {
      return ayatListNot!;
    }

    print('isReloading');
    Database? database = await sl<DataBaseClient>().database;
    // Fixed query: removed the unnecessary JOIN
    List<Map>? results = await database?.rawQuery(
        "SELECT * FROM ${Aya.tableName} WHERE PageNum = ?", [pageNum]);

    List<Aya> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });

    ayatListNot = ayaList; // Cache the results
    return ayaList;
  }

  Future<List<Aya>> getAllAyah(int surahNumber) async {
    Database? database = await sl<DataBaseClient>().database;

    List<Map>? results = await database?.rawQuery(
        "SELECT * FROM ${Aya.tableName} WHERE SoraNum = ?", [surahNumber]);

    List<Aya> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });

    return ayaList;
  }
}
