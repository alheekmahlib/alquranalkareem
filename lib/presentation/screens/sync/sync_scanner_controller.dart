part of 'sync.dart';

/// متحكم شاشة مسح QR للانضمام لمجموعة مزامنة — يملك خط المسح المتحرك
/// وحالة الالتقاط وفشل الكاميرا، ويعيد رمز الغرفة عبر Get.back.
class SyncScannerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxBool captured = false.obs;

  /// أغلب أخطاء التشغيل سببها رفض إذن الكاميرا — البديل الرمز اليدوي.
  final RxBool cameraFailed = false.obs;

  bool _handled = false;
  late final AnimationController scanLine;

  @override
  void onInit() {
    super.onInit();
    scanLine = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void onClose() {
    scanLine.dispose();
    super.onClose();
  }

  void onScan(Code result) {
    if (_handled) return;
    final raw = result.text;
    if (raw == null || !SyncLogic.isLikelyRoomCode(raw)) return;
    _handled = true;
    final context = Get.context;
    if (context == null || MediaQuery.disableAnimationsOf(context)) {
      Get.back<String>(result: raw);
      return;
    }
    // نبضة التقاط قصيرة قبل العودة — إشارة بصرية أن الرمز قُرئ.
    captured.value = true;
    Future.delayed(const Duration(milliseconds: 320), () {
      if (!isClosed) Get.back<String>(result: raw);
    });
  }

  void onControllerCreated(CameraController? controller, Exception? error) {
    if (error != null) cameraFailed.value = true;
  }
}

/// يربط متحكم الشاشة بدورة حياة مسارها — يُنشأ عند الدخول ويُدمَّر عند الخروج.
class SyncScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SyncScannerController());
  }
}
