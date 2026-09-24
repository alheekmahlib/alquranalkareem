part of 'sync.dart';

/// شاشة مسح رمز QR للانضمام لمجموعة مزامنة — بأسلوب iOS:
/// إطار عرض مستدير وخط مسح يتزحلق بهدوء ونبضة عند الالتقاط.
/// تعيد رمز الغرفة عبر Get.back أو null عند الإلغاء.
class SyncScannerScreen extends GetView<SyncScannerController> {
  const SyncScannerScreen({super.key});

  static const double _frameSize = 280;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final accent = Theme.of(context).primaryColorLight;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('scanQrTitle'.tr, style: AppTextStyles.titleLarge()),
      ),
      body: Stack(
        children: [
          Obx(
            () => controller.cameraFailed.value
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'cameraPermissionDenied'.tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium().copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : ReaderWidget(
                    onScan: controller.onScan,
                    onControllerCreated: controller.onControllerCreated,
                    codeFormat: Format.qrCode,
                    tryHarder: true,
                    showScannerOverlay: false,
                    showFlashlight: false,
                    showToggleCamera: false,
                    showGallery: false,
                  ),
          ),
          Center(
            child: Obx(
              () => AnimatedScale(
                scale: controller.captured.value ? 1.06 : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: Container(
                  width: _frameSize,
                  height: _frameSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: controller.captured.value
                          ? Colors.green
                          : Colors.white70,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: Stack(
                      children: [
                        if (!reduceMotion)
                          AnimatedBuilder(
                            animation: controller.scanLine,
                            builder: (context, _) {
                              final top =
                                  controller.scanLine.value * (_frameSize - 4) -
                                  2;
                              return Positioned(
                                top: top,
                                left: 18,
                                right: 18,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        accent.withValues(alpha: 0),
                                        accent,
                                        accent.withValues(alpha: 0),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accent.withValues(alpha: 0.6),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(24.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'scanQrInstruction'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium().copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
