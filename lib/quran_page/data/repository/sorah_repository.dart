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

    // Check if database is null or closed before proceeding
    if (database == null || !database.isOpen) {
      print('Database is null or closed');
      return [];
    }

    try {
      List<Map>? results =
          (await database.query(Sorah.tableName, columns: Sorah.columns))
              .cast<Map>();
      List<Sorah> sorahList = [];
      results.forEach((result) {
        sorahList.add(Sorah.fromMap(result));
      });
      return sorahList;
    } catch (e) {
      print('Database query failed: $e');
      return [];
    }
  }
}
