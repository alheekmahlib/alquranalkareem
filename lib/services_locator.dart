import 'dart:io' show Platform;
import 'dart:ui' show Size;

import 'package:alquranalkareem/quran_page/data/repository/bookmarks_controller.dart';
import 'package:alquranalkareem/shared/controller/audio_controller.dart';
import 'package:alquranalkareem/shared/controller/aya_controller.dart';
import 'package:alquranalkareem/shared/controller/bookmarksText_controller.dart';
import 'package:alquranalkareem/shared/controller/notes_controller.dart';
import 'package:alquranalkareem/shared/controller/quranText_controller.dart';
import 'package:alquranalkareem/shared/controller/reminder_controller.dart';
import 'package:alquranalkareem/shared/controller/settings_controller.dart';
import 'package:alquranalkareem/shared/controller/surahTextController.dart';
import 'package:alquranalkareem/shared/controller/surah_repository_controller.dart';
import 'package:alquranalkareem/shared/controller/translate_controller.dart';
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
import 'audio_screen/controller/surah_audio_controller.dart';
import 'shared/controller/ayat_controller.dart';
import 'shared/controller/general_controller.dart';
import 'shared/local_notifications.dart';
import 'shared/utils/helpers/ui_helper.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    // SharedPrefrences
    sl.registerSingletonAsync<SharedPreferences>(() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs;
    });

    // Databases
    // sl.registerSingletonAsync<DatabaseHelper>(() async {
    //   return (await DatabaseHelper.instance
    //     ..database);
    //   // return
    // });
    //
    // sl.registerSingletonAsync<NotificationDatabaseHelper>(() async {
    //   return (await NotificationDatabaseHelper.instance
    //     ..database);
    // });
    //
    // sl.registerSingletonAsync<DataBaseClient>(() async {
    //   return (await DataBaseClient.instance
    //     ..initDatabase());
    // });
    // sl.registerSingletonAsync<TafseerDataBaseClient>(() async {
    //   return (await TafseerDataBaseClient.instance
    //     ..initDatabase());
    // });

    // Controllers
    sl.registerLazySingleton<AyatController>(
        () => Get.put<AyatController>(AyatController(), permanent: true));

    sl.registerLazySingleton<GeneralController>(
        () => Get.put<GeneralController>(GeneralController(), permanent: true));

    sl.registerLazySingleton<NotificationsController>(() =>
        Get.put<NotificationsController>(NotificationsController(),
            permanent: true));

    sl.registerLazySingleton<AudioController>(
        () => Get.put<AudioController>(AudioController(), permanent: true));

    sl.registerLazySingleton<SurahAudioController>(() =>
        Get.put<SurahAudioController>(SurahAudioController(), permanent: true));

    sl.registerLazySingleton<TranslateDataController>(() =>
        Get.put<TranslateDataController>(TranslateDataController(),
            permanent: true));

    sl.registerLazySingleton<QuranTextController>(() =>
        Get.put<QuranTextController>(QuranTextController(), permanent: true));

    sl.registerLazySingleton<SorahRepositoryController>(() =>
        Get.put<SorahRepositoryController>(SorahRepositoryController(),
            permanent: true));

    sl.registerLazySingleton<NotesController>(
        () => Get.put<NotesController>(NotesController(), permanent: true));

    sl.registerLazySingleton<BookmarksController>(() =>
        Get.put<BookmarksController>(BookmarksController(), permanent: true));

    sl.registerLazySingleton<BookmarksTextController>(() =>
        Get.put<BookmarksTextController>(BookmarksTextController(),
            permanent: true));

    sl.registerLazySingleton<SurahTextController>(() =>
        Get.put<SurahTextController>(SurahTextController(), permanent: true));

    sl.registerLazySingleton<AyaController>(
        () => Get.put<AyaController>(AyaController(), permanent: true));

    sl.registerLazySingleton<SettingsController>(() =>
        Get.put<SettingsController>(SettingsController(), permanent: true));

    sl.registerLazySingleton<ReminderController>(() =>
        Get.put<ReminderController>(ReminderController(), permanent: true));

    // Notifications

    NotifyHelper().initializeNotification();
    sl<NotificationsController>().initializeLocalNotifications();

    // Other

    UiHelper.rateMyApp.init();

    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

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
