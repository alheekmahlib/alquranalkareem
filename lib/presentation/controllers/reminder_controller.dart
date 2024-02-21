import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/data/models/reminder_model.dart';
import '../../core/services/local_notifications.dart';
import '../../core/services/reminder_storage.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';

class ReminderController extends GetxController {
  bool iosStyle = true;
  TimeOfDay? changedTimeOfDay;
  bool isReminderEnabled = false;
  RxList<Reminder> reminders = RxList<Reminder>();
  Time time = Time(hour: 11, minute: 30, second: 20);

  /// Reminder
  void loadReminders() async {
    List<Reminder> loadedReminders = await ReminderStorage.loadReminders();
    reminders.value = RxList<Reminder>(loadedReminders);
  }

  Future<bool> showTimePicker(BuildContext context, Reminder reminder) async {
    bool isConfirmed = false;
    Time initialTime = time;
    TimeOfDay initialTimeOfDay =
        TimeOfDay(hour: initialTime.hour, minute: initialTime.minute);

    await Navigator.of(context).push(
      showPicker(
        context: context,
        value: time,
        onChange: (time) {
          changedTimeOfDay = time;
          print(changedTimeOfDay);
        },
        accentColor: Theme.of(context).colorScheme.surface,
        okText: 'ok'.tr,
        okStyle: TextStyle(
          fontFamily: 'kufi',
          fontSize: 14,
          color: Theme.of(context).colorScheme.surface,
        ),
        cancelText: 'cancel'.tr,
        cancelStyle: TextStyle(
            fontFamily: 'kufi',
            fontSize: 14,
            color: Theme.of(context).colorScheme.surface),
        themeData: ThemeData(
          cardColor: Theme.of(context).colorScheme.background,
        ),
      ),
    );

    if (changedTimeOfDay != null && changedTimeOfDay != initialTimeOfDay) {
      final int hour = changedTimeOfDay!.hour;
      final int minute = changedTimeOfDay!.minute;
      // Update the reminder's time
      reminder.time = Time(hour: hour, minute: minute);
      // Schedule the notification with the reminder's ID
      await NotifyHelper().scheduledNotification(
          context, reminder.id, hour, minute, reminder.name);
      isConfirmed = true;
    }

    return isConfirmed;
  }

  Future<void> addReminder() async {
    String reminderName = "";

    DateTime now = DateTime.now();
    Time currentTime = Time(hour: now.hour, minute: now.minute);

    reminders.add(Reminder(
        id: reminders.length,
        isEnabled: false,
        time: currentTime,
        name: reminderName));
    ReminderStorage.saveReminders(reminders);
  }

  deleteReminder(BuildContext context, int index) async {
    // Cancel the scheduled notification
    await NotifyHelper().cancelScheduledNotification(reminders[index].id);

    // Delete the reminder
    await ReminderStorage.deleteReminder(index)
        .then((value) => context.showCustomErrorSnackBar('deletedReminder'.tr));

    // Update the reminders list
    reminders.removeAt(index);

    // Update the reminder IDs
    for (int i = index; i < reminders.length; i++) {
      reminders[i].id = i;
    }

    // Save the updated reminders list
    ReminderStorage.saveReminders(reminders);
  }

  void onTimeChanged(Time newTime) {
    time = newTime;
  }
}
