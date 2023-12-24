import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/sorah_bookmark.dart';

class SorahBookmarkRepository {
  // DataBaseClient? _client;
  // SorahBookmarkRepository() {
  //   _client = DataBaseClient.instance;
  // }

  Future<List<SoraBookmark>> all() async {
    Database? database = await sl<DataBaseClient>().database;
    List<Map>? results = (await database!
            .query(SoraBookmark.tableName, columns: SoraBookmark.columns))
        .cast<Map>();
    List<SoraBookmark> soraBookmarkList = [];
    for (var result in results) {
      soraBookmarkList.add(SoraBookmark.fromMap(result));
    }
    return soraBookmarkList;
  }
}
