import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../core/services/local_notifications.dart';
import '../adhkar_state.dart';

class ReminderController extends GetxController {
  static ReminderController get instance =>
      Get.isRegistered<ReminderController>()
          ? Get.find<ReminderController>()
          : Get.put<ReminderController>(ReminderController());

  AdhkarState state = AdhkarState();
  final box = GetStorage();
  final NotifyHelper notifyHelper = NotifyHelper();

  @override
  void onInit() {
    super.onInit();
    loadCustomAdhkarData();
    loadSwitchValues();
  }

  void addCustomAdhkar(String category) {
    String id = '$category${DateTime.now().millisecondsSinceEpoch}';
    state.customAdhkar[id] = category;
    state.customAdhkarEnabled[id] = false;
    saveCustomAdhkarData();
    box.write('custom_$id', false);
    update();
  }

  void removeCustomAdhkar(String id) {
    state.customAdhkar.remove(id);
    state.customAdhkarEnabled.remove(id);
    saveCustomAdhkarData();
    box.remove('custom_$id');
    notifyHelper.cancelScheduledNotification(id.hashCode);
    update();
  }

  void toggleAdhkarEnabled(String id, bool isEnabled) {
    if (id == "أذكار الصباح") {
      state.isMorningEnabled.value = isEnabled;
      box.write('custom_أذكار الصباح', isEnabled);
    } else if (id == "أذكار المساء") {
      state.isEveningEnabled.value = isEnabled;
      box.write('custom_أذكار المساء', isEnabled);
    } else {
      state.customAdhkarEnabled[id] = isEnabled;
      box.write('custom_$id', isEnabled);
    }

    if (!isEnabled) {
      notifyHelper.cancelScheduledNotification(id.hashCode);
    }

    update();
  }

  bool loadSwitchValue(String key) {
    return box.read<bool>(key) ?? false;
  }

  void loadSwitchValues() {
    state.isMorningEnabled.value = loadSwitchValue('custom_أذكار الصباح');
    state.isEveningEnabled.value = loadSwitchValue('custom_أذكار المساء');
    for (var id in state.customAdhkar.keys) {
      state.customAdhkarEnabled[id] = loadSwitchValue('custom_$id');
    }
    update();
  }

  void saveCustomAdhkarData() {
    box.write('customAdhkar', state.customAdhkar);
    box.write('customAdhkarEnabled', state.customAdhkarEnabled);
  }

  void loadCustomAdhkarData() {
    Map<String, String> customAdhkarMap =
        box.read<Map>('customAdhkar')?.cast<String, String>() ?? {};
    Map<String, bool> customAdhkarEnabledMap = Map<String, bool>.from(
        box.read<Map>('customAdhkarEnabled')?.cast<String, bool>() ?? {});

    state.customAdhkar.assignAll(customAdhkarMap);
    state.customAdhkarEnabled.assignAll(customAdhkarEnabledMap);
  }
}
