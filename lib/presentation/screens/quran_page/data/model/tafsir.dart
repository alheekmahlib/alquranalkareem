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

List<String> tafsirTableName = [
  'ibnkatheer',
  'baghawy',
  'qurtubi',
  'saadi',
  'tabari',
];

class TafsirTable extends Table {
  IntColumn get id => integer().named('index').autoIncrement()();
  IntColumn get surahNum => integer().named('sura')();
  IntColumn get ayahNum => integer().named('aya')();
  TextColumn get tafsirText => text().named('Text')();
  IntColumn get pageNum => integer().named('PageNum')();
}
