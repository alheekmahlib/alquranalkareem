import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran_library.dart';

void main() {
  group('TasmeeMode', () {
    test('إظهار الكلمات الافتراضي حسب النمط', () {
      expect(
        TasmeeMode.tasmee.showsWordsByDefault,
        isFalse,
        reason: 'التسميع الكلاسيكي يخفي الكلمات',
      );
      expect(TasmeeMode.corrector.showsWordsByDefault, isTrue);
      expect(TasmeeMode.teacher.showsWordsByDefault, isTrue);
    });

    test('tasmeeModeFromName: الأسماء المخزنة والقيم المجهولة', () {
      expect(tasmeeModeFromName('tasmee'), TasmeeMode.tasmee);
      expect(tasmeeModeFromName('corrector'), TasmeeMode.corrector);
      expect(tasmeeModeFromName('teacher'), TasmeeMode.teacher);
      expect(
        tasmeeModeFromName(null),
        TasmeeMode.tasmee,
        reason: 'لا اختيار محفوظ → الافتراضي',
      );
      expect(
        tasmeeModeFromName('future_mode'),
        TasmeeMode.tasmee,
        reason: 'قيمة من إصدار أحدث تُهمل بأمان',
      );
    });
  });
}
