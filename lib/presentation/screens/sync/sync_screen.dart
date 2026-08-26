part of 'sync.dart';

/// شاشة مزامنة الأجهزة عبر QR — حالة "بلا غرفة" (إنشاء/انضمام)
/// وحالة "مُقرن" (QR للإقران، الحالة، تحديث يدوي، إلغاء المزامنة).
class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncCtrl = SyncController.instance;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isBooks: false,
        isTitled: false,
        isNotifi: false,
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
        centerChild: Text('deviceSync'.tr, style: AppTextStyles.titleLarge()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(
            () => syncCtrl.roomId.value == null
                ? const _UnpairedView()
                : const _PairedView(),
          ),
        ),
      ),
    );
  }
}
