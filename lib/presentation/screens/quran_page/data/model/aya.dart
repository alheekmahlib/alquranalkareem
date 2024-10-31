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
