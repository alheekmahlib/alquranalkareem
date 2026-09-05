import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../screens/quran_page/quran.dart';

/// متحكم إعدادات التسميع — إدارة نموذج التصحيح المحلي (حالة/تنزيل/حذف)
/// ودورة حياة جلسة التسميع في الواجهة (فتح ورقة النتائج تلقائيًا).
///
/// المنطق يعيش هنا وليس في الواجهة: [TasmeeModelSettings] داخل
/// mushaf_settings.dart و[TasmeeBarWidget] كلاهما Stateless ويراقبان
/// حقول Rx فقط.
class TasmeeSettingsController extends GetxController {
  static TasmeeSettingsController get instance {
    // تسجيل دائم: الكائن واحد طوال عمر التطبيق — حذفه مع مسار مضيف عبر
    // SmartManagement كان سبب خلل مشابه في TasmeeCtrl (فقدان حالة عابرة
    // وإنشاء نسخة يتيمة لا تقرأها الواجهة).
    if (GetInstance().isRegistered<TasmeeSettingsController>()) {
      return GetInstance().find<TasmeeSettingsController>();
    }
    return Get.put(TasmeeSettingsController(), permanent: true);
  }

  final _modelService = TasmeeModelService();

  bool _sheetOpen = false;

  /// هل نموذج التصحيح المحلي منزّل وصالح؟
  final isModelReady = false.obs;

  /// جارٍ تنزيل النموذج الآن؟
  final isDownloading = false.obs;

  /// تقدم التنزيل (0.0–1.0).
  final downloadProgress = 0.0.obs;

  /// آخر رسالة خطأ (تنزيل/حذف) — تُعرض داخل الإعدادات وتُصفَّر عند أي محاولة.
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshModelStatus();
    _listenForSessionFinished();
  }

  /// يفتح ورقة نتائج التسميع تلقائيًا عبر [customBottomSheet] عند اكتمال
  /// التقييم — مرة واحدة لكل جلسة، ويُعاد ضبط الحارس عند بدء تسجيل جديد.
  ///
  /// المستمع دائم في هذا الكونترولر (لا يموت بإخفاء الأشرطة أو الخروج من
  /// شاشة القرآن أثناء التسجيل) — بخلاف ما كان في ويدجت الشريط سابقًا.
  void _listenForSessionFinished() {
    // الكونترولر دائم — المستمع يعيش مدى التطبيق ولا يحتاج تخزينًا للتخلص منه.
    ever<RecitationState>(TasmeeCtrl.instance.state.sessionState, (s) {
      if (s == RecitationState.recording || s == RecitationState.connecting) {
        _sheetOpen = false;
        return;
      }
      if (s == RecitationState.finished && !_sheetOpen) {
        // نمط المعلم يدير شيتات نتائجه بنفسه في TasmeeSessionController
        // (نتيجة لكل محاولة آية، وبلا شيت عند الإتقان).
        if (TasmeeCtrl.instance.state.mode.value == TasmeeMode.teacher) {
          return;
        }
        _sheetOpen = true;
        customBottomSheet(
          TasmeeResultWidget(),
        ).whenComplete(() => _sheetOpen = false);
      }
    });
  }

  /// يفحص وجود النموذج على القرص ويزامن حالة مكتبة التسميع.
  Future<void> refreshModelStatus() async {
    try {
      final ready = await _modelService.isModelReady();
      isModelReady.value = ready;
      TasmeeCtrl.instance.state.isModelReady.value = ready;
    } catch (e) {
      debugPrint('TasmeeSettingsController: status check failed: $e');
    }
  }

  /// ينزّل النموذج المحلي (≈73MB) مع تقدم لحظي — التنزيل ذرّي (ملف مؤقت
  /// ثم إعادة تسمية) فيُعاد بأمان عند الانقطاع.
  Future<void> downloadModel() async {
    if (isDownloading.value || isModelReady.value) return;
    isDownloading.value = true;
    downloadProgress.value = 0;
    error.value = '';
    try {
      await _modelService.downloadModel(
        onProgress: (p) => downloadProgress.value = p,
      );
      isModelReady.value = true;
      TasmeeCtrl.instance.state.isModelReady.value = true;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isDownloading.value = false;
    }
  }

  /// يحذف النموذج المحلي لتحرير المساحة ويصفّر المحرك؛ ضغط زر التسجيل
  /// بعدها سيطالب بتنزيله من جديد.
  Future<void> deleteModel() async {
    if (isDownloading.value) return;
    error.value = '';
    try {
      await _modelService.deleteModel();
      Recitation.reset();
      isModelReady.value = false;
      TasmeeCtrl.instance.state.isModelReady.value = false;
    } catch (e) {
      error.value = e.toString();
    }
  }
}
