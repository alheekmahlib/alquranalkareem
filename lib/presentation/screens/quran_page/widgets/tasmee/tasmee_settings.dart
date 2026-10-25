part of '../../quran.dart';

/// إعدادات التسميع — إدارة نموذج التصحيح المحلي فقط (حالة/تنزيل/حذف).
///
/// [TasmeeSettings] tasmee settings section: local model management.
/// Stateless — المنطق في [TasmeeSettingsController] والواجهة تراقب Rx فقط.
class TasmeeSettings extends StatelessWidget {
  TasmeeSettings({super.key});

  final tasmeeSettingsCtrl = TasmeeSettingsController.instance;

  @override
  Widget build(BuildContext context) {
    // التسميع غير مدعوم على الويب.
    if (kIsWeb) return const SizedBox.shrink();
    return Obx(() {
      final downloading = tasmeeSettingsCtrl.isDownloading.value;
      final ready = tasmeeSettingsCtrl.isModelReady.value;
      final progress = tasmeeSettingsCtrl.downloadProgress.value;
      int progressValue = (progress * 100).toInt();
      String progressString = progressValue.toString();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          // العنوان
          Center(child: Text('tasmeaa'.tr, style: AppTextStyles.titleMedium())),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: ContainerButton(
                  height: 45,
                  width: double.infinity,
                  title: 'tasmeeLocalModel',
                  titleColor: context.theme.colorScheme.inversePrimary,
                  progressColor: Get.theme.colorScheme.primary.withValues(
                    alpha: .6,
                  ),
                  progressBackgroundColor: Get.theme.colorScheme.primary
                      .withValues(alpha: .2),
                  value: ready.obs,
                  isDownloading: downloading,
                  downloadProgress: progressString,
                  horizontalPadding: 8.0,
                  verticalPadding: 4.0,
                  verticalMargin: 4.0,
                  onPressed: tasmeeSettingsCtrl.downloadModel,
                ),
              ),
              if (ready) const Gap(6),
              if (ready)
                CustomButton(
                  height: 45,
                  isCustomSvgColor: true,
                  horizontalPadding: 12.0,
                  svgPath: SvgPath.svgHomeRemove,
                  svgColor: context.theme.canvasColor,
                  backgroundColor: context.theme.colorScheme.surface,
                  onPressed: tasmeeSettingsCtrl.deleteModel,
                ),
            ],
          ),
          if (tasmeeSettingsCtrl.error.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                tasmeeSettingsCtrl.error.value,
                style: AppTextStyles.bodySmall().copyWith(
                  color: context.theme.colorScheme.surface,
                ),
              ),
            ),
          const Gap(8),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(8),
          // وضع المصحّح غير الحاجز: الكلمة الخاطئة تُعلَّم حمراء بلا شيت
          // يوقف الجلسة — لمن يفضّل المتابعة والتصحيح لاحقًا.
          Obx(() {
            final nonBlocking =
                TasmeeCtrl.instance.state.nonBlockingCorrector.value;
            return CustomSwitchListTile(
              title: 'tasmeeNonBlockingCorrector'.tr,
              value: nonBlocking,
              onChanged: (v) =>
                  TasmeeCtrl.instance.state.nonBlockingCorrector.value = v,
            );
          }),
          const Gap(8),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(8),
          // صرامة معايير التصحيح (عتبة القبول النسبي وسياسة الأدلة).
          Obx(() {
            final current = TasmeeCtrl.instance.state.strictness.value;
            return Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'tasmeeStrictness'.tr,
                  style: AppTextStyles.bodySmall().copyWith(
                    color: context.theme.colorScheme.inversePrimary,
                  ),
                ),
                const Gap(6),
                Wrap(
                  children: TasmeeStrictness.values.map((strictness) {
                    return ContainerButton(
                      title: _strictnessKey(strictness),
                      titleColor: context.theme.colorScheme.inversePrimary,
                      value: (current == strictness).obs,
                      horizontalPadding: 8.0,
                      verticalPadding: 8.0,
                      horizontalMargin: 4.0,
                      verticalMargin: 4.0,
                      onPressed: () =>
                          TasmeeCtrl.instance.state.strictness.value =
                              strictness,
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          const Gap(8),
        ],
      );
    });
  }

  /// مفتاح ترجمة كل مستوى صرامة — switch شامل يُنبّه المحلّل عند إضافة قيمة.
  static String _strictnessKey(TasmeeStrictness strictness) =>
      switch (strictness) {
        TasmeeStrictness.strict => 'tasmeeStrictnessStrict',
        TasmeeStrictness.balanced => 'tasmeeStrictnessBalanced',
        TasmeeStrictness.lenient => 'tasmeeStrictnessLenient',
      };
}
