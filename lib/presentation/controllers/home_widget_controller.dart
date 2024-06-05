import 'dart:developer';

import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/utils/constants/string_constants.dart';
import '../../core/widgets/home_widget/hijri_widget/hijri_widget_config.dart';
import '../../core/widgets/home_widget/prayers_widget/prayers_widget_config.dart';

class HomeWidgetController extends GetxController {
  static HomeWidgetController get instance =>
      Get.isRegistered<HomeWidgetController>()
          ? Get.find<HomeWidgetController>()
          : Get.put<HomeWidgetController>(HomeWidgetController());
  RxString hijriPathImage = ''.obs;
  RxString prayersPathImages = ''.obs;

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(StringConstants.groupId);
  }

  void registerDailyTask() {
    try {
      Workmanager().registerOneOffTask(
        'com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget_${DateTime.now().millisecondsSinceEpoch}',
        'com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget',
        initialDelay: const Duration(hours: 12),
      );
      log('Register a new Hijri widget');
    } catch (e) {
      log('Error scheduling daily task: $e', name: 'NotificationsCtrl');
    }
  }

  void registerDailyPrayers() {
    try {
      Workmanager().registerOneOffTask(
        'com.alheekmah.alquranalkareem.alquranalkareem.prayersWidget_${DateTime.now().millisecondsSinceEpoch}',
        'com.alheekmah.alquranalkareem.alquranalkareem.prayersWidget',
        initialDelay: const Duration(minutes: 15),
      );
      log('Register a new Prayers widget');
    } catch (e) {
      log('Error scheduling daily task: $e', name: 'NotificationsCtrl');
    }
  }

  // void registerDailyPrayers() {
  //   try {
  //     adhanCtrl.getTimeLeftForNextPrayer()
  //     Workmanager().registerOneOffTask(
  //       'com.alheekmah.alquranalkareem.alquranalkareem.currentPrayerTime_${DateTime.now().millisecondsSinceEpoch}',
  //       'com.alheekmah.alquranalkareem.alquranalkareem.currentPrayerTime',
  //       initialDelay: const Duration(minutes: 2),
  //     );
  //     log('Register a new Prayers widget');
  //   } catch (e) {
  //     log('Error scheduling daily task: $e', name: 'NotificationsCtrl');
  //   }
  // }

  @override
  void onInit() {
    Workmanager().initialize(
      callbackDispatcherHijri,
      isInDebugMode: true,
    );
    Workmanager().initialize(
      callbackDispatcherPrayers,
      isInDebugMode: true,
    );
    super.onInit();
  }
}

void callbackDispatcherHijri() {
  Workmanager().executeTask((task, inputData) async {
    final HomeWidgetController homeWCtrl = Get.find();
    HijriWidgetConfig().updateHijriDate();
    homeWCtrl.registerDailyTask();
    return Future.value(true);
  });
}

void callbackDispatcherPrayers() {
  Workmanager().executeTask((task, inputData) async {
    final HomeWidgetController homeWCtrl = Get.find();
    PrayersWidgetConfig().updatePrayersDate();
    homeWCtrl.registerDailyPrayers();
    return Future.value(true);
  });
}
