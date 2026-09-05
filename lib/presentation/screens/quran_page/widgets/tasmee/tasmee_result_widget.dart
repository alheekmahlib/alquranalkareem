part of '../../quran.dart';

/// محتوى ورقة نتائج التسميع — يُعرض داخل [customBottomSheet]
/// بنمط التطبيق، ويُبنى من [RecitationResult] العامة للمكتبة.
///
/// [result] يُمرَّر عند عرض نتيجة محفوظة (قائمة الصفحات المنجزة)؛
/// وإن تُرك null تُقرأ نتيجة آخر جلسة من حالة التسميع.
class TasmeeResultWidget extends StatelessWidget {
  TasmeeResultWidget({super.key, this.result});

  final tasmee = TasmeeCtrl.instance;

  /// نتيجة جاهزة للعرض (محفوظة) — تتجاوز نتيجة آخر جلسة.
  final RecitationResult? result;

  @override
  Widget build(BuildContext context) {
    final textColor = context.theme.colorScheme.inversePrimary;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          final result = this.result ?? tasmee.state.lastResult.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TitleWidget(
                      title: 'tasmeeResultTitle'.tr,
                      horizontalPadding: 0.0,
                    ),
                  ),
                  _positionLabel(result, textColor),
                ],
              ),
              const Gap(12),
              if (result == null || !result.hasMatch)
                _buildNoMatch(context)
              else ...[
                _buildSummaryBar(context, result),
                const Gap(12),
                if (result.isFullyCorrect)
                  _buildSuccessRow(context)
                else
                  _buildErrorsList(context, result),
              ],
              const Gap(12),
              // إخلاء المسؤولية (إلزامي — رخصة NPL-1.2) بنص الترخيص كما هو.
              Text(
                TasmeeStyle.defaults(
                      isDark: themeCtrl.isDarkMode,
                      context: context,
                    ).disclaimer ??
                    '',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall(
                  fontSize: 11,
                  color: textColor.withValues(alpha: .7),
                ),
              ),
              const Gap(16),
            ],
          );
        }),
      ),
    );
  }

  /// شارة موقع النطاق المُسمَّع (سورة:آية).
  Widget _positionLabel(RecitationResult? result, Color textColor) {
    final s = result?.start;
    if (s == null) return const SizedBox.shrink();
    final e = result!.end ?? s;
    final sameAyah = s.suraIdx == e.suraIdx && s.ayaIdx == e.ayaIdx;
    final position = sameAyah
        ? '${s.suraIdx}:${s.ayaIdx}'
        : '${s.suraIdx}:${s.ayaIdx} — ${e.suraIdx}:${e.ayaIdx}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        position.convertNumbersToCurrentLang(),
        style: AppTextStyles.titleSmall(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor.withValues(alpha: .8),
        ),
      ),
    );
  }

  /// عرض عدم التعرف على التلاوة.
  Widget _buildNoMatch(BuildContext context) {
    final incorrectColor = context.theme.colorScheme.surface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: .center,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: incorrectColor),
          const Gap(8),
          Text(
            tasmee.state.lastError.value.isEmpty
                ? 'tasmeeNoMatch'.tr
                : tasmee.state.lastError.value,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(
              fontSize: 13,
              color: context.theme.colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }

  /// شريط ملخص الأخطاء: إجمالي / تجويد / نطق / تشكيل.
  Widget _buildSummaryBar(BuildContext context, RecitationResult result) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _TasmeeSummaryChip(
          label: 'tasmeeTotal'.tr,
          value: '${result.errors.length}'.convertNumbersToCurrentLang(),
          color: context.theme.colorScheme.surface.withValues(alpha: .2),
        ),
        _TasmeeSummaryChip(
          label: 'tasmeeTajweed'.tr,
          value: '${result.tajweedErrors.length}'.convertNumbersToCurrentLang(),
          color: context.theme.colorScheme.primary.withValues(alpha: .2),
        ),
        _TasmeeSummaryChip(
          label: 'tasmeePronunciation'.tr,
          value: '${result.normalErrors.length}'.convertNumbersToCurrentLang(),
          color: context.theme.colorScheme.primary.withValues(alpha: .1),
        ),
        _TasmeeSummaryChip(
          label: 'tasmeeTashkeel'.tr,
          value: '${result.tashkeelErrors.length}'
              .convertNumbersToCurrentLang(),
          color: context.theme.colorScheme.primary.withValues(alpha: .05),
        ),
      ],
    );
  }

  /// صف النجاح عند عدم وجود أخطاء.
  Widget _buildSuccessRow(BuildContext context) {
    final correctColor = context.theme.primaryColorLight;
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: correctColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          customSvgWithCustomColor(SvgPath.svgCheckMark, color: correctColor),
          const Gap(10),
          Expanded(
            child: Text(
              'tasmeeNoErrors'.tr,
              style: AppTextStyles.titleSmall(
                fontWeight: FontWeight.w700,
                color: correctColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// قائمة بطاقات الأخطاء بارتفاع محدود حتى لا تطول الورقة.
  Widget _buildErrorsList(BuildContext context, RecitationResult result) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * .4),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: result.errors.length,
        itemBuilder: (_, i) => TasmeeErrorCard(error: result.errors[i]),
      ),
    );
  }
}
