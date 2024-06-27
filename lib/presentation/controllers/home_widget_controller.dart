import 'dart:developer';

import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import '../../main.dart';

class HomeWidgetController extends GetxController {
  static HomeWidgetController get instance =>
      Get.isRegistered<HomeWidgetController>()
          ? Get.find<HomeWidgetController>()
          : Get.put<HomeWidgetController>(HomeWidgetController());
  RxString hijriPathImage = ''.obs;
  RxString prayersPathImages = ''.obs;

  // void registerDailyTask() {
  //   try {
  //     Workmanager().registerOneOffTask(
  //       'com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget_${DateTime.now().millisecondsSinceEpoch}',
  //       'com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget',
  //       initialDelay: const Duration(hours: 12),
  //     );
  //     log('Register a new Hijri widget');
  //   } catch (e) {
  //     log('Error scheduling daily task: $e', name: 'NotificationsCtrl');
  //   }
  // }

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
    // Workmanager().initialize(
    //   callbackDispatcherHijri,
    //   isInDebugMode: true,
    // );
    Workmanager().initialize(
      callbackDispatcherPrayers,
      isInDebugMode: true,
    );
    super.onInit();
  }
}
