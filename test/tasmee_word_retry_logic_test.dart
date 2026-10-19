import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran_library.dart';

/// تحقق منطقي (نقي بلا محرك) لمسار إعادة نطق الكلمة في المصحح:
/// بناء مدى الكلمة الواحدة + الحكم بالتقييم المرجعي (محاذاة + كشف
/// أخطاء) الذي يتسامح مع وحدات CTC الضوضائية الافتتاحية — عكس التتبّع
/// الحيّ الاسترشادي الذي كان يعتبرها خطأً دائمًا.
void main() {
  // وحدات اختبارية: كلمة أولى (ب، س) وكلمة ثانية (ر، ح، م) وكلمة ثالثة
  // (س، ي، د، ن، م) — الخمسية تتيح الإرساء السريع (fastAnchorUnits=5).
  QuranUnit unit(String symbol, String letter, {int id = 1}) =>
      QuranUnit(symbol: symbol, id: id, letter: letter, coreRepeat: 1);

  final word0 = [unit('بـ', 'ب', id: 2), unit('سـ', 'س', id: 3)];
  final word1 = [
    unit('ر~', 'ر', id: 4),
    unit('حـ', 'ح', id: 5),
    unit('مـ', 'م', id: 6),
  ];
  final word2 = [
    unit('س~', 'س', id: 12),
    unit('يـ', 'ي', id: 13),
    unit('د~', 'د', id: 14),
    unit('نـ', 'ن', id: 15),
    unit('م~', 'م', id: 16),
  ];

  QuranReferenceVerse buildVerse() => QuranReferenceVerse(
    verseKey: '1:1',
    uthmani: 'بِسْمِ الرَّحْمَٰنِ السَّيْدِنِمْ',
    phonemeString: 'b s r H m s y d n m',
    phonemeWords: const ['b s', 'r H m', 's y d n m'],
    uthmaniWords: const ['بِسْمِ', 'الرَّحْمَٰنِ', 'السَّيْدِنِمْ'],
    units: [...word0, ...word1, ...word2],
    unitWordIdx: [0, 0, 1, 1, 1, 2, 2, 2, 2, 2],
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

  group('RangeLiveTracker — تفصيل خطأ الكلمة للمصحح', () {
    ({TasmeeErrorKind kind, TasmeeWordMistake? mistake}) runTracker(
      QuranReferenceRange range,
      List<QuranUnit> pred,
    ) {
      TasmeeErrorKind firedKind = TasmeeErrorKind.correct;
      TasmeeWordMistake? firedMistake;
      final tracker = RangeLiveTracker(
        range: range,
        onWordDone: (v, w, kind, mistake) {
          firedKind = kind;
          firedMistake = mistake;
        },
      );
      tracker.onUnits(pred);
      return (kind: firedKind, mistake: firedMistake);
    }

    test('استبدال: نفس الحرف برمز مختلف — متوقع/منطوق بالرموز', () {
      // كلمة خمسية يُستبدل وسطها بحركة مختلفة (نفس الحرف، رمز مختلف) —
      // انحراف الحركة الواحد لا يُسقط الإرساء السريع (تسامح 5.0.3)
      // فيُصنَّف التفصيل لحظة الاكتمال.
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 2)!;
      final replaced = [
        word2[0],
        unit('يَ', 'ي', id: 10),
        word2[2],
        word2[3],
        word2[4],
      ];
      final r = runTracker(range, replaced);
      expect(r.kind, isNot(TasmeeErrorKind.correct));
      expect(r.mistake, isNotNull);
      expect(r.mistake!.errorType, 'replace');
      expect(r.mistake!.expectedSymbol, 'يـ');
      expect(r.mistake!.predictedSymbol, 'يَ');
    });

    test('إدراج: نطق زائد — يُبلَّغ بالوحدة الزائدة', () {
      // إرساء على أول خمس وحدات من الآية ثم قاف دخيلة وسط الكلمة
      // الثالثة — تُوسم زيادة على الكلمة الجارية عند اكتمالها.
      final range = QuranReferenceRange.fromVerses([buildVerse()])!;
      final inserted = [
        ...word0,
        ...word1,
        word2[0],
        unit('ق', 'ق', id: 11),
        ...word2.skip(1),
      ];
      final r = runTracker(range, inserted);
      expect(r.kind, TasmeeErrorKind.normal);
      expect(r.mistake!.errorType, 'insert');
      expect(r.mistake!.predictedSymbol, 'ق');
    });

    test('نطق سليم → kind=correct وبلا تفصيل', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 2)!;
      final r = runTracker(range, word2);
      expect(r.kind, TasmeeErrorKind.correct);
      expect(r.mistake, isNull);
    });
  });

  group('إصلاح الجمود على كلمة — تسامح الحدود والقبول النسبي', () {
    // سلسلة تسامح الكلمة الواحدة نفسها المعتمدة في تقييم المكتبة.
    List<UnitAlignOp> singleWordOps(
      List<QuranUnit> ref,
      List<QuranUnit> pred,
    ) => dropTrailingDeletes(
      dropLeadingDeletes(
        dropTrailingInserts(
          dropLeadingInserts(alignUnits(ref, pred)),
          maxUnits: 2,
        ),
        maxUnits: 1,
      ),
      maxUnits: 1,
    );

    List<RecitationError> evaluate(List<QuranUnit> ref, List<QuranUnit> pred) =>
        buildErrorsFromUnitAlignment(
          ops: singleWordOps(ref, pred),
          refUnits: ref,
          predUnits: pred,
          wordAt: QuranReferenceRange.fromSingleWord(buildVerse(), 1)!.wordAt,
        );

    test('سقوط وحدة البداية من التعرف (حدّ CTC) → لا خطأ حروف رادع', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 1)!;
      final errors = evaluate(range.units, word1.sublist(1));
      expect(
        errors.where((e) => e.errorType == 'normal'),
        isEmpty,
        reason: 'سقوط الراء الأولى كان يُفشل المحاولة مهما كُررت',
      );
    });

    test('سقوط وحدة الذيل من التعرف (حدّ CTC) → لا خطأ حروف رادع', () {
      final range = QuranReferenceRange.fromSingleWord(buildVerse(), 1)!;
      final errors = evaluate(range.units, word1.sublist(0, 2));
      expect(errors.where((e) => e.errorType == 'normal'), isEmpty);
    });

    test('خطأ حرف رادع مع دقة ≥ 75% → المحاولة مقبولة (كلمة طويلة)', () {
      // كلمة 7 وحدات باستبدال واحدة → دقة 6/7 ≈ 0.857.
      const result = RecitationResult(
        uthmaniText: 'كلمة',
        unitAccuracy: 6 / 7,
        errors: [
          RecitationError(
            errorType: 'normal',
            speechErrorType: 'replace',
            expectedPh: 'س',
            predictedPh: 'ص',
          ),
        ],
      );
      expect(isWordRetryAcceptable(result), isTrue);
    });

    test('خطأ حرف رادع مع دقة < 75% (كلمة قصيرة) → تبقى مرفوضة', () {
      const result = RecitationResult(
        uthmaniText: 'كلمة',
        unitAccuracy: 1 / 2,
        errors: [
          RecitationError(
            errorType: 'normal',
            speechErrorType: 'replace',
            expectedPh: 'س',
            predictedPh: 'ص',
          ),
        ],
      );
      expect(isWordRetryAcceptable(result), isFalse);
    });
  });
}
