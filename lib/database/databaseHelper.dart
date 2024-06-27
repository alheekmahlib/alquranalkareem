import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '/presentation/screens/quran_page/data/model/bookmark.dart';
import '../presentation/screens/athkar/models/zeker_model.dart';
import '../presentation/screens/quran_page/data/model/bookmark_ayahs.dart';

class DatabaseHelper {
  static Database? _db;
  static const int _version = 8;
  static const String tableNote = 'noteTable';
  static const String tableBookmarks = 'bookmarkTable';
  static const String tableBookmarksText = 'bookmarkTextTable';
  static const String tableAzkar = 'azkarTable';
  static const String columnId = 'id';
  static const String columnBId = 'id';
  static const String columnCId = 'id';
  static const String columnTId = 'nomPageF';
  static const String columnPageNum = 'pageNum';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_db != null) return _db;

    // lazily instantiate the db the first time it is accessed
    // await initDb();
    _db = await initDb();
    if (_db == null) {}
    return _db;
  }

  Future<Database?> initDb() async {
    sqfliteFfiInit();
    // var androidDatabasesPath = await getDatabasesPath();
    // var androidPath = p.join(androidDatabasesPath, 'notesBookmarks.db');
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = p.join(databasePath.path, 'notesBookmarks.db');
    return (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
            options: OpenDatabaseOptions(
                version: _version,
                readOnly: false,
                onUpgrade: onUpgrade,
                onCreate: onCreate))
        : sqflite.openDatabase(path,
            version: _version,
            readOnly: false,
            onUpgrade: onUpgrade,
            onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE bookmarkTable ('
      'id INTEGER PRIMARY KEY, '
      'sorahName TEXT, '
      'pageNum INTEGER, '
      'lastRead TEXT)',
    );
    print('create bookmarkTable');
    await db.execute(
      'CREATE TABLE azkarTable ('
      'id INTEGER PRIMARY KEY, '
      'category TEXT, '
      'count TEXT, '
      'description TEXT, '
      'reference TEXT, '
      'zekr TEXT)',
    );
    print('create azkarTable');
    await db.execute(
      'CREATE TABLE bookmarkTextTable ('
      'id INTEGER PRIMARY KEY, '
      'sorahName TEXT, '
      'sorahNum INTEGER, '
      'pageNum INTEGER, '
      'ayahNum INTEGER, '
      'nomPageF INTEGER, '
      'nomPageL INTEGER, '
      'lastRead TEXT)',
    );
    print('create bookmarkTextTable');
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Database onUpgrade');
    db.execute("ALTER TABLE bookmarkTextTable ADD COLUMN ayahNum INTEGER;");
    // var results = await db.rawQuery(
    //     "SELECT name FROM sqlite_master WHERE type='table' AND name='bookmarkTextTable'");
    // if (results.isEmpty) {
    //   await db.execute(
    //     'CREATE TABLE bookmarkTextTable ('
    //     'id INTEGER PRIMARY KEY, '
    //     'sorahName TEXT, '
    //     'sorahNum INTEGER, '
    //     'pageNum INTEGER, '
    //     'nomPageF INTEGER, '
    //     'nomPageL INTEGER, '
    //     'lastRead TEXT)',
    //   );
    print('Upgrade bookmarkTextTable');
    // }
  }

  /// bookmarks database
  static Future<int?> addBookmark(Bookmarks? bookmarks) async {
    print('Save Bookmarks');
    try {
      return await _db!.insert(tableBookmarks, bookmarks!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteBookmark(Bookmarks? bookmarks) async {
    print('Delete Bookmarks');
    return await _db!.delete(tableBookmarks,
        where: '$columnBId = ?', whereArgs: [bookmarks!.id]);
  }

  static Future<int> updateBookmarks(Bookmarks bookmarks) async {
    print('Update Bookmarks');
    return await _db!.update(tableBookmarks, bookmarks.toJson(),
        where: "$columnBId = ?", whereArgs: [bookmarks.id]);
  }

  static Future<List<Map<String, dynamic>>> queryB() async {
    print('get Bookmarks');
    return await _db!.query(tableBookmarks);
  }

  /// bookmarks Text database
  static Future<int?> addBookmarkText(BookmarksAyahs? bookmarksText) async {
    print('Save Text Bookmarks');
    try {
      return await _db!.insert(tableBookmarksText, bookmarksText!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteBookmarkText(BookmarksAyahs? bookmarksText) async {
    print('Delete Text Bookmarks');
    return await _db!.delete(tableBookmarksText,
        where: '$columnTId = ?', whereArgs: [bookmarksText!.ayahUQNumber]);
  }

  static Future<int> updateBookmarksText(BookmarksAyahs bookmarksText) async {
    print('Update Text Bookmarks');
    return await _db!.update(tableBookmarksText, bookmarksText.toJson(),
        where: "$columnTId = ?", whereArgs: [bookmarksText.id]);
  }

  static Future<List<Map<String, dynamic>>> queryT() async {
    print('get Text Bookmarks');
    print('${'=' * 30} db?.isOpen: ${_db?.isOpen}');
    final data = await _db!.query(tableBookmarksText);
    print('${'=' * 30} data: $data');
    return data;
  }

  /// azkar database
  static Future<int?> addAdhkar(Dhekr? azkar) async {
    print('Save Azkar');
    try {
      return await _db!.insert(tableAzkar, azkar!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteAdhkar(Dhekr? azkar) async {
    print('Delete Azkar');
    return await _db!
        .delete(tableAzkar, where: '$columnCId = ?', whereArgs: [azkar!.id]);
  }

  static Future<int> updateAdhkar(Dhekr azkar) async {
    print('Update Azkar');
    return await _db!.update(tableAzkar, azkar.toJson(),
        where: "$columnCId = ?", whereArgs: [azkar.id]);
  }

  static Future<List<Map<String, dynamic>>> queryC() async {
    print('Update Azkar');
    return await _db!.query(tableAzkar);
  }

  Future close() async {
    return await _db!.close();
  }
}
