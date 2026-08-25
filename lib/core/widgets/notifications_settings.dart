import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../services/notifications_manager.dart';
import '../utils/helpers/app_text_styles.dart';
import 'container_button.dart';
import 'custom_switch_widget.dart';

/// قسم إعدادات التذكيرات الذكية — يُضاف داخل [SettingsList].
///
/// كل تغيير هنا يعيد جدولة هضم اليوم فورًا عبر [NotificationManager].
class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  NotificationManager get manager => NotificationManager.instance;

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: manager.manualHour ?? 20,
        minute: manager.manualMinute ?? 0,
      ),
    );
    if (picked == null) return;
    await manager.setManualTime(picked.hour, picked.minute);
    setState(() {});
  }

  Future<void> _pickQuietStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: manager.quietStartHour, minute: 0),
    );
    if (picked == null) return;
    await manager.setQuietHours(picked.hour, manager.quietEndHour);
    setState(() {});
  }

  Future<void> _pickQuietEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: manager.quietEndHour, minute: 0),
    );
    if (picked == null) return;
    await manager.setQuietHours(manager.quietStartHour, picked.hour);
    setState(() {});
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
      child: Column(
        children: [
          Text('smartReminders'.tr, style: AppTextStyles.titleMedium()),
          const Gap(4),
          divider,
          const Gap(8),
          CustomSwitchListTile(
            title: 'smartReminders'.tr,
            subtitle: 'smartRemindersDesc'.tr,
            value: manager.isEnabled,
            onChanged: (value) async {
              await manager.setEnabled(value);
              setState(() {});
            },
          ),
          if (manager.isEnabled) ...[
            const Gap(8),
            divider,
            const Gap(8),
            _reminderTimeTile(context),
            const Gap(8),
            divider,
            const Gap(8),
            _quietHoursSection(context, divider),
            const Gap(8),
            divider,
            const Gap(8),
            _contentSection(context),
          ],
        ],
      ),
    );
  }

  Widget _reminderTimeTile(BuildContext context) {
    final isAuto = manager.manualHour == null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: .15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
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
                titleStyle: AppTextStyles.titleMedium().copyWith(fontSize: 14),
                onPressed: () async {
                  await manager.setManualTime(null);
                  setState(() {});
                },
              ),
              const Gap(4),
              ContainerButton(
                title: isAuto
                    ? '--:--'
                    : _formatTime(
                        manager.manualHour!,
                        manager.manualMinute ?? 0,
                      ),
                titleColor: context.theme.colorScheme.inversePrimary,
                value: (!isAuto).obs,
                height: 32,
                verticalPadding: 4.0,
                horizontalPadding: 8.0,
                onPressed: _pickReminderTime,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quietHoursSection(BuildContext context, Widget divider) {
    return Column(
      children: [
        CustomSwitchListTile(
          title: 'quietHours'.tr,
          subtitle:
              '${'from'.tr} ${_formatTime(manager.quietStartHour)} '
              '${'to'.tr} ${_formatTime(manager.quietEndHour)}',
          value: manager.isQuietHoursEnabled,
          onChanged: (value) async {
            await manager.setQuietHoursEnabled(value);
            setState(() {});
          },
        ),
        if (manager.isQuietHoursEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'from'.tr,
                        style: AppTextStyles.titleMedium().copyWith(height: 2),
                      ),
                      const Gap(8),
                      ContainerButton(
                        title: _formatTime(manager.quietStartHour),
                        height: 32,
                        verticalPadding: 4.0,
                        horizontalPadding: 8.0,
                        onPressed: _pickQuietStart,
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'to'.tr,
                        style: AppTextStyles.titleMedium().copyWith(height: 2),
                        textAlign: TextAlign.end,
                      ),
                      const Gap(8),
                      ContainerButton(
                        title: _formatTime(manager.quietEndHour),
                        height: 32,
                        verticalPadding: 4.0,
                        horizontalPadding: 8.0,
                        onPressed: _pickQuietEnd,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _contentSection(BuildContext context) {
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
          value: manager.isQuranContentEnabled,
          onChanged: (value) async {
            await manager.setQuranContentEnabled(value);
            setState(() {});
          },
        ),
        const Gap(4),
        CustomSwitchListTile(
          title: 'islamicLibrary'.tr,
          value: manager.isBooksContentEnabled,
          onChanged: (value) async {
            await manager.setBooksContentEnabled(value);
            setState(() {});
          },
        ),
        const Gap(4),
        CustomSwitchListTile(
          title: 'khatmah'.tr,
          value: manager.isKhatmahContentEnabled,
          onChanged: (value) async {
            await manager.setKhatmahContentEnabled(value);
            setState(() {});
          },
        ),
      ],
    );
  }
}
