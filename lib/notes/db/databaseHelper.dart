import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:alquranalkareem/quran_page/data/model/bookmark.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../azkar/models/azkar.dart';
import '../model/Notes.dart';

class DatabaseHelper {

  static Database? _db;
  static const int _version = 1;
  static const String tableNote = 'noteTable';
  static const String tableBookmarks = 'bookmarkTable';
  static const String tableAzkar = 'azkarTable';
  static const String columnId = 'id';
  static const String columnBId = 'id';
  static const String columnCId = 'id';


  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        var databasesPath = await getDatabasesPath();
        String _path = p.join(databasesPath, 'notesBookmarks.db');
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
              await db.execute(
                  'CREATE TABLE noteTable ('
                      'id INTEGER PRIMARY KEY, '
                      'title TEXT, '
                      'description TEXT)',
              );
              print('create noteTable');
              await db.execute(
                'CREATE TABLE bookmarkTable ('
                  'id INTEGER PRIMARY KEY, '
                  'sorahName TEXT, '
                  'pageNum INTEGER, '
                  'lastRead TEXT)',);
              print('create bookmarkTable');
              await db.execute(
                'CREATE TABLE azkarTable ('
                  'id INTEGER PRIMARY KEY, '
                  'category TEXT, '
                  'count TEXT, '
                  'description TEXT, '
                  'reference TEXT, '
                  'zekr TEXT)',);
              print('create azkarTable');
            }
        );
      } catch (e) {
        print(e);
      }
    }
  }
  static void onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db.execute(
        'CREATE TABLE azkarTable ('
            'id INTEGER PRIMARY KEY, '
            'category TEXT, '
            'count TEXT, '
            'description TEXT, '
            'reference TEXT, '
            'zekr TEXT)',); // add new column to existing table.
      // await db.execute("CREATE TABLE NewTable...") // create new Table
    }
    // if (oldVersion < newVersion) {
    //   db.execute("ALTER TABLE noteTable ADD COLUMN date TEXT;");
    // }
  }


  // void _onCreate(Database db, int newVersion) async {
  //   await db.execute(
  //       'CREATE TABLE $tableNote('
  //           '$columnId INTEGER PRIMARY KEY, '
  //           '$columnTitle TEXT, '
  //           '$columnDescription TEXT)'
  //   );
  // }

  static Future<int?> saveNote(Notes? note) async {
    print('Save Note');
    try {
      return await _db!.insert(tableNote, note!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteNote(Notes? note) async {
    print('Delete Note');
    return await _db!.delete(tableNote, where: '$columnId = ?', whereArgs: [note!.id]);

  }

  static Future<int> updateNote(Notes? note) async {
    print('Update Note');
    return await _db!.update(tableNote, note!.toJson(), where: "$columnId = ?", whereArgs: [note.id]);

  }

  static Future<List<Map<String, dynamic>>> queryN() async {
    print('Update Note');
    return await _db!.query(tableNote);

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
    return await _db!.delete(tableBookmarks, where: '$columnBId = ?', whereArgs: [bookmarks!.id]);

  }

  static Future<int> updateBookmarks(Bookmarks bookmarks) async {
    print('Update Bookmarks');
    return await _db!.update(tableBookmarks, bookmarks.toJson(), where: "$columnBId = ?", whereArgs: [bookmarks.id]);

  }

  static Future<List<Map<String, dynamic>>> queryB() async {
    print('Update Bookmarks');
    return await _db!.query(tableBookmarks);

  }

  /// azkar database
  static Future<int?> addAzkar(Azkar? azkar) async {
    print('Save Azkar');
    try {
      return await _db!.insert(tableAzkar, azkar!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteAzkar(Azkar? azkar) async {
    print('Delete Azkar');
    return await _db!.delete(tableAzkar, where: '$columnCId = ?', whereArgs: [azkar!.id]);

  }

  static Future<int> updateAzkar(Azkar azkar) async {
    print('Update Azkar');
    return await _db!.update(tableAzkar, azkar.toJson(), where: "$columnCId = ?", whereArgs: [azkar.id]);

  }

  static Future<List<Map<String, dynamic>>> queryC() async {
    print('Update Azkar');
    return await _db!.query(tableAzkar);

  }


  Future close() async {
    return await _db!.close();
  }
}