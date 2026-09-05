part of '../../quran.dart';

/// شيت تصحيح كلمة خاطئة في نمط المصحح — الكلمة ونوع خطئها ونطقها
/// وإعادة نطقها حتى تصح (أو تخطيها). كل المنطق في [TasmeeCtrl]
/// و[TasmeeSessionController] — الويدجت Stateless.
class TasmeeWordCorrectionSheet extends StatelessWidget {
  const TasmeeWordCorrectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final tasmee = TasmeeCtrl.instance;
    final sessionCtrl = TasmeeSessionController.instance;
    final textColor = context.theme.colorScheme.inversePrimary;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          final correction = tasmee.state.activeWordCorrection.value;
          if (correction == null) return const SizedBox.shrink();
          final outcome = tasmee.state.wordRetryOutcome.value;
          final listening = tasmee.state.isWordRetryListening.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: TitleWidget(
                      title: 'tasmeeCorrectWord',
                      horizontalPadding: 0.0,
                    ),
                  ),
                  _kindBadge(context, correction.errorKind),
                ],
              ),
              const Gap(12),
              _wordCard(context, correction.wordText),
              const Gap(12),
              CustomButton(
                isCustomSvgColor: true,
                svgPath: SvgPath.svgAudioPlayWord,
                tooltip: 'tasmeePlayWord'.tr,
                svgColor: Get.theme.primaryColorLight,
                onPressed: sessionCtrl.playCorrectionWordAudio,
              ),
              const Gap(10),
              _statusArea(context, listening: listening, outcome: outcome),
              const Gap(12),
              // أثناء الاستماع يظهر المؤشر النابض بدل زر الإعادة.
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: listening
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            isCustomSvgColor: true,
                            svgPath: SvgPath.svgQuranMicrophone,
                            tooltip: 'tasmeeRepeatWord'.tr,
                            backgroundColor: Get.theme.primaryColorLight,
                            svgColor: Get.theme.colorScheme.surface,
                            onPressed: tasmee.startWordRetry,
                          ),
                          const Gap(16),
                          CustomButton(
                            isCustomSvgColor: true,
                            svgPath: SvgPath.svgAudioNextIcon,
                            tooltip: 'tasmeeSkipWord'.tr,
                            svgColor: textColor,
                            onPressed: sessionCtrl.skipWordCorrection,
                          ),
                        ],
                      ),
              ),
              const Gap(16),
            ],
          );
        }),
      ),
    );
  }

  /// شارة نوع الخطأ (تجويد/نطق/تشكيل) — بمفاتيح الترجمة القائمة.
  Widget _kindBadge(BuildContext context, TasmeeErrorKind kind) {
    final label = switch (kind) {
      TasmeeErrorKind.tajweed => 'tasmeeTajweed'.tr,
      TasmeeErrorKind.tashkeel => 'tasmeeTashkeel'.tr,
      _ => 'tasmeePronunciation'.tr,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTextStyles.titleSmall(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.theme.colorScheme.inversePrimary.withValues(alpha: .8),
        ),
      ),
    );
  }

  /// الكلمة العثمانية بخط كبير.
  Widget _wordCard(BuildContext context, String wordText) {
    if (wordText.isEmpty) return const SizedBox.shrink();
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.theme.primaryColorLight.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        wordText,
        textAlign: TextAlign.center,
        style: AppTextStyles.titleMedium(
          fontSize: 28,
          color: context.theme.colorScheme.inversePrimary,
        ),
      ),
    );
  }

  /// حالة إعادة النطق: تلميح البدء، مؤشر الاستماع، أو النتيجة.
  Widget _statusArea(
    BuildContext context, {
    required bool listening,
    required TasmeeWordRetryOutcome? outcome,
  }) {
    final style = AppTextStyles.bodySmall(
      fontSize: 13,
      color: context.theme.colorScheme.inversePrimary,
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: switch (outcome) {
        TasmeeWordRetryOutcome.correct => Row(
          key: const ValueKey('correct'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customSvgWithCustomColor(
              SvgPath.svgCheckMark,
              color: context.theme.primaryColorLight,
            ),
            const Gap(8),
            Expanded(child: Text('tasmeeWordCorrect'.tr, style: style)),
          ],
        ),
        TasmeeWordRetryOutcome.incorrect => Text(
          key: const ValueKey('incorrect'),
          'tasmeeTryAgain'.tr,
          textAlign: TextAlign.center,
          style: style.copyWith(color: context.theme.colorScheme.surface),
        ),
        _ when listening => Row(
          key: const ValueKey('listening'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _PulsingTasmeeDot(),
            const Gap(8),
            Expanded(child: Text('tasmeeListeningWord'.tr, style: style)),
          ],
        ),
        _ => Text(
          key: const ValueKey('hint'),
          'tasmeeRepeatHint'.tr,
          textAlign: TextAlign.center,
          style: style,
        ),
      },
    );
  }
}
