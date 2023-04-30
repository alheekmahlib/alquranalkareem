import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:alquranalkareem/quran_page/data/model/bookmark.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../azkar/models/azkar.dart';
import '../notes/model/Notes.dart';
import '../quran_text/model/bookmark_text.dart';
import '../quran_text/model/bookmark_text_ayah.dart';

class DatabaseHelper {
  static Database? _db;
  static const int _version = 6;
  static const String tableNote = 'noteTable';
  static const String tableBookmarks = 'bookmarkTable';
  static const String tableBookmarksText = 'bookmarkTextTable';
  static const String tableAzkar = 'azkarTable';
  static const String tablebookmarkTextAyah = 'bookmarkTextAyahTable';
  static const String columnId = 'id';
  static const String columnBId = 'id';
  static const String columnCId = 'id';
  static const String columnTId = 'id';
  static const String columnAId = 'id';
  static const String columnPageNum = 'pageNum';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    // await initDatabase();
    _db = await initDb();
    return _db;
  }

  Future<Database?> initDb() async {
    // if (_db != null) {
    //   debugPrint('not null db');
    //   // return;
    // } else {
    sqfliteFfiInit();
    var androidDatabasesPath = await getDatabasesPath();
    var androidPath = p.join(androidDatabasesPath, 'notesBookmarks.db');
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = p.join(databasePath.path, 'notesBookmarks.db');
    return (Platform.isAndroid)
      ? openDatabase(androidPath,
        version: _version,
        readOnly: false,
        onUpgrade: onUpgrade,
        onCreate: onCreate)
        : (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: _version,
            readOnly: false,
            onUpgrade: onUpgrade,
            onCreate: onCreate))
        : openDatabase(path,
        version: _version,
        readOnly: false,
        onUpgrade: onUpgrade,
        onCreate: onCreate);
    // if(Platform.isAndroid){
    //   var databasesPath = await getDatabasesPath();
    //   var path = p.join(databasesPath, 'notesBookmarks.db');
    //   return openDatabase(path,
    //       version: _version,
    //       readOnly: false,
    //       // onUpgrade: onUpgrade,
    //       onCreate: onCreate);
    // } else {
    //   Directory databasePath = await getApplicationDocumentsDirectory();
    //   var path = p.join(databasePath.path, 'notesBookmarks.db');
    //   return (Platform.isWindows || Platform.isLinux)
    //       ? databaseFactoryFfi.openDatabase(path,
    //       options: OpenDatabaseOptions(
    //           version: _version,
    //           readOnly: false,
    //           // onUpgrade: onUpgrade,
    //           onCreate: onCreate))
    //       : openDatabase(path,
    //       version: _version,
    //       readOnly: false,
    //       // onUpgrade: onUpgrade,
    //       onCreate: onCreate);
    // }
    // var databasesPath = await getDatabasesPath();
    // var path = p.join(databasesPath, 'notesBookmarks.db');
    // Directory databasePath = await getApplicationDocumentsDirectory();
    // var path = p.join(databasePath.path, 'notesBookmarks.db');
    // return (Platform.isWindows || Platform.isLinux)
    //     ? databaseFactoryFfi.openDatabase(path,
    //         options: OpenDatabaseOptions(
    //             version: _version,
    //             readOnly: false,
    //             // onUpgrade: onUpgrade,
    //             onCreate: onCreate))
    //     : openDatabase(path,
    //         version: _version,
    //         readOnly: false,
    //         // onUpgrade: onUpgrade,
    //         onCreate: onCreate);
    /*try {
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
      }*/
    // }
  }

  Future onCreate(Database db, int version) async {
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
      'nomPageF INTEGER, '
      'nomPageL INTEGER, '
      'lastRead TEXT)',
    );
    print('create bookmarkTextTable');
    await db.execute(
      'CREATE TABLE bookmarkTextAyahTable ('
      'id INTEGER PRIMARY KEY, '
      'sorahName TEXT, '
      'sorahNum INTEGER, '
      'ayahNum INTEGER, '
      'nomPageF INTEGER, '
      'nomPageL INTEGER, '
      'lastRead TEXT)',
    );
    print('create bookmarkTextAyahTable');
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Database onUpgrade');
    /*oldVersion < newVersion ? await db.execute(
      'CREATE TABLE bookmarkTextTable ('
          'id INTEGER PRIMARY KEY, '
          'sorahName TEXT, '
          'sorahNum INTEGER, '
          'pageNum INTEGER, '
          'nomPageF INTEGER, '
          'nomPageL INTEGER, '
          'lastRead TEXT)',
    )
        : print('Database up to date');*/
    // for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
    //   await db.execute(
    //     'CREATE TABLE bookmarkTextTable ('
    //         'id INTEGER PRIMARY KEY, '
    //         'sorahName TEXT, '
    //         'sorahNum INTEGER, '
    //         'pageNum INTEGER, '
    //         'nomPageF INTEGER, '
    //         'nomPageL INTEGER, '
    //         'lastRead TEXT)',
    //   );
    //   // switch (version) {
    //   //   case 1: {
    //   //     //Version 1 - no changes (won't enter here)
    //   //     break;
    //   //   }
    //   //   case 2: {
    //   //     await db.execute(
    //   //       'CREATE TABLE bookmarkTextTable ('
    //   //           'id INTEGER PRIMARY KEY, '
    //   //           'sorahName TEXT, '
    //   //           'sorahNum INTEGER, '
    //   //           'pageNum INTEGER, '
    //   //           'nomPageF INTEGER, '
    //   //           'nomPageL INTEGER, '
    //   //           'lastRead TEXT)',
    //   //     );
    //   //     break;
    //   //   }
    //   // }
    // }
    // switch (newVersion) {
    //   case 3:
    //     await db.execute(
    //       'CREATE TABLE bookmarkTextTable ('
    //           'id INTEGER PRIMARY KEY, '
    //           'sorahName TEXT, '
    //           'sorahNum INTEGER, '
    //           'pageNum INTEGER, '
    //           'nomPageF INTEGER, '
    //           'nomPageL INTEGER, '
    //           'lastRead TEXT)',
    //     );
    //     break;
    // }
    var results = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='bookmarkTextTable'");
    if (results.isEmpty) {
      await db.execute(
        'CREATE TABLE bookmarkTextTable ('
            'id INTEGER PRIMARY KEY, '
            'sorahName TEXT, '
            'sorahNum INTEGER, '
            'pageNum INTEGER, '
            'nomPageF INTEGER, '
            'nomPageL INTEGER, '
            'lastRead TEXT)',
      );
      print('Upgrade bookmarkTextTable');
    }
    //   // await db.execute("ALTER TABLE bookmarkTextTable ADD COLUMN sorahNum TEXT");
    //   print('Database onUpgrade');
    //   // await db.execute("CREATE TABLE NewTable...") // create new Table
    // }
    // if (oldVersion < newVersion) {
    //   db.execute("ALTER TABLE bookmarkTextTable ADD COLUMN sorahNum TEXT;");
    //   print('Database onUpgrade');
    // }
  }

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
    return await _db!
        .delete(tableNote, where: '$columnId = ?', whereArgs: [note!.id]);
  }

  static Future<int> updateNote(Notes? note) async {
    print('Update Note');
    return await _db!.update(tableNote, note!.toJson(),
        where: "$columnId = ?", whereArgs: [note.id]);
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
    return await _db!.delete(tableBookmarks,
        where: '$columnBId = ?', whereArgs: [bookmarks!.id]);
  }

  // static Future<int> deleteBookmark(int? pageNum) async {
  //   print('Delete Bookmarks');
  //   return await _db!.delete(tableBookmarks,
  //       where: '$columnPageNum = ?', whereArgs: [pageNum]);
  // }

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
  static Future<int?> addBookmarkText(BookmarksText? bookmarksText) async {
    print('Save Text Bookmarks');
    try {
      return await _db!.insert(tableBookmarksText, bookmarksText!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteBookmarkText(BookmarksText? bookmarksText) async {
    print('Delete Text Bookmarks');
    return await _db!.delete(tableBookmarksText,
        where: '$columnTId = ?', whereArgs: [bookmarksText!.id]);
  }

  static Future<int> updateBookmarksText(BookmarksText bookmarksText) async {
    print('Update Text Bookmarks');
    return await _db!.update(tableBookmarksText, bookmarksText.toJson(),
        where: "$columnTId = ?", whereArgs: [bookmarksText.id]);
  }

  static Future<List<Map<String, dynamic>>> queryT() async {
    print('get Text Bookmarks');
    return await _db!.query(tableBookmarksText);
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
    return await _db!
        .delete(tableAzkar, where: '$columnCId = ?', whereArgs: [azkar!.id]);
  }

  static Future<int> updateAzkar(Azkar azkar) async {
    print('Update Azkar');
    return await _db!.update(tableAzkar, azkar.toJson(),
        where: "$columnCId = ?", whereArgs: [azkar.id]);
  }

  static Future<List<Map<String, dynamic>>> queryC() async {
    print('Update Azkar');
    return await _db!.query(tableAzkar);
  }

  /// bookmarks Text database
  static Future<int?> addBookmarkAyahText(BookmarksTextAyah? bookmarksTextAyah) async {
    print('Save Text Ayah Bookmarks');
    try {
      return await _db!.insert(tablebookmarkTextAyah, bookmarksTextAyah!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteBookmarkAyahText(BookmarksTextAyah? bookmarksTextAyah) async {
    print('Delete Text Ayah Bookmarks');
    return await _db!.delete(tablebookmarkTextAyah,
        where: '$columnAId = ?', whereArgs: [bookmarksTextAyah!.id]);
  }

  static Future<int> updateBookmarksAyahText(BookmarksTextAyah bookmarksTextAyah) async {
    print('Update Text Ayah Bookmarks');
    return await _db!.update(tablebookmarkTextAyah, bookmarksTextAyah.toJson(),
        where: "$columnAId = ?", whereArgs: [bookmarksTextAyah.id]);
  }

  static Future<List<Map<String, dynamic>>> queryA() async {
    print('get Text Ayah Bookmarks');
    return await _db!.query(tablebookmarkTextAyah);
  }

  Future close() async {
    return await _db!.close();
  }
}
