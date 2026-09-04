part of '../../quran.dart';

/// بطاقة خطأ تسميع واحدة: نوعه، القاعدة، الكلمة، والمتوقع/المنطوق.
class TasmeeErrorCard extends StatelessWidget {
  const TasmeeErrorCard({super.key, required this.error});

  final RecitationError error;

  @override
  Widget build(BuildContext context) {
    final isTajweed = error.errorType == 'tajweed';
    final isTashkeel = error.errorType == 'tashkeel';
    final iconColor = isTajweed
        ? context.theme.primaryColorLight
        : isTashkeel
        ? context.theme.primaryColorLight
        : context.theme.colorScheme.surface;
    final textColor = context.theme.colorScheme.inversePrimary;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: .05),
        border: Border.all(color: iconColor.withValues(alpha: .25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customSvgWithColor(SvgPath.svgAlert, color: iconColor, height: 22),
          const Gap(10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _errorTitle(),
                        style: AppTextStyles.titleSmall(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      if (error.expectedPh?.isNotEmpty ?? false) ...[
                        const Gap(6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _TasmeePhonemeChip(
                              label:
                                  '${'tasmeeExpected'.tr}: ${error.expectedPh}',
                              color: context.theme.primaryColorLight,
                            ),
                            if (error.predictedPh?.isNotEmpty ?? false)
                              _TasmeePhonemeChip(
                                label:
                                    '${'tasmeeActual'.tr}: ${error.predictedPh}',
                                color: context.theme.colorScheme.surface,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                if (error.wordText?.isNotEmpty ?? false) ...[
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      error.wordText!,
                      style: AppTextStyles.titleMedium(
                        fontSize: 15,
                        color: context.theme.colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// عنوان الخطأ مترجمًا: فعل النطق (زيادة/نقص/استبدال) + اسم القاعدة
  /// (عربي أو إنجليزي حسب لغة التطبيق).
  String _errorTitle() {
    final verb = switch (error.speechErrorType) {
      'insert' => 'tasmeeInsert'.tr,
      'delete' => 'tasmeeDelete'.tr,
      'replace' => 'tasmeeReplace'.tr,
      _ => error.speechErrorType,
    };
    final rules = [
      ...error.refTajweedRules,
      ...error.insertedTajweedRules,
      ...error.replacedTajweedRules,
      ...error.missingTajweedRules,
    ];
    final rule = rules.isNotEmpty ? rules.first : null;
    final isArabic = Get.locale?.languageCode == 'ar';
    final ruleName = rule == null
        ? ''
        : isArabic
        ? rule.nameAr
        : rule.nameEn;
    return ruleName.isEmpty ? verb : '$verb — $ruleName';
  }
}
