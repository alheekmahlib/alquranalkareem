import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/surah.dart';

class SurahRepository {
  // DataBaseClient? _client;
  // SorahRepository() {
  //   _client = DataBaseClient.instance;
  // }

  Future<List<Surah>> all() async {
    Database? database = await sl<DataBaseClient>().database;

    // Check if database is null or closed before proceeding
    if (database == null || !database.isOpen) {
      print('Database is null or closed');
      return [];
    }

    try {
      List<Map>? results =
          (await database.query(Surah.tableName, columns: Surah.columns))
              .cast<Map>();
      List<Surah> sorahList = [];
      results.forEach((result) {
        sorahList.add(Surah.fromMap(result));
      });
      return sorahList;
    } catch (e) {
      print('Database query failed: $e');
      return [];
    }
  }
}
