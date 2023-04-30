import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class TafseerDataBaseClient {
//   var _databaseName = "QuranData.sqlite";
//
//   // make this a singleton class
//   TafseerDataBaseClient._privateConstructor();
//   static final TafseerDataBaseClient instance =
//   TafseerDataBaseClient._privateConstructor();
//
//   // only have a single app-wide reference to the database
//   static Database? _database;
//
//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     // lazily instantiate the db the first time it is accessed
//     await initDatabase();
//     _database = await _openDatabase(_databaseName);
//     return _database;
//   }
//
//   Future _openDatabase(String fileName) async {
//     sqfliteFfiInit();
//     var androidDatabasesPath = await getDatabasesPath();
//     var androidPath = join(androidDatabasesPath, fileName);
//     Directory databasePath = await getApplicationDocumentsDirectory();
//     var path = join(databasePath.path, fileName);
//     return (Platform.isAndroid)
//         ? openDatabase(path,
//         version: 2,
//         readOnly: false
//     )
//         : (Platform.isWindows || Platform.isLinux)
//         ? databaseFactoryFfi.openDatabase(path,
//         options: OpenDatabaseOptions(
//             version: 2,
//             readOnly: false
//         )
//     )
//         : openDatabase(path,
//         version: 2,
//         readOnly: false
//     );
//   }
//
//   Future initDatabase() async {
//     var databasesPath = await getDatabasesPath();
//     var path = join(databasesPath, this._databaseName);
//
//     // Check if the database exists
//     var exists = await databaseExists(path);
//
//     if (!exists) {
//       // Should happen only the first time you launch your application
//       print("Creating new copy from asset");
//
//       // Make sure the parent directory exists
//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (_) {}
//
//       // Copy from asset
//       ByteData data = await rootBundle.load(join("assets", this._databaseName));
//       List<int> bytes =
//       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//       // Write and flush the bytes written
//       await File(path).writeAsBytes(bytes, flush: true);
//
//       // Open the database
//       Database database = await openDatabase(path, version: 2);
//
//       // Close the database connection
//       await database.close();
//     } else {
//       print("Opening existing database");
//     }
//   }
//
// }
// class TafseerDataBaseClient {
//   var _databaseName = "QuranData.sqlite";
//
//   // make this a singleton class
//   TafseerDataBaseClient._privateConstructor();
//   static final TafseerDataBaseClient instance =
//   TafseerDataBaseClient._privateConstructor();
//
//   // only have a single app-wide reference to the database
//   static Database? _database;
//
//   Future<Database?> get database async {
//     if (_database != null) return _database!;
//     // lazily instantiate the db the first time it is accessed
//     await initDatabase();
//     _database = await _openDatabase(_databaseName);
//     return _database!;
//   }
//
//   Future _openDatabase(String fileName) async {
//     sqfliteFfiInit();
//     var androidDatabasesPath = await getDatabasesPath();
//     var androidPath = join(androidDatabasesPath, fileName);
//     Directory databasePath = await getApplicationDocumentsDirectory();
//     var path = join(databasePath.path, fileName);
//     return (Platform.isAndroid)
//         ? openDatabase(androidPath,
//         version: 2,
//         readOnly: false
//     )
//         : (Platform.isWindows || Platform.isLinux)
//         ? databaseFactoryFfi.openDatabase(path,
//         options: OpenDatabaseOptions(
//             version: 2,
//             readOnly: false
//         )
//     )
//         : openDatabase(path,
//         version: 2,
//         readOnly: false
//     );
//   }
//
//   Future initDatabase() async {
//     var databasesPath = await getDatabasesPath();
//     var path = join(databasesPath, this._databaseName);
//
//     // Check if the database exists
//     var exists = await databaseExists(path);
//
//     if (!exists) {
//       // Should happen only the first time you launch your application
//       print("Creating new copy from asset");
//
//       // Make sure the parent directory exists
//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (_) {}
//
//       // Copy from asset
//       ByteData data = await rootBundle.load(join("assets", this._databaseName));
//       List<int> bytes =
//       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//       // Write and flush the bytes written
//       await File(path).writeAsBytes(bytes, flush: true);
//     }
//
//     // Open the database
//     Database database = await openDatabase(path, version: 2);
//
//     // Print the list of tables in the database for debugging purposes
//     var result = await database.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
//     print("Tables in the database: $result");
//
//     // Close the database connection
//     await database.close();
//
//     print("Opening existing database");
//   }
//
// }
class TafseerDataBaseClient {
  var _databaseName = "QuranData.sqlite";

  // make this a singleton class
  TafseerDataBaseClient._privateConstructor();
  static final TafseerDataBaseClient instance =
  TafseerDataBaseClient._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    await initDatabase();
    _database = await _openDatabase(_databaseName);
    return _database;
  }

  Future _openDatabase(String fileName) async {
    sqfliteFfiInit();
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = join(databasePath.path, fileName);

    // if (Platform.isAndroid) {
    //   var androidDatabasesPath = await getDatabasesPath();
    //   path = join(androidDatabasesPath, fileName);
    // }

    return (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(version: 6))
        : openDatabase(path, version: 6);
  }

  Future initDatabase() async {
    // Get the application documents directory
    Directory databasesPath = await getApplicationDocumentsDirectory();
    var path = join(databasesPath.path, this._databaseName);
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Open a database transaction
      Database database = await openDatabase(path, version: 6);
      await database.transaction((txn) async {
        // Make sure the parent directory exists
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        // Copy from asset
        ByteData data = await rootBundle.load(join("assets", this._databaseName));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
      });

      // Close the database connection
      database.close();
    } else {
      print("Opening existing database");
    }
  }

}