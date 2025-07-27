import 'dart:io' show Platform;

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

import '/core/services/languages/dependency_inj.dart' as dep;
import 'core/services/background_services.dart';
import 'core/services/home_widget_service.dart';
import 'core/services/notifications_helper.dart';
import 'core/services/services_locator.dart';
import 'core/utils/constants/shared_preferences_constants.dart';
import 'myApp.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding;
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Map<String, Map<String, String>> languages = await dep.init();
  await initializeApp();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  runApp(MyApp(
    languages: languages,
  ));
}

Future<void> initializeApp() async {
  Future.delayed(const Duration(seconds: 0));
  await GetStorage.init();
  NotifyHelper.initAwesomeNotifications();
  await ServicesLocator().init();
  tz.initializeTimeZones();

  // تهيئة Home Widgets - Initialize Home Widgets
  await HomeWidgetService.instance.initializeHomeWidgets();

  if (Platform.isIOS || Platform.isAndroid) {
    await BGServices().registerTask();
  }
  FlutterNativeSplash.remove();
  GetStorage().write(AUDIO_SERVICE_INITIALIZED, false);
  // try {
  //   await WakelockPlus.enable();
  // } catch (e) {
  //   print('Failed to enable wakelock: $e');
  // }
}
