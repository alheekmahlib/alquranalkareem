import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_library/quran_library.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

import '../utils/helpers/app_text_styles.dart';
import 'audio_tour_script.dart';
import 'azkar_tour_script.dart';
import 'books_tour_script.dart';
import 'home_tour_script.dart';
import 'midad_tour_script.dart';
import 'mushaf_tour_script.dart';
import 'tasmee_tour_script.dart';

/// مخزن إكمال الجولات فوق GetStorage (المستخدم أصلاً في التطبيق).
///
/// يتذكّر الجولات التي اكتملت أو تخطّاها المستخدم حتى لا تبدأ تلقائياً في
/// كل تشغيل. الواجهة ثلاث دوال فقط كما تشترط الحزمة.
class GetStorageTourCompletionStore implements TourCompletionStore {
  GetStorageTourCompletionStore(this._box);

  final GetStorage _box;
  static const String _key = 'completed_tours';

  List<String> get _done =>
      (_box.read<List>(_key) ?? const <dynamic>[]).cast<String>();

  @override
  Future<bool> isCompleted(String tourId) async => _done.contains(tourId);

  @override
  Future<void> markCompleted(String tourId) async {
    if (_done.contains(tourId)) return;
    await _box.write(_key, <String>[..._done, tourId]);
  }

  @override
  Future<void> reset(String tourId) async =>
      _box.write(_key, _done.where((id) => id != tourId).toList());
}

/// خدمة الجولة المركزية: كنترولر واحد لكل التطبيق، يعيش عمر التطبيق،
/// وتُستدعى جولة كل قسم من أي مكان عبر [AppTour.instance].
///
/// تُسجَّل مرة واحدة في main() بعد GetStorage.init():
///   Get.put(AppTour(), permanent: true);
/// ويُركَّب مضيفها SpotlightTourHost مرة واحدة في GetMaterialApp.builder
/// في myApp.dart (انظر دليل الربط).
///
/// ملاحظة: في get 4.7.x يجب أن ترث GetxController (وليس GetxService) حتى
/// يقبل خلطات الـ Ticker، وGet.put(..., permanent: true) يمنحها نفس أثر
/// الخدمة الدائمة. والخليط متعدد (GetTickerProviderStateMixin وليس المفرد)
/// لأن كل تشغيل للجولة ينشئ PageSwipeDemo جديداً بـ AnimationController
/// جديد، وإعادة الجولة بالخليط المفرد كانت سترمي خطأً.
class AppTour extends GetxController
    with GetTickerProviderStateMixin
    implements
        MushafTourHooks,
        AudioTourHooks,
        MidadTourHooks,
        BooksTourHooks,
        AzkarTourHooks,
        HomeTourHooks {
  AppTour({
    bool Function()? isControlsVisible,
    void Function()? toggleControls,
    void Function()? collapsePanels,
    bool Function()? isAyahMenuOpen,
    void Function()? openAyahMenu,
    void Function()? closeAyahMenu,
    bool Function()? isPlayerExpanded,
    void Function(bool expanded)? setPlayerExpanded,
    bool Function()? isOnAudioFullScreen,
    Future<void> Function()? openAudioFullScreen,
    void Function()? closeAudioFullScreen,
    double Function()? audioSurahListOffset,
    void Function(double offset)? scrollAudioSurahListTo,
    bool Function()? isMidasAssistantMode,
    void Function(bool assistant)? setMidasAssistantMode,
    bool Function()? isMidadOnline,
    Future<void> Function()? awaitMidadReady,
    bool Function()? hasMidadSectionLoaded,
    bool Function()? isMidadSharedLoaded,
    bool Function()? isMidadSemanticEmpty,
    bool Function()? isMidadAssistantFresh,
    bool Function()? hasMidadProviders,
    bool Function()? hasBooksLastRead,
    bool Function()? hasVisibleBooksGrid,
    double Function()? booksListScrollOffset,
    void Function(double offset)? scrollBooksListTo,
    bool Function()? isBooksSectionSearchActive,
    void Function(bool active)? setBooksSectionSearchActive,
    bool Function()? isBooksReaderBarsVisible,
    void Function(bool visible)? setBooksReaderBarsVisible,
    bool Function()? hasBooksChaptersDropdown,
    bool Function(int bookNumber)? isBooksBookDownloaded,
    PageController Function()? booksReaderPageController,
    bool Function()? hasAzkarCategoriesVisible,
    double Function()? azkarListScrollOffset,
    void Function(double offset)? scrollAzkarListTo,
    double Function()? azkarItemScrollOffset,
    void Function(double offset)? scrollAzkarItemTo,
    bool Function()? hasHomeDailyAyah,
    bool Function()? hasHomeDailyZeker,
    double Function()? homeScrollOffset,
    double Function()? homeScrollMax,
    void Function(double offset)? scrollHomeTo,
  }) : _isControlsVisible = isControlsVisible,
       _toggleControls = toggleControls,
       _collapsePanels = collapsePanels,
       _isAyahMenuOpen = isAyahMenuOpen,
       _openAyahMenu = openAyahMenu,
       _closeAyahMenu = closeAyahMenu,
       _isPlayerExpanded = isPlayerExpanded,
       _setPlayerExpanded = setPlayerExpanded,
       _isOnAudioFullScreen = isOnAudioFullScreen,
       _openAudioFullScreen = openAudioFullScreen,
       _closeAudioFullScreen = closeAudioFullScreen,
       _audioSurahListOffset = audioSurahListOffset,
       _scrollAudioSurahListTo = scrollAudioSurahListTo,
       _isMidasAssistantMode = isMidasAssistantMode,
       _setMidasAssistantMode = setMidasAssistantMode,
       _isMidadOnline = isMidadOnline,
       _awaitMidadReady = awaitMidadReady,
       _hasMidadSectionLoaded = hasMidadSectionLoaded,
       _isMidadSharedLoaded = isMidadSharedLoaded,
       _isMidadSemanticEmpty = isMidadSemanticEmpty,
       _isMidadAssistantFresh = isMidadAssistantFresh,
       _hasMidadProviders = hasMidadProviders,
       _hasBooksLastRead = hasBooksLastRead,
       _hasVisibleBooksGrid = hasVisibleBooksGrid,
       _booksListScrollOffset = booksListScrollOffset,
       _scrollBooksListTo = scrollBooksListTo,
       _isBooksSectionSearchActive = isBooksSectionSearchActive,
       _setBooksSectionSearchActive = setBooksSectionSearchActive,
       _isBooksReaderBarsVisible = isBooksReaderBarsVisible,
       _setBooksReaderBarsVisible = setBooksReaderBarsVisible,
       _hasBooksChaptersDropdown = hasBooksChaptersDropdown,
       _isBooksBookDownloaded = isBooksBookDownloaded,
       _booksReaderPageController = booksReaderPageController,
       _hasAzkarCategoriesVisible = hasAzkarCategoriesVisible,
       _azkarListScrollOffset = azkarListScrollOffset,
       _scrollAzkarListTo = scrollAzkarListTo,
       _azkarItemScrollOffset = azkarItemScrollOffset,
       _scrollAzkarItemTo = scrollAzkarItemTo,
       _hasHomeDailyAyah = hasHomeDailyAyah,
       _hasHomeDailyZeker = hasHomeDailyZeker,
       _homeScrollOffset = homeScrollOffset,
       _homeScrollMax = homeScrollMax,
       _scrollHomeTo = scrollHomeTo;

  static AppTour get instance => Get.find<AppTour>();

  /// تُحقن من main.dart، فلا يستورد هذا الملف مكتبات التطبيق الكبيرة وتبقى
  /// الخدمة قابلة للاختبار مستقلة:
  /// * ظهور أزرار التحكم: قراءته (GeneralController.instance.state
  ///   .isShowControl.value) وتبديله (QuranController.instance.showControl).
  /// * طي ورقتي الأعلى والأسفل (QuranController.instance.closePanels).
  /// * ورقة خيارات الآية (AyahMenuHelper): هل هي مفتوحة، وفتحها وإغلاقها.
  final bool Function()? _isControlsVisible;
  final void Function()? _toggleControls;
  final void Function()? _collapsePanels;
  final bool Function()? _isAyahMenuOpen;
  final void Function()? _openAyahMenu;
  final void Function()? _closeAyahMenu;
  final bool Function()? _isPlayerExpanded;
  final void Function(bool expanded)? _setPlayerExpanded;
  final bool Function()? _isOnAudioFullScreen;
  final Future<void> Function()? _openAudioFullScreen;
  final void Function()? _closeAudioFullScreen;
  final double Function()? _audioSurahListOffset;
  final void Function(double offset)? _scrollAudioSurahListTo;
  final bool Function()? _isMidasAssistantMode;
  final void Function(bool assistant)? _setMidasAssistantMode;
  final bool Function()? _isMidadOnline;
  final Future<void> Function()? _awaitMidadReady;
  final bool Function()? _hasMidadSectionLoaded;
  final bool Function()? _isMidadSharedLoaded;
  final bool Function()? _isMidadSemanticEmpty;
  final bool Function()? _isMidadAssistantFresh;
  final bool Function()? _hasMidadProviders;
  final bool Function()? _hasBooksLastRead;
  final bool Function()? _hasVisibleBooksGrid;
  final double Function()? _booksListScrollOffset;
  final void Function(double offset)? _scrollBooksListTo;
  final bool Function()? _isBooksSectionSearchActive;
  final void Function(bool active)? _setBooksSectionSearchActive;
  final bool Function()? _isBooksReaderBarsVisible;
  final void Function(bool visible)? _setBooksReaderBarsVisible;
  final bool Function()? _hasBooksChaptersDropdown;
  final bool Function(int bookNumber)? _isBooksBookDownloaded;
  final PageController Function()? _booksReaderPageController;
  final bool Function()? _hasAzkarCategoriesVisible;
  final double Function()? _azkarListScrollOffset;
  final void Function(double offset)? _scrollAzkarListTo;
  final double Function()? _azkarItemScrollOffset;
  final void Function(double offset)? _scrollAzkarItemTo;
  final bool Function()? _hasHomeDailyAyah;
  final bool Function()? _hasHomeDailyZeker;
  final double Function()? _homeScrollOffset;
  final double Function()? _homeScrollMax;
  final void Function(double offset)? _scrollHomeTo;

  // ---- MushafTourHooks: ما ينفّذه السيناريو في التطبيق ----------------

  @override
  bool get isControlsVisible => _isControlsVisible?.call() ?? true;

  @override
  void toggleControls() => _toggleControls?.call();

  @override
  void collapsePanels() => _collapsePanels?.call();

  @override
  bool get isAyahMenuOpen => _isAyahMenuOpen?.call() ?? false;

  @override
  void openAyahMenu() => _openAyahMenu?.call();

  @override
  void closeAyahMenu() => _closeAyahMenu?.call();

  // ---- MidadTourHooks: ما ينفّذه السيناريو في التطبيق ----------------

  @override
  bool get isMidasAssistantMode => _isMidasAssistantMode?.call() ?? false;

  @override
  void setMidasAssistantMode(bool assistant) =>
      _setMidasAssistantMode?.call(assistant);

  @override
  bool get isMidadOnline => _isMidadOnline?.call() ?? true;

  @override
  Future<void> awaitMidadReady() async => await _awaitMidadReady?.call();

  @override
  bool get hasMidadSectionLoaded => _hasMidadSectionLoaded?.call() ?? false;

  @override
  bool get isMidadSharedLoaded => _isMidadSharedLoaded?.call() ?? false;

  @override
  bool get isMidadSemanticEmpty => _isMidadSemanticEmpty?.call() ?? true;

  @override
  bool get isMidadAssistantFresh => _isMidadAssistantFresh?.call() ?? true;

  @override
  bool get hasMidadProviders => _hasMidadProviders?.call() ?? false;

  // ---- BooksTourHooks: ما ينفّذه السيناريو في التطبيق ----------------

  @override
  bool get hasBooksLastRead => _hasBooksLastRead?.call() ?? false;

  @override
  bool get hasVisibleBooksGrid => _hasVisibleBooksGrid?.call() ?? false;

  @override
  double get booksListScrollOffset => _booksListScrollOffset?.call() ?? 0;

  @override
  void scrollBooksListTo(double offset) => _scrollBooksListTo?.call(offset);

  @override
  bool get isBooksSectionSearchActive =>
      _isBooksSectionSearchActive?.call() ?? false;

  @override
  void setBooksSectionSearchActive(bool active) =>
      _setBooksSectionSearchActive?.call(active);

  @override
  bool get isBooksReaderBarsVisible =>
      _isBooksReaderBarsVisible?.call() ?? true;

  @override
  void setBooksReaderBarsVisible(bool visible) =>
      _setBooksReaderBarsVisible?.call(visible);

  @override
  bool get hasBooksChaptersDropdown =>
      _hasBooksChaptersDropdown?.call() ?? false;

  @override
  bool isBooksBookDownloaded(int bookNumber) =>
      _isBooksBookDownloaded?.call(bookNumber) ?? false;

  // ---- AzkarTourHooks: ما ينفّذه السيناريو في التطبيق ----------------

  @override
  bool get hasAzkarCategoriesVisible =>
      _hasAzkarCategoriesVisible?.call() ?? true;

  @override
  double get azkarListScrollOffset => _azkarListScrollOffset?.call() ?? 0;

  @override
  void scrollAzkarListTo(double offset) => _scrollAzkarListTo?.call(offset);

  @override
  double get azkarItemScrollOffset => _azkarItemScrollOffset?.call() ?? 0;

  @override
  void scrollAzkarItemTo(double offset) => _scrollAzkarItemTo?.call(offset);

  // ---- HomeTourHooks: ما ينفّذه السيناريو في التطبيق ----------------

  @override
  bool get hasHomeDailyAyah => _hasHomeDailyAyah?.call() ?? false;

  @override
  bool get hasHomeDailyZeker => _hasHomeDailyZeker?.call() ?? false;

  @override
  double get homeScrollOffset => _homeScrollOffset?.call() ?? 0;

  @override
  double get homeScrollMax => _homeScrollMax?.call() ?? 0;

  @override
  void scrollHomeTo(double offset) => _scrollHomeTo?.call(offset);

  // ---- AudioTourHooks: ما ينفّذه السيناريو في التطبيق ----------------

  @override
  bool get isPlayerExpanded => _isPlayerExpanded?.call() ?? false;

  @override
  void setPlayerExpanded(bool expanded) => _setPlayerExpanded?.call(expanded);

  @override
  double get surahListOffset => _audioSurahListOffset?.call() ?? 0;

  @override
  void scrollSurahListTo(double offset) =>
      _scrollAudioSurahListTo?.call(offset);

  /// هل فتحت الجولة شاشة المشغّل الكامل؟ لا تُغلق إلا حين تكون هي من
  /// فتحتها، فتُترك للمستخدم شاشةٌ فتحها بنفسه.
  bool _audioTourOpenedFullScreen = false;

  @override
  Future<void> openFullScreen() async {
    if (_isOnAudioFullScreen?.call() ?? false) return;
    _audioTourOpenedFullScreen = true;
    await _openAudioFullScreen?.call();
  }

  @override
  void closeFullScreen() {
    if (!_audioTourOpenedFullScreen) return;
    _audioTourOpenedFullScreen = false;
    // إن غادر المستخدم الشاشة الكاملة بنفسه وسط الجولة فالراوتر فوقها لم
    // يعد الشاشةَ، والرجوع هنا كان سيطرد شاشة القائمة تحتها.
    if (_isOnAudioFullScreen?.call() ?? false) _closeAudioFullScreen?.call();
  }

  /// معرّف جولة المصحف في مخزن الإكمال.
  static const String mushafTourId = 'mushaf';

  /// معرّف جولة التسميع في مخزن الإكمال.
  static const String tasmeeTourId = 'tasmee';

  /// معرّف جولة المصحف الصوتي في مخزن الإكمال.
  static const String audioTourId = 'audio';

  /// معرّف جولة مداد الكاملة في مخزن الإكمال.
  static const String midadTourId = 'midad';

  /// معرّف جولة التحميل القصيرة (الوضع الدلالي قبل تحميل أي قسم).
  static const String midadDownloadTourId = 'midad_download';

  /// معرّف جولة المساعد الذكي (وضع المساعد قبل تحميل أي قسم).
  static const String midadAssistantTourId = 'midad_assistant';

  /// معرّف جولة قائمة الكتب (شاشة المكتبة الإسلامية) في مخزن الإكمال.
  static const String booksTourId = 'books';

  /// معرّف جولة صفحة الكتاب في مخزن الإكمال.
  static const String booksChaptersTourId = 'books_chapters';

  /// معرّف جولة القارئ في مخزن الإكمال.
  static const String booksReaderTourId = 'books_reader';

  /// معرّف جولة الأذكار (الشاشة الرئيسية) في مخزن الإكمال.
  static const String azkarTourId = 'azkar';

  /// معرّف جولة شاشة القسم (أذكار التصنيف) في مخزن الإكمال.
  static const String azkarItemTourId = 'azkar_item';

  /// معرّف جولة الصفحة الرئيسية في مخزن الإكمال.
  static const String homeTourId = 'home';

  /// مخزن الإكمال الدائم (متاح لأزرار «إعادة الجولة» في الأقسام الأخرى).
  late final GetStorageTourCompletionStore store =
      GetStorageTourCompletionStore(GetStorage());

  /// الكنترولر المركزي الوحيد. لا تُتخلَّص منه مع أي شاشة؛ عمره عمر
  /// التطبيق، ويُمرَّر إلى SpotlightTourHost في myApp.dart.
  late final SpotlightTourController tour = SpotlightTourController(
    completionStore: store,
  );

  // ---- مفاتيح أهداف خطوات المصحف -------------------------------------
  // كل مفتاح يُمرَّر إلى ودجت واحد مركَّب في كل لحظة (قاعدة GlobalKey
  // المعروفة). مواضع تركيبها موضحة في دليل الربط. بقية الأهداف، وهي التي
  // قد تُركَّب أكثر من مرة، مفاتيحها عادية في MushafTourKeys.

  /// غلاف QuranLibraryScreen في text_build.dart (منطقة صفحة المصحف كاملة).
  final GlobalKey mushafPageKey = GlobalKey();

  /// شريط الأزرار العلوي: الـContainer داخل QuranTopBar في
  /// quran_top_bar.dart (لا جذره، فهو Align بملء الشاشة).
  final GlobalKey topBarKey = GlobalKey();

  // ---- عرض قلب الصفحة ---------------------------------------------------

  PageSwipeDemo? _mushafSwipeDemo;

  /// عرض قلب صفحة القارئ. يُنشأ مع كل بدء جولة القارئ على كنترولر الصفحات
  /// الحيّ، فصفحة القارئ تعيد إنشاء كنترولرها في كل زيارة (getSafePageController
  /// في امتداد الكتب)، فالربط بكنترولر بادئ الجولة السابقة لا يقلب شيئاً.
  PageSwipeDemo? _booksSwipeDemo;

  /// صفحة المستخدم قبل بدء العرض، لاستعادتها إن قاطع المستخدم العرض.
  int? _pageBeforeDemo;

  /// هل عرض قلب الصفحة يعمل الآن؟ استخدمه لتجاهل نداءات onPageChanged
  /// المؤقتة أثناء العرض إن أضفت مستقبلاً ردّ onPageChanged خاصاً بك إلى
  /// QuranLibraryScreen:
  ///   onPageChanged: (i) {
  ///     if (AppTour.instance.isSwipeDemoRunning) return;
  ///     ...
  ///   },
  bool get isSwipeDemoRunning => _mushafSwipeDemo?.isRunning ?? false;

  /// ملف علامة «عرض قلب جارٍ» في مجلد مستندات التطبيق: يُكتب قبل بدء
  /// العرض ويُحذف بعد تأكّد وصول استعادة «آخر صفحة» إلى القرص. بقاؤه عند
  /// إقلاع التطبيق يعني أن الجلسة السابقة قُتلت قبل اكتمال الاستعادة،
  /// فيُصلحها [repairInterruptedDemoIfNeeded].
  ///
  /// لماذا ملف خاص وليس مفتاح GetStorage؟ لأن وعد GetStorage.write يكتمل
  /// قبل الكتابة الفعلية (الكتابة مجدولة عبر طابور داخلي لا يوفّر واجهة
  /// انتظار)، فلا يصلح حاجز متانة؛ أما File.writeAsString(flush: true)
  /// فيُنتظر فعلاً. وللسبب نفسه لا يُحذف الملف قبل التأكد من ظهور تصحيح
  /// «آخر صفحة» داخل ملف GetStorage.gs نفسه (انظر [_deleteGuardWhenDurable]).
  static const String _kDemoGuardFileName = 'tour_demo_guard.json';

  File? _guardFile;
  File? _getStorageFile;

  Future<File> _guard() async => _guardFile ??= File(
    '${(await getApplicationDocumentsDirectory()).path}/$_kDemoGuardFileName',
  );

  /// ملف الحاوية الافتراضية لـ GetStorage (اسم الحاوية في main هو
  /// الافتراضي GetStorage، وامتداده .gs في get_storage 2.1.1).
  Future<File> _gsBox() async => _getStorageFile ??= File(
    '${(await getApplicationDocumentsDirectory()).path}/GetStorage.gs',
  );

  bool _mushafAutoTriggered = false;

  bool _tasmeeAutoTriggered = false;

  bool _audioAutoTriggered = false;

  bool _midadAutoTriggered = false;

  bool _midadAssistantAutoTriggered = false;

  bool _booksAutoTriggered = false;

  bool _booksChaptersAutoTriggered = false;

  bool _booksReaderAutoTriggered = false;

  bool _azkarAutoTriggered = false;

  bool _azkarItemAutoTriggered = false;

  bool _homeAutoTriggered = false;

  /// يمنع بدء جولة [tourId] تلقائياً في هذه الجلسة: يضبط علم «مرة واحدة»
  /// الخاص بها فلا أثر لنداءات شاشتها (startXTourOnce). يستدعيه مشغّل
  /// الجولات قبل فتح القسم كي لا تشغّل الشاشة جولتها التلقائية وتتزاحم مع
  /// الجولة التي اختارها المستخدم من الإعدادات. جولة مداد تشمل جولة
  /// المساعد أيضاً لأن شاشة مداد تشغّلهما معاً.
  void suppressAutoStart(String tourId) {
    switch (tourId) {
      case mushafTourId:
        _mushafAutoTriggered = true;
      case tasmeeTourId:
        _tasmeeAutoTriggered = true;
      case audioTourId:
        _audioAutoTriggered = true;
      case midadTourId:
      case midadAssistantTourId:
        _midadAutoTriggered = true;
        _midadAssistantAutoTriggered = true;
      case booksTourId:
        _booksAutoTriggered = true;
      case azkarTourId:
        _azkarAutoTriggered = true;
      case homeTourId:
        _homeAutoTriggered = true;
    }
  }

  /// سيناريو الجولة الجارية (null قبل أول بدء). يُنشأ مع كل بدء لأن
  /// [buildMushafSteps] كذلك، ويُوجَّه إليه ما يطرأ على ورقة خيارات الآية.
  MushafTourScript? _script;

  /// يبني خطوات جولة المصحف ويجهّز عرض قلب الصفحة على كنترولر الصفحات
  /// الحالي.
  ///
  /// مهم: يُستدعى لحظة بدء الجولة فقط (من [repairThenStartMushafTourOnce]
  /// و[replayMushafTour]) ولا تُخزَّن القائمة الناتجة، لأن quran_library
  /// يعيد إنشاء quranPagesController عند تغيّر الاتجاه أو وضع العرض
  /// (صفحتان على الديسكتوب العريض)، فإنشاء العرض هنا يضمن أنه مربوط
  /// بالكنترولر الحيّ الحالي وليس بنسخة مصروفة.
  List<TourStep> buildMushafSteps() {
    _mushafSwipeDemo?.dispose();
    _mushafSwipeDemo = PageSwipeDemo(
      pageController: QuranCtrl.instance.quranPagesController,
      vsync: this,
    );
    final demo = _mushafSwipeDemo!;
    final tourStyle = _tourStyle();
    // الخطوات نفسها وأسماء أهدافها في MushafTourScript. الكنترولر يخبر
    // السيناريو بتغيّر الخطوة وبانتهاء الجولة ليجهاز التطبيق لكل خطوة.
    final script = _script = MushafTourScript(
      tour: tour,
      hooks: this,
      style: tourStyle,
      swipeDemo: demo,
      pageKey: mushafPageKey,
      controlsBarKey: topBarKey,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// أسلوب بطاقات الجولات وأزرارها بأسلوب التطبيق. يُبنى لحظة بدء الجولة
  /// لأنه يقرأ ألوان السمة الجارية.
  TourStepStyle _tourStyle() => TourStepStyle(
    cardMaxWidth: 500,
    accentColor: Get.theme.colorScheme.surface,
    cardColor: Get.theme.colorScheme.primaryContainer,
    scrimColor: Get.theme.colorScheme.primary.withValues(alpha: .5),
    onAccentColor: Get.theme.colorScheme.surface,
    indicatorColor: Get.theme.colorScheme.surface,
    skipStyle: AppTextStyles.titleSmall(),
    buttonTextStyle: AppTextStyles.titleMedium(),
    titleStyle: AppTextStyles.titleMedium(),
    bodyStyle: AppTextStyles.bodySmall(fontSize: 15),
    previousStyle: AppTextStyles.bodySmall(
      fontSize: 15,
      color: Get.theme.colorScheme.surface,
    ),
  );

  /// يصلّح أي عرض قلب متقطع من جلسة سابقة ثم يبدأ جولة المصحف أول مرة
  /// فقط. نقطة الاستدعاء الوحيدة من build الخاص بـ QuranHome عبر
  /// addPostFrameCallback. الإصلاح يُنتظَر قبل البدء حتى لا تتسابق
  /// الاستعادة مع عرض القلب، والعلم يُضبط تزامنياً قبل أي انتظار فلا
  /// تتكرر الجولة مهما تعددت إعادات البناء وردود الإطار المتزاحمة، ولا
  /// تبدأ إن كانت جولة أخرى ظاهرة أو كانت جولة المصحف مكتملة سابقاً.
  void repairThenStartMushafTourOnce() {
    if (_mushafAutoTriggered) return;
    _mushafAutoTriggered = true;
    () async {
      await repairInterruptedDemoIfNeeded();
      tour.startOnce(tourId: mushafTourId, steps: buildMushafSteps());
    }();
  }

  /// إعادة جولة المصحف فوراً (من الإعدادات، بعد إغلاق ورقتها حتى لا يغطيها
  /// ستر الجولة).
  Future<void> replayMushafTour() async {
    _mushafAutoTriggered = true;
    await store.reset(mushafTourId);
    tour.start(tourId: mushafTourId, steps: buildMushafSteps());
  }

  /// يبني خطوات جولة التسميع بحسب نمط التسميع الجاري، ويوجّه إليها ما يطرأ
  /// على الكنترولر. يُستدعى لحظة بدء الجولة فقط (من [startTasmeeTourOnce]
  /// و[replayTasmeeTour])، لأن في الجولة محطات تُبنى بحسب النمط وقد
  /// يبدّله المستخدم بين جولة وأخرى.
  List<TourStep> buildTasmeeSteps() {
    final script = TasmeeTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      mode: TasmeeCtrl.instance.state.mode.value,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة التسميع أول مرة فقط. نقطة الاستدعاء الوحيدة من build الخاص
  /// بـ QuranHome في وضع التسميع عبر addPostFrameCallback. العلم يُضبط
  /// تزامنياً قبل أي انتظار فلا تتكرر الجولة مهما تعددت إعادات البناء وردود
  /// الإطار المتزاحمة، ولا تبدأ إن كانت جولة أخرى ظاهرة أو كانت جولة التسميع
  /// مكتملة سابقاً.
  void startTasmeeTourOnce() {
    if (_tasmeeAutoTriggered) return;
    _tasmeeAutoTriggered = true;
    tour.startOnce(tourId: tasmeeTourId, steps: buildTasmeeSteps());
  }

  /// إعادة جولة التسميع فوراً (من الإعدادات).
  Future<void> replayTasmeeTour() async {
    _tasmeeAutoTriggered = true;
    await store.reset(tasmeeTourId);
    tour.start(tourId: tasmeeTourId, steps: buildTasmeeSteps());
  }

  /// يبني خطوات جولة المصحف الصوتي ويوجّه إليها ما يطرأ على الكنترولر.
  /// يُستدعى لحظة بدء الجولة فقط (من [startAudioTourOnce] و
  /// [replayAudioTour])، لأن أسلوب البطاقات يُقرأ من السمة الجارية.
  List<TourStep> buildAudioSteps() {
    final script = AudioTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة المصحف الصوتي أول مرة فقط. نقطة الاستدعاء الوحيدة من build
  /// الخاص بـ AudioScreen عبر addPostFrameCallback. العلم يُضبط تزامنياً
  /// قبل أي انتظار فلا تتكرر الجولة مهما تعددت إعادات البناء وردود الإطار
  /// المتزاحمة، ولا تبدأ إن كانت جولة أخرى ظاهرة أو كانت جولة القسم
  /// مكتملة سابقاً.
  void startAudioTourOnce() {
    if (_audioAutoTriggered) return;
    _audioAutoTriggered = true;
    tour.startOnce(tourId: audioTourId, steps: buildAudioSteps());
  }

  /// إعادة جولة المصحف الصوتي فوراً (من الإعدادات).
  Future<void> replayAudioTour() async {
    _audioAutoTriggered = true;
    await store.reset(audioTourId);
    tour.start(tourId: audioTourId, steps: buildAudioSteps());
  }

  /// يبني خطوات جولة مداد الكاملة ويوجّه إليها ما يطرأ على الكنترولر.
  /// تُقرأ حالة الشاشة (اتصال، اقتراحات، مزودون) لحظة البدء فقط لأنها
  /// تفصل محطاتٍ قد غاب هدفها في بعض الحالات.
  List<TourStep> buildMidadSteps() {
    final script = MidadTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      online: isMidadOnline,
      hasProviders: hasMidadProviders,
      semanticEmpty: isMidadSemanticEmpty,
      assistantFresh: isMidadAssistantFresh,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبني خطوات جولة التحميل القصيرة، ولا تجهيز لها فتُربط ردّاها الفارغة
  /// لتُلغي ردّ أي جولة أقدم على الكنترولر.
  List<TourStep> buildMidadDownloadSteps() {
    final script = MidadDownloadTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      sharedLoaded: isMidadSharedLoaded,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبني خطوات جولة المساعد الذكي، ولا تجهيز لها كجولة التحميل.
  List<TourStep> buildMidadAssistantSteps() {
    final script = MidadAssistantTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      online: isMidadOnline,
      assistantFresh: isMidadAssistantFresh,
      hasProviders: hasMidadProviders,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// جولة مداد المطابقة للحالة: الكاملة بعد تحميل أي قسم؛ وإلا فجولة
  /// المساعد إن كان المستخدم في وضع المساعد (فالمساعد يعمل دون تحميلات)،
  /// وإلا فجولة التحميل.
  (String, List<TourStep>) _midadTourForCurrentState() {
    if (hasMidadSectionLoaded) return (midadTourId, buildMidadSteps());
    if (isMidasAssistantMode) {
      return (midadAssistantTourId, buildMidadAssistantSteps());
    }
    return (midadDownloadTourId, buildMidadDownloadSteps());
  }

  /// يبدأ جولة مداد أول مرة فقط، بتفريق حالة الشاشة كما في
  /// [_midadTourForCurrentState]. نقطة الاستدعاء الوحيدة من بطاقة التشغيل
  /// داخل شاشة مداد بعد اكتمال التهيئة، فلا انتظار هنا ولا تبدأ الجولة
  /// فوق شاشة أخرى.
  void startMidadTourOnce() {
    if (_midadAutoTriggered) return;
    _midadAutoTriggered = true;
    final (id, steps) = _midadTourForCurrentState();
    if (id == midadAssistantTourId) {
      // هذه هي جولته الأولى هذه الجلسة، فلا يعيدها الانتقال إليه ثانيةً.
      _midadAssistantAutoTriggered = true;
    }
    tour.startOnce(tourId: id, steps: steps);
  }

  /// يبدأ جولة المساعد الذكي أول مرة فقط: أول انتقال إلى وضع المساعد قبل
  /// تحميل أي قسم (تستدعيها بطاقة التشغيل داخل الشاشة). بعد التحميل لا
  /// شيء، فالجولة الكاملة تشرح المساعد ضمن مسارها.
  void startMidadAssistantTourOnce() {
    if (_midadAssistantAutoTriggered) return;
    _midadAssistantAutoTriggered = true;
    if (hasMidadSectionLoaded) return;
    tour.startOnce(
      tourId: midadAssistantTourId,
      steps: buildMidadAssistantSteps(),
    );
  }

  /// إعادة جولة مداد فوراً (من الإعدادات): يعيد الجولة المطابقة لحالة
  /// الشاشة بعد اكتمال التهيئة إن كانت جارية.
  Future<void> replayMidadTour() async {
    _midadAutoTriggered = true;
    await awaitMidadReady();
    final (id, steps) = _midadTourForCurrentState();
    await store.reset(id);
    tour.start(tourId: id, steps: steps);
  }

  /// يبني خطوات جولة قائمة الكتب ويوجّه إليها ما يطرأ على الكنترولر.
  /// تُقرأ حالة الشاشة (شريط آخر قراءة، شبكة الكتب) لحظة البدء فقط لأنها
  /// تفصل محطاتٍ قد غاب هدفها في بعض الحالات.
  List<TourStep> buildBooksSteps() {
    final script = BooksTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      hasLastRead: hasBooksLastRead,
      hasGrid: hasVisibleBooksGrid,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة قائمة الكتب أول مرة فقط. نقطة الاستدعاء الوحيدة من بطاقة
  /// التشغيل داخل شاشة المكتبة بعد اكتمال تحميل الكتب. العلم يُضبط
  /// تزامنياً فلا تتكرر الجولة مهما تعددت إعادات البناء، ولا تبدأ إن كانت
  /// جولة أخرى ظاهرة أو كانت جولة القسم مكتملة سابقاً.
  void startBooksTourOnce() {
    if (_booksAutoTriggered) return;
    _booksAutoTriggered = true;
    tour.startOnce(tourId: booksTourId, steps: buildBooksSteps());
  }

  /// إعادة جولة قائمة الكتب فوراً (من الإعدادات).
  Future<void> replayBooksTour() async {
    _booksAutoTriggered = true;
    await store.reset(booksTourId);
    tour.start(tourId: booksTourId, steps: buildBooksSteps());
  }

  /// يبني خطوات جولة صفحة الكتاب [bookNumber] ويوجّه إليها ما يطرأ على
  /// الكنترولر. حالة تحميل الكتاب تُقرأ لحظة البدء لأنها تفصل محطتي
  /// الفهرس وتُتبع عنوان زر التحميل/الحذف.
  List<TourStep> buildBooksChaptersSteps({required int bookNumber}) {
    final script = BooksChaptersTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      bookNumber: bookNumber,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة صفحة الكتاب أول مرة فقط. نقطة الاستدعاء الوحيدة من build
  /// الخاص بـ ChaptersPage عبر addPostFrameCallback. العلم يُضبط تزامنياً
  /// فلا تتكرر الجولة مهما تعددت إعادات البناء، ولا تبدأ إن كانت جولة
  /// أخرى ظاهرة أو كانت جولتها مكتملة سابقاً.
  void startBooksChaptersTourOnce({required int bookNumber}) {
    if (_booksChaptersAutoTriggered) return;
    _booksChaptersAutoTriggered = true;
    tour.startOnce(
      tourId: booksChaptersTourId,
      steps: buildBooksChaptersSteps(bookNumber: bookNumber),
    );
  }

  /// إعادة جولة صفحة الكتاب فوراً (من زر الاستفهام في الشاشة).
  Future<void> replayBooksChaptersTour({required int bookNumber}) async {
    _booksChaptersAutoTriggered = true;
    await store.reset(booksChaptersTourId);
    tour.start(
      tourId: booksChaptersTourId,
      steps: buildBooksChaptersSteps(bookNumber: bookNumber),
    );
  }

  /// يبني خطوات جولة القارئ ويوجّه إليها ما يطرأ على الكنترولر. جاهزية
  /// الفصول المنسدلة تُقرأ لحظة البدء لأنها تفصل محطتها، ويُنشأ عرض قلب
  /// الصفحة على كنترولر الصفحات الحيّ (يُهدم عرضُ الجولة السابقة أولاً).
  List<TourStep> buildBooksReaderSteps() {
    _booksSwipeDemo?.dispose();
    _booksSwipeDemo = PageSwipeDemo(
      pageController: _booksReaderPageController?.call() ?? PageController(),
      vsync: this,
    );
    final script = BooksReaderTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      swipeDemo: _booksSwipeDemo,
      hasChaptersDropdown: hasBooksChaptersDropdown,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة القارئ أول مرة فقط. نقطة الاستدعاء الوحيدة من بطاقة التشغيل
  /// داخل جسم الصفحات، فلا تبدأ إلا بعد جهوزية الصفحات. العلم يُضبط
  /// تزامنياً فلا تتكرر الجولة مهما تعددت إعادات البناء، ولا تبدأ إن كانت
  /// جولة أخرى ظاهرة أو كانت جولتها مكتملة سابقاً.
  void startBooksReaderTourOnce() {
    if (_booksReaderAutoTriggered) return;
    _booksReaderAutoTriggered = true;
    tour.startOnce(tourId: booksReaderTourId, steps: buildBooksReaderSteps());
  }

  /// إعادة جولة القارئ فوراً (من زر الاستفهام في الشاشة).
  Future<void> replayBooksReaderTour() async {
    _booksReaderAutoTriggered = true;
    await store.reset(booksReaderTourId);
    tour.start(tourId: booksReaderTourId, steps: buildBooksReaderSteps());
  }

  /// يبني خطوات جولة الأذكار (الشاشة الرئيسية) ويوجّه إليها ما يطرأ على
  /// الكنترولر. تُقرأ حالة الشاشة (ظهور قائمة الأقسام) لحظة البدء فقط
  /// لأنها تفصل محطةً قد غاب هدفها حين يكون البحث جارياً.
  List<TourStep> buildAzkarSteps() {
    final script = AzkarTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      hasCategoriesVisible: hasAzkarCategoriesVisible,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة الأذكار أول مرة فقط. نقطة الاستدعاء الوحيدة من بطاقة
  /// التشغيل داخل شاشة الأذكار بعد اكتمال تحميل الأقسام. العلم يُضبط
  /// تزامنياً فلا تتكرر الجولة مهما أُعيدت إعادات البناء، ولا تبدأ إن كانت
  /// جولة أخرى ظاهرة أو كانت جولة القسم مكتملة سابقاً.
  void startAzkarTourOnce() {
    if (_azkarAutoTriggered) return;
    _azkarAutoTriggered = true;
    tour.startOnce(tourId: azkarTourId, steps: buildAzkarSteps());
  }

  /// إعادة جولة الأذكار فوراً (من الإعدادات).
  Future<void> replayAzkarTour() async {
    _azkarAutoTriggered = true;
    await store.reset(azkarTourId);
    tour.start(tourId: azkarTourId, steps: buildAzkarSteps());
  }

  /// يبني خطوات جولة شاشة القسم ويوجّه إليها ما يطرأ على الكنترولر:
  /// تثبيت الشاشة على أعلاها خلال محطتي شريط الخيارات ونص أول ذكر،
  /// وإعادة موضع المستخدم عند انتهائها.
  List<TourStep> buildAzkarItemSteps() {
    final script = AzkarItemTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة شاشة القسم أول مرة فقط. نقطة الاستدعاء الوحيدة من build
  /// الخاص بـ AdhkarItem عبر addPostFrameCallback. العلم يُضبط تزامنياً
  /// فلا تتكرر الجولة مهما أُعيدت إعادات البناء، ولا تبدأ إن كانت جولة
  /// أخرى ظاهرة أو كانت جولتها مكتملة سابقاً.
  void startAzkarItemTourOnce() {
    if (_azkarItemAutoTriggered) return;
    _azkarItemAutoTriggered = true;
    tour.startOnce(tourId: azkarItemTourId, steps: buildAzkarItemSteps());
  }

  /// إعادة جولة شاشة القسم فوراً (من زر الاستفهام في الشاشة).
  Future<void> replayAzkarItemTour() async {
    _azkarItemAutoTriggered = true;
    await store.reset(azkarItemTourId);
    tour.start(tourId: azkarItemTourId, steps: buildAzkarItemSteps());
  }

  /// يبني خطوات جولة الصفحة الرئيسية ويوجّه إليها ما يطرأ على الكنترولر.
  /// تُقرأ حالة الشاشة (حضور آية اليوم وذكر اليوم) لحظة البدء فقط لأنها
  /// تفصل محطاتٍ قد غاب هدفها حين لم يُجلب المحتوى اليومي بعد.
  List<TourStep> buildHomeTourSteps() {
    final script = HomeTourScript(
      tour: tour,
      hooks: this,
      style: _tourStyle(),
      hasDailyAyah: hasHomeDailyAyah,
      hasDailyZeker: hasHomeDailyZeker,
    );
    tour
      ..onStepChanged = script.onStepChanged
      ..onSkip = script.onTourEnd
      ..onFinish = script.onTourEnd;
    return script.steps;
  }

  /// يبدأ جولة الصفحة الرئيسية أول مرة فقط. نقطة الاستدعاء الوحيدة من
  /// بطاقة التشغيل داخل الصفحة بعد جاهزية المحتوى اليومي (أو انقضاء مهلة
  /// انتظاره). العلم يُضبط تزامنياً فلا تتكرر الجولة مهما أُعيدت إعادات
  /// البناء، ولا تبدأ إن كانت جولة أخرى ظاهرة أو كانت جولتها مكتملة
  /// سابقاً.
  void startHomeTourOnce() {
    if (_homeAutoTriggered) return;
    _homeAutoTriggered = true;
    tour.startOnce(tourId: homeTourId, steps: buildHomeTourSteps());
  }

  /// إعادة جولة الصفحة الرئيسية فوراً (من الإعدادات).
  Future<void> replayHomeTour() async {
    _homeAutoTriggered = true;
    await store.reset(homeTourId);
    tour.start(tourId: homeTourId, steps: buildHomeTourSteps());
  }

  /// يصلّح موضع القراءة إن قُتل التطبيق قسراً وسط عرض القلب في جلسة
  /// سابقة: علامة [_kDemoGuardKey] الباقية تحمل صفحة المستخدم قبل ذلك
  /// العرض، فتُستعاد رقماً وتخزيناً وصفحة معروضة ثم تُمحى. لا تفعل شيئاً
  /// في الإقلاع الطبيعي. يستدعيها [repairThenStartMushafTourOnce] عند
  /// فتح شاشة المصحف قبل بدء الجولة.
  Future<void> repairInterruptedDemoIfNeeded() async {
    final guard = await _guard();
    if (!await guard.exists()) return;
    int? page;
    int? demoPage;
    try {
      final map =
          json.decode(await guard.readAsString()) as Map<String, dynamic>;
      page = map['page'] as int?;
      demoPage = map['demoPage'] as int?;
    } catch (_) {}
    if (page == null || demoPage == null) {
      await guard.delete();
      return;
    }
    final quranCtrl = QuranCtrl.instance;
    // ذاكرة GetStorage هنا قُرئت من الملف عند الإقلاع، فهي صورة القرص.
    final stored =
        GetStorage().read<int>('last_page') ??
        quranCtrl.state.currentPageNumber.value;
    if (stored == demoPage) {
      // الجلسة السابقة قُتلت و«آخر صفحة» عالقة على صفحة العرض: استعدها.
      quranCtrl.state.currentPageNumber.value = page;
      quranCtrl.saveLastPage(page);
      final pc = quranCtrl.quranPagesController;
      if (pc.hasClients && pc.page?.round() != page - 1) {
        pc.jumpToPage(page - 1);
      }
      await _deleteGuardWhenDurable(page);
      return;
    }
    // غير ذلك: إما وصلت الاستعادة قبل موت الجلسة (stored == page) أو
    // واصل المستخدم القراءة بعد الجولة (قيمة أخرى)، فلا شيء يُصلح
    // ويُحذف الملف فقط؛ لا يجوز إعادة «آخر صفحة» إلى الوراء هنا.
    await guard.delete();
  }

  /// إنهاء الجولة إن كانت ظاهرة. تُستدعى عند مغادرة شاشة المصحف حتى لا
  /// تبقى الجولة ظاهرة فوق صفحة أهدافها غائبة.
  void closeTourIfRunning() {
    if (tour.status != TourStatus.idle) {
      tour.skip();
    }
  }

  /// ورقة خيارات الآية فُتحت (تستدعيها AyahMenuHelper): إن كانت الجولة تنتظر
  /// الضغطة المطوّلة انتقلت إلى شرح الورقة.
  void onAyahMenuOpened() => _script?.onAyahMenuOpened();

  /// ورقة خيارات الآية أُغلقت (تستدعيها AyahMenuHelper): إن كانت الجولة تشرح
  /// داخلها عادت إلى خطوة الضغطة المطوّل.
  void onAyahMenuClosed() => _script?.onAyahMenuClosed();

  @override
  Future<void> captureReadingPage() async {
    final page = QuranCtrl.instance.state.currentPageNumber.value;
    _pageBeforeDemo = page;
    // حاجز متانة حقيقي: كتابة العلامة بـ flush:true وانتظارها، والجولة
    // تنتظر onEnter قبل أن تظهر الخطوة ويبدأ أي عرض، فالعلامة على القرص
    // قبل أول حركة للصفحة، لا بافتراض توقيت بل بانتظار نظام الملفات.
    // demoPage: الصفحة الوحيدة التي قد تعلق عليها «آخر صفحة» (الاتجاه
    // الوحيد للعرض في هذه الجولة: التقدّم صفحة واحدة في مصحف RTL).
    final file = await _guard();
    // كتابة ذرية: ملف مؤقت يُدفق (flush) ثم يُعاد تسميته؛ إعادة التسمية
    // عملية ذرية في نظام الملفات، فإن قُتلت العملية أثناء الكتابة بقي
    // الملف المؤقت الناقص وحده ولا يُقرأ، وتبقى العلامة إما كاملة أو غير
    // موجودة، ولا حالة وسطى تُفسد التحليل.
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(
      json.encode(<String, int>{'page': page, 'demoPage': page + 1}),
      flush: true,
    );
    await tmp.rename(file.path);
  }

  /// يعيد رقم الصفحة الحالية و«آخر صفحة» المحفوظة إلى موضع المستخدم إن
  /// بقيا على صفحة العرض بعد مقاطعته. في المسار الطبيعي لا يفعل شيئاً
  /// لأن قلبة العودة صحّحتهما أصلاً.
  @override
  Future<void> restoreReadingPage() async {
    final page = _pageBeforeDemo;
    _pageBeforeDemo = null;
    if (page == null) return;
    {
      final quranCtrl = QuranCtrl.instance;
      final pc = quranCtrl.quranPagesController;
      // يقارن أيضاً الصفحة المعروضة فعلياً: تدوير الشاشة أو تبديل وضع العرض
      // على الديسكتوب أثناء القلبة يعيد إنشاء كنترولر الصفحات عند موضع
      // العرض المؤقت، فيبقى المرئي على صفحة العرض وإن كان الرقم صحيحاً.
      final bool visualMismatch = pc.hasClients && pc.page?.round() != page - 1;
      if (quranCtrl.state.currentPageNumber.value != page || visualMismatch) {
        quranCtrl.state.currentPageNumber.value = page;
        quranCtrl.saveLastPage(page);
        if (visualMismatch) {
          pc.jumpToPage(page - 1);
        }
      }
    }
    // لا يُحذف ملف العلامة قبل التأكد من وصول التصحيح إلى قرص GetStorage.
    await _deleteGuardWhenDurable(page);
  }

  /// يحذف ملف العلامة فقط بعد أن يظهر `"last_page":page` فعلاً في ملف
  /// GetStorage.gs، دليل القرص الوحيد المتاح، إذ لا توفّر GetStorage
  /// واجهة انتظار لكتاباتها. عند انتهاء المهلة (ثانية واحدة) دون تأكيد
  /// تبقى العلامة، وتتولى الإقلاعة التالية الإصلاح بدلاً من حذف متفائل.
  Future<void> _deleteGuardWhenDurable(int page) async {
    final gs = await _gsBox();
    final guard = await _guard();
    for (var i = 0; i < 40; i++) {
      try {
        if ((await gs.readAsString()).contains('"last_page":$page')) {
          if (await guard.exists()) await guard.delete();
          return;
        }
      } catch (_) {
        // قراءة أثناء كتابة GetStorage للملف قد تعطي محتوى جزئياً: أعد المحاولة.
      }
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  }

  @override
  void onClose() {
    _mushafSwipeDemo?.dispose();
    _booksSwipeDemo?.dispose();
    tour.dispose();
    super.onClose();
  }
}
