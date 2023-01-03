import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


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
    _database = await _openDatabase();
    return _database;
  }

  Future _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this._databaseName);
    print("open database");
    return await openDatabase(path, readOnly: false);
  }

  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this._databaseName);
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

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
    } else {
      print("Opening existing database");
    }
  }
}
