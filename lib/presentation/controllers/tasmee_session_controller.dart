import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../screens/quran_page/quran.dart';
import '../screens/quran_page/widgets/tasmee/data/models/tasmee_page_result.dart';
import '../screens/quran_page/widgets/tasmee/data/repositories/tasmee_results_repository.dart';

/// منسّق جلسات التسميع — يمتلك كل منطق دورة الحياة خارج المكتبة:
/// حفظ نتائج الصفحات عند اكتمالها، و(لاحقًا) حلقتا مصحح التلاوة
/// ومعلم القرآن. الواجهات تبقى Stateless وتقرأ حقول Rx فقط.
///
/// إعدادات النموذج وفتح ورقة النتائج التلقائي يبقيان في
/// [TasmeeSettingsController] — مسؤولية واحدة لكل كونترولر.
class TasmeeSessionController extends GetxController {
  static TasmeeSessionController get instance {
    // تسجيل دائم مثل TasmeeSettingsController: كائن واحد طوال عمر
    // التطبيق لا يُحذف مع المسارات (SmartManagement).
    if (GetInstance().isRegistered<TasmeeSessionController>()) {
      return GetInstance().find<TasmeeSessionController>();
    }
    return Get.put(TasmeeSessionController(), permanent: true);
  }

  TasmeeSessionController({TasmeeResultsRepository? repository})
    : _repository = repository ?? TasmeeResultsRepository();

  final TasmeeResultsRepository _repository;

  /// الصفحات المنجزة (الأحدث أولًا) — تُحدث بعد كل حفظ/حذف/تحميل.
  final results = <TasmeePageResult>[].obs;

  /// جارٍ تحميل القائمة؟
  final isLoadingResults = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenForSessionFinished();
    _listenForWordCorrection();
    _listenForWordRetryOutcome();
    loadResults();
  }

  /// عند اكتمال تقييم جلسة مطابِقة تُحفظ نتيجة صفحتها — يستبدل أي
  /// نتيجة سابقة لنفس الصفحة (الأحدث فقط).
  void _listenForSessionFinished() {
    // الكونترولر دائم — المستمع يعيش مدى التطبيق كنمط إعدادات التسميع.
    ever<RecitationState>(TasmeeCtrl.instance.state.sessionState, (s) async {
      if (s == RecitationState.finished) {
        await _saveCurrentPageResult();
      }
    });
  }

  Future<void> _saveCurrentPageResult() async {
    final state = TasmeeCtrl.instance.state;
    final result = state.lastResult.value;
    final page = state.currentRangePage;
    if (result == null || !result.hasMatch || page <= 0) return;

    final correct = state.wordStatuses.values
        .where((s) => s == TasmeeWordStatus.correct)
        .length;
    final total = state.totalWords.value > 0 ? state.totalWords.value : correct;
    final start = result.start;
    final end = result.end ?? start;

    try {
      await _repository.saveLatest(
        TasmeePageResult(
          pageNumber: page,
          mode: state.mode.value.name,
          completedAt: DateTime.now(),
          startSura: start?.suraIdx ?? 1,
          startAya: start?.ayaIdx ?? 1,
          endSura: end?.suraIdx ?? start?.suraIdx ?? 1,
          endAya: end?.ayaIdx ?? start?.ayaIdx ?? 1,
          totalWords: total,
          correctWords: correct,
          isFullyCorrect: result.isFullyCorrect,
          errors: result.errors
              .map(TasmeeErrorSnapshot.fromRecitationError)
              .toList(),
        ),
      );
      await loadResults();
    } catch (e) {
      debugPrint('TasmeeSessionController: save result failed: $e');
    }
  }

  Future<void> loadResults() async {
    isLoadingResults.value = true;
    try {
      results.value = await _repository.allPages();
    } catch (e) {
      debugPrint('TasmeeSessionController: load results failed: $e');
    } finally {
      isLoadingResults.value = false;
    }
  }

  Future<void> deleteResult(int pageNumber) async {
    await _repository.deleteByPage(pageNumber);
    await loadResults();
  }

  // ── تصحيح الكلمة (نمط المصحح) ─────────────────────────────────

  bool _correctionSheetOpen = false;

  /// عند ضبط كلمة خاطئة (وتجميد الجلسة) يُفتح شيت التصحيح ويُشغَّل نطق
  /// الكلمة تلقائيًا.
  void _listenForWordCorrection() {
    ever<TasmeeWordCorrection?>(
      TasmeeCtrl.instance.state.activeWordCorrection,
      (correction) {
        if (correction != null) _openCorrectionSheet(correction);
      },
    );
  }

  /// عند نجاح إعادة النطق تُحلّ الكلمة (تُعلَّم خضراء وتُستأنف الجلسة)
  /// ويُغلق الشيت تلقائيًا.
  void _listenForWordRetryOutcome() {
    ever<TasmeeWordRetryOutcome?>(TasmeeCtrl.instance.state.wordRetryOutcome, (
      outcome,
    ) {
      if (outcome == TasmeeWordRetryOutcome.correct && _correctionSheetOpen) {
        TasmeeCtrl.instance.resolveWordCorrection(accepted: true);
        Get.back();
      }
    });
  }

  Future<void> _openCorrectionSheet(TasmeeWordCorrection correction) async {
    if (_correctionSheetOpen) return;
    _correctionSheetOpen = true;
    // شغّل نطق الكلمة فور فتح الشيت ليستمع المستخدم ثم يعيدها.
    await playCorrectionWordAudio();
    await customBottomSheet(const TasmeeWordCorrectionSheet());
    // أُغلق الشيت دون قبول (سحب/Back) → تخطٍّ حتى لا تتعلق الجلسة
    // متوقفة بانتظار تصحيح لن يصل.
    if (TasmeeCtrl.instance.state.activeWordCorrection.value != null) {
      await TasmeeCtrl.instance.resolveWordCorrection(accepted: false);
    }
    _correctionSheetOpen = false;
  }

  /// يشغّل نطق الكلمة المنتظرة تصحيحًا (زر السماعة في الشيت).
  Future<void> playCorrectionWordAudio() async {
    final correction = TasmeeCtrl.instance.state.activeWordCorrection.value;
    if (correction == null) return;
    try {
      await WordInfoCtrl.instance.playWordAudio(
        WordRef(
          surahNumber: correction.suraIdx,
          ayahNumber: correction.ayaIdx,
          wordNumber: correction.wordNumber,
        ),
      );
    } catch (e) {
      debugPrint('TasmeeSessionController: word audio failed: $e');
    }
  }

  /// يتخطى الكلمة المنتظرة (تبقى معلَّمة خاطئة) ويغلق شيت التصحيح
  /// وتُستأنف الجلسة.
  Future<void> skipWordCorrection() async {
    await TasmeeCtrl.instance.resolveWordCorrection(accepted: false);
    Get.back();
  }
}
