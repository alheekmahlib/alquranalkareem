import 'package:drift/drift.dart';

enum MufaserName {
  ibnkatheer,
  baghawy,
  qurtubi,
  saadi,
  tabari,
}

List<String> tafsirDBName = [
  'ibnkatheerV2.sqlite',
  'baghawyV2.db',
  'qurtubiV2.db',
  'saadiV3.db',
  'tabariV2.db',
];

class TafsirTable extends Table {
  IntColumn get id => integer().named('index').autoIncrement()();
  IntColumn get surahNum => integer().named('sura')();
  IntColumn get ayahNum => integer().named('aya')();
  TextColumn get tafsirText => text().named('Text')();
  IntColumn get pageNum => integer().named('PageNum')();
}
// class Tafsir {
//   late int index;
//   late int surah;
//   late int aya;
//   late String tafsirText;
//   late int pageNum;
//
//   static final columns = ["index", "sura", 'aya', 'text', 'PageNum'];
//
//   static fromMap(Map map) {
//     Tafsir translate = Tafsir();
//     translate.index = map["index"];
//     translate.aya = map["aya"];
//     translate.surah = map["sura"];
//     translate.tafsirText = map["text"];
//     translate.pageNum = map['PageNum'];
//     return translate;
//   }
//   // static Tafseer fromMap(Map<String, Object?> map, String mufaserName) {
//   //   Tafseer translate = Tafseer();
//   //   translate.mufaserName = mufaserName;
//   //   translate.index = (map["index"] as int?)!;
//   //   translate.aya = (map["aya"] as int?)!;
//   //   translate.surah = (map["sura"] as int?)!;
//   //   translate.text = (map["text"] as String?)!;
//   //   translate.pageNum = (map['PageNum'] as int?)!;
//   //   return translate;
//   // }
// }
