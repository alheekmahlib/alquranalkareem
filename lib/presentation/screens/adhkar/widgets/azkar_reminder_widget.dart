import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/services/notifications_helper.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../../../../core/widgets/custom_switch_widget.dart';
import '../../../../core/widgets/title_widget.dart';
import '../controller/adhkar_controller.dart';
import '../controller/reminder/reminder_controller.dart';

class AdhkarReminderWidget extends StatelessWidget {
  final adhkarCtrl = AzkarController.instance;
  final reminderCtrl = ReminderController.instance;

  AdhkarReminderWidget() {
    // NotifyHelper.initFlutterLocalNotifications();
    // NotifyHelper.initAwesomeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: 'reminders', textStyle: AppTextStyles.titleLarge()),
        Flexible(
          child: Obx(() {
            return ListView(
              shrinkWrap: true,
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
                reminderCtrl.state.customAdhkar.isNotEmpty
                    ? const Gap(16)
                    : const SizedBox.shrink(),
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
                const Gap(16),
                ...reminderCtrl.state.customAdhkar.entries.map((entry) {
                  String id = entry.key;
                  String reminder = entry.value;
                  return Flexible(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                !(reminderCtrl.state.customAdhkarEnabled[id] ??
                                    false)
                                ? Theme.of(
                                    context,
                                  ).canvasColor.withValues(alpha: .1)
                                : Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: .15),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(
                              width: 1,
                              color:
                                  !(reminderCtrl
                                          .state
                                          .customAdhkarEnabled[id] ??
                                      false)
                                  ? Colors.transparent
                                  : Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          child: _buildSwitchListTile(
                            context,
                            reminder,
                            RxBool(
                              reminderCtrl.state.customAdhkarEnabled[id] ??
                                  false,
                            ),
                            true,
                            id,
                          ),
                        ),
                        const Gap(8),
                      ],
                    ),
                  );
                }).toList(),
                ContainerButton(
                  onPressed: () => _addNewReminder(context),
                  width: double.infinity,
                  title: 'addMore',
                  value: true.obs,
                  withArrow: true,
                  verticalPadding: 8.0,
                  backgroundColor: context.theme.primaryColorLight.withValues(
                    alpha: .1,
                  ),
                ),
                const Gap(16),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSwitchListTile(
    BuildContext context,
    String title,
    RxBool isEnabled,
    bool isDelete, [
    String? id,
  ]) {
    return CustomSwitchListTile(
      title: title,
      value: isEnabled.value,
      onChanged: (value) {
        if (value) {
          _showTimePickerDialog(context, title, id ?? title);
        } else {
          reminderCtrl.toggleAdhkarEnabled(id ?? title, false);
        }
      },
      leading: isDelete
          ? IconButton(
              icon: Icon(
                Icons.delete,
                size: 24,
                color: Theme.of(context).canvasColor,
              ),
              onPressed: () => reminderCtrl.removeCustomAdhkar(id ?? title),
            )
          : null,
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    String title,
    String id,
  ) async {
    print('Opening time picker for: $title');

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      confirmText: 'ok'.tr,
      cancelText: 'cancel'.tr,
      helpText: 'selectTime'.tr,
    );

    if (pickedTime != null) {
      int hour = pickedTime.hour;
      int minute = pickedTime.minute;
      print('Picked time: $pickedTime');

      // Convert TimeOfDay to DateTime
      DateTime now = DateTime.now();
      DateTime scheduleDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      NotifyHelper().scheduledNotification(
        reminderId: id.hashCode,
        title: 'reminders'.tr,
        summary: title,
        body: "تذكير ${title.toLowerCase()}",
        isRepeats: true,
        time: scheduleDateTime,
      );
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
              Text('chooseDhekr'.tr, style: AppTextStyles.titleMedium()),
              const Gap(16),
              Obx(() {
                if (adhkarCtrl.state.selectedCategory.value == null ||
                    !adhkarCtrl.state.categories.contains(
                      adhkarCtrl.state.selectedCategory.value,
                    )) {
                  adhkarCtrl.state.selectedCategory.value =
                      adhkarCtrl.state.categories.first;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomDropdown<String>(
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Theme.of(context).canvasColor,
                      expandedFillColor: Theme.of(context).canvasColor,
                      closedBorderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    closedHeaderPadding: const EdgeInsets.symmetric(
                      vertical: 7.0,
                      horizontal: 8.0,
                    ),
                    hintBuilder: (context, _, select) => Text(
                      adhkarCtrl.state.selectedCategory.value!,
                      style: AppTextStyles.titleMedium(),
                    ),
                    items: List.generate(
                      adhkarCtrl.state.categories.length,
                      (index) => adhkarCtrl.state.categories[index],
                    ),
                    listItemBuilder: (context, category, select, _) =>
                        Text('$category', style: AppTextStyles.titleMedium()),
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
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff000000).withValues(alpha: .6),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: AppTextStyles.titleMedium(),
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
                      _showTimePickerDialog(
                        context,
                        selectedCategory,
                        '$selectedCategory${DateTime.now().millisecondsSinceEpoch}',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff000000).withValues(alpha: .6),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Text('ok'.tr, style: AppTextStyles.titleMedium()),
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
