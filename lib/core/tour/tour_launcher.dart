import 'package:flexible_sheet/flexible_sheet.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/general/app_section.dart';
import 'app_tour.dart';

/// الجولات التي يمكن تشغيلها من الإعدادات: جولة واحدة لكل قسم يُفتح من
/// الصفحة الرئيسية. جولات الشاشات المتداخلة (صفحة الكتاب، القارئ، شاشة
/// قسم الأذكار) ليست هنا: تحتاج كتاباً أو قسماً يختاره المستخدم، فزر «؟»
/// يبقى في شاشاتها يعيد جولتها.
enum AppTourPick {
  home(AppSection.home, AppTour.homeTourId, 'homeTourIntroTitle'),
  mushaf(AppSection.mushaf, AppTour.mushafTourId, 'mushafTourIntroTitle'),
  tasmee(AppSection.tasmee, AppTour.tasmeeTourId, 'tasmeeTourIntroTitle'),
  audio(AppSection.audio, AppTour.audioTourId, 'audioTourIntroTitle'),
  midad(AppSection.midad, AppTour.midadTourId, 'midadTourIntroTitle'),
  books(AppSection.books, AppTour.booksTourId, 'booksTourIntroTitle'),
  azkar(AppSection.azkar, AppTour.azkarTourId, 'azkarTourIntroTitle');

  const AppTourPick(this.section, this.id, this.titleKey);

  /// القسم الذي تُشرح جولته شاشته.
  final AppSection section;

  /// معرّف الجولة في مخزن الإكمال وعند أعلام «مرة واحدة».
  final String id;

  /// مفتاح عنوانها: عنوان بطاقة افتتاح الجولة نفسه، موجود في كل اللغات.
  final String titleKey;

  /// هل شاشة الجولة هي [currentRoute]؟ للمصحف والتسميع شاشة واحدة، فيميز
  /// بينهما وضع التسميع [isTasmeeMode].
  bool showsOn(String currentRoute, {required bool isTasmeeMode}) =>
      switch (this) {
        AppTourPick.mushaf => currentRoute == section.route && !isTasmeeMode,
        AppTourPick.tasmee => currentRoute == section.route && isTasmeeMode,
        _ => currentRoute == section.route,
      };

  /// هل شاشة الجولة هي الشاشة الجارية الآن؟
  bool isOnScreen(bool isTasmeeMode) =>
      showsOn(Get.currentRoute, isTasmeeMode: isTasmeeMode);

  /// يعيد الجولة فوراً على شاشتها؛ جولة مداد هي المطابقة لحالة الشاشة.
  Future<void> replay(AppTour tour) => switch (this) {
    AppTourPick.home => tour.replayHomeTour(),
    AppTourPick.mushaf => tour.replayMushafTour(),
    AppTourPick.tasmee => tour.replayTasmeeTour(),
    AppTourPick.audio => tour.replayAudioTour(),
    AppTourPick.midad => tour.replayMidadTour(),
    AppTourPick.books => tour.replayBooksTour(),
    AppTourPick.azkar => tour.replayAzkarTour(),
  };
}

/// يشغّل جولة اختارها المستخدم من الإعدادات: يغلق ورقة الإعدادات، فإن
/// لم تكن شاشة الجولة هي الجارية فتح أولًا قسمها (العودة إلى الرئيسية ثم
/// فتحه كما من بطاقته)، ثم أعاد الجولة بعد استقرار الشاشة وجهوزية بياناتها.
///
/// تُحقن الاعتماديات من main.dart كما في [AppTour]، فيبقى المشغّل قابلاً
/// للاختبار مستقلاً عن شاشات التطبيق وكنترولراتها.
class TourLauncher extends GetxController {
  TourLauncher({
    required Future<void> Function(AppSection section) openSection,
    required Future<void> Function() returnToHome,
    required bool Function() isTasmeeMode,
    required bool Function(AppTourPick tour) isSectionReady,
  }) : _openSection = openSection,
       _returnToHome = returnToHome,
       _isTasmeeMode = isTasmeeMode,
       _isSectionReady = isSectionReady;

  static TourLauncher get instance => Get.find<TourLauncher>();

  /// استقرار ورقة الإعدادات بعد إغلاقها قبل أي حركة أخرى، فلا تتزاحم
  /// حركة الورقة بحركة الشاشات.
  static const sheetSettle = Duration(milliseconds: 300);

  /// استقرار شاشة القسم بعد فتحها: انتقال GetX الافتراضي (300ms) وهامش.
  static const screenSettle = Duration(milliseconds: 450);

  /// خطوة وسقف انتظار جاهزية بيانات القسم (كما في انتظار جولة الرئيسية).
  static const readinessStep = Duration(milliseconds: 100);
  static const readinessLimit = Duration(seconds: 4);

  final Future<void> Function(AppSection section) _openSection;
  final Future<void> Function() _returnToHome;
  final bool Function() _isTasmeeMode;
  final bool Function(AppTourPick tour) _isSectionReady;

  /// يشغّل [tour]. [settingsSheet] ورقة الإعدادات التي اختيرت منها الجولة
  /// (كنترولر الشاشة الحاضنة) فتُغلق أولًا.
  Future<void> start(
    AppTourPick tour, {
    FlexibleSheetController? settingsSheet,
  }) async {
    settingsSheet?.close();
    await Future<void>.delayed(sheetSettle);
    final appTour = AppTour.instance;
    if (!tour.isOnScreen(_isTasmeeMode())) {
      // الشاشة ستُفتح الآن: لا تشغّل جولتها التلقائية فتزاحم الجولة المطلوبة.
      appTour.suppressAutoStart(tour.id);
      // الرئيسية مقصودة بذاتها: فتحها هو العودة إليها.
      if (tour.section != AppSection.home) await _returnToHome();
      await _openSection(tour.section);
      await Future<void>.delayed(screenSettle);
      await SchedulerBinding.instance.endOfFrame;
      if (!tour.isOnScreen(_isTasmeeMode())) return;
    }
    await _whenReady(tour);
    // غادر المستخدم القسم أثناء انتظار البيانات: لا تبدأ فوق شاشة أخرى.
    if (!tour.isOnScreen(_isTasmeeMode())) return;
    await tour.replay(appTour);
  }

  /// ينتظر جاهزية بيانات القسم حتى [readinessLimit]، ثم يكمل على كل حال
  /// فتفصل الجولة المحطات التي غاب هدفها كما تفعل مع الشاشة غير الجاهزة.
  Future<void> _whenReady(AppTourPick tour) async {
    var waited = Duration.zero;
    while (!_isSectionReady(tour) && waited < readinessLimit) {
      await Future<void>.delayed(readinessStep);
      waited += readinessStep;
    }
  }
}
