import 'package:flutter_test/flutter_test.dart';

import 'package:alquranalkareem/database/bookmark_db/bookmark_database.dart';

/// يعالج عقد AdhkarData.fromJson مع ملف azkar.json الثابت الذي لا يحتوي
/// أعمدة المزامنة (updatedAt/deleted/syncUuid) — انظر adhkar_controller.
void main() {
  // شكل عنصر azkar.json كما هو في الأصول (بلا أي مفتاح مزامنة).
  final legacyAzkarJson = <String, dynamic>{
    'id': 1,
    'category': 'أذكار الصباح',
    'count': '3',
    'description': 'd',
    'reference': 'r',
    'zekr': 'z',
  };

  test('fromJson الخام مع JSON قديم ينهار — توثيق السبب الجذري', () {
    // عقد drift المولد: العمود غير القابل للـ null بلا مفتاح يقابل null
    // cast يفشل. هذا الاختبار يثبّت السبب؛ لو غيّرت drift السلوك يومًا
    // فحدّث الاستدعاء في adhkar_controller accordingly.
    expect(
      () => AdhkarData.fromJson(legacyAzkarJson),
      throwsA(isA<TypeError>()),
    );
  });

  test('fromJson مع القيم المُحقونة (نمط المتحكم) ينجح', () {
    final data = AdhkarData.fromJson({
      ...legacyAzkarJson,
      'updatedAt': 0,
      'deleted': false,
    });
    expect(data.category, 'أذكار الصباح');
    expect(data.updatedAt, 0);
    expect(data.deleted, isFalse);
    expect(data.syncUuid, isNull);
  });
}
