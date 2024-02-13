import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/aya.dart';

class AyaRepository {
  // DataBaseClient? _client;
  // AyaRepository() {
  //   _client = DataBaseClient.instance;
  // }

  Future<List<Aya>> search(String text) async {
    // Attempt to get a database instance.
    Database? database = await sl<DataBaseClient>().database;
    if (database == null) {
      throw DatabaseException("Database connection failed.");
    }

    List<Aya> ayaList = [];
    try {
      // Prepare the search text by replacing specific characters for broader matching.
      String searchTextReplace = text.replaceAll("ة", "ه");
      String searchTextReplaceReverse = text.replaceAll("ه", "ة");

      // Perform the query without using a transaction for a read-only operation.
      List<Map> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        where:
            "SearchText LIKE ? OR SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?",
        whereArgs: [
          '%$searchTextReplace%',
          '%$text%',
          text,
          '%$searchTextReplaceReverse%',
          '%$text%'
        ],
      );

      // Convert the query results into a list of Aya objects.
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    } catch (e) {
      // Log the error and rethrow a more generic exception to avoid leaking details.
      print("Error in search: $e");
      throw DatabaseException("An error occurred during the search operation.");
    }

    return ayaList;
  }

  Future<List<Aya>> surahSearch(String text) async {
    // Attempt to get a database instance.
    Database? database = await sl<DataBaseClient>().database;
    if (database == null) {
      throw DatabaseException("Database connection failed.");
    }

    List<Aya> ayaList = [];
    try {
      // Prepare the search text by replacing specific characters for broader matching.
      String searchTextReplace = text.replaceAll("ة", "ه");

      // Perform the query without using a transaction for a read-only operation.
      List<Map> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        // Corrected WHERE clause to start with a valid condition
        where:
            "SoraNameSearch LIKE ? OR SoraName_En LIKE ? OR PageNum = ? OR SoraNum = ?",
        whereArgs: ['%$searchTextReplace%', '%$text%', text, text],
      );

      // Convert the query results into a list of Aya objects.
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    } catch (e) {
      // Log the error and rethrow a more generic exception to avoid leaking details.
      print("Error in search: $e");
      throw DatabaseException("An error occurred during the search operation.");
    }

    return ayaList;
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

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}
