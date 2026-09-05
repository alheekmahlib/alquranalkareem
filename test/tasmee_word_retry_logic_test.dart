import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran_library.dart';

/// تحقق منطقي (نقي بلا محرك) لمسار إعادة نطق الكلمة في المصحح:
/// بناء مدى الكلمة الواحدة + الحكم بالتقييم المرجعي (محاذاة + كشف
/// أخطاء) الذي يتسامح مع وحدات CTC الضوضائية الافتتاحية — عكس التتبّع
/// الحيّ الاسترشادي الذي كان يعتبرها خطأً دائمًا.
void main() {
  // وحدات اختبارية: كلمة أولى (ب، س) وكلمة ثانية (ر، ح، م).
  QuranUnit unit(String symbol, String letter, {int id = 1}) =>
      QuranUnit(symbol: symbol, id: id, letter: letter, coreRepeat: 1);

  final word0 = [unit('بـ', 'ب', id: 2), unit('سـ', 'س', id: 3)];
  final word1 = [
    unit('ر~', 'ر', id: 4),
    unit('حـ', 'ح', id: 5),
    unit('مـ', 'م', id: 6),
  ];

  QuranReferenceVerse buildVerse() => QuranReferenceVerse(
    verseKey: '1:1',
    uthmani: 'بِسْمِ الرَّحْمَٰنِ',
    phonemeString: 'b s r H m',
    phonemeWords: const ['b s', 'r H m'],
    uthmaniWords: const ['بِسْمِ', 'الرَّحْمَٰنِ'],
    units: [...word0, ...word1],
    unitWordIdx: [0, 0, 1, 1, 1],
  );

  group('QuranReferenceRange.fromSingleWord', () {
    test('مدى من وحدات الكلمة المطلوبة وحدها', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 1);
      expect(range, isNotNull);
      expect(range!.units.length, 3, reason: 'وحدات الكلمة الثانية فقط');
      expect(range.units.first.letter, 'ر');
      expect(range.wordSpans.length, 1);
      expect(range.wordSpans.first.wordIdx, 1);
      expect(range.wordSpans.first.startUnit, 0);
      expect(range.wordSpans.first.endUnit, 2);
      expect(range.wordCount, 1);
      expect(range.keyOfVerse(0), (suraIdx: 1, ayaIdx: 1));
    });

    test('كلمة بلا وحدات تُعيد null', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 9);
      expect(range, isNull);
    });
  });

  group('حكم إعادة النطق بالمسار المرجعي', () {
    test('نطق مثالي → بلا أخطاء (isFullyCorrect)', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 1)!;
      final ops = dropLeadingInserts(alignUnits(range.units, word1));
      final stats = computeUnitStats(ops);
      expect(stats.matches, 3);
      expect(stats.insertions + stats.deletions + stats.replacements, 0);
      final errors = buildErrorsFromUnitAlignment(
        ops: ops,
        refUnits: range.units,
        predUnits: word1,
        wordAt: range.wordAt,
      );
      expect(errors, isEmpty, reason: 'الحكم: صحيحة');
    });

    test('وحدة ضوضائية افتتاحية من CTC لا تُفشل المحاولة', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 1)!;
      // حرف دخيل في البداية (كما يصدر عن CTC قبل الكلمة) ثم نطق سليم.
      final noisy = [unit('ا', 'ا', id: 7), ...word1];
      final ops = dropLeadingInserts(alignUnits(range.units, noisy));
      final errors = buildErrorsFromUnitAlignment(
        ops: ops,
        refUnits: range.units,
        predUnits: noisy,
        wordAt: range.wordAt,
      );
      expect(
        errors,
        isEmpty,
        reason: 'التسامح مع البادئ — سبب فشل الحكم الحيّ السابق',
      );
    });

    test('نطق خاطئ فعليًا → أخطاء مكتشفة', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 1)!;
      // استبدال حرف الحاء بالخاء في المنتصف.
      final wrong = [word1[0], unit('خـ', 'خ', id: 8), word1[2]];
      final ops = dropLeadingInserts(alignUnits(range.units, wrong));
      final errors = buildErrorsFromUnitAlignment(
        ops: ops,
        refUnits: range.units,
        predUnits: wrong,
        wordAt: range.wordAt,
      );
      expect(errors, isNotEmpty, reason: 'الحكم: خاطئة');
    });
  });
}
