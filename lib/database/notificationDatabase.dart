import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class NotificationDatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'notifications';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnImage = 'image';
  static const columnContent = 'content';

  NotificationDatabaseHelper._privateConstructor();
  static final NotificationDatabaseHelper instance = NotificationDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        timestamp TEXT
      )
          ''');
  }

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
