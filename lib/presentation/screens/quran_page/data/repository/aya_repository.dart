import 'package:alquranalkareem/core/utils/constants/extensions/reverse_diacritics_extension.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/services/services_locator.dart';
import '../data_source/data_client.dart';
import '../model/aya.dart';

class AyaRepository {
  Future<Database?> getDatabase() async {
    try {
      return await sl<DataBaseClient>().database;
    } catch (e) {
      throw DatabaseException("Database connection failed: ${e.toString()}");
    }
  }

  // Future<List<Aya>> search(String text) async {
  //   final Database? database = await getDatabase();
  //   if (database == null) throw DatabaseException("Database is not available");
  //
  //   List<Aya> ayaList = [];
  //   try {
  //     // Prepare the search text by replacing specific characters for broader matching.
  //     String searchTextReplace = text.replaceAll("ة", "ه");
  //     String searchTextReplaceReverse = text.replaceAll("ه", "ة");
  //
  //     // Perform the query without using a transaction for a read-only operation.
  //     List<Map> results = await database.query(
  //       Aya.tableName,
  //       columns: Aya.columns,
  //       where:
  //           "SearchText LIKE ? OR SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?",
  //       whereArgs: [
  //         '%$searchTextReplace%',
  //         '%$text%',
  //         text,
  //         '%$searchTextReplaceReverse%',
  //         '%$text%'
  //       ],
  //     );
  //
  //     // Convert the query results into a list of Aya objects.
  //     for (var result in results) {
  //       ayaList.add(Aya.fromMap(result));
  //     }
  //   } catch (e) {
  //     // Log the error and rethrow a more generic exception to avoid leaking details.
  //     print("Error in search: $e");
  //     throw DatabaseException("An error occurred during the search operation.");
  //   }
  //
  //   return ayaList;
  // }

  Future<List<Aya>> search(String text) async {
    final Database? database = await getDatabase();
    if (database == null) throw DatabaseException("Database is not available");

    List<Aya> ayaList = [];
    try {
      // Prepare the search text by removing diacritics.
      // String processedText = removeDiacritics(text);
      List<String> textVariations = text.reverseDiacritics(text);

      // Create a dynamic where clause and whereArgs list.
      StringBuffer whereClause = StringBuffer();
      List<String> whereArgs = [];

      for (int i = 0; i < textVariations.length; i++) {
        if (i > 0) whereClause.write(' OR ');
        whereClause.write("SearchText LIKE ?");
        whereArgs.add('%${textVariations[i]}%');
      }

      // Add the original text conditions
      if (textVariations.isNotEmpty) whereClause.write(' OR ');
      whereClause.write(
          "SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?");
      whereArgs.add('%$text%');
      whereArgs.add(text);
      whereArgs.add('%$text%');
      whereArgs.add('%$text%');

      // Perform the query without using a transaction for a read-only operation.
      List<Map> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        where: whereClause.toString(),
        whereArgs: whereArgs,
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

  Future<List<Aya>> fetchAyahsByPage(int offset, int limit) async {
    Database? database = await sl<DataBaseClient>().database;
    List<Aya> ayaList = [];

    // This SQL query will fetch a limited number of Ayahs, starting from an offset.
    // It assumes that you have a way to order the Ayahs consistently.
    await database!.transaction((txn) async {
      List<Map>? results = await txn.rawQuery(
        'SELECT * FROM ${Aya.tableName} LIMIT ? OFFSET ?',
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
