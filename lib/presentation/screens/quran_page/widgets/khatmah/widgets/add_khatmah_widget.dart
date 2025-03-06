part of '../../../quran.dart';

class AddKhatmahWidget extends StatelessWidget {
  AddKhatmahWidget({super.key});

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'createKhatmah'.tr,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 20,
              fontFamily: 'kufi',
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    TextFieldBarWidget(
                      controller: khatmahCtrl.nameController,
                      hintText: 'khatmahName'.tr,
                      prefixIcon: const SizedBox.shrink(),
                      horizontalPadding: 4.0,
                      onPressed: () => khatmahCtrl.nameController.clear(),
                      onChanged: null,
                      onSubmitted: null,
                    ),
                    const Gap(8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Obx(() => CustomDropdown<int>(
                                enabled: !khatmahCtrl.isTahzibSahabah.value,
                                decoration: CustomDropdownDecoration(
                                  closedFillColor:
                                      Theme.of(context).colorScheme.surface,
                                  expandedFillColor:
                                      Theme.of(context).colorScheme.surface,
                                  closedBorderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                closedHeaderPadding: const EdgeInsets.symmetric(
                                    vertical: 7.0, horizontal: 8.0),
                                // hintText: 'المدة',
                                hintBuilder: (context, _, select) => Text(
                                  'duration'.tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'kufi',
                                  ),
                                ),

                                items: List.generate(100, (index) => index + 1),
                                listItemBuilder: (context, index, select, _) =>
                                    Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'naskh',
                                  ),
                                ),
                                initialItem: null,
                                onChanged: (value) {
                                  log('changing value to: $value');
                                  khatmahCtrl.daysController.text =
                                      (value! + 1).toString();
                                },
                              )),
                        ),
                        const Gap(16),
                        Expanded(
                          flex: 6,
                          child: Obx(() => GestureDetector(
                                onTap: () => khatmahCtrl.isTahzibSahabahOnTap(),
                                child: Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 7.0),
                                  decoration: BoxDecoration(
                                    color: khatmahCtrl.isTahzibSahabah.value
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withValues(alpha: .3),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'divisionBySahabah'.tr,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        fontSize: 14,
                                        fontFamily: 'kufi',
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Expanded(
                flex: 1,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: ElevatedButtonWidget(
                    onClick: () => khatmahCtrl.addKhatmahOnTap(),
                    index: 0,
                    height: 40,
                    width: 110,
                    color: Theme.of(context).colorScheme.surface,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'addKhatmah'.tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'kufi',
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          GestureDetector(
            onTap: () {
              Get.dialog(Dialog(
                alignment: Alignment.bottomCenter,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ColorPicker(
                      // Use the screenPickerColor as color.
                      color: Color(khatmahCtrl.screenPickerColor.value),
                      // Update the khatmahCtrl.screenPickerColor.value using the callback.
                      onColorChanged: (Color color) =>
                          khatmahCtrl.screenPickerColor.value = color.value,
                      pickerTypeLabels: {
                        ColorPickerType.accent: 'accent'.tr,
                        ColorPickerType.primary: 'primary'.tr
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
                      // subheading: context.hDivider(
                      //     width: Get.width,
                      //     color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ));
            },
            child: Container(
              width: Get.width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Text(
                    'choiceColor'.tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                  const Spacer(),
                  Obx(() => Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Color(khatmahCtrl.screenPickerColor.value),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
