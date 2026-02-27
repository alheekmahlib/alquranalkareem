part of '../../../quran.dart';

class AddKhatmahWidget extends StatelessWidget {
  AddKhatmahWidget({super.key});

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: context.theme.primaryColorLight.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// --- اسم الختمة ---
          TextFieldBarWidget(
            controller: khatmahCtrl.nameController,
            hintText: 'khatmahName'.tr,
            prefixIcon: const SizedBox.shrink(),
            horizontalPadding: 4.0,
            onButtonPressed: () => khatmahCtrl.nameController.clear(),
            onChanged: null,
            onSubmitted: null,
          ),

          /// --- المدة وتحزيب الصحابة ---
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Obx(
                  () => CustomDropdown<int>(
                    enabled: !khatmahCtrl.isTahzibSahabah.value,
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Theme.of(
                        context,
                      ).primaryColorLight.withValues(alpha: .15),
                      expandedFillColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      closedBorderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    closedHeaderPadding: const EdgeInsets.symmetric(
                      vertical: 7.0,
                      horizontal: 8.0,
                    ),
                    hintBuilder: (context, _, select) =>
                        Text('duration'.tr, style: AppTextStyles.titleSmall()),
                    items: List.generate(100, (index) => index + 1),
                    listItemBuilder: (context, index, select, _) =>
                        Text('${index + 1}', style: AppTextStyles.titleSmall()),
                    initialItem: null,
                    onChanged: (value) {
                      log('changing value to: $value');
                      khatmahCtrl.daysController.text = (value! + 1).toString();
                    },
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                flex: 5,
                child: Obx(
                  () => ContainerButton(
                    onPressed: () => khatmahCtrl.isTahzibSahabahOnTap(),
                    height: 38,
                    horizontalPadding: 8.0,
                    verticalPadding: 7.0,
                    value: khatmahCtrl.isTahzibSahabah,
                    backgroundColor: khatmahCtrl.isTahzibSahabah.value
                        ? Theme.of(
                            context,
                          ).primaryColorLight.withValues(alpha: .5)
                        : Theme.of(
                            context,
                          ).primaryColorLight.withValues(alpha: .3),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'divisionBySahabah'.tr,
                        style: AppTextStyles.titleSmall(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),

          /// --- اختيار اللون وزر الإضافة ---
          Row(
            children: [
              Expanded(
                child: ContainerButton(
                  onPressed: () {
                    Get.dialog(
                      Dialog(
                        alignment: Alignment.bottomCenter,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: SizedBox(
                          height: 450,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ColorPicker(
                              color: Color(khatmahCtrl.screenPickerColor.value),
                              onColorChanged: (Color color) =>
                                  khatmahCtrl.screenPickerColor.value = color
                                      .toARGB32(),
                              pickerTypeLabels: {
                                ColorPickerType.accent: 'accent'.tr,
                                ColorPickerType.primary: 'primary'.tr,
                              },
                              width: 44,
                              borderRadius: 22,
                              heading: Text(
                                'choiceColor'.tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'kufi',
                                  height: .5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  height: 40,
                  withArrow: true,
                  horizontalPadding: 12.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: Color(khatmahCtrl.screenPickerColor.value),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Text('choiceColor'.tr, style: AppTextStyles.titleSmall()),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => khatmahCtrl.addKhatmahOnTap(),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'addKhatmah'.tr,
                      style: AppTextStyles.titleSmall(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
