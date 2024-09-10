import 'package:drift/drift.dart';

class QuranTable extends Table {
  IntColumn get id => integer().named('ID').autoIncrement()();
  IntColumn get surahNum => integer().named('SoraNum')();
  IntColumn get ayaNum => integer().named('AyaNum')();
  IntColumn get pageNum => integer().named('PageNum').nullable()();
  TextColumn get sorahName => text().named('SoraName_ar')();
  TextColumn get sorahNameEn => text().named('SoraName_En')();
  TextColumn get ayaText => text().named('AyaDiac')();
  TextColumn get searchTextColumn => text().named('SearchText')();
  TextColumn get soraNameSearch => text().named('SoraNameSearch')();
  IntColumn get partNum => integer().named('PartNum')();
}

// class Aya {
//   static String tableName = "Quran";
//   late int id;
//   late int surahNum;
//   late int ayaNum;
//   dynamic pageNum;
//   late String sorahName;
//   late String sorahNameEn;
//   late String text;
//   late String SearchText;
//   late String soraNameSearch;
//   late int partNum;
//
//   static final columns = [
//     "ID",
//     "SoraNum",
//     'AyaNum',
//     'PageNum',
//     'SoraName_ar',
//     'SoraName_En',
//     'SoraNameSearch',
//     'AyaDiac',
//     'SearchText',
//     'PartNum'
//   ];
//
//   Map toMap() {
//     Map map = {
//       "SoraNum": surahNum,
//       "AyaNum": ayaNum,
//       "PageNum": pageNum,
//       "SoraName_ar": sorahName,
//       "SoraName_En": sorahNameEn,
//       "AyaDiac": text,
//       "SearchText": SearchText,
//       "SoraNameSearch": soraNameSearch,
//       "PartNum": partNum,
//     };
//
//     map["ID"] = id;
//
//     return map;
//   }
//
//   static fromMap(Map map) {
//     Aya aya = Aya();
//     aya.id = map["ID"];
//     aya.sorahName = map["SoraName_ar"];
//     aya.sorahNameEn = map["SoraName_En"];
//     aya.ayaNum = map["AyaNum"];
//     aya.surahNum = map["SoraNum"];
//     aya.text = map["AyaDiac"];
//     aya.SearchText = map["SearchText"];
//     aya.soraNameSearch = map["SoraNameSearch"];
//     aya.partNum = map["PartNum"];
//     aya.pageNum = map["PageNum"];
//     return aya;
//   }
// }
