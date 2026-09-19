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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        final correction = tasmee.state.activeWordCorrection.value;
        if (correction == null) return const SizedBox.shrink();
        final outcome = tasmee.state.wordRetryOutcome.value;
        final listening = tasmee.state.isWordRetryListening.value;
        // بعد محاولة فاشلة: اعرض خطأ هذه المحاولة بالذات (قد يختلف عن
        // خطأ التلاوة الأول — أصلح المستخدم النطق فصار الخطأ تشكيلًا
        // أو تجويدًا) ليعرف ما يصحّحه الآن.
        final retryFeedback = tasmee.state.wordRetryFeedback.value;
        final latest = outcome == TasmeeWordRetryOutcome.incorrect
            ? retryFeedback
            : null;
        final shownKind = latest?.kind ?? correction.errorKind;
        final shownVerb = latest?.errorType ?? correction.errorType;
        final shownExpected =
            latest?.expectedSymbol ?? correction.expectedSymbol;
        final shownPredicted =
            latest?.predictedSymbol ?? correction.predictedSymbol;
        final hasDetail =
            (shownExpected?.isNotEmpty == true) ||
            (shownPredicted?.isNotEmpty == true) ||
            (latest?.ruleName?.isNotEmpty == true);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: TitleWidget(
                title: 'tasmeeCorrectWord',
                horizontalPadding: 0.0,
              ),
            ),
            _kindBadge(context, shownKind),
            const Gap(8),
            _wordCard(context, correction.wordText),
            // تفصيل الخطأ الذي وقع فيه المستخدم في هذه الكلمة.
            if (hasDetail) ...[
              const Gap(8),
              _mistakeRow(
                context,
                verb: shownVerb,
                expectedSymbol: shownExpected,
                predictedSymbol: shownPredicted,
                ruleName: latest?.ruleName,
              ),
            ],
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
                          svgPath: SvgPath.svgAudioPreviousIcon,
                          tooltip: 'tasmeeSkipWord'.tr,
                          svgColor: Get.theme.primaryColorLight,
                          onPressed: sessionCtrl.skipWordCorrection,
                        ),
                      ],
                    ),
            ),
            const Gap(16),
          ],
        );
      }),
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
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: context.theme.colorScheme.inversePrimary.withValues(alpha: .8),
        ),
      ),
    );
  }

  /// تفصيل الخطأ: نوعه (زيادة/نقصان/استبدال) والمتوقع مقابل المنطوق —
  /// بشرائح الفونيمات نفسها المستخدمة في بطاقات الأخطاء. الحقول من
  /// خطأ التلاوة الأصلي أو من أحدث محاولة إعادة نطق (أيهما أحدث).
  Widget _mistakeRow(
    BuildContext context, {
    required String verb,
    String? expectedSymbol,
    String? predictedSymbol,
    String? ruleName,
  }) {
    final verbLabel = switch (verb) {
      'insert' => 'tasmeeInsert'.tr,
      'delete' => 'tasmeeDelete'.tr,
      _ => 'tasmeeReplace'.tr,
    };
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: [
        _TasmeePhonemeChip(
          label: verbLabel,
          color: context.theme.colorScheme.surface,
        ),
        if (ruleName?.isNotEmpty == true)
          _TasmeePhonemeChip(
            label: ruleName!,
            color: Get.theme.primaryColorLight,
          ),
        if (expectedSymbol?.isNotEmpty == true)
          _TasmeePhonemeChip(
            label: '${'tasmeeExpected'.tr}: $expectedSymbol',
            color: context.theme.primaryColorLight,
          ),
        if (predictedSymbol?.isNotEmpty == true)
          _TasmeePhonemeChip(
            label: '${'tasmeeActual'.tr}: $predictedSymbol',
            color: context.theme.colorScheme.surface,
          ),
      ],
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
