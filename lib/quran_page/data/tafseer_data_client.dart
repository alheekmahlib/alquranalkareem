import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TafseerDataBaseClient {
  final _databaseName = "QuranData.sqlite";

  // make this a singleton class
  TafseerDataBaseClient._privateConstructor();
  static final TafseerDataBaseClient instance =
      TafseerDataBaseClient._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    print('db == null => ${_database == null}');
    // lazily instantiate the db the first time it is accessed
    await initDatabase();
    _database = await _openDatabase(_databaseName);
    print('db == null => ${_database == null}');
    return _database;
  }

  Future _openDatabase(String fileName) async {
    sqfliteFfiInit();
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = join(databasePath.path, fileName);

    return (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
            options: OpenDatabaseOptions(version: 6))
        : openDatabase(path, version: 6);
  }

  Future initDatabase() async {
    // Get the application documents directory
    Directory databasesPath = await getApplicationDocumentsDirectory();
    var path = join(databasesPath.path, _databaseName);
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
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

      print("Database copied from assets to $path");
    } else {
      print("Opening existing database");
    }
  }
}
