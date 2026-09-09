part of '../../quran.dart';

/// شيت اختيار نمط التسميع — ثلاث بطاقات (تسميع/مصحح التلاوة/معلم
/// القرآن) بأيقونة ووصف، والنمط الحالي مُميَّز. الاختيار يُحفظ ويُطبَّق
/// عبر [TasmeeCtrl.setMode] (يوقف التسجيل النشط ويحفظ نتيجته قبل
/// التبديل) — الويدجت Stateless.
class TasmeeModeSheetWidget extends StatelessWidget {
  const TasmeeModeSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasmee = TasmeeCtrl.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: 'tasmeeModeTitle'.tr, horizontalPadding: 0.0),
          const Gap(12),
          Obx(() {
            final current = tasmee.state.mode.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeCard(
                  context,
                  mode: TasmeeMode.tasmee,
                  titleKey: 'tasmeeModeTasmee',
                  descKey: 'tasmeeModeTasmeeDesc',
                  selected: current == TasmeeMode.tasmee,
                ),
                _buildModeCard(
                  context,
                  mode: TasmeeMode.corrector,
                  titleKey: 'tasmeeModeCorrector',
                  descKey: 'tasmeeModeCorrectorDesc',
                  selected: current == TasmeeMode.corrector,
                ),
                _buildModeCard(
                  context,
                  mode: TasmeeMode.teacher,
                  titleKey: 'tasmeeModeTeacher',
                  descKey: 'tasmeeModeTeacherDesc',
                  selected: current == TasmeeMode.teacher,
                ),
              ],
            );
          }),
          const Gap(16),
        ],
      ),
    );
  }

  /// بطاقة نمط واحدة — تمييز الحالي عبر قيمة `value` وشريط الاختيار
  /// المدمجَين في [ContainerButton].
  Widget _buildModeCard(
    BuildContext context, {
    required TasmeeMode mode,
    required String titleKey,
    required String descKey,
    required bool selected,
  }) {
    return ContainerButton(
      width: Get.width,
      horizontalMargin: 0,
      verticalMargin: 4,
      title: titleKey,
      subtitle: descKey,
      withArrow: true,
      value: selected.obs,
      backgroundColor: selected
          ? context.theme.primaryColorLight.withValues(alpha: .5)
          : null,
      onPressed: () {
        Get.back();
        TasmeeCtrl.instance.setMode(mode);
      },
    );
  }
}
