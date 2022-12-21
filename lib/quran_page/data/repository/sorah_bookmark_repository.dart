import 'package:sqflite/sqflite.dart';
import '../data_client.dart';
import '../model/sorah_bookmark.dart';

class SorahBookmarkRepository {
  DataBaseClient? _client;
  SorahBookmarkRepository() {
    _client = DataBaseClient.instance;
  }

  Future<List<SoraBookmark>> all() async {
    Database? database = await _client!.database;
    List<Map>? results = (await database!
            .query(SoraBookmark.tableName, columns: SoraBookmark.columns))
        .cast<Map>();
    List<SoraBookmark> soraBookmarkList = [];
    results.forEach((result) {
      soraBookmarkList.add(SoraBookmark.fromMap(result));
    });
    return soraBookmarkList;
  }
}
