import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
<<<<<<< HEAD
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
=======
import 'package:sqflite/sqflite.dart';
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee


/// test
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
<<<<<<< HEAD
    _database = await _openDatabase(_databaseName);
    return _database;
  }

  Future _openDatabase(String fileName) async {
    sqfliteFfiInit();
    var androidDatabasesPath = await getDatabasesPath();
    var androidPath = join(androidDatabasesPath, fileName);
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = join(databasePath.path, fileName);
    return (Platform.isAndroid)
      ? openDatabase(androidPath,
        version: 1,
        readOnly: false
    )
      : (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 1,
            readOnly: false
        )
    )
        : openDatabase(path,
        version: 1,
        readOnly: false
    );
    // if(Platform.isAndroid){
    //   var databasesPath = await getDatabasesPath();
    //   var path = join(databasesPath, fileName);
    //   return openDatabase(path,
    //       version: 1,
    //       readOnly: false
    //   );
    // } else {
    //   Directory databasePath = await getApplicationDocumentsDirectory();
    //   var path = join(databasePath.path, fileName);
    //   return (Platform.isWindows || Platform.isLinux)
    //       ? databaseFactoryFfi.openDatabase(path,
    //       options: OpenDatabaseOptions(
    //           version: 1,
    //           readOnly: false
    //       )
    //   )
    //       : openDatabase(path,
    //       version: 1,
    //       readOnly: false
    //   );
    // }

    // var databasesPath = await getDatabasesPath();
    // var path = join(databasesPath, this._databaseName);
    // print("open database");
    // return await openDatabase(path, readOnly: false);
=======
    _database = await _openDatabase();
    return _database;
  }

  Future _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this._databaseName);
    print("open database");
    return await openDatabase(path, readOnly: false);
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
  }

  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this._databaseName);
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

<<<<<<< HEAD
      // Open a database transaction
      Database database = await openDatabase(path, version: 1);
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
=======
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
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
    } else {
      print("Opening existing database");
    }
  }
}
