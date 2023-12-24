import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/aya.dart';

class AyaRepository {
  // DataBaseClient? _client;
  // AyaRepository() {
  //   _client = DataBaseClient.instance;
  // }

  Future<List<Aya>?> search(String text) async {
    try {
      Database? database = await sl<DataBaseClient>().database;
      if (database == null) {
        return null;
      }
      List<Aya> ayaList = [];
      await database.transaction((transaction) async {
        List<Map>? results = await transaction.query(
          Aya.tableName,
          columns: Aya.columns,
          where: "SearchText LIKE ? OR PageNum = ? OR SoraNameSearch = ?",
          whereArgs: ['%$text%', text, text],
        );
        for (var result in results) {
          ayaList.add(Aya.fromMap(result));
        }
      });
      return ayaList;
    } catch (e) {
      print("Error in search: $e");
      return null;
    }
  }

  Future<List<Aya>> getPage(int pageNum) async {
    Database? database = await sl<DataBaseClient>().database;
    List<Aya> ayaList = [];
    await database?.transaction((txn) async {
      List<Map>? results = await txn.query(
        Aya.tableName,
        columns: Aya.columns,
        where: "PageNum = $pageNum",
      );
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    });
    return ayaList;
  }

  Future<List<Aya>> allTafseer(int ayahNum) async {
    Database? database = await sl<DataBaseClient>().database;
    List<Map>? results = await database?.transaction((txn) async {
      return await txn.query(
        Aya.tableName,
        columns: Aya.columns,
        where: "PageNum = $ayahNum",
      );
    });
    List<Aya> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });
    return ayaList;
  }

  Future<List<Aya>> all() async {
    Database? database = await sl<DataBaseClient>().database;
    List<Aya> ayaList = [];

    await database!.transaction((txn) async {
      List<Map>? results = await txn.query(
        Aya.tableName,
        columns: Aya.columns,
      );
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    });

    return ayaList;
  }

  Future<List<Aya>> fetchAyahsByPage(int offset, int limit) async {
    Database? database = await sl<DataBaseClient>().database;
    List<Aya> ayaList = [];

    // This SQL query will fetch a limited number of Ayahs, starting from an offset.
    // It assumes that you have a way to order the Ayahs consistently.
    await database!.transaction((txn) async {
      List<Map>? results = await txn.rawQuery(
        'SELECT * FROM ${Aya.tableName} ORDER BY some_order_column LIMIT ? OFFSET ?',
        [limit, offset],
      );
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    });

    return ayaList;
  }
}
