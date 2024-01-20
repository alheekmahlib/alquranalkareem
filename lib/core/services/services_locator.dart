import 'dart:io';
import 'dart:ui' show Size;

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../presentation/controllers/quran_controller.dart';
import '../utils/constants/shared_pref_services.dart';
import '../utils/helpers/ui_helper.dart';
import '/database/databaseHelper.dart';
import '/database/notificationDatabase.dart';
import '/presentation/controllers/audio_controller.dart';
import '/presentation/controllers/aya_controller.dart';
import '/presentation/controllers/ayat_controller.dart';
import '/presentation/controllers/azkar_controller.dart';
import '/presentation/controllers/bookmarksText_controller.dart';
import '/presentation/controllers/bookmarks_controller.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/controllers/notes_controller.dart';
import '/presentation/controllers/notifications_controller.dart';
import '/presentation/controllers/playList_controller.dart';
import '/presentation/controllers/quranText_controller.dart';
import '/presentation/controllers/reminder_controller.dart';
import '/presentation/controllers/settings_controller.dart';
import '/presentation/controllers/share_controller.dart';
import '/presentation/controllers/surahTextController.dart';
import '/presentation/controllers/surah_audio_controller.dart';
import '/presentation/controllers/surah_repository_controller.dart';
import '/presentation/controllers/translate_controller.dart';
import '/presentation/screens/quran_page/data/data_source/baghawy_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/data_client.dart';
import '/presentation/screens/quran_page/data/data_source/ibnkatheer_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/qurtubi_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/saadi_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/tabari_data_client.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void initSingleton() {
    sl<SharedPrefServices>();
  }

  Future<void> _initPrefs() async =>
      await SharedPreferences.getInstance().then((v) {
        sl.registerSingleton<SharedPreferences>(v);
        sl.registerSingleton<SharedPrefServices>(SharedPrefServices(v));
      });

  Future<void> _initDatabaseHelper() async =>
      sl.registerSingleton<DatabaseHelper>(await DatabaseHelper.instance
        ..database);

  Future<void> _initDatabaseNotification() async =>
      sl.registerSingleton<NotificationDatabaseHelper>(
          await NotificationDatabaseHelper.instance
            ..database);

  Future<void> _initDatabaseClient() async =>
      sl.registerSingleton<DataBaseClient>(await DataBaseClient.instance
        ..initDatabase());

  Future<void> _initDatabaseIbnkatheer() async =>
      sl.registerSingleton<IbnkatheerDataBaseClient>(
          await IbnkatheerDataBaseClient.instance
            ..initDatabase());

  Future<void> _initDatabaseBaghawy() async =>
      sl.registerSingleton<BaghawyDataBaseClient>(
          await BaghawyDataBaseClient.instance
            ..initDatabase());

  Future<void> _initDatabaseQurtubi() async =>
      sl.registerSingleton<QurtubiDataBaseClient>(
          await QurtubiDataBaseClient.instance
            ..initDatabase());

  Future<void> _initDatabaseSaadi() async => sl
      .registerSingleton<SaadiDataBaseClient>(await SaadiDataBaseClient.instance
        ..initDatabase());

  Future<void> _initDatabaseTabari() async =>
      sl.registerSingleton<TabariDataBaseClient>(
          await TabariDataBaseClient.instance
            ..initDatabase());

  Future _windowSize() async {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux)
      await DesktopWindow.setWindowSize(const Size(900, 840));
  }

  Future<void> init() async {
    await Future.wait([
      // JustAudioBackground.init(
      //   androidNotificationChannelId:
      //       'com.alheekmah.alquranalkareem.channel.audio',
      //   androidNotificationChannelName: 'Audio playback',
      //   androidNotificationOngoing: true,
      // ),
      _initPrefs(),
      _initDatabaseHelper(),
      _initDatabaseNotification(),
      _initDatabaseClient(),
      _initDatabaseIbnkatheer(),
      _initDatabaseBaghawy(),
      _initDatabaseQurtubi(),
      _initDatabaseSaadi(),
      _initDatabaseTabari(),
      _windowSize(),
    ]);

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

    sl.registerLazySingleton<SurahRepositoryController>(() =>
        Get.put<SurahRepositoryController>(SurahRepositoryController(),
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

    sl.registerLazySingleton<AzkarController>(
        () => Get.put<AzkarController>(AzkarController(), permanent: true));

    sl.registerLazySingleton<ShareController>(
        () => Get.put<ShareController>(ShareController(), permanent: true));

    sl.registerLazySingleton<PlayListController>(() =>
        Get.put<PlayListController>(PlayListController(), permanent: true));

    sl.registerLazySingleton<QuranController>(
        () => Get.put<QuranController>(QuranController(), permanent: true));

    // NotifyHelper().initializeNotification();
    // sl<NotificationsController>().initializeLocalNotifications();

    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.rateMyApp.init();
    }

    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }
  }
}
