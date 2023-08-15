import 'dart:io' show Platform;
import 'dart:ui' show Size;

import 'package:bloc/bloc.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:wakelock/wakelock.dart';

import '/shared/controller/notifications_controller.dart';
import 'database/databaseHelper.dart';
import 'database/notificationDatabase.dart';
import 'quran_page/data/data_client.dart';
import 'quran_page/data/tafseer_data_client.dart';
import 'shared/bloc_observer.dart';
import 'shared/controller/ayat_controller.dart';
import 'shared/controller/general_controller.dart';
import 'shared/local_notifications.dart';
import 'shared/utils/helpers/ui_helper.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    // Controllers
    sl.registerLazySingleton<AyatController>(
        () => Get.put<AyatController>(AyatController(), permanent: true));

    sl.registerLazySingleton<GeneralController>(
        () => Get.put<GeneralController>(GeneralController(), permanent: true));
    sl.registerSingleton<NotificationsController>(
        Get.put<NotificationsController>(NotificationsController(),
            permanent: true));

    // SharedPrefrences
    sl.registerLazySingletonAsync<SharedPreferences>(
        () async => await SharedPreferences.getInstance());

    // Databases

    sl.registerSingletonAsync<DatabaseHelper>(() async {
      return (await DatabaseHelper.instance
        ..database);
      // return
    });

    sl.registerSingletonAsync<NotificationDatabaseHelper>(() async {
      return (await NotificationDatabaseHelper.instance
        ..database);
    });

    sl.registerSingletonAsync<DataBaseClient>(() async {
      return (await DataBaseClient.instance
        ..initDatabase());
    });
    sl.registerSingletonAsync<TafseerDataBaseClient>(() async {
      return (await TafseerDataBaseClient.instance
        ..initDatabase());
    });

    // Notifications

    NotifyHelper().initializeNotification();
    sl<NotificationsController>().initializeLocalNotifications();

    // Other

    UiHelper.rateMyApp.init();

    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    Bloc.observer = MyBlocObserver();

    Wakelock.enable();
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      if (Platform.isMacOS) {
        await DesktopWindow.setMinWindowSize(const Size(900, 840));
      }
    }
  }
}
