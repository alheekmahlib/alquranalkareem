import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/services/notifications_helper.dart';
import '../controller/adhkar_controller.dart';
import '../controller/reminder/reminder_controller.dart';

class AdhkarReminderWidget extends StatelessWidget {
  final adhkarCtrl = AzkarController.instance;
  final reminderCtrl = ReminderController.instance;

  AdhkarReminderWidget() {
    NotifyHelper.initAwesomeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .9,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              context.customWhiteClose(height: 30),
              const Gap(8),
              context.vDivider(height: 20),
              const Gap(8),
              Text(
                'reminders'.tr,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const Gap(16),
          Flexible(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildSwitchListTile(
                    context,
                    "أذكار الصباح",
                    reminderCtrl.state.isMorningEnabled,
                    false,
                  ),
                  const Gap(8),
                  _buildSwitchListTile(
                    context,
                    "أذكار المساء",
                    reminderCtrl.state.isEveningEnabled,
                    false,
                  ),
                  const Gap(16),
                  context.hDivider(width: Get.width),
                  const Gap(16),
                  reminderCtrl.state.customAdhkar.isNotEmpty
                      ? Text(
                          "customReminder".tr,
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Gap(8),
                  ...reminderCtrl.state.customAdhkar.entries.map((entry) {
                    String id = entry.key;
                    String reminder = entry.value;
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: !(reminderCtrl
                                        .state.customAdhkarEnabled[id] ??
                                    false)
                                ? Theme.of(context).canvasColor.withOpacity(.1)
                                : Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.15),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              width: 1,
                              color: !(reminderCtrl
                                          .state.customAdhkarEnabled[id] ??
                                      false)
                                  ? Colors.transparent
                                  : Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          child: _buildSwitchListTile(
                            context,
                            reminder,
                            RxBool(reminderCtrl.state.customAdhkarEnabled[id] ??
                                false),
                            true,
                            id,
                          ),
                        ),
                        const Gap(8),
                      ],
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: () => _addNewReminder(context),
                    child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        'addMore'.tr,
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 18,
                          fontFamily: 'kufi',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchListTile(
      BuildContext context, String title, RxBool isEnabled, bool isDelete,
      [String? id]) {
    return Container(
      decoration: BoxDecoration(
        color: !isEnabled.value
            ? Theme.of(context).canvasColor.withOpacity(.1)
            : Theme.of(context).colorScheme.surface.withOpacity(.15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 1,
          color: !isEnabled.value
              ? Colors.transparent
              : Theme.of(context).colorScheme.surface,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).canvasColor,
            fontSize: 22,
            fontFamily: 'naskh',
          ),
        ),
        secondary: isDelete
            ? IconButton(
                icon: Icon(Icons.delete,
                    size: 24, color: Theme.of(context).canvasColor),
                onPressed: () => reminderCtrl.removeCustomAdhkar(id ?? title),
              )
            : const SizedBox.shrink(),
        value: isEnabled.value,
        activeColor: Theme.of(context).colorScheme.surface,
        inactiveTrackColor: Theme.of(context).canvasColor.withOpacity(.5),
        onChanged: (value) {
          if (value) {
            _showTimePickerDialog(context, title, id ?? title);
          } else {
            reminderCtrl.toggleAdhkarEnabled(id ?? title, false);
          }
        },
      ),
    );
  }

  void _showTimePickerDialog(
      BuildContext context, String title, String id) async {
    print('Opening time picker for: $title');

    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        confirmText: 'ok'.tr,
        cancelText: 'cancel'.tr,
        helpText: 'selectTime'.tr);

    if (pickedTime != null) {
      int hour = pickedTime.hour;
      int minute = pickedTime.minute;
      print('Picked time: $hour:$minute');

      NotifyHelper().scheduledNotification(id.hashCode, title,
          "تذكير ${title.toLowerCase()}", DateTime(hour, minute));
      reminderCtrl.toggleAdhkarEnabled(id, true);
      // Ensure the switch is set to true in the UI
      if (title == "أذكار الصباح") {
        reminderCtrl.state.isMorningEnabled.value = true;
        reminderCtrl.state.box.write(title, true);
      } else if (title == "أذكار المساء") {
        reminderCtrl.state.isEveningEnabled.value = true;
        reminderCtrl.state.box.write(title, true);
      } else {
        reminderCtrl.state.customAdhkarEnabled[id] = true;
        reminderCtrl.state.box.write('custom_$id', true);
      }
    } else {
      print('Time picker canceled or closed.');
      reminderCtrl.toggleAdhkarEnabled(id, false);
      // Ensure the switch is set to false in the UI
      if (title == "أذكار الصباح") {
        reminderCtrl.state.isMorningEnabled.value = false;
        reminderCtrl.state.box.write(title, false);
      } else if (title == "أذكار المساء") {
        reminderCtrl.state.isEveningEnabled.value = false;
        reminderCtrl.state.box.write(title, false);
      } else {
        reminderCtrl.state.customAdhkarEnabled[id] = false;
        reminderCtrl.state.box.write('custom_$id', false);
      }
    }
  }

  void _addNewReminder(BuildContext context) {
    if (adhkarCtrl.state.categories.isEmpty) {
      adhkarCtrl.state.categories.addAll(['صباح', 'مساء']);
    }

    Get.dialog(
      Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          height: 170,
          child: Column(
            children: [
              const Gap(16),
              Text(
                'chooseDhekr'.tr,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: 18,
                  fontFamily: 'kufi',
                ),
              ),
              const Gap(16),
              Obx(() {
                if (adhkarCtrl.state.selectedCategory.value == null ||
                    !adhkarCtrl.state.categories
                        .contains(adhkarCtrl.state.selectedCategory.value)) {
                  adhkarCtrl.state.selectedCategory.value =
                      adhkarCtrl.state.categories.first;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomDropdown<String>(
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Theme.of(context).canvasColor,
                      expandedFillColor: Theme.of(context).canvasColor,
                      closedBorderRadius:
                          const BorderRadius.all(Radius.circular(8)),
                    ),
                    closedHeaderPadding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 8.0),
                    hintBuilder: (context, _, select) => Text(
                      adhkarCtrl.state.selectedCategory.value!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'naskh',
                      ),
                    ),
                    items: List.generate(adhkarCtrl.state.categories.length,
                        (index) => adhkarCtrl.state.categories[index]),
                    listItemBuilder: (context, category, select, _) => Text(
                      '$category',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'naskh',
                      ),
                    ),
                    initialItem: null,
                    onChanged: (newValue) =>
                        adhkarCtrl.state.selectedCategory.value = newValue!,
                  ),
                );
              }),
              const Gap(16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff000000).withOpacity(.6),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 16,
                          fontFamily: 'kufi',
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () {
                      String selectedCategory =
                          adhkarCtrl.state.selectedCategory.value!;
                      print('Selected category: $selectedCategory');
                      Get.back();
                      reminderCtrl.addCustomAdhkar(selectedCategory);
                      _showTimePickerDialog(context, selectedCategory,
                          '$selectedCategory${DateTime.now().millisecondsSinceEpoch}');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff000000).withOpacity(.6),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        'ok'.tr,
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 16,
                          fontFamily: 'kufi',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
