part of '../../quran.dart';

/// قائمة صفحات التسميع المنجزة — تُفتح من زر check-list في شريط
/// التسميع داخل [customBottomSheet]؛ الضغط على صفحة يدفع نتيجتها
/// كصفحة داخل نفس الورقة عبر [customPushToPage]، والحذف بالسحب.
///
/// الودجت Stateless — البيانات والعمليات في [TasmeeSessionController].
class TasmeePagesListWidget extends StatelessWidget {
  const TasmeePagesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // الوصول للكونترولر يضمن إنشاءه (وتسجيل مستمع الحفظ في onInit).
    final sessionCtrl = TasmeeSessionController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: 'tasmeeResultsPages'.tr, horizontalPadding: 0.0),
          const Gap(12),
          Obx(() {
            if (sessionCtrl.isLoadingResults.value) {
              return const SizedBox(height: 240, child: ShimmerEffectBuild());
            }
            final results = sessionCtrl.results;
            if (results.isEmpty) return _buildEmpty(context);
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * .45),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (_, i) =>
                    _buildRow(context, sessionCtrl, results[i]),
              ),
            );
          }),
          const Gap(16),
        ],
      ),
    );
  }

  /// حالة عدم وجود نتائج محفوظة بعد.
  Widget _buildEmpty(BuildContext context) {
    final color = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          customSvgWithColor(
            SvgPath.svgQuranCheckList,
            color: color,
            height: 42,
          ),
          const Gap(10),
          Text(
            'tasmeeNoResults'.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(
              fontSize: 13,
              color: context.theme.colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// صف صفحة منجزة واحدة: الموضع، الإحصاء، التاريخ — وحذف بالسحب.
  Widget _buildRow(
    BuildContext context,
    TasmeeSessionController sessionCtrl,
    TasmeePageResult result,
  ) {
    return Dismissible(
      key: ValueKey('tasmee_result_${result.pageNumber}'),
      background: const DeleteWidget(),
      onDismissed: (_) async {
        await sessionCtrl.deleteResult(result.pageNumber);
        context.showCustomErrorSnackBar('tasmeeResultDeleted'.tr, isDone: true);
      },
      child: ContainerButton(
        width: Get.width,
        horizontalMargin: 0,
        verticalMargin: 4,
        svgPath: SvgPath.svgQuranCheckList,
        svgColor: result.isFullyCorrect
            ? context.theme.primaryColorLight
            : context.theme.colorScheme.surface,
        title:
            '${'tasmeePage'.tr} '
                    '${result.pageNumber.toString().convertNumbersToCurrentLang()}'
                    ' • ${result.startSura}:${result.startAya}'
                .convertNumbersToCurrentLang(),
        subtitle: _subtitle(result),
        withArrow: true,
        isTitleCentered: false,
        onPressed: () => context.customPushToPage(
          context,
          TasmeeResultWidget(result: result.toRecitationResult()),
        ),
      ),
    );
  }

  /// سطر الإحصاء أسفل العنوان: النسبة/الأخطاء + التاريخ.
  String _subtitle(TasmeePageResult result) {
    final date = intl.DateFormat('d/M/y').format(result.completedAt);
    final stats = result.isFullyCorrect
        ? '${result.scorePercent.toString().convertNumbersToCurrentLang()}%'
        : '${result.scorePercent.toString().convertNumbersToCurrentLang()}%'
              ' • ${result.totalErrors.toString().convertNumbersToCurrentLang()}'
              ' ${'tasmeeErrorsCount'.tr}';
    return '$stats • ${date.convertNumbersToCurrentLang()}';
  }
}
