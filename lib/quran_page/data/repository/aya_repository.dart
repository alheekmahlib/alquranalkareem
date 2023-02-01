import 'package:sqflite/sqflite.dart';
import '../data_client.dart';
import '../model/aya.dart';

class AyaRepository {
  DataBaseClient? _client;
  AyaRepository() {
    _client = DataBaseClient.instance;
  }

  Future<List<Aya>> search(String text) async {
    Database? database = await _client?.database;
<<<<<<< HEAD
    List<Aya> ayaList = [];
    await database?.transaction((txn) async {
      List<Map>? results = (await txn?.query(Aya.tableName,
          columns: Aya.columns, where: "SearchText LIKE '%$text%'"))
          ?.cast<Map>();
      results?.forEach((result) {
        ayaList.add(Aya.fromMap(result));
      });
=======
    List<Map>? results = (await database?.query(Aya.tableName,
            columns: Aya.columns, where: "SearchText LIKE '%$text%'"))
        ?.cast<Map>();
    List<Aya> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Aya.fromMap(result));
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
    });
    return ayaList;
  }

  Future<List<Aya>> getPage(int pageNum) async {
    Database? database = await _client?.database;
<<<<<<< HEAD
    List<Aya> ayaList = [];
    await database!.transaction((txn) async {
      List<Map>? results = (await txn.query(Aya.tableName,
          columns: Aya.columns, where: "PageNum = $pageNum"))
          ?.cast<Map>();
      results?.forEach((result) {
        ayaList.add(Aya.fromMap(result));
      });
    });
    return ayaList;
  }

  Future<List<Aya>> allTafseer(int ayahNum) async {
    Database? database = await _client?.database;
    List<Map>? results = (await database?.transaction((txn) async {
      return await txn.query(Aya.tableName,
          columns: Aya.columns, where: "PageNum = $ayahNum");
    }))?.cast<Map>();
=======
    List<Map>? results = (await database?.query(Aya.tableName,
            columns: Aya.columns, where: "PageNum = $pageNum"))
        ?.cast<Map>();
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
    List<Aya> ayaList = [];
    results?.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });
    return ayaList;
  }

  Future<List<Aya>> all() async {
    Database? database = await _client?.database;
<<<<<<< HEAD
    List<Aya> ayaList = [];

    await database!.transaction((txn) async {
      List<Map>? results =
      (await txn.query(Aya.tableName, columns: Aya.columns)).cast<Map>();

      results.forEach((result) {
        ayaList.add(Aya.fromMap(result));
      });
    });

=======
    List<Map>? results =
        (await database!.query(Aya.tableName, columns: Aya.columns))
            .cast<Map>();
    List<Aya> ayaList = [];
    results.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
    return ayaList;
  }
}
