part of '../../../prayers.dart';

extension AdhanUi on AdhanController {
  /// -------- [OnTaps] ----------

  void shafiOnTap() {
    state.isHanafi.value = true;
    // sl<NotificationController>().initializeNotification();
    state.box.write(SHAFI, state.isHanafi.value);
    initializeAdhan();
  }

  void hanafiOnTap() {
    state.isHanafi.value = false;
    // sl<NotificationController>().initializeNotification();
    state.box.write(SHAFI, state.isHanafi.value);
    initializeAdhan();
    // update();
  }

  Future<void> removeOnTap(int index) async {
    print("Before remove: ${state.adjustments[index].value}");
    state.adjustments[index].value -= 1;
    state.box.write(prayerNameList[index]['sharedAdjustment'],
        state.adjustments[index].value);
    print("After remove: ${state.adjustments[index].value}");
    initializeAdhan();
    // sl<NotificationController>().initializeNotification();
    // update();
  }

  Future<void> addOnTap(int index) async {
    print("Before add: ${state.adjustments[index].value}");
    state.adjustments[index].value += 1;
    state.box.write(prayerNameList[index]['sharedAdjustment'],
        state.adjustments[index].value);
    print("After add: ${state.adjustments[index].value}");
    await initTimes();
    // sl<NotificationController>().initializeNotification();
    update();
  }

  Future<void> switchAutoCalculation(bool value) async {
    state.autoCalculationMethod.value = value;
    // sl<NotificationController>().initializeNotification();
    state.box.write(AUTO_CALCULATION, value);
    initializeAdhan();
  }

  void notificationOptionsOnTap(int i, int prayerIndex) {
    PrayersNotificationsCtrl.instance.scheduleDailyNotificationForPrayer(
      prayerIndex,
      (prayerNameList[prayerIndex]['hourTime'] as DateTime),
      prayerNameList[prayerIndex]['title'],
      notificationOptions[i]['title'],
    );
    Get.back();
    update();
  }
}
