import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DataBaseClient {
  final _databaseName = "QuranV3.sqlite";

  // make this a singleton class
  DataBaseClient._privateConstructor();
  static final DataBaseClient instance = DataBaseClient._privateConstructor();

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
        ? databaseFactoryFfi.openDatabase(path, options: OpenDatabaseOptions())
        : openDatabase(path);
  }

  Future initDatabase() async {
    // Get the application documents directory
    Directory databasesPath = await getApplicationDocumentsDirectory();
    var path = join(databasesPath.path, _databaseName);
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await File(path).create(recursive: true);
      } catch (e) {
        print('Directory creation failed: $e');
        return; // Exit if cannot create directory
      }

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      // The declaration and assignment of 'bytes' happen before its usage.
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      try {
        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
        print("Database copied from assets to $path");

        // After the file write, check if the file exists
        if (await File(path).exists()) {
          print("Confirmed: Database file exists at $path");
        } else {
          print("Error: Database file does not exist at $path");
        }
      } catch (e) {
        print('Failed to write to the database file: $e');
      }
    } else {
      print("Opening existing database");
      // It would also be good to check if the file exists here as well
      if (await File(path).exists()) {
        print("Confirmed: Database file exists and can be opened at $path");
      } else {
        print(
            "Error: The database file does not exist at $path. Cannot open the database.");
      }
    }
  }

  static Future<void> close() async {
    await _database!.close();
  }
}
