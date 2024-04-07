import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/khatmah_model.dart';

part 'khatmah_database.g.dart';

@DriftDatabase(tables: [Khatmahs])
class KhatmahDatabase extends _$KhatmahDatabase {
  KhatmahDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Khatmah>> getAllKhatmas() => select(khatmahs).get();
  Future insertKhatma(Insertable<Khatmah> khatma) =>
      into(khatmahs).insert(khatma);
  Future updateKhatma(Insertable<Khatmah> khatma) =>
      update(khatmahs).replace(khatma);
  Future deleteKhatma(Insertable<Khatmah> khatma) =>
      delete(khatmahs).delete(khatma);

  Future<void> deleteKhatmaById(int id) async {
    await (delete(khatmahs)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'khatmah.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
