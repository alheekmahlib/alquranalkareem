part of '../events.dart';

/// ويدجت تكامل التقويم الهجري مع home widget
/// Hijri calendar integration widget with home widget
class HijriWidgetIntegration extends StatelessWidget {
  HijriWidgetIntegration({super.key});

  final hijriWidgetCtrl = HijriHomeWidgetController.instance;
  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان - Title
          Text(
            'إعدادات Widget التقويم الهجري',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'kufi',
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
          const Gap(16),

          // معلومات الـ widget - Widget information
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  Get.theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات التقويم الهجري الحالية:',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                const Gap(8),
                _buildInfoRow(
                    'اليوم', '${eventCtrl.hijriNow.hDay}'.convertNumbers()),
                _buildInfoRow('اسم اليوم',
                    eventCtrl.getWeekdayName(eventCtrl.hijriNow.weekDay() - 1)),
                _buildInfoRow(
                    'الشهر', eventCtrl.hijriNow.getLongMonthName().tr),
                _buildInfoRow(
                    'السنة', '${eventCtrl.hijriNow.hYear}'.convertNumbers()),
                _buildInfoRow('تقدم الشهر',
                    '${((eventCtrl.hijriNow.hDay / eventCtrl.getLengthOfMonth) * 100).round()}%'),
              ],
            ),
          ),

          const Gap(16),

          // أزرار التحكم - Control buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // تحديث بيانات الـ widget - Update widget data
                    await hijriWidgetCtrl.updateHijriWidgetData();
                    Get.snackbar(
                      'تم التحديث',
                      'تم تحديث بيانات Widget التقويم الهجري بنجاح',
                      backgroundColor: Get.theme.colorScheme.primary,
                      colorText: Get.theme.colorScheme.onPrimary,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث Widget'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.primary,
                    foregroundColor: Get.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // فتح إعدادات الـ widget في النظام - Open widget settings
                    _showWidgetInstructions(context);
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('إرشادات'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بناء صف المعلومات - Build information row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'kufi',
              color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'kufi',
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// عرض إرشادات استخدام الـ widget - Show widget usage instructions
  void _showWidgetInstructions(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'إرشادات استخدام Widget التقويم الهجري',
          style: TextStyle(
            fontFamily: 'kufi',
            fontSize: 16.0,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'لإضافة Widget التقويم الهجري إلى الشاشة الرئيسية:',
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              _buildInstructionStep('1', 'اضغط مطولاً على الشاشة الرئيسية'),
              _buildInstructionStep('2', 'اختر "Widgets" أو "الأدوات"'),
              _buildInstructionStep(
                  '3', 'ابحث عن "القرآن الكريم" أو "التقويم الهجري"'),
              _buildInstructionStep('4', 'اسحب الـ Widget إلى المكان المرغوب'),
              _buildInstructionStep('5', 'سيتم تحديث البيانات تلقائياً كل يوم'),
              const Gap(8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'ملاحظة: تأكد من فتح التطبيق بانتظام لضمان تحديث البيانات.',
                  style: TextStyle(
                    fontFamily: 'kufi',
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  /// بناء خطوة الإرشاد - Build instruction step
  Widget _buildInstructionStep(String number, String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Get.theme.colorScheme.onPrimary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(
                fontFamily: 'kufi',
                fontSize: 13.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
