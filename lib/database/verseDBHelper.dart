import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../quran_page/data/model/verse.dart';

class DBHelper {
  static final _databaseName = "ayahinfo_1260.db";
  // static final _databaseVersion = 1;

  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the app's document directory and the database file's path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Check if the database file exists
    if (await databaseExists(path)) {
      return await openDatabase(path);
    } else {
      // If the file doesn't exist, copy it from the assets folder to the app's document directory
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      return await openDatabase(path);
    }
  }

  Future<List<Verse>> getVerses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('glyphs');
    return List.generate(maps.length, (i) {
      return Verse(
        ayahNumber: maps[i]['ayah_number'],
        glyphId: maps[i]['glyph_id'],
        lineNumber: maps[i]['line_number'],
        maxX: maps[i]['max_x'],
        maxY: maps[i]['max_y'],
        minX: maps[i]['min_x'],
        minY: maps[i]['min_y'],
        pageNumber: maps[i]['page_number'],
        position: maps[i]['position'],
        suraNumber: maps[i]['sura_number'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getVersesForCurrentPage(int currentPage) async {
    // You need to open the database first, if it's not already open
    Database db = await this.database;

    // Assuming you have a table named 'verses' with a 'page_number' column
    List<Map<String, dynamic>> result =
    await db.query('glyphs', where: 'page_number = ?', whereArgs: [currentPage]);
    return result;
  }

}
