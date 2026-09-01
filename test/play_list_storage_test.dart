import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:alquranalkareem/presentation/screens/quran_page/widgets/playlist/data/models/playList_model.dart';

/// يثبّت عقد تخزين قوائم التشغيل (playList):
/// تُخزَّن القوائم كـ List<String> من JSON — الصيغة نفسها التي كانت
/// SharedPreferences تكتبها والتي يقرؤها GetStorage بعد الترحيل.
void main() {
  PlayListModel buildPlayList({required int id}) => PlayListModel(
    id: id,
    name: 'الفاتحة',
    readerName: 'الحوصري',
    fromSurahNumber: 1,
    fromSurahName: 'سُورَةُ الفاتحة',
    fromAyah: 1,
    fromAyahUQ: 1,
    toSurahNumber: 2,
    toSurahName: 'سُورَةُ البقرة',
    toAyah: 141,
    toAyahUQ: 148,
    createdAt: '2026-01-01T00:00:00.000',
  );

  test('الصيغة المخزنة (قائمة نصوص JSON) تعود كما كُتبت', () {
    final playLists = [buildPlayList(id: 0), buildPlayList(id: 1)];

    // الكتابة بنمط savePlayList
    final stored = playLists.map((r) => jsonEncode(r.toJson())).toList();

    // القراءة بنمط loadPlayList
    final loaded = stored
        .map((r) => PlayListModel.fromJson(jsonDecode(r)))
        .toList();

    expect(loaded.length, 2);
    expect(loaded[0].id, 0);
    expect(loaded[1].id, 1);
    expect(loaded[1].fromAyahUQ, 1);
    expect(loaded[1].toAyahUQ, 148);
    expect(loaded[1].readerName, 'الحوصري');
  });

  test('قائمة فارغة تعود فارغة بعد الدورة الكاملة', () {
    final stored = <String>[];
    final loaded = stored
        .map((r) => PlayListModel.fromJson(jsonDecode(r)))
        .toList();
    expect(loaded, isEmpty);
  });

  test(
    'الترميز القديم (startNum) ما زال مقروءًا — حماية بيانات النسخ السابقة',
    () {
      final legacyJson = jsonEncode({
        'id': 3,
        'name': 'قائمة قديمة',
        'readerName': 'المنشاوي',
        'surahNum': 1,
        'surahName': 'سُورَةُ الفاتحة',
        'startNum': 1,
        'startUQNum': 1,
        'endNum': 7,
        'endUQNum': 7,
      });
      final loaded = PlayListModel.fromJson(jsonDecode(legacyJson));
      expect(loaded.fromSurahNumber, 1);
      expect(loaded.toAyahUQ, 7);
      expect(loaded.totalAyahs, 7);
    },
  );
}
