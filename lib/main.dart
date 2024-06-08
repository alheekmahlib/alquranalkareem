import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '/core/services/languages/dependency_inj.dart' as dep;
import 'core/services/services_locator.dart';
import 'core/widgets/home_widget/prayers_widget/prayers_widget_config.dart';
import 'myApp.dart';
import 'presentation/controllers/home_widget_controller.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding;
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Map<String, Map<String, String>> languages = await dep.init();
  await initializeApp();
  // Initialize WorkManager
  Workmanager().initialize(
    callbackDispatcherHijri,
    isInDebugMode: true, // Set to false for production
  );

  // Cancel all previous tasks to avoid scheduling conflict
  await Workmanager().cancelAll();

  // Register the task (for testing purposes)
  Workmanager().registerOneOffTask(
    "1",
    "com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget",
    initialDelay: const Duration(seconds: 20),
  );

  runApp(MyApp(
    languages: languages,
  ));
}

Future<void> initializeApp() async {
  Future.delayed(const Duration(seconds: 0));
  await GetStorage.init();
  await ServicesLocator().init();
  tz.initializeTimeZones();
  FlutterNativeSplash.remove();
}

// void callbackDispatcherHijri() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Workmanager().executeTask((task, inputData) async {
//     final HomeWidgetController homeWCtrl = Get.find();
//     HijriWidgetConfig().updateHijriDate();
//     homeWCtrl.registerDailyTask();
//     return Future.value(true);
//   });
// }

void callbackDispatcherHijri() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    print("Background Task Triggered: $task");

    try {
      // Simulate task execution
      await Future.delayed(const Duration(seconds: 2));
      print("Background Task Completed Successfully: $task");
      return Future.value(true);
    } catch (e) {
      print("Background Task Error: $e");
      return Future.value(false);
    }
  });
}

void callbackDispatcherPrayers() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    if (Platform.isIOS) {
      final HomeWidgetController homeWCtrl = Get.find();
      PrayersWidgetConfig().updatePrayersDate();
      homeWCtrl.registerDailyPrayers();
    }
    return Future.value(true);
  });
}
