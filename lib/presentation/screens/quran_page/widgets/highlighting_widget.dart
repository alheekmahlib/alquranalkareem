import 'dart:io';

import 'package:alquranalkareem/presentation/controllers/general_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/services/services_locator.dart';

class Verse {
  final int id;
  final int sura;
  final int aya;
  final int safha;
  final int x;
  final int y;

  const Verse({
    required this.id,
    required this.sura,
    required this.aya,
    required this.safha,
    required this.x,
    required this.y,
  });
  static Verse fromMap(Map<String, dynamic> map) => Verse(
        id: map['id'] as int,
        sura: map['sura'] as int,
        aya: map['aya'] as int,
        safha: map['safha'] as int,
        x: map['x'] as int,
        y: map['y'] as int,
      );
}

class HighlightingWidget extends StatefulWidget {
  final int safha;
  const HighlightingWidget({super.key, required this.safha});

  @override
  State<HighlightingWidget> createState() => _HighlightingWidgetState();
}

class _HighlightingWidgetState extends State<HighlightingWidget> {
  int _highlightedVerseId = -1;

  @override
  void initState() {
    DBHelper().getVerses(widget.safha);
    super.initState();
  }

  void setHighlightedVerse(int id) {
    setState(() {
      _highlightedVerseId = id;
    });
  }

  Widget _buildHighlightBox(int highlightedVerseId) {
    if (highlightedVerseId == -1) {
      return const SizedBox(); // Placeholder when no verse is highlighted
    }

    final highlightedVerse = sl<GeneralController>()
        .verses
        .firstWhere((verse) => verse.id == highlightedVerseId);

    return Positioned(
      left: highlightedVerse.x.toDouble(),
      top: highlightedVerse.y.toDouble(),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(0.5),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        // Add any additional content or widgets within the highlight box
        // child: Text(
        //   highlightedVerse
        //       .text, // Display verse text or other relevant information
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 16.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Show the Qur'an image for the current page
        Image.asset('assets/pages/00${widget.safha}.png'),

        // Overlay a transparent container for highlighting
        Positioned.fill(
          child: GestureDetector(
            onTapDown: (details) async {
              final x = details.localPosition.dx;
              final y = details.localPosition.dy;

              // Check if tap is within any verse area
              final verses = await DBHelper().getVerses(widget.safha);
              if (verses != null) {
                final highlightedVerse = verses.firstWhereOrNull(
                  (verse) =>
                      x >= verse.x &&
                      x <= verse.x + 100 &&
                      y >= verse.y &&
                      y <= verse.y + 50,
                );

                if (highlightedVerse != null) {
                  setHighlightedVerse(highlightedVerse.id);
                }
              } else {
                // Show loading indicator or error message
              }
            },
            child: Container(
              color: Colors.transparent,

              // Show highlight box based on _highlightedVerseId
              child: AnimatedOpacity(
                opacity: _highlightedVerseId == -1 ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Stack(
                  children: [
                    _buildHighlightBox(_highlightedVerseId),
                  ],
                ), // Use the separate function
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DBHelper {
  static const _databaseName = "ayat.ayt";
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
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      return await openDatabase(path);
    }
  }

  Future<List<Verse>> getVerses(int safha) async {
    final db = await database;
    final results =
        await db.query('amaken_hafs', where: 'safha = ?', whereArgs: [safha]);
    final verses = results.map((map) => Verse.fromMap(map)).toList();
    sl<GeneralController>().verses = verses; // Explicitly assign converted list
    return verses;
  }

  Future<List<Map<String, dynamic>>> getVersesForCurrentPage(
      int currentPage) async {
    // You need to open the database first, if it's not already open
    Database db = await database;

    // Assuming you have a table named 'verses' with a 'page_number' column
    List<Map<String, dynamic>> result = await db
        .query('amaken_hafs', where: 'safha = ?', whereArgs: [currentPage]);
    return result;
  }
}
