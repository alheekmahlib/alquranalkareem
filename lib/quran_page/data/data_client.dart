import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


// class DataBaseClient {
//   var _databaseName = "QuranV3.sqlite";
//
//   // make this a singleton class
//   DataBaseClient._privateConstructor();
//   static final DataBaseClient instance = DataBaseClient._privateConstructor();
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
//     Directory databasePath = await getApplicationDocumentsDirectory();
//     var path = join(databasePath.path, fileName);
//
//     if (Platform.isAndroid) {
//       var androidDatabasesPath = await getDatabasesPath();
//       path = join(androidDatabasesPath, fileName);
//     }
//
//     return (Platform.isWindows || Platform.isLinux)
//         ? databaseFactoryFfi.openDatabase(path,
//         options: OpenDatabaseOptions(version: 5))
//         : openDatabase(path, version: 5);
//   }
//
//   Future initDatabase() async {
//     // Get the application documents directory
//     Directory databasesPath = await getApplicationDocumentsDirectory();
//     var path = join(databasesPath.path, this._databaseName);
//     // Check if the database exists
//     var exists = await databaseExists(path);
//
//     if (!exists) {
//       // Should happen only the first time you launch your application
//       print("Creating new copy from asset");
//
//       // Open a database transaction
//       Database database = await openDatabase(path, version: 5);
//       await database.transaction((txn) async {
//         // Make sure the parent directory exists
//         try {
//           await Directory(dirname(path)).create(recursive: true);
//         } catch (_) {}
//
//         // Copy from asset
//         ByteData data = await rootBundle.load(join("assets", this._databaseName));
//         List<int> bytes =
//         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//         // Write and flush the bytes written
//         await File(path).writeAsBytes(bytes, flush: true);
//       });
//
//       // Close the database connection
//       database.close();
//     } else {
//       print("Opening existing database");
//     }
//   }
//
//   static Future<void> close() async {
//     await _database!.close();
//   }
// }
class DataBaseClient {
  var _databaseName = "QuranV3.sqlite";

  // make this a singleton class
  DataBaseClient._privateConstructor();
  static final DataBaseClient instance = DataBaseClient._privateConstructor();

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
    var androidDatabasesPath = await getDatabasesPath();
    var androidPath = join(androidDatabasesPath, fileName);
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = join(databasePath.path, fileName);
    return
    //   (Platform.isAndroid)
    //     ? openDatabase(androidPath,
    //     version: 5
    // )
    //     :
    (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 5
        )
    )
        : openDatabase(path,
        version: 5
    );
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
      Database database = await openDatabase(path, version: 5);
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

  static Future<void> close() async {
    await _database!.close();
  }
}


// class DataBaseClient {
//   var _databaseName = "QuranV3.sqlite";
//   var _currentDbVersion = 4;
//
//   // make this a singleton class
//   DataBaseClient._privateConstructor();
//   static final DataBaseClient instance = DataBaseClient._privateConstructor();
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
//     Directory databasePath = await getApplicationDocumentsDirectory();
//     var path = join(databasePath.path, fileName);
//     return (Platform.isAndroid)
//         ? openDatabase(path, version: _currentDbVersion)
//         : (Platform.isWindows || Platform.isLinux)
//         ? databaseFactoryFfi.openDatabase(
//       path,
//       options: OpenDatabaseOptions(version: _currentDbVersion),
//     )
//         : openDatabase(path, version: _currentDbVersion);
//   }
//
//
//   Future initDatabase() async {
//     // Get the application documents directory
//     var androidDatabasesPath = await getDatabasesPath();
//     var path = join(androidDatabasesPath, this._databaseName);
//     // Check if the database exists
//     var exists = await databaseExists(path);
//
//     if (!exists || _currentDbVersion > await _getExistingDbVersion(path)) {
//       // If the database does not exist or the version number is lower
//       if (exists) {
//         // await deleteDatabase(path); // Delete the existing database
//       }
//
//       // Create and copy the updated database
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
//       Database database = await openDatabase(path, version: _currentDbVersion);
//
//       // Close the database connection
//       await database.close();
//     } else {
//       print("Opening existing database");
//     }
//   }
//
//   // Helper function to get the existing database version number
//   Future<int> _getExistingDbVersion(String path) async {
//     Database? db;
//     int? version;
//     try {
//       db = await openDatabase(path, readOnly: true);
//       // Get the user_version pragma value which stores the database version
//       var result = await db.rawQuery('PRAGMA user_version');
//       version = result.isNotEmpty ? result.first.values.first as int : 0;
//     } catch (e) {
//       print("Error getting database version: $e");
//       version = 0;
//     } finally {
//       if (db != null) {
//         await db.close();
//       }
//     }
//     return version ?? 0;
//   }
//
//   static Future<void> close() async {
//     await _database!.close();
//   }
// }
// class DataBaseClient {
//   var _databaseName = "QuranV3.sqlite";
//   var _currentDbVersion = 4;
//
//   // make this a singleton class
//   DataBaseClient._privateConstructor();
//   static final DataBaseClient instance = DataBaseClient._privateConstructor();
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
//         ? openDatabase(path, version: _currentDbVersion)
//         : (Platform.isWindows || Platform.isLinux)
//         ? databaseFactoryFfi.openDatabase(path,
//         options: OpenDatabaseOptions(
//             version: _currentDbVersion))
//         : openDatabase(path, version: _currentDbVersion);
//   }
//
//   Future initDatabase() async {
//     // Get the application documents directory
//     Directory databasesPath = await getApplicationDocumentsDirectory();
//     var path = join(databasesPath.path, this._databaseName);
//     // Check if the database exists
//     var exists = await databaseExists(path);
//
//     if (!exists || _currentDbVersion > await _getExistingDbVersion(path)) {
//       // If the database does not exist or the version number is lower
//       if (exists) {
//         await deleteDatabase(path); // Delete the existing database
//       }
//
//       // Create and copy the updated database
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
//       Database database = await openDatabase(path, version: _currentDbVersion);
//
//       // Close the database connection
//       await database.close();
//     } else {
//       print("Opening existing database");
//     }
//   }
//
//   // Helper function to get the existing database version number
//   Future<int> _getExistingDbVersion(String path) async {
//     Database db = await openReadOnlyDatabase(path);
//     int? version;
//     try {
//       // Get the user_version pragma value which stores the database version
//       var result = await db.rawQuery('PRAGMA user_version');
//       version = result.isNotEmpty ? result.first.values.first as int : 0;
//     } catch (e) {
//       print("Error getting database version: $e");
//       version = 0;
//     } finally {
//       await db.close();
//     }
//     return version ?? 0;
//   }
//
//   static Future<void> close() async {
//     await _database!.close();
//   }
// }
