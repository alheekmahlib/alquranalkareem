import 'dart:io' show Platform;

import 'package:connectivity_kit/connectivity_kit.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:video_player_media_kit/video_player_media_kit.dart';

import '/core/services/languages/dependency_inj.dart' as dep;
import 'core/services/background_services.dart';
import 'core/services/home_widget_service.dart';
import 'core/services/notifications_helper.dart';
import 'core/services/services_locator.dart';
import 'core/tour/app_tour.dart';
import 'core/utils/constants/extensions/convert_number_extension.dart';
import 'core/utils/constants/shared_preferences_constants.dart';
import 'myApp.dart';
import 'presentation/controllers/general/general_controller.dart';
import 'presentation/screens/feedback/data/feedback_queue.dart';
import 'presentation/screens/quran_page/data/helper/ayah_menu_helper.dart';
import 'presentation/screens/quran_page/quran.dart';
import 'presentation/screens/surah_audio/surah_audio.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    VideoPlayerMediaKit.ensureInitialized(windows: true);
  }

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Map<String, Map<String, String>> languages = await dep.init();
  await initializeApp();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  runApp(
    AppInfo(
      data: await AppInfoData.get(),
      child: MyApp(languages: languages),
    ),
  );
}

Future<void> initializeApp() async {
  Future.delayed(const Duration(seconds: 0));
  final service = ConnectionService(
    options: const ConnectionOptions(enableReachability: true),
  );
  await service.init();

  Get.put(service, permanent: true);
  Get.put(ConnectionController(), permanent: true);
  // طابور الـ feedback: إرسال مؤجَّل يستأنف تلقائيًا عند عودة الاتصال.
  await FeedbackQueue.init(service);
  await GetStorage.init();
  await QuranLibrary.init(
    numberConverter: (text, {languageCode}) =>
        text.convertNumbersToCurrentLang(),
  );
  QuranLibrary.initWordAudio();
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
  ReadersConstants.customAyahReaders = ayahReaderInfo;

  ReadersConstants.customSurahReaders = surahReaderInfo;
  Get.put(
    AppTour(
      isControlsVisible: () =>
          GeneralController.instance.state.isShowControl.value,
      toggleControls: () => QuranController.instance.showControl(),
      collapsePanels: () => QuranController.instance.closePanels(),
      isAyahMenuOpen: () => AyahMenuHelper.isOpen,
      openAyahMenu: AyahMenuHelper.reopenLast,
      // وبعد إغلاقها تُمحى علامة تحديد الآية إن بقيت.
      closeAyahMenu: () {
        AyahMenuHelper.close();
        QuranController.instance.clearAyahSelection();
      },
      // جولة المصحف الصوتي: لوحة التشغيل السفلية وشاشة المشغّل الكامل.
      isPlayerExpanded: () =>
          AudioCtrl.instance.surahState.isPlayExpanded.value,
      setPlayerExpanded: (expanded) =>
          AudioCtrl.instance.surahState.isPlayExpanded.value = expanded,
      isOnAudioFullScreen: () =>
          Get.isRegistered<AudioSurahWithAyahsController>(),
      // Get.to يعود عند إغلاق الشاشة لا عند انتهاء انتقالها، فلا يُنتظر
      // وعده؛ تُنتظر مهلة الانتقال (fadeIn) فقط حتى تُبنى أهداف الشاشة
      // قبل عرض البطاقة.
      openAudioFullScreen: () async {
        Get.to(
          () => const AudioSurahWithAyahs(),
          transition: Transition.fadeIn,
          binding: BindingsBuilder(() {
            Get.put(AudioSurahWithAyahsController());
          }),
        );
        await Future<void>.delayed(const Duration(milliseconds: 450));
      },
      // Get.back يمرّ بـ PopScope بعلم didPop فلا يوقف التلاوة (مسار زر
      // الإغلاق نفسه).
      closeAudioFullScreen: () => Get.back<void>(),
      // قائمة السور: تثبيتها على أعلاها خلال محطتي القائمة والتنزيل
      // (هدف التنزيل زر الصف الأول) ثم إعادة موضع المستخدم.
      audioSurahListOffset: () {
        final controller = AudioCtrl.instance.state.surahListController;
        return controller.hasClients ? controller.position.pixels : 0.0;
      },
      scrollAudioSurahListTo: (offset) {
        final controller = AudioCtrl.instance.state.surahListController;
        if (controller.hasClients) controller.jumpTo(offset);
      },
    ),
    permanent: true,
  );
}
