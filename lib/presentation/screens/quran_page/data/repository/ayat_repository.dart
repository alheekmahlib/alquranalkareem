import '../data_source/quran_database.dart';

class AyatRepository {
  List<QuranTableData>? ayatListNot;

  Future<List<QuranTableData>> getPageAyat(int pageNum) async {
    final db = QuranDatabase();

    if (ayatListNot != null) {
      return ayatListNot!;
    }

    print('isReloading');

    final results = await (db.select(db.quranTable)
          ..where((t) => t.pageNum.equals(pageNum)))
        .get();

    ayatListNot = results;

    return results;
  }

  Future<List<QuranTableData>> getAllAyah(int surahNumber) async {
    final db = QuranDatabase();

    final results = await (db.select(db.quranTable)
          ..where((t) => t.surahNum.equals(surahNumber)))
        .get();

    return results;
  }
}
