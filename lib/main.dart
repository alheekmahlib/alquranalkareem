import 'dart:async';
import 'dart:io';
import 'package:alquranalkareem/quran_page/data/data_client.dart';
import 'package:alquranalkareem/quran_page/data/tafseer_data_client.dart';
import 'package:alquranalkareem/shared/bloc_observer.dart';
import 'package:alquranalkareem/shared/local_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wakelock/wakelock.dart';
import 'database/databaseHelper.dart';
import 'database/notificationDatabase.dart';
import 'myApp.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true,);
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  // databaseFactory = databaseFactoryFfi;
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual, overlays: SystemUiOverlay.values, //This line is used for showing the bottom bar
  // );
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    windowSize();
  }
  Wakelock.enable();

  init();
  tz.initializeTimeZones();
  Bloc.observer = MyBlocObserver();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp(theme: ThemeData.light()));
}



Future windowSize() async {
  await DesktopWindow.setMinWindowSize(const Size(900, 840));
}

init() async {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  databaseHelper.database;
  NotificationDatabaseHelper notificationdatabaseHelper = NotificationDatabaseHelper.instance;
  notificationdatabaseHelper.database;
  DataBaseClient dataBaseClient = DataBaseClient.instance;
  dataBaseClient.initDatabase();
  TafseerDataBaseClient tafseerDataBaseClient = TafseerDataBaseClient.instance;
  tafseerDataBaseClient.initDatabase();
  NotifyHelper().initializeNotification();
}
