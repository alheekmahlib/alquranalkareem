import 'package:get/get.dart';

import '/core/services/notifications_manager.dart';

/// متحكم واجهة إعدادات التذكيرات الذكية — طبقة عرض رفيعة فوق
/// [NotificationManager] (مصدر الحقيقة في GetStorage) تضيف التفاعلية
/// عبر update() لبناء [GetBuilder].
class NotificationsSettingsController extends GetxController {
  static NotificationsSettingsController get instance =>
      GetInstance().putOrFind(() => NotificationsSettingsController());

  final NotificationManager _manager = NotificationManager.instance;

  bool get isEnabled => _manager.isEnabled;

  int? get manualHour => _manager.manualHour;

  int? get manualMinute => _manager.manualMinute;

  bool get isQuietHoursEnabled => _manager.isQuietHoursEnabled;

  int get quietStartHour => _manager.quietStartHour;

  int get quietEndHour => _manager.quietEndHour;

  bool get isQuranContentEnabled => _manager.isQuranContentEnabled;

  bool get isBooksContentEnabled => _manager.isBooksContentEnabled;

  bool get isKhatmahContentEnabled => _manager.isKhatmahContentEnabled;

  Future<void> setEnabled(bool value) async {
    await _manager.setEnabled(value);
    update();
  }

  /// تعيين وقت يدوي، أو null للعودة إلى الاختيار التلقائي الذكي.
  Future<void> setManualTime(int? hour, [int? minute]) async {
    await _manager.setManualTime(hour, minute);
    update();
  }

  Future<void> setQuietHoursEnabled(bool value) async {
    await _manager.setQuietHoursEnabled(value);
    update();
  }

  Future<void> setQuietHours(int startHour, int endHour) async {
    await _manager.setQuietHours(startHour, endHour);
    update();
  }

  Future<void> setQuranContentEnabled(bool value) async {
    await _manager.setQuranContentEnabled(value);
    update();
  }

  Future<void> setBooksContentEnabled(bool value) async {
    await _manager.setBooksContentEnabled(value);
    update();
  }

  Future<void> setKhatmahContentEnabled(bool value) async {
    await _manager.setKhatmahContentEnabled(value);
    update();
  }
}
