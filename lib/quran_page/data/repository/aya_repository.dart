import 'package:sqflite/sqflite.dart';
import '../data_client.dart';
import '../model/aya.dart';

class AyaRepository {
  DataBaseClient? _client;
  AyaRepository() {
    _client = DataBaseClient.instance;
  }

  Future<List<Aya>?> search(String text) async {
    try {
      Database? database = await _client?.database;
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
        results.forEach((result) {
          ayaList.add(Aya.fromMap(result));
        });
      });
      return ayaList;
    } catch (e) {
      print("Error in search: $e");
      return null;
    }
  }



  Future<List<Aya>> getPage(int pageNum) async {
    Database? database = await _client?.database;
    List<Aya> ayaList = [];
    await database?.transaction((txn) async {
      List<Map>? results = await txn.query(
        Aya.tableName,
        columns: Aya.columns,
        where: "PageNum = $pageNum",
      );
      results.forEach((result) {
        ayaList.add(Aya.fromMap(result));
      });
    });
    return ayaList;
  }

  Future<List<Aya>> allTafseer(int ayahNum) async {
    Database? database = await _client?.database;
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
    Database? database = await _client?.database;
    List<Aya> ayaList = [];

    await database!.transaction((txn) async {
      List<Map>? results = await txn.query(
        Aya.tableName,
        columns: Aya.columns,
      );
      results.forEach((result) {
        ayaList.add(Aya.fromMap(result));
      });
    });

    return ayaList;
  }
}
