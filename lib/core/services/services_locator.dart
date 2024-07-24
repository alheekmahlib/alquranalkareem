import 'dart:async';
import 'dart:io';
import 'dart:ui' show Size;

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '/database/databaseHelper.dart';
import '/database/notificationDatabase.dart';
import '/presentation/controllers/settings_controller.dart';
import '/presentation/screens/quran_page/data/data_source/baghawy_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/data_client.dart';
import '/presentation/screens/quran_page/data/data_source/ibnkatheer_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/qurtubi_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/saadi_data_client.dart';
import '/presentation/screens/quran_page/data/data_source/tabari_data_client.dart';
import '../../presentation/controllers/daily_ayah_controller.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/controllers/theme_controller.dart';
import '../../presentation/screens/adhkar/controller/adhkar_controller.dart';
import '../../presentation/screens/books/controller/books_controller.dart';
import '../../presentation/screens/ourApp/controller/ourApps_controller.dart';
import '../../presentation/screens/quran_page/controllers/audio/audio_controller.dart';
import '../../presentation/screens/quran_page/controllers/aya_controller.dart';
import '../../presentation/screens/quran_page/controllers/ayat_controller.dart';
import '../../presentation/screens/quran_page/controllers/bookmarks_controller.dart';
import '../../presentation/screens/quran_page/controllers/khatmah_controller.dart';
import '../../presentation/screens/quran_page/controllers/playList_controller.dart';
import '../../presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import '../../presentation/screens/quran_page/controllers/share_controller.dart';
import '../../presentation/screens/quran_page/controllers/translate_controller.dart';
import '../../presentation/screens/splash/controller/splash_screen_controller.dart';
import '../../presentation/screens/surah_audio/controller/surah_audio_controller.dart';
import '../../presentation/screens/whats_new/controller/whats_new_controller.dart';
import '../utils/helpers/ui_helper.dart';

final sl = GetIt.instance;

class ServicesLocator {
  // Future<void> _initPrefs() async =>
  // await SharedPreferences.getInstance().then((v) {
  //   sl.registerSingleton<SharedPreferences>(v);
  // });

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

      // _initPrefs(), // moved to notificationsCtrl
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
    sl.registerLazySingleton<ThemeController>(
        () => Get.put<ThemeController>(ThemeController(), permanent: true));

    sl.registerLazySingleton<AyatController>(
        () => Get.put<AyatController>(AyatController(), permanent: true));

    sl.registerLazySingleton<GeneralController>(
        () => Get.put<GeneralController>(GeneralController(), permanent: true));

    sl.registerLazySingleton<AudioController>(
        () => Get.put<AudioController>(AudioController(), permanent: true));

    sl.registerSingleton<QuranController>(
        Get.put<QuranController>(QuranController(), permanent: true));

    sl.registerLazySingleton<SurahAudioController>(() =>
        Get.put<SurahAudioController>(SurahAudioController(), permanent: true));

    sl.registerLazySingleton<TranslateDataController>(() =>
        Get.put<TranslateDataController>(TranslateDataController(),
            permanent: true));

    sl.registerLazySingleton<BookmarksController>(() =>
        Get.put<BookmarksController>(BookmarksController(), permanent: true));

    sl.registerLazySingleton<AyaController>(
        () => Get.put<AyaController>(AyaController(), permanent: true));

    sl.registerLazySingleton<SettingsController>(() =>
        Get.put<SettingsController>(SettingsController(), permanent: true));

    sl.registerSingleton<AzkarController>(
        Get.put<AzkarController>(AzkarController(), permanent: true));

    sl.registerLazySingleton<ShareController>(
        () => Get.put<ShareController>(ShareController(), permanent: true));

    sl.registerLazySingleton<PlayListController>(() =>
        Get.put<PlayListController>(PlayListController(), permanent: true));

    sl.registerLazySingleton<SplashScreenController>(() =>
        Get.put<SplashScreenController>(SplashScreenController(),
            permanent: true));

    sl.registerLazySingleton<OurAppsController>(
        () => Get.put<OurAppsController>(OurAppsController(), permanent: true));

    sl.registerLazySingleton<KhatmahController>(
        () => Get.put<KhatmahController>(KhatmahController(), permanent: true));

    sl.registerLazySingleton<DailyAyahController>(() =>
        Get.put<DailyAyahController>(DailyAyahController(), permanent: true));

    sl.registerLazySingleton<BooksController>(
        () => Get.put<BooksController>(BooksController(), permanent: true));

    sl.registerLazySingleton<WhatsNewController>(() =>
        Get.put<WhatsNewController>(WhatsNewController(), permanent: true));
    // NotifyHelper().initializeNotification();
    // sl<NotificationsController>().initializeLocalNotifications();

    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.rateMyApp.init();
    }

    if (Platform.isIOS) {
      await JustAudioBackground.init(
        androidNotificationChannelId:
            'com.alheekmah.alquranalkareem.alquranalkareem',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      );
    }

    // Workmanager().initialize(sl<NotificationController>().callbackDispatcher);
    // sl<NotificationController>().registerBackgroundTask();

    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }
  }
}
