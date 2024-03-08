import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'notifications';

  static const columnId = '_id';
  static const columnTitle = 'title';
  static const columnImage = 'image';
  static const columnContent = 'content';

  NotificationDatabaseHelper._privateConstructor();
  static final NotificationDatabaseHelper instance =
      NotificationDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $table (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          timestamp TEXT
        )
      ''');
      },
      onOpen: (db) async {
        print('DB opened: $db');
      },
    );
  }

  // Future _onCreate(Database db, int version) async {
  //   await db.execute('''
  //         CREATE TABLE $table (
  //       id INTEGER PRIMARY KEY,
  //       title TEXT NOT NULL,
  //       timestamp TEXT
  //     )
  //         ''');
  // }

  Future<int> insertNotification(Map<String, dynamic> data) async {
    Database? db = await instance.database;
    return await db!.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  static Future<List<Map<String, dynamic>>> loadNotifications() async {
    final rows = await NotificationDatabaseHelper.instance.queryAllRows();
    return rows;
  }
}
