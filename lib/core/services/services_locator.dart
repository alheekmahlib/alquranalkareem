import 'dart:async';
import 'dart:io';
import 'dart:ui' show Size;

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '/presentation/controllers/settings_controller.dart';
import '../../presentation/controllers/daily_ayah_controller.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/controllers/theme_controller.dart';
import '../../presentation/screens/adhkar/controller/adhkar_controller.dart';
import '../../presentation/screens/books/controller/books_controller.dart';
import '../../presentation/screens/ourApp/controller/ourApps_controller.dart';
import '../../presentation/screens/prayers/prayers.dart';
import '../../presentation/screens/quran_page/controllers/audio/audio_controller.dart';
import '../../presentation/screens/quran_page/controllers/bookmarks_controller.dart';
import '../../presentation/screens/quran_page/controllers/khatmah_controller.dart';
import '../../presentation/screens/quran_page/controllers/playList_controller.dart';
import '../../presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import '../../presentation/screens/quran_page/controllers/share_controller.dart';
import '../../presentation/screens/quran_page/controllers/tafsir_ctrl.dart';
import '../../presentation/screens/quran_page/controllers/translate_controller.dart';
import '../../presentation/screens/quran_page/widgets/search/controller/quran_search_controller.dart';
import '../../presentation/screens/splash/controller/splash_screen_controller.dart';
import '../../presentation/screens/surah_audio/controller/surah_audio_controller.dart';
import '../../presentation/screens/whats_new/controller/whats_new_controller.dart';
import '../utils/helpers/ui_helper.dart';
import '../widgets/local_notification/controller/local_notifications_controller.dart';

final sl = GetIt.instance;

class ServicesLocator {
  // Future<void> _initPrefs() async =>
  // await SharedPreferences.getInstance().then((v) {
  //   sl.registerSingleton<SharedPreferences>(v);
  // });

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
      GetStorage.init('AdhanSounds'),
      _windowSize(),
    ]);

    // Controllers
    sl.registerLazySingleton<ThemeController>(
        () => Get.put<ThemeController>(ThemeController(), permanent: true));

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

    sl.registerLazySingleton<QuranSearchController>(() =>
        Get.put<QuranSearchController>(QuranSearchController(),
            permanent: true));

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

    sl.registerLazySingleton<LocalNotificationsController>(() =>
        Get.put<LocalNotificationsController>(LocalNotificationsController(),
            permanent: true));

    sl.registerLazySingleton<TafsirCtrl>(
        () => Get.put<TafsirCtrl>(TafsirCtrl(), permanent: true));

    sl.registerLazySingleton<AdhanController>(
        () => Get.put<AdhanController>(AdhanController(), permanent: true));

    sl.registerLazySingleton<PrayersNotificationsCtrl>(() =>
        Get.put<PrayersNotificationsCtrl>(PrayersNotificationsCtrl(),
            permanent: true));
    // NotifyHelper().initializeNotification();
    // sl<NotificationsController>().initializeLocalNotifications();

    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.rateMyApp.init();
      // Future.delayed(const Duration(seconds: 7)).then((_) => {
      //       AudioService.init(
      //         builder: () => AudioPlayerHandler(),
      //         config: const AudioServiceConfig(
      //           androidNotificationChannelId:
      //               'com.alheekmah.alquranalkareem.alquranalkareem',
      //           androidNotificationChannelName: 'Audio playback',
      //           androidNotificationOngoing: true,
      //         ),
      //       )
      //     });
    }

    // if (Platform.isIOS) {
    // await AudioService.init(
    //   androidNotificationChannelId:
    //       'com.alheekmah.alquranalkareem.alquranalkareem',
    //   androidNotificationChannelName: 'Audio playback',
    //   androidNotificationOngoing: true,
    // );
    // }

    // Workmanager().initialize(sl<NotificationController>().callbackDispatcher);
    // sl<NotificationController>().registerBackgroundTask();

    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
}
