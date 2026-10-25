part of '../quran.dart';

/// إعدادات السكرول التلقائي — تُضاف داخل FontsDownloadWidget
///
/// [AutoScrollSettings] settings section for auto-scroll:
/// stop condition selector, page count input, and initial speed slider.
class AutoScrollSettings extends StatelessWidget {
  const AutoScrollSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final autoScrollCtrl = AutoScrollCtrl.instance;

    return Obx(() {
      final selectedCondition = autoScrollCtrl.state.stopCondition.value;
      final speed = autoScrollCtrl.state.speed.value;
      final pageCount = autoScrollCtrl.state.targetPageCount.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          // العنوان
          Center(
            child: Text(
              'autoScrollSettings'.tr,
              style: AppTextStyles.titleMedium(),
            ),
          ),
          const Gap(4),
          Divider(
            thickness: 1.0,
            height: 1.0,
            endIndent: 32.0,
            indent: 32.0,
            color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
          ),
          const Gap(10),

          // شرط التوقف
          Text(
            'stopCondition'.tr,
            style: AppTextStyles.bodySmall().copyWith(
              color: context.theme.colorScheme.inversePrimary.withValues(
                alpha: .7,
              ),
            ),
          ),
          const Gap(6),
          Wrap(
            children: AutoScrollStopCondition.values.map((condition) {
              final isSelected = selectedCondition == condition;
              final chipLabel =
                  QuranController
                      .instance
                      .autoScrollStyle
                      .stopConditionLabels?[condition] ??
                  condition.labelAr;
              return ContainerButton(
                title: chipLabel,
                titleColor: context.theme.colorScheme.inversePrimary,
                value: isSelected.obs,
                horizontalPadding: 8.0,
                verticalPadding: 8.0,
                horizontalMargin: 4.0,
                verticalMargin: 4.0,
                onPressed: () => autoScrollCtrl.updateStopCondition(condition),
              );
            }).toList(),
          ),

          // حقل عدد الصفحات (يظهر فقط عند اختيار pageCount)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: selectedCondition == AutoScrollStopCondition.pageCount
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColorLight.withValues(alpha: .15),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'pageCount'.tr,
                          style: AppTextStyles.titleMedium().copyWith(
                            height: 2,
                          ),
                        ),
                        AnimatedCounterButton(
                          value: pageCount,
                          height: 32,
                          counterType: CounterType.integer,
                          onChanged: (newValue) {
                            autoScrollCtrl.updateTargetPageCount(newValue);
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // سرعة البداية
          const Gap(10),
          Row(
            children: [
              Text('speed'.tr, style: AppTextStyles.titleSmall()),
              const SizedBox(width: 4),
              Text(
                speed.toStringAsFixed(1).convertNumbersAccordingToLang(),
                style: AppTextStyles.titleSmall().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.theme.colorScheme.surface,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            width: MediaQuery.sizeOf(context).width,
            child: FlutterSlider(
              values: [speed],
              min: 0.05,
              max: 5.0,
              rtl: alignmentLayout(true, false),
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBarHeight: 5,
                activeTrackBarHeight: 5,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Get.theme.colorScheme.surface.withValues(alpha: .2),
                ),
                activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Get.theme.colorScheme.surface,
                ),
              ),
              handlerAnimation: const FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: null,
                duration: Duration(milliseconds: 700),
                scale: 1.4,
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                autoScrollCtrl.updateSpeed(lowerValue);
              },
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: Material(
                  type: MaterialType.circle,
                  color: Colors.transparent,
                  elevation: 3,
                  child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                ),
              ),
            ),
          ),
          // تسميات بطيء / سريع
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('slow'.tr, style: AppTextStyles.titleSmall()),
                Text('fast'.tr, style: AppTextStyles.titleSmall()),
              ],
            ),
          ),
          const Gap(8),
        ],
      );
    });
  }
}
