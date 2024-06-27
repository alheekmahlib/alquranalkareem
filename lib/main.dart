import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

import '/core/services/languages/dependency_inj.dart' as dep;
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
  FlutterNativeSplash.remove();
}
