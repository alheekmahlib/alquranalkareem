import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../screens/quran_page/quran.dart';
import '../screens/quran_page/widgets/tasmee/data/models/tasmee_page_result.dart';
import '../screens/quran_page/widgets/tasmee/data/repositories/tasmee_results_repository.dart';

/// منسّق جلسات التسميع — يمتلك كل منطق دورة الحياة خارج المكتبة:
/// حفظ نتائج الصفحات عند اكتمالها، شيت تصحيح الكلمة (المصحح)، وحلقة
/// معلم القرآن (قارئ ← تسميع ← تقييم ← إعادة). الواجهات تبقى Stateless
/// وتقرأ حقول Rx فقط.
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
    _listenForTeacherEvaluation();
    _listenForTeacherAbort();
    loadResults();
  }

  /// عند اكتمال تقييم جلسة مطابِقة تُحفظ نتيجة صفحتها — يستبدل أي
  /// نتيجة سابقة لنفس الصفحة (الأحدث فقط). نمط المعلم يحفظ عند اكتمال
  /// الصفحة كاملة داخل حلقة المعلم أدناه.
  void _listenForSessionFinished() {
    // الكونترولر دائم — المستمع يعيش مدى التطبيق كنمط إعدادات التسميع.
    ever<RecitationState>(TasmeeCtrl.instance.state.sessionState, (s) async {
      if (s == RecitationState.finished &&
          TasmeeCtrl.instance.state.mode.value != TasmeeMode.teacher) {
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

  // ── معلم القرآن (آية بآية) ────────────────────────────────────

  bool _teacherRunning = false;
  int _teacherAyahIdx = -1;

  /// يبدأ حلقة المعلم لآيات الصفحة الحالية: القارئ يتلو الآية ← يسجّل
  /// المستخدم ← تقييم ← أخطاء: نتيجة الآية ثم إعادة تلقائية للتلاوة،
  /// إتقان: الآية التالية — حتى تُتقن الصفحة فتُحفظ نتيجتها.
  Future<void> startTeacherSession() async {
    final tasmee = TasmeeCtrl.instance;
    final state = tasmee.state;
    if (state.mode.value != TasmeeMode.teacher ||
        !state.isTasmeeMode.value ||
        _teacherRunning) {
      return;
    }
    final total = tasmee.rangeAyahCount;
    if (total == 0) return;
    _teacherRunning = true;
    _teacherAyahIdx = 0;
    state.teacherAyahTotal.value = total;
    await _playTeacherAyah();
  }

  /// يوقف حلقة المعلم (زر الإيقاف/تبديل النمط/الخروج من الوضع).
  Future<void> stopTeacherSession() async {
    _teacherRunning = false;
    final tasmee = TasmeeCtrl.instance;
    tasmee.state.teacherPhase.value = TasmeeTeacherPhase.idle;
    try {
      await AudioCtrl.instance.state.stopAllAudio();
    } catch (_) {}
    if (tasmee.isRecording || tasmee.isProcessing) {
      await tasmee.stopRecording();
    }
  }

  /// يعيد جلسة المعلم من الآية الأولى (زر الإعادة في الشريط).
  Future<void> restartTeacherSession() async {
    await stopTeacherSession();
    await TasmeeCtrl.instance.retryTasmee();
    await startTeacherSession();
  }

  /// طور الآية الحالية: تلاوة القارئ ثم تسجيل المستخدم تلقائيًا.
  Future<void> _playTeacherAyah() async {
    final tasmee = TasmeeCtrl.instance;
    final state = tasmee.state;
    if (!_teacherRunning) return;
    state.teacherAyahIndex.value = _teacherAyahIdx;
    state.teacherPhase.value = TasmeeTeacherPhase.qariPlaying;
    final ayahUq = tasmee.rangeAyahUQ(_teacherAyahIdx);
    final played = ayahUq > 0 ? await _playQariAyah(ayahUq) : false;
    if (!_teacherRunning) return;
    if (!played) {
      // تعذّر تشغيل التلاوة (اتصال/تنزيل) — أوقف الحلقة برسالة واضحة.
      state.lastError.value = 'tasmeeTeacherPlayFailed'.tr;
      await stopTeacherSession();
      return;
    }
    state.teacherPhase.value = TasmeeTeacherPhase.userRecording;
    await tasmee.startAyahRecording(_teacherAyahIdx);
  }

  /// يشغّل تلاوة القارئ للآية (بالقارئ المختار للتلاوة) وينتظر اكتمالها
  /// — اكتمال التشغيل يُرصد عبر `isPlaying` (لا حاجة للاعتماد على
  /// أنواع just_audio هنا).
  Future<bool> _playQariAyah(int ayahUq) async {
    final audio = AudioCtrl.instance;
    final started = Completer<void>();
    final done = Completer<bool>();
    final worker = ever<bool>(audio.state.isPlaying, (playing) {
      if (playing) {
        if (!started.isCompleted) started.complete();
      } else if (started.isCompleted && !done.isCompleted) {
        done.complete(true);
      }
    });
    try {
      await audio.playAyah(
        Get.context!,
        ayahUq,
        playSingleAyah: true,
        isDarkMode: Get.isDarkMode,
      );
    } catch (e) {
      debugPrint('TasmeeSessionController: playAyah failed: $e');
    }
    bool ok = false;
    try {
      // انتظر بدء التشغيل (يشمل وقت تنزيل الآية عند اللزوم) ثم اكتماله.
      await started.future.timeout(const Duration(seconds: 90));
      await done.future.timeout(const Duration(minutes: 5));
      ok = true;
    } on TimeoutException {
      ok = false;
    } catch (_) {
      ok = false;
    }
    worker.dispose();
    if (!ok) {
      try {
        await audio.state.stopAllAudio();
      } catch (_) {}
    }
    return ok;
  }

  /// بعد تقييم كل محاولة آية: إتقان → التالية (أو حفظ الصفحة عند
  /// الأخيرة)، أخطاء → شيت نتيجة الآية ثم إعادة تلقائية للتلاوة.
  void _listenForTeacherEvaluation() {
    ever<RecitationState>(TasmeeCtrl.instance.state.sessionState, (s) async {
      final tasmee = TasmeeCtrl.instance;
      final state = tasmee.state;
      if (s != RecitationState.finished ||
          !_teacherRunning ||
          state.mode.value != TasmeeMode.teacher ||
          state.teacherPhase.value == TasmeeTeacherPhase.pageDone) {
        return;
      }
      state.teacherPhase.value = TasmeeTeacherPhase.evaluating;
      final result = state.lastResult.value;
      final passed = result != null && result.hasMatch && result.isFullyCorrect;
      if (passed) {
        if (_teacherAyahIdx >= state.teacherAyahTotal.value - 1) {
          // أُتقنت آخر آية — اكتمال الصفحة: احفظ واعرض النتيجة.
          state.teacherPhase.value = TasmeeTeacherPhase.pageDone;
          _teacherRunning = false;
          await _saveCurrentPageResult();
          await customBottomSheet(TasmeeResultWidget());
        } else {
          _teacherAyahIdx++;
          await _playTeacherAyah();
        }
      } else {
        // أخطاء: اعرض نتيجة الآية، وعند إغلاقها يُعاد تلاوة القارئ
        // تلقائيًا لنفس الآية.
        await customBottomSheet(TasmeeResultWidget());
        if (_teacherRunning) await _playTeacherAyah();
      }
    });
  }

  /// تبديل النمط أو الخروج من وضع التسميع يوقفان حلقة المعلم فورًا.
  void _listenForTeacherAbort() {
    final tasmee = TasmeeCtrl.instance;
    ever<TasmeeMode>(tasmee.state.mode, (_) => stopTeacherSession());
    ever<bool>(tasmee.state.isTasmeeMode, (active) {
      if (!active) stopTeacherSession();
    });
  }
}
