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
import 'core/tour/tour_launcher.dart';
import 'core/utils/constants/extensions/convert_number_extension.dart';
import 'core/utils/constants/shared_preferences_constants.dart';
import 'myApp.dart';
import 'presentation/controllers/general/general_controller.dart';
import 'presentation/controllers/daily_ayah_controller.dart';
import 'presentation/screens/ai_search/ai_search.dart';
import 'presentation/screens/adhkar/controller/adhkar_controller.dart';
import 'presentation/screens/books/books.dart';
import 'presentation/screens/books/controller/chapters_controller.dart';
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
      // جولة مداد: وضع الشاشة (دلالي ↔ مساعد) وحالة التحميل والاتصال.
      // حفظ الوضع يتم في الكنترولر تلقائياً عند تغييره، فيكفي الضبط بالقيمة.
      isMidasAssistantMode: () =>
          AiSearchController.instance.state.midasMode.value ==
          MidasMode.assistant,
      setMidasAssistantMode: (assistant) =>
          AiSearchController.instance.state.midasMode.value = assistant
          ? MidasMode.assistant
          : MidasMode.semantic,
      isMidadOnline: () => ConnectionController.instance.isOnline,
      // مهلة احتياطية: البدء التلقائي للجولة لا يمرّ من هنا أصلاً، فهو من
      // بطاقة تشغيل لا تستدعيه إلا بعد اكتمال التهيئة.
      awaitMidadReady: () => AiSearchController.instance
          .ensureInitialized()
          .timeout(const Duration(seconds: 15), onTimeout: () {}),
      hasMidadSectionLoaded: () =>
          AiSearchController.instance.state.hasAnySectionLoaded,
      isMidadSharedLoaded: () =>
          AiSearchController.instance.state.isSharedLoaded.value,
      // شرط حالة الفراغ الدلالي كما تقرره شاشة المحتوى نفسها: لا بحث جارٍ
      // ولا نتائج، والاستعلام فارغ أو خلفه خطأ.
      isMidadSemanticEmpty: () {
        final state = AiSearchController.instance.state;
        final hasResults = SearchSection.all.any(
          (section) => state.sectionResults(section.id).isNotEmpty,
        );
        return !state.isSearching.value &&
            !hasResults &&
            (state.currentQuery.value.isEmpty ||
                state.errorMessage.value.isNotEmpty);
      },
      isMidadAssistantFresh: () {
        final state = AiSearchController.instance.state;
        return state.isAssistantEmpty && state.assistantError.value.isEmpty;
      },
      hasMidadProviders: () =>
          AiSearchController.instance.availableProviders.isNotEmpty,
      // جولات المكتبة الإسلامية: قائمة الكتب وصفحة الكتاب والقارئ.
      hasBooksLastRead: () =>
          BooksController.instance.state.lastReadPage.isNotEmpty,
      // هدف الشبكة غلاف أول كتاب فيها أعلى القائمة؛ تبويب الفواصل بلا شبكة،
      // وتبويب الأحاديث تدفع شبكة الكتب تحت حافة القائمة بشبكاته المقدَّمة.
      hasVisibleBooksGrid: () {
        final booksCtrl = BooksController.instance;
        final tabs = buildBooksTabs(booksCtrl.state.bookTypes);
        final index = BooksTabBarController.instance.currentIndex.value;
        if (index < 0 || index >= tabs.length) return false;
        final tab = tabs[index];
        if (tab.customChild != null || tab.filterBookType == 'hadiths') {
          return false;
        }
        return booksCtrl
            .getFilteredBooks(
              booksCtrl.state.booksList,
              isDownloadedBooks: tab.isDownloadedBooks,
              filterBookType: tab.filterBookType,
              title: tab.title,
            )
            .isNotEmpty;
      },
      // قائمة الكتب: تثبيتها على أعلاها خلال محطتي آخر القراءة والشبكة
      // (هدف الشبكة غلاف أول كتاب) ثم إعادة موضع المستخدم.
      booksListScrollOffset: () {
        final controller = BooksController.instance.state.booksListController;
        return controller.hasClients ? controller.position.pixels : 0.0;
      },
      scrollBooksListTo: (offset) {
        final controller = BooksController.instance.state.booksListController;
        if (controller.hasClients) controller.jumpTo(offset);
      },
      // حقل البحث داخل القسم: يطوى خلال محطتي الترتيب والبحث (زراه لا
      // يُركبان ممدَّدًا) ثم يعاد إلى حالة المستخدم.
      isBooksSectionSearchActive: () =>
          BooksController.instance.state.isSearch.value,
      setBooksSectionSearchActive: (active) =>
          BooksController.instance.state.isSearch.value = active,
      // شريطا القارئ: يظهران خلال محطاتهما ثم يعادان إلى حالة المستخدم.
      isBooksReaderBarsVisible: () {
        final state = BooksController.instance.state;
        return state.tabBarController.isHandleVisible &&
            state.navBarController.isHandleVisible;
      },
      setBooksReaderBarsVisible: (visible) {
        final state = BooksController.instance.state;
        if (visible) {
          state.tabBarController.showHandle();
          state.navBarController.showHandle();
        } else {
          state.tabBarController.hideHandle();
          state.navBarController.hideHandle();
        }
      },
      hasBooksChaptersDropdown: () {
        final controller = ChaptersController.instance;
        return !controller.isLoading && controller.chapters.isNotEmpty;
      },
      isBooksBookDownloaded: (bookNumber) =>
          BooksController.instance.isBookDownloaded(bookNumber),
      // كنترولر صفحات القارئ الحيّ: يقلبه عرض الجولة فعلاً ويستعيده، وشاشة
      // القارئ تعيد إنشاءه في كل زيارة فيُقرأ عند بدء الجولة لا قبله.
      booksReaderPageController: () =>
          BooksController.instance.state.bookPageController,
      // جولتا الأذكار: الشاشة الرئيسية وشاشة القسم. محطة التصنيفات أولُّ
      // بطاقة في القائمة، فتُحذف إن كان البحث جارياً يستبدلها بنتائجه.
      hasAzkarCategoriesVisible: () =>
          AzkarController.instance.state.searchQuery.value.isEmpty,
      // قائمة الأقسام: تثبيتها على أعلاها خلال محطة التصنيفات (هدفها أول
      // بطاقة) ثم إعادة موضع المستخدم.
      azkarListScrollOffset: () {
        final controller = AzkarController.instance.state.listController;
        return controller.hasClients ? controller.position.pixels : 0.0;
      },
      scrollAzkarListTo: (offset) {
        final controller = AzkarController.instance.state.listController;
        if (controller.hasClients) controller.jumpTo(offset);
      },
      // شاشة القسم: تثبيتها على أعلاها خلال محطتي شريط الخيارات ونص أول
      // ذكر (فالقدوم من نتائج البحث يمرّرها إلى ذكر بعيد) ثم إعادة الموضع.
      azkarItemScrollOffset: () {
        final controller = AzkarController.instance.state.itemScrollController;
        return controller.hasClients ? controller.position.pixels : 0.0;
      },
      scrollAzkarItemTo: (offset) {
        final controller = AzkarController.instance.state.itemScrollController;
        if (controller.hasClients) controller.jumpTo(offset);
      },
      // جولة الصفحة الرئيسية: آية اليوم وذكر اليوم يجلبان من قاعدتي
      // البيانات بعد فتح الصفحة، فتفصل محطات المحتوى اليومي حين لم
      // يجلبا بعد. وقائمة الصفحة تُمرَّر لكشف أهدافها أسفل الطية ثم يعاد
      // موضع المستخدم.
      hasHomeDailyAyah: () => DailyAyahController.instance.ayahOfTheDay != null,
      hasHomeDailyZeker: () =>
          AzkarController.instance.state.dhekrOfTheDay != null,
      homeScrollOffset: () {
        final controller =
            GeneralController.instance.state.homeScrollController;
        return controller.hasClients ? controller.position.pixels : 0.0;
      },
      homeScrollMax: () {
        final controller =
            GeneralController.instance.state.homeScrollController;
        return controller.hasClients
            ? controller.position.maxScrollExtent
            : 0.0;
      },
      scrollHomeTo: (offset) {
        final controller =
            GeneralController.instance.state.homeScrollController;
        if (controller.hasClients) controller.jumpTo(offset);
      },
    ),
    permanent: true,
  );

  // مشغّل الجولات من الإعدادات: يغلق ورقة الإعدادات، يفتح قسم الجولة إن
  // لم يكن هو الشاشة الجارية، ثم يشغّلها بعد جهوزية شاشته وبياناتها.
  // الاعتماديات closures كما في AppTour فيبقى المشغّل قابلاً للاختبار.
  Get.put(
    TourLauncher(
      openSection: (section) => GeneralController.instance.open(section),
      returnToHome: () => GeneralController.instance.returnToHome(),
      isTasmeeMode: () => TasmeeCtrl.instance.state.isTasmeeMode.value,
      // جاهزية البيانات التي تفصل محطات: تحميل الكتب، أقسام الأذكار،
      // والمحتوى اليومي في الرئيسية. بقية الأقسام جاهزة ببناء شاشته.
      isSectionReady: (tour) => switch (tour) {
        AppTourPick.books => !BooksController.instance.state.isLoading.value,
        AppTourPick.azkar =>
          AzkarController.instance.state.categories.isNotEmpty,
        AppTourPick.home =>
          DailyAyahController.instance.ayahOfTheDay != null &&
              AzkarController.instance.state.dhekrOfTheDay != null,
        _ => true,
      },
    ),
    permanent: true,
  );
}
