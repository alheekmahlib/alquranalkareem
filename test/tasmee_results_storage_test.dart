import 'package:alquranalkareem/presentation/screens/quran_page/widgets/tasmee/data/data_source/tasmee_results_database.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/tasmee/data/models/tasmee_page_result.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/tasmee/data/repositories/tasmee_results_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran_library.dart';

void main() {
  group('TasmeeErrorSnapshot serialization', () {
    test('round-trip يحفظ حقول العرض كما هي', () {
      final error = const RecitationError(
        errorType: 'tajweed',
        speechErrorType: 'replace',
        wordText: 'ٱلرَّحْمَٰنِ',
        expectedPh: 'r a H',
        predictedPh: 'r a',
        expectedLen: 4,
        predictedLen: 2,
        suraIdx: 1,
        ayaIdx: 2,
        wordIdx: 3,
        refTajweedRules: [
          TajweedRule(nameAr: 'المد اللازم', nameEn: 'Lazem Madd'),
        ],
      );
      final snapshot = TasmeeErrorSnapshot.fromRecitationError(error);
      final restored = TasmeeErrorSnapshot.fromJson(
        Map<String, dynamic>.from(snapshot.toJson()),
      );

      expect(restored.errorType, 'tajweed');
      expect(restored.speechErrorType, 'replace');
      expect(restored.wordText, 'ٱلرَّحْمَٰنِ');
      expect(restored.expectedPh, 'r a H');
      expect(restored.predictedPh, 'r a');
      expect(restored.expectedLen, 4);
      expect(restored.ruleNameAr, 'المد اللازم');
      expect(restored.ruleNameEn, 'Lazem Madd');
      expect(restored.suraIdx, 1);
      expect(restored.wordIdx, 3);
    });

    test('toRecitationError يعيد بناء خطأ قابل للعرض بنفس البطاقات', () {
      const snapshot = TasmeeErrorSnapshot(
        errorType: 'normal',
        speechErrorType: 'insert',
        wordText: 'كلمة',
        expectedPh: 'a',
        ruleNameAr: 'قاعدة',
        ruleNameEn: 'Rule',
      );
      final error = snapshot.toRecitationError();
      expect(error.errorType, 'normal');
      expect(error.speechErrorType, 'insert');
      expect(error.wordText, 'كلمة');
      expect(error.refTajweedRules.first.nameAr, 'قاعدة');
    });
  });

  group('TasmeePageResult', () {
    test('العدادات والنسبة تُشتق من الأخطاء والكلمات', () {
      final result = TasmeePageResult(
        pageNumber: 27,
        mode: 'tasmee',
        completedAt: DateTime(2026, 9, 4),
        startSura: 21,
        startAya: 50,
        endSura: 21,
        endAya: 68,
        totalWords: 100,
        correctWords: 92,
        isFullyCorrect: false,
        errors: const [
          TasmeeErrorSnapshot(errorType: 'tajweed', speechErrorType: 'insert'),
          TasmeeErrorSnapshot(errorType: 'normal', speechErrorType: 'replace'),
          TasmeeErrorSnapshot(errorType: 'tashkeel', speechErrorType: 'delete'),
          TasmeeErrorSnapshot(errorType: 'normal', speechErrorType: 'insert'),
        ],
      );
      expect(result.totalErrors, 4);
      expect(result.tajweedErrors, 1);
      expect(result.normalErrors, 2);
      expect(result.tashkeelErrors, 1);
      expect(result.scorePercent, 92);
    });

    test('toRecitationResult نتيجة مطابِقة بنفس عدد الأخطاء', () {
      final result = TasmeePageResult(
        pageNumber: 3,
        mode: 'tasmee',
        completedAt: DateTime(2026, 9, 4),
        startSura: 2,
        startAya: 1,
        endSura: 2,
        endAya: 5,
        totalWords: 10,
        correctWords: 10,
        isFullyCorrect: true,
        errors: const [],
      );
      final recitation = result.toRecitationResult();
      expect(recitation.hasMatch, isTrue);
      expect(recitation.isFullyCorrect, isTrue);
      expect(recitation.start?.suraIdx, 2);
      expect(recitation.end?.ayaIdx, 5);
    });
  });

  group('TasmeeResultsRepository (drift في الذاكرة)', () {
    late TasmeeResultsRepository repo;

    setUp(() {
      repo = TasmeeResultsRepository(
        database: TasmeeResultsDatabase.forTesting(NativeDatabase.memory()),
      );
    });

    TasmeePageResult pageResult(
      int page, {
      DateTime? completedAt,
      int score = 90,
      List<TasmeeErrorSnapshot> errors = const [],
    }) {
      return TasmeePageResult(
        pageNumber: page,
        mode: 'tasmee',
        completedAt: completedAt ?? DateTime(2026, 9, 4),
        startSura: 21,
        startAya: 1,
        endSura: 21,
        endAya: 10,
        totalWords: 100,
        correctWords: score,
        isFullyCorrect: errors.isEmpty,
        errors: errors,
      );
    }

    test('upsert: أحدث نتيجة واحدة لكل صفحة', () async {
      await repo.saveLatest(
        pageResult(
          27,
          completedAt: DateTime(2026, 9, 1),
          errors: const [
            TasmeeErrorSnapshot(errorType: 'normal', speechErrorType: 'insert'),
          ],
        ),
      );
      await repo.saveLatest(pageResult(27, completedAt: DateTime(2026, 9, 4)));

      final pages = await repo.allPages();
      expect(pages.length, 1, reason: 'صف واحد لكل صفحة');
      expect(pages.first.correctWords, 90);
      expect(pages.first.totalErrors, 0, reason: 'النتيجة الأحدث فقط تبقى');
    });

    test('allPages: الأحدث إنجازًا أولًا', () async {
      await repo.saveLatest(pageResult(30, completedAt: DateTime(2026, 9, 1)));
      await repo.saveLatest(pageResult(28, completedAt: DateTime(2026, 9, 3)));
      await repo.saveLatest(pageResult(50, completedAt: DateTime(2026, 9, 2)));

      final pages = await repo.allPages();
      expect(pages.map((p) => p.pageNumber), [28, 50, 30]);
    });

    test('getByPage وdeleteByPage', () async {
      await repo.saveLatest(pageResult(27));
      expect((await repo.getByPage(27))?.pageNumber, 27);
      expect(await repo.getByPage(99), isNull);

      await repo.deleteByPage(27);
      expect(await repo.getByPage(27), isNull);
      expect(await repo.allPages(), isEmpty);
    });

    test('أخطاء النتيجة المحفوظة تعود كاملة بعد إعادة التحميل', () async {
      await repo.saveLatest(
        pageResult(
          27,
          errors: const [
            TasmeeErrorSnapshot(
              errorType: 'tajweed',
              speechErrorType: 'replace',
              wordText: 'ٱلرَّحْمَٰنِ',
              expectedPh: 'r a H',
              ruleNameAr: 'المد اللازم',
            ),
          ],
        ),
      );
      final saved = await repo.getByPage(27);
      expect(saved!.errors.length, 1);
      expect(saved.errors.first.wordText, 'ٱلرَّحْمَٰنِ');
      expect(saved.errors.first.ruleNameAr, 'المد اللازم');
    });
  });
}
