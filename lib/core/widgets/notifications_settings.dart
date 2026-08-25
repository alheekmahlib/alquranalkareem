import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/notifications_settings_controller.dart';
import '../utils/helpers/app_text_styles.dart';
import 'container_button.dart';
import 'custom_switch_widget.dart';

/// قسم إعدادات التذكيرات الذكية — يُضاف داخل [SettingsList].
///
/// الحالة في [NotificationsSettingsController] (GetX) وكل تغيير يعيد
/// جدولة هضم اليوم فورًا عبر NotificationManager.
class NotificationsSettings extends StatelessWidget {
  NotificationsSettings({super.key});

  final notificationsSettingsCtrl = NotificationsSettingsController.instance;

  Future<void> _pickReminderTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: notificationsSettingsCtrl.manualHour ?? 20,
        minute: notificationsSettingsCtrl.manualMinute ?? 0,
      ),
    );
    if (picked == null) return;
    await notificationsSettingsCtrl.setManualTime(picked.hour, picked.minute);
  }

  Future<void> _pickQuietStart(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: notificationsSettingsCtrl.quietStartHour,
        minute: 0,
      ),
    );
    if (picked == null) return;
    await notificationsSettingsCtrl.setQuietHours(
      picked.hour,
      notificationsSettingsCtrl.quietEndHour,
    );
  }

  Future<void> _pickQuietEnd(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: notificationsSettingsCtrl.quietEndHour,
        minute: 0,
      ),
    );
    if (picked == null) return;
    await notificationsSettingsCtrl.setQuietHours(
      notificationsSettingsCtrl.quietStartHour,
      picked.hour,
    );
  }

  String _formatTime(int hour, [int minute = 0]) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 1.0,
      height: 1.0,
      endIndent: 32.0,
      indent: 32.0,
      color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GetBuilder<NotificationsSettingsController>(
        builder: (ctrl) => Column(
          children: [
            Text('smartReminders'.tr, style: AppTextStyles.titleMedium()),
            const Gap(4),
            divider,
            const Gap(8),
            CustomSwitchListTile(
              title: 'smartReminders'.tr,
              subtitle: 'smartRemindersDesc'.tr,
              value: ctrl.isEnabled,
              onChanged: ctrl.setEnabled,
            ),
            if (ctrl.isEnabled) ...[
              const Gap(8),
              divider,
              const Gap(8),
              _reminderTimeTile(context, ctrl),
              const Gap(8),
              divider,
              const Gap(8),
              _quietHoursSection(context, ctrl),
              const Gap(8),
              divider,
              const Gap(8),
              _contentSection(context, ctrl),
            ],
          ],
        ),
      ),
    );
  }

  Widget _reminderTimeTile(
    BuildContext context,
    NotificationsSettingsController ctrl,
  ) {
    final isAuto = ctrl.manualHour == null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: .15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'reminderTime'.tr,
              style: AppTextStyles.titleMedium().copyWith(height: 2),
            ),
          ),
          ContainerButton(
            title: 'autoTime'.tr,
            titleColor: context.theme.colorScheme.inversePrimary,
            value: isAuto.obs,
            height: 32,
            verticalPadding: 4.0,
            horizontalPadding: 8.0,
            onPressed: () => ctrl.setManualTime(null),
          ),
          const Gap(4),
          ContainerButton(
            title: isAuto
                ? '--:--'
                : _formatTime(ctrl.manualHour!, ctrl.manualMinute ?? 0),
            titleColor: context.theme.colorScheme.inversePrimary,
            value: (!isAuto).obs,
            height: 32,
            verticalPadding: 4.0,
            horizontalPadding: 8.0,
            onPressed: () => _pickReminderTime(context),
          ),
        ],
      ),
    );
  }

  Widget _quietHoursSection(
    BuildContext context,
    NotificationsSettingsController ctrl,
  ) {
    return Column(
      children: [
        CustomSwitchListTile(
          title: 'quietHours'.tr,
          subtitle:
              '${'from'.tr} ${_formatTime(ctrl.quietStartHour)} '
              '${'to'.tr} ${_formatTime(ctrl.quietEndHour)}',
          value: ctrl.isQuietHoursEnabled,
          onChanged: ctrl.setQuietHoursEnabled,
        ),
        if (ctrl.isQuietHoursEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'from'.tr,
                    style: AppTextStyles.titleMedium().copyWith(height: 2),
                  ),
                ),
                ContainerButton(
                  title: _formatTime(ctrl.quietStartHour),
                  height: 32,
                  verticalPadding: 4.0,
                  horizontalPadding: 8.0,
                  onPressed: () => _pickQuietStart(context),
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    'to'.tr,
                    style: AppTextStyles.titleMedium().copyWith(height: 2),
                    textAlign: TextAlign.end,
                  ),
                ),
                ContainerButton(
                  title: _formatTime(ctrl.quietEndHour),
                  height: 32,
                  verticalPadding: 4.0,
                  horizontalPadding: 8.0,
                  onPressed: () => _pickQuietEnd(context),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _contentSection(
    BuildContext context,
    NotificationsSettingsController ctrl,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'digestContent'.tr,
              style: AppTextStyles.titleSmall().copyWith(
                color: context.theme.colorScheme.inversePrimary.withValues(
                  alpha: .7,
                ),
              ),
            ),
          ),
        ),
        const Gap(6),
        CustomSwitchListTile(
          title: 'quran'.tr,
          value: ctrl.isQuranContentEnabled,
          onChanged: ctrl.setQuranContentEnabled,
        ),
        const Gap(4),
        CustomSwitchListTile(
          title: 'islamicLibrary'.tr,
          value: ctrl.isBooksContentEnabled,
          onChanged: ctrl.setBooksContentEnabled,
        ),
        const Gap(4),
        CustomSwitchListTile(
          title: 'khatmah'.tr,
          value: ctrl.isKhatmahContentEnabled,
          onChanged: ctrl.setKhatmahContentEnabled,
        ),
      ],
    );
  }
}
