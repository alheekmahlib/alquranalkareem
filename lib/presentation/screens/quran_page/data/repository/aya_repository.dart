import '../data_source/quran_database.dart';

class AyaRepository {
  static Future<List<QuranTableData>> searchAyahs(String text) async {
    final db = QuranDatabase();
    return await db.searchAyahs(text);
  }

  static Future<List<QuranTableData>> getAyahsBySurah(String surahName) async {
    final db = QuranDatabase();
    return await db.searchSurah(surahName);
  }

  static Future<List<QuranTableData>> fetchAyahsByPage(
      int offset, int limit) async {
    final db = QuranDatabase();
    return await db.fetchAyahsByPage(offset, limit);
  }
}
