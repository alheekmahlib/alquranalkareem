part of 'sync.dart';

/// شاشة مسح رمز QR للانضمام لمجموعة مزامنة.
/// تعيد رمز الغرفة عبر Navigator.pop أو null عند الإلغاء.
class SyncScannerScreen extends StatefulWidget {
  const SyncScannerScreen({super.key});

  @override
  State<SyncScannerScreen> createState() => _SyncScannerScreenState();
}

class _SyncScannerScreenState extends State<SyncScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;
      if (raw.startsWith(SyncConstants.qrPrefix) || raw.length >= 10) {
        _handled = true;
        Navigator.of(context).pop(raw);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('scanQrTitle'.tr, style: AppTextStyles.titleLarge()),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              // أغلب أخطاء التشغيل سببها رفض إذن الكاميرا — البديل الرمز اليدوي.
              return Center(
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
              );
            },
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
