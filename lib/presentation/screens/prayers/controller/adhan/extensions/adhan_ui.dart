import '../../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../adhan_controller.dart';

extension AdhanUi on AdhanController {
  /// -------- [OnTaps] ----------

  void shafiOnTap() {
    state.isHanafi.value = true;
    initializeAdhanVariables();
    // sl<NotificationController>().initializeNotification();
    state.box.write(SHAFI, state.isHanafi.value);
  }

  void hanafiOnTap() {
    state.isHanafi.value = false;
    initializeAdhanVariables();
    // sl<NotificationController>().initializeNotification();
    state.box.write(SHAFI, state.isHanafi.value);
  }

  Future<void> removeOnTap(int index) async {
    print("Before remove: ${state.adjustments[index].value}");
    state.adjustments[index].value -= 1;
    state.box.write(prayerNameList[index]['sharedAdjustment'],
        state.adjustments[index].value);
    print("After remove: ${state.adjustments[index].value}");
    await initTimes();
    // sl<NotificationController>().initializeNotification();
    update();
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
    state.autoCalculationMethod.value = !state.autoCalculationMethod.value;
    await initializeAdhanVariables();
    // sl<NotificationController>().initializeNotification();
    state.box.write(AUTO_CALCULATION, value);
  }
}
