part of '../../prayers.dart';

class SetTimingCalculations extends StatelessWidget {
  SetTimingCalculations({super.key});

  final adhanCtrl = AdhanController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'ضبط حساب المواقيت'.tr,
            style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontFamily: 'kufi',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تحديد طريقة الحساب تلقائيًا',
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: adhanCtrl.state.autoCalculationMethod.value,
                          activeColor: Colors.red,
                          inactiveTrackColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.5),
                          activeTrackColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.7),
                          thumbColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.surface),
                          trackOutlineColor: WidgetStatePropertyAll(adhanCtrl
                                  .state.autoCalculationMethod.value
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).canvasColor.withOpacity(.5)),
                          onChanged: (bool value) =>
                              adhanCtrl.switchAutoCalculation(value),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Obx(() => !adhanCtrl.state.autoCalculationMethod.value
                    ? pickCalculationMethod()
                    : const SizedBox.shrink()),
                const Gap(8),
                Text(
                  'المذهب'.tr,
                  style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontFamily: 'kufi',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const Gap(4),
                Obx(() => Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 16.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor.withOpacity(.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'شافعي، مالكي وحنبلي',
                                style: TextStyle(
                                  fontFamily: 'kufi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              Switch(
                                value: adhanCtrl.state.isHanafi.value,
                                activeColor: Colors.red,
                                inactiveTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.5),
                                activeTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.7),
                                thumbColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.surface),
                                trackOutlineColor: WidgetStatePropertyAll(
                                    adhanCtrl.state.isHanafi.value
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.5)),
                                onChanged: (_) => adhanCtrl.shafiOnTap(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'حنفي',
                                style: TextStyle(
                                  fontFamily: 'kufi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              Obx(() => Switch(
                                    value: !adhanCtrl.state.isHanafi.value,
                                    activeColor: Colors.red,
                                    inactiveTrackColor: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.5),
                                    activeTrackColor: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.7),
                                    thumbColor: WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.surface),
                                    trackOutlineColor: WidgetStatePropertyAll(
                                        !adhanCtrl.state.isHanafi.value
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Theme.of(context)
                                                .canvasColor
                                                .withOpacity(.5)),
                                    onChanged: (_) => adhanCtrl.hanafiOnTap(),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    )),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'أن أذان العشاء يتأخر عند الحنفية ، عنه لدى الجمهور ، بنحو ثنتي عشرة دقيقة كما في " الموسوعة الفقهية الكويتية " (7/175)، وأذان العصر يتأخر عند الحنفية بنصف ساعة وأكثر ، بحسب اختلاف البلدان والفصول.',
                    style: TextStyle(
                      fontFamily: 'naskh',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor.withOpacity(.6),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Gap(32),
                Obx(() => Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 16.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor.withOpacity(.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'منتصف الليل',
                                style: TextStyle(
                                  fontFamily: 'kufi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              Switch(
                                value: adhanCtrl.state.middleOfTheNight.value,
                                activeColor: Colors.red,
                                inactiveTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.5),
                                activeTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.7),
                                thumbColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.surface),
                                trackOutlineColor: WidgetStatePropertyAll(
                                    adhanCtrl.state.middleOfTheNight.value
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.5)),
                                onChanged: (_) {
                                  adhanCtrl.getHighLatitudeRule(0);
                                  adhanCtrl.initializeAdhan();
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'سبع الليل',
                                style: TextStyle(
                                  fontFamily: 'kufi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              Switch(
                                value: adhanCtrl.state.seventhOfTheNight.value,
                                activeColor: Colors.red,
                                inactiveTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.5),
                                activeTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.7),
                                thumbColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.surface),
                                trackOutlineColor: WidgetStatePropertyAll(
                                    adhanCtrl.state.seventhOfTheNight.value
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.5)),
                                onChanged: (_) {
                                  adhanCtrl.getHighLatitudeRule(1);
                                  adhanCtrl.initializeAdhan();
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'بإستخدام الزاوية',
                                style: TextStyle(
                                  fontFamily: 'kufi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              Switch(
                                value: adhanCtrl.state.twilightAngle.value,
                                activeColor: Colors.red,
                                inactiveTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.5),
                                activeTrackColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.7),
                                thumbColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.surface),
                                trackOutlineColor: WidgetStatePropertyAll(
                                    adhanCtrl.state.twilightAngle.value
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.5)),
                                onChanged: (_) {
                                  adhanCtrl.getHighLatitudeRule(2);
                                  adhanCtrl.initializeAdhan();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                const Gap(32),
                SettingPrayerTimes(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
