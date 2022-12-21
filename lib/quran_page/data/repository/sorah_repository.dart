import 'package:sqflite/sqflite.dart';
import '../data_client.dart';
import '../model/sorah.dart';

class SorahRepository {
  DataBaseClient? _client;
  SorahRepository() {
    _client = DataBaseClient.instance;
  }

  Future<List<Sorah>> all() async {
    Database? database = await _client?.database;
    List<Map>? results =
        (await database?.query(Sorah.tableName, columns: Sorah.columns))
            ?.cast<Map>();
    List<Sorah> sorahList = [];
    results?.forEach((result) {
      sorahList.add(Sorah.fromMap(result));
    });
    return sorahList;
  }
}
