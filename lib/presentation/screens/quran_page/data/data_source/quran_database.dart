import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/aya.dart';

part 'quran_database.g.dart';

@DriftDatabase(tables: [QuranTable])
class QuranDatabase extends _$QuranDatabase {
  QuranDatabase._internal() : super(_openConnection());

  static final QuranDatabase _instance = QuranDatabase._internal();

  factory QuranDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  Future<List<QuranTableData>> getAyahsBySurah(String surahName) {
    return (select(quranTable)
          ..where((t) => t.soraNameSearch.equals(surahName)))
        .get();
  }

  Future<List<QuranTableData>> searchAyahs(String searchText) async {
    /// TODO: هنا المشكلة يا هلال
    final results = await customSelect(
      'SELECT * FROM Quran WHERE SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?',
      variables: [
        Variable.withString('%$searchText%'), // SearchText
        Variable.withString(searchText), // PageNum
        Variable.withString('%$searchText%'), // SoraNameSearch
        Variable.withString('%$searchText%'), // SoraName_En
      ],
    ).get();

    // تحويل النتائج إلى نموذج QuranTableData
    return results.map((row) {
      return QuranTableData(
        id: row.read<int>('ID'),
        partNum: row.read<int>('PartNum'),
        pageNum: row.read<int>('PageNum'),
        surahNum: row.read<int>('SoraNum'),
        sorahNameEn: row.read<String>('SoraName_En'),
        sorahName: row.read<String>('SoraName_ar'),
        ayaNum: row.read<int>('AyaNum'),
        ayaText: row.read<String>('AyaDiac'),
        searchTextColumn: row.read<String>('SearchText'),
        soraNameSearch: row.read<String>('SoraNameSearch'),
      );
    }).toList();
  }

  Future<List<QuranTableData>> fetchAyahsByPage(int offset, int limit) {
    return (select(quranTable)..limit(limit, offset: offset)).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'QuranV3.sqlite'));

    if (!await file.exists()) {
      throw Exception('Database file not found!');
    }

    return NativeDatabase(file);
  });
}

// class DataBaseClient {
//   final _databaseName = "QuranV3.sqlite";
//
//   // make this a singleton class
//   DataBaseClient._privateConstructor();
//   static final DataBaseClient instance = DataBaseClient._privateConstructor();
//
//   // only have a single app-wide reference to the database
//   static Database? _database;
//
//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     print('db == null => ${_database == null}');
//     // lazily instantiate the db the first time it is accessed
//     await initDatabase();
//     _database = await _openDatabase(_databaseName);
//     print('db == null => ${_database == null}');
//     return _database;
//   }
//
//   Future _openDatabase(String fileName) async {
//     sqfliteFfiInit();
//     Directory databasePath = await getApplicationDocumentsDirectory();
//     var path = join(databasePath.path, fileName);
//     return (Platform.isWindows || Platform.isLinux)
//         ? databaseFactoryFfi.openDatabase(path, options: OpenDatabaseOptions())
//         : openDatabase(path);
//   }
//
//   Future initDatabase() async {
//     // Get the application documents directory
//     Directory databasesPath = await getApplicationDocumentsDirectory();
//     var path = join(databasesPath.path, _databaseName);
//     // Check if the database exists
//     var exists = await databaseExists(path);
//
//     if (!exists) {
//       print("Creating new copy from asset");
//
//       // Make sure the parent directory exists
//       try {
//         await File(path).create(recursive: true);
//       } catch (e) {
//         print('Directory creation failed: $e');
//         return; // Exit if cannot create directory
//       }
//
//       // Copy from asset
//       ByteData data = await rootBundle.load(join("assets", _databaseName));
//       // The declaration and assignment of 'bytes' happen before its usage.
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//       try {
//         // Write and flush the bytes written
//         await File(path).writeAsBytes(bytes, flush: true);
//         print("Database copied from assets to $path");
//
//         // After the file write, check if the file exists
//         if (await File(path).exists()) {
//           print("Confirmed: Database file exists at $path");
//         } else {
//           print("Error: Database file does not exist at $path");
//         }
//       } catch (e) {
//         print('Failed to write to the database file: $e');
//       }
//     } else {
//       print("Opening existing database");
//       // It would also be good to check if the file exists here as well
//       if (await File(path).exists()) {
//         print("Confirmed: Database file exists and can be opened at $path");
//       } else {
//         print(
//             "Error: The database file does not exist at $path. Cannot open the database.");
//       }
//     }
//   }
//
//   static Future<void> close() async {
//     await _database!.close();
//   }
// }
