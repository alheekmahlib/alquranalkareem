import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '/core/services/languages/dependency_inj.dart' as dep;
import 'core/services/services_locator.dart';
import 'myApp.dart';
import 'presentation/controllers/notification_controller.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding;
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Map<String, Map<String, String>> languages = await dep.init();
  initializeApp().then((_) {
    runApp(MyApp(
      languages: languages,
    ));
  });
}

Future<void> initializeApp() async {
  Future.delayed(const Duration(seconds: 0));
  await ServicesLocator().init();
  sl<NotificationController>().schedulePrayerNotifications();
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  FlutterNativeSplash.remove();
}

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     // Initialize as needed
//     await NotificationController().schedulePrayerNotifications();
//     return Future.value(true);
//   });
// }
