import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

import '/core/services/languages/dependency_inj.dart' as dep;
import 'core/services/background_services.dart';
import 'core/services/notifications_helper.dart';
import 'core/services/services_locator.dart';
import 'myApp.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding;
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Map<String, Map<String, String>> languages = await dep.init();
  await initializeApp();

  runApp(MyApp(
    languages: languages,
  ));
}

Future<void> initializeApp() async {
  Future.delayed(const Duration(seconds: 0));
  await GetStorage.init();
  await ServicesLocator().init();
  tz.initializeTimeZones();
  NotifyHelper.initAwesomeNotifications();
  if (Platform.isIOS || Platform.isAndroid) {
    await BGServices().registerTask();
  }
  FlutterNativeSplash.remove();
  WakelockPlus.enable();
}
