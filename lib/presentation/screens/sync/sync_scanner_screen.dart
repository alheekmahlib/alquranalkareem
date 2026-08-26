part of 'sync.dart';

/// شاشة مسح رمز QR للانضمام لمجموعة مزامنة — بأسلوب iOS:
/// إطار عرض مستدير وخط مسح يتزحلق بهدوء ونبضة عند الالتقاط.
/// تعيد رمز الغرفة عبر Navigator.pop أو null عند الإلغاء.
class SyncScannerScreen extends StatefulWidget {
  const SyncScannerScreen({super.key});

  @override
  State<SyncScannerScreen> createState() => _SyncScannerScreenState();
}

class _SyncScannerScreenState extends State<SyncScannerScreen>
    with TickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  late final AnimationController _scanLine;
  bool _handled = false;
  bool _captured = false;

  static const double _frameSize = 280;

  @override
  void initState() {
    super.initState();
    _scanLine = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _scanLine.dispose();
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
        if (!mounted) return;
        if (MediaQuery.disableAnimationsOf(context)) {
          Navigator.of(context).pop(raw);
          return;
        }
        // نبضة التقاط قصيرة قبل العودة — إشارة بصرية أن الرمز قُرئ.
        setState(() => _captured = true);
        Future.delayed(const Duration(milliseconds: 320), () {
          if (mounted) Navigator.of(context).pop(raw);
        });
        return;
      }
    }
  }

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
          Center(
            child: AnimatedScale(
              scale: _captured ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: Container(
                width: _frameSize,
                height: _frameSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _captured ? Colors.green : Colors.white70,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Stack(
                    children: [
                      if (!reduceMotion)
                        AnimatedBuilder(
                          animation: _scanLine,
                          builder: (context, _) {
                            final top = _scanLine.value * (_frameSize - 4) - 2;
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
