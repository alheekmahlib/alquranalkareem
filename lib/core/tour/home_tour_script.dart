import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

import 'books_tour_script.dart';
import 'mushaf_tour_script.dart';

/// محطات جولة الصفحة الرئيسية. ترتيب التعداد هو ترتيب الجولة (من الشريط
/// العلوي نزولاً إلى آخر قسم في الصفحة).
///
/// آية اليوم وذكر اليوم يجلبان من قاعدتي البيانات بعد فتح الصفحة، فتفصل
/// محطتاهما ([dailyAyah]، و[dailyZeker] و[azkar] معًا) حين لم يجلبا بعد
/// لحظة بدء الجولة ([homeTourStopsFor]) لا أن تُعرض بلا إضاءة.
enum HomeTourStop {
  intro,

  /// جرس الإشعارات في الشريط العلوي: يفتح ورقة التنبيهات.
  notifications,

  /// زر الإعدادات في الشريط العلوي (مفتاحه مفتاح جولة المصحف نفسه؛ زر
  /// واحد لا يحمل مفتاحين).
  settings,

  /// بطاقة التاريخ الهجري والميلادي وشريط تقدم الشهر.
  hijri,

  /// بطاقة مداد: البحث الذكي.
  midad,

  /// بطاقة معلم القرآن: وضع التسميع.
  tasmeeMode,

  /// بطاقة متابعة القراءة بشريط تقدم الختمة.
  lastRead,

  /// زر المصحف: يفتح القرآن على آخر صفحة قُرئت.
  quran,

  /// زر المصحف الصوتي.
  quranAudio,

  /// آية اليوم وتفسيرها (تحت بطاقة متابعة القراءة).
  dailyAyah,

  /// بطاقة ذكر اليوم.
  dailyZeker,

  /// زر الأذكار داخل بطاقة ذكر اليوم: يفتح شاشة الأذكار.
  azkar,

  /// زر المكتبة الإسلامية.
  islamicLibrary,

  /// شريط آخر قراءة في المكتبة (مفتاحه مفتاح جولة المكتبة نفسه).
  booksLastRead,
  closing,
}

/// محطات جولة الصفحة الرئيسية بحسب حالة الشاشة لحظة بدئها، بترتيب سيرها.
List<HomeTourStop> homeTourStopsFor({
  required bool hasDailyAyah,
  required bool hasDailyZeker,
}) => [
  for (final stop in HomeTourStop.values)
    if (_stopApplies(
      stop,
      hasDailyAyah: hasDailyAyah,
      hasDailyZeker: hasDailyZeker,
    ))
      stop,
];

bool _stopApplies(
  HomeTourStop stop, {
  required bool hasDailyAyah,
  required bool hasDailyZeker,
}) {
  if (stop == HomeTourStop.dailyAyah) return hasDailyAyah;
  // زر الأذكار داخل بطاقة ذكر اليوم: يغيب بغيابها.
  if (stop == HomeTourStop.dailyZeker || stop == HomeTourStop.azkar) {
    return hasDailyZeker;
  }
  return true;
}

/// مفاتيح ترجمة نصوص محطات جولة الصفحة الرئيسية في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة. وعنوان البطاقة
// الختامية نص عام تنتهي به كل جولة.
const Map<HomeTourStop, String> _featureNameTitleKeys = {
  HomeTourStop.midad: 'midad',
  HomeTourStop.tasmeeMode: 'tasmeeModeTeacher',
  HomeTourStop.lastRead: 'continueReading',
  HomeTourStop.quran: 'quran',
  HomeTourStop.quranAudio: 'quranAudio',
  HomeTourStop.dailyZeker: 'dailyZeker',
  HomeTourStop.azkar: 'azkar',
  HomeTourStop.islamicLibrary: 'islamicLibrary',
  HomeTourStop.closing: 'mushafTourClosingTitle',
};

String homeTourTitleKey(HomeTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String homeTourDescKey(HomeTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(HomeTourStop stop) {
  final name = stop.name;
  return 'homeTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف جولة الصفحة الرئيسية، فلا يصلح لها GlobalKey:
/// الشاشات تُدفع فوقها في المكدس، وبطاقة التاريخ تُركَّب أيضًا في شاشة
/// التقويم فيقتصر مفتاحها على نسختها في الصفحة الرئيسية. تُبرز الجولة
/// آخر نسخة ظاهرة من الهدف.
///
/// مواضع تركيبها: [notifications] على زر الجرس في tab_bar_widget.dart
/// (معامل يمرره موقع الاستدعاء؛ الودجت مشترك بين الشاشات)، و[hijri] على
/// بطاقة التاريخ في hijri_widget.dart (خارج شاشة التقويم)، و[midad] و
/// [tasmeeMode] على بطاقتي الذكاء الاصطناعي في ai_section.dart، و
/// [lastRead] على بطاقة متابعة القراءة و[quran] و[quranAudio] على زرّيها
/// في quran_section.dart، و[dailyAyah] على بطاقة آية اليوم في
/// ayah_tafsir_widget.dart، و[dailyZeker] و[azkar] على بطاقة ذكر اليوم
/// وزرها في daily_zeker.dart، و[islamicLibrary] على زر المكتبة في
/// books_section.dart. زر الإعدادات وشريط آخر قراءة في المكتبة يعيدان
/// استخدام مفتاحي جولتي المصحف والمكتبة (انظر [_plainKeys]).
abstract final class HomeTourKeys {
  static const notifications = ValueKey<String>('home_tour.notifications');
  static const hijri = ValueKey<String>('home_tour.hijri');
  static const midad = ValueKey<String>('home_tour.midad');
  static const tasmeeMode = ValueKey<String>('home_tour.tasmee_mode');
  static const lastRead = ValueKey<String>('home_tour.last_read');
  static const quran = ValueKey<String>('home_tour.quran');
  static const quranAudio = ValueKey<String>('home_tour.quran_audio');
  static const dailyAyah = ValueKey<String>('home_tour.daily_ayah');
  static const dailyZeker = ValueKey<String>('home_tour.daily_zeker');
  static const azkar = ValueKey<String>('home_tour.azkar');
  static const islamicLibrary = ValueKey<String>('home_tour.islamic_library');
}

const Map<HomeTourStop, Key> _plainKeys = {
  HomeTourStop.notifications: HomeTourKeys.notifications,
  // الزر مشترك مع بقية الشاشات وقد حمل مفتاح جولة المصحف أصلًا؛ ودجت واحد
  // لا يحمل مفتاحين، فتُبرزه هذه الجولة بمفتاحه القائم.
  HomeTourStop.settings: MushafTourKeys.settings,
  HomeTourStop.hijri: HomeTourKeys.hijri,
  HomeTourStop.midad: HomeTourKeys.midad,
  HomeTourStop.tasmeeMode: HomeTourKeys.tasmeeMode,
  HomeTourStop.lastRead: HomeTourKeys.lastRead,
  HomeTourStop.quran: HomeTourKeys.quran,
  HomeTourStop.quranAudio: HomeTourKeys.quranAudio,
  HomeTourStop.dailyAyah: HomeTourKeys.dailyAyah,
  HomeTourStop.dailyZeker: HomeTourKeys.dailyZeker,
  HomeTourStop.azkar: HomeTourKeys.azkar,
  HomeTourStop.islamicLibrary: HomeTourKeys.islamicLibrary,
  // الشريط مركَّب في شاشة المكتبة أيضًا وقد حمل مفتاح جولتها أصلًا.
  HomeTourStop.booksLastRead: BooksTourKeys.lastRead,
};

const Map<HomeTourStop, IconData> _icons = {
  HomeTourStop.intro: Icons.home_outlined,
  HomeTourStop.notifications: Icons.notifications_outlined,
  HomeTourStop.settings: Icons.settings,
  HomeTourStop.hijri: Icons.calendar_month,
  HomeTourStop.midad: Icons.auto_awesome,
  HomeTourStop.tasmeeMode: Icons.mic,
  HomeTourStop.lastRead: Icons.menu_book,
  HomeTourStop.quran: Icons.book,
  HomeTourStop.quranAudio: Icons.volume_up,
  HomeTourStop.dailyAyah: Icons.format_quote,
  HomeTourStop.dailyZeker: Icons.favorite_border,
  HomeTourStop.azkar: Icons.volunteer_activism,
  HomeTourStop.islamicLibrary: Icons.local_library,
  HomeTourStop.booksLastRead: Icons.history,
  HomeTourStop.closing: Icons.task_alt,
};

/// ما تنفّذه خدمة الجولة (AppTour) لجولة الصفحة الرئيسية بحلول تُحقن من
/// main.dart، فلا يستورد هذا الملف شاشات التطبيق وتبقى قابلة للاختبار:
/// حضور المحتوى اليومي، وتمرير قائمة الصفحة.
abstract interface class HomeTourHooks {
  /// هل جلبت آية اليوم (تبقى null حتى يكتمل جلبها)؟ يفصل محطتها.
  bool get hasHomeDailyAyah;

  /// هل جلب ذكر اليوم؟ يفصل محطتي بطاقته وزرها.
  bool get hasHomeDailyZeker;

  /// موضع تمرير قائمة الصفحة الرئيسية (0 إن لم تُركَّب القائمة بعد).
  double get homeScrollOffset;

  /// أقصى موضع تمرير تتيحه القائمة (0 إن لم تُركَّب بعد).
  double get homeScrollMax;

  /// يمرر قائمة الصفحة الرئيسية إلى موضع [offset].
  void scrollHomeTo(double offset);
}

/// إزاحة تمرير تُنزل قسم القرآن وأهدافه إلى أسفل الشريط العلوي خلال
/// محطاته، لا خلفه: قمة بطاقة متابعة القراءة تقع عند ~246pt حين تكون
/// القائمة ساكنة على أعلاها (قياس iPhone 18 Pro)، والشريط العلوي
/// يغطي ~70pt، فالإزاحة 155 تُنزل قمة البطاقة إلى ~91pt. عام ليقرأه
/// الاختبار بدل تكرار الرقم.
const double homeTourMidZoneOffset = 155;

/// سيناريو جولة الصفحة الرئيسية: محطاتها بحسب حالة الشاشة لحظة بدئها،
/// والتجهيز مركزي في [onStepChanged] (يُربط بـ
/// `SpotlightTourController.onStepChanged`): تمرير القائمة لكل محطة إلى
/// منطقتها (أعلاها لمحطات الشريط والبطاقات الأولى، وإزاحة متوسطة لمحطات
/// قسم القرآن، وأقصاها لمحطات أسفل الصفحة) لأن أهدافها قد تقع أسفل
/// الطية، ويعاد موضع المستخدم حالما تغادر الجولة نطاقه أو تنتهي.
class HomeTourScript {
  HomeTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required bool hasDailyAyah,
    required bool hasDailyZeker,
  }) : stops = homeTourStopsFor(
         hasDailyAyah: hasDailyAyah,
         hasDailyZeker: hasDailyZeker,
       );

  final SpotlightTourController tour;
  final HomeTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب الحالة التي بدئت فيها، بترتيب سيرها.
  final List<HomeTourStop> stops;

  /// موضع القائمة الذي تركه المستخدم حين مرّرتها الجولة (null: لم تمررها
  /// بعد).
  double? _userOffset;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(HomeTourStop stop) => TourStep(
    targetKey: switch (stop) {
      HomeTourStop.intro || HomeTourStop.closing => null,
      _ => _plainKeys[stop],
    },
    title: homeTourTitleKey(stop).tr,
    description: homeTourDescKey(stop).tr,
    icon: _icons[stop],
    style: style,
  );

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _syncScroll(_zoneOf(stop));
  }

  /// انتهت الجولة (إتمامًا أو تخطيًا أو مغادرة الشاشة): يعاد موضع القائمة
  /// إلى المستخدم.
  void onTourEnd() => _syncScroll(null);

  /// إزاحة منطقة المحطة: أعلى القائمة لمحطات الشريط والبطاقات الأولى،
  /// وإزاحة متوسطة لمحطات قسم القرآن، وأقصاها لمحطات أسفل الصفحة، وnull
  /// للبطاقتين الحرتين (لا تحتاجان موقعًا).
  double? _zoneOf(HomeTourStop stop) {
    switch (stop) {
      case HomeTourStop.intro:
      case HomeTourStop.closing:
        return null;
      case HomeTourStop.notifications:
      case HomeTourStop.settings:
      case HomeTourStop.hijri:
      case HomeTourStop.midad:
      case HomeTourStop.tasmeeMode:
        return 0;
      case HomeTourStop.lastRead:
      case HomeTourStop.quran:
      case HomeTourStop.quranAudio:
      case HomeTourStop.dailyAyah:
        return homeTourMidZoneOffset;
      case HomeTourStop.dailyZeker:
      case HomeTourStop.azkar:
      case HomeTourStop.islamicLibrary:
      case HomeTourStop.booksLastRead:
        return hooks.homeScrollMax;
    }
  }

  /// يمرر القائمة إلى [target] (null: يعاد موضع المستخدم) محتفظًا بموضعه
  /// قبل أول تمرير للجولة.
  void _syncScroll(double? target) {
    if (target == null) {
      final user = _userOffset;
      if (user == null) return;
      _userOffset = null;
      if (hooks.homeScrollOffset != user) hooks.scrollHomeTo(user);
      return;
    }
    _userOffset ??= hooks.homeScrollOffset;
    final clamped = target.clamp(0.0, hooks.homeScrollMax);
    if (hooks.homeScrollOffset != clamped) hooks.scrollHomeTo(clamped);
  }

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  HomeTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}
