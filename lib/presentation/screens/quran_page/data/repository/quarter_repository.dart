import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/quarter.dart';

class QuarterRepository {
  // DataBaseClient? _client;
  // QuarterRepository() {
  //   _client = DataBaseClient.instance;
  // }

  Future<List<Quarter>> all() async {
    Database? database = await sl<DataBaseClient>().database;
    List<Map>? results =
        (await database?.query(Quarter.tableName, columns: Quarter.columns))
            ?.cast<Map>();
    List<Quarter> quarterList = [];
    results?.forEach((result) {
      quarterList.add(Quarter.fromMap(result));
    });
    return quarterList;
  }
}
