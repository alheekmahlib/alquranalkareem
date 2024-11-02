part of '../../../prayers.dart';

extension ScheduleDailyExtension on PrayersNotificationsCtrl {
  Future<void> scheduleDailyNotificationForPrayer(
    int prayerId,
    DateTime prayerTime,
    String prayerName,
    String notificationType,
  ) {
    if ('nothing' == notificationType) {
      GetStorage('AdhanSounds').remove('scheduledAdhan_$prayerName');
      log('منبة صلاة $prayerName removed');
      return NotifyHelper().cancelNotification(prayerId);
    }
    GetStorage('AdhanSounds')
        .write('scheduledAdhan_$prayerName', notificationType);
    return NotifyHelper().scheduledNotification(
      prayerId,
      'منبة صلاة $prayerName',
      'حان وقت صلاة $prayerName',
      // time: prayerTime,
      payload: {'sound_type': notificationType},
    );
  }
}
