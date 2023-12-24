// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../presentation/screens/quran_page/widgets/highlighting_widget.dart';
//
// class DBHelper {
//   static const _databaseName = "ayat.ayt";
//   // static final _databaseVersion = 1;
//
//   static final DBHelper _instance = DBHelper._internal();
//
//   factory DBHelper() {
//     return _instance;
//   }
//
//   DBHelper._internal();
//
//   DBHelper._privateConstructor();
//   static final DBHelper instance = DBHelper._privateConstructor();
//
//   static Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     // Get the app's document directory and the database file's path
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//
//     // Check if the database file exists
//     if (await databaseExists(path)) {
//       return await openDatabase(path);
//     } else {
//       // If the file doesn't exist, copy it from the assets folder to the app's document directory
//       ByteData data = await rootBundle.load(join("assets", _databaseName));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       await File(path).writeAsBytes(bytes, flush: true);
//       return await openDatabase(path);
//     }
//   }
//
//   Future<List<Verse>> getVerses(int safha) async {
//     final db = await database;
//     verses = await db.query(
//       'amaken_hafs',
//       where: 'safha = ?',
//       whereArgs: [safha],
//     );
//     return verses.map((map) => Verse.fromMap(map)).toList();
//   }
//
//   Future<List<Map<String, dynamic>>> getVersesForCurrentPage(
//       int currentPage) async {
//     // You need to open the database first, if it's not already open
//     Database db = await database;
//
//     // Assuming you have a table named 'verses' with a 'page_number' column
//     List<Map<String, dynamic>> result = await db
//         .query('glyphs', where: 'page_number = ?', whereArgs: [currentPage]);
//     return result;
//   }
// }
