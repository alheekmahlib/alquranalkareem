import 'package:drift/drift.dart';

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sorahName => text()();
  IntColumn get pageNum => integer()();
  TextColumn get lastRead => text()();

  // أعمدة مزامنة الأجهزة عبر QR — انظر docs/superpowers/specs
  TextColumn get syncUuid => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
}

// class Bookmarks {
//   int? id;
//   String? sorahName;
//   int? pageNum;
//   String? lastRead;
//
//   Bookmarks({this.id, this.sorahName, this.pageNum, this.lastRead});
//
//   Map<String, dynamic> toJson() {
//     return <String, dynamic>{
//       'id': id,
//       'sorahName': sorahName,
//       'pageNum': pageNum,
//       'lastRead': lastRead,
//     };
//   }
//
//   Bookmarks.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     sorahName = json['sorahName'];
//     pageNum = json['pageNum'];
//     lastRead = json['lastRead'];
//   }
// }
