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
    implements MushafTourHooks, AudioTourHooks {
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
       _scrollAudioSurahListTo = scrollAudioSurahListTo;

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

  /// إعادة جولة المصحف فوراً (من زر الإعادة في شاشة المصحف). أغلق القائمة
  /// المنبثقة قبل استدعائها حتى لا يغطيها ستر الجولة.
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

  /// إعادة جولة التسميع فوراً (من زر الجولة في شاشة التسميع).
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

  /// إعادة جولة المصحف الصوتي فوراً (من زر الجولة في شاشة القسم).
  Future<void> replayAudioTour() async {
    _audioAutoTriggered = true;
    await store.reset(audioTourId);
    tour.start(tourId: audioTourId, steps: buildAudioSteps());
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
    tour.dispose();
    super.onClose();
  }
}
