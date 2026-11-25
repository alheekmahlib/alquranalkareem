import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

import 'mushaf_tour_script.dart' show MushafTourKeys;
import 'tour_controls.dart';

/// محطات جولة التسميع. ترتيب التعداد هو ترتيب الجولة.
///
/// محطتان يُركَّب هدف إحداهما في نمط دون الآخر، فتدخل الجولة بحسب النمط
/// الجاري ([tasmeeTourStopsFor]): الجولة لا تتجاوز خطوة غاب هدفها، بل تعرض
/// بطاقتها بلا إضاءة.
enum TasmeeTourStop {
  intro,
  modeButton,

  /// منتقي القارئ: في نمط معلم القرآن فقط.
  teacherReader,
  startRecording,
  status,

  /// زر العين: في نمط التسميع فقط، فالكلمات ظاهرة في المصحح والمعلم.
  showWords,
  retry,
  pagesList,
  settings,
  closing,
}

/// محطات الجولة في نمط التسميع [mode]، بترتيب سيرها.
List<TasmeeTourStop> tasmeeTourStopsFor(TasmeeMode mode) => [
  for (final stop in TasmeeTourStop.values)
    if (switch (stop) {
      TasmeeTourStop.teacherReader => mode == TasmeeMode.teacher,
      TasmeeTourStop.showWords => mode == TasmeeMode.tasmee,
      _ => true,
    })
      stop,
];

/// هل تحتاج المحطة ظهور أشرطة التحكم؟ كل أهداف الجولة أزرار في الشاشة لا
/// تُركَّب إلا حين تظهر الأشرطة، عدا بطاقتي الافتتاح والختام.
bool tasmeeTourNeedsControls(TasmeeTourStop stop) => switch (stop) {
  TasmeeTourStop.intro || TasmeeTourStop.closing => false,
  _ => true,
};

/// مفاتيح ترجمة نصوص المحطة في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة. وعنوان البطاقة
// الختامية نص عام تنتهي به كل جولة.
const Map<TasmeeTourStop, String> _featureNameTitleKeys = {
  TasmeeTourStop.modeButton: 'tasmeeModeTitle',
  TasmeeTourStop.startRecording: 'tasmeeStartRecording',
  TasmeeTourStop.retry: 'tasmeeRetry',
  TasmeeTourStop.pagesList: 'tasmeeResultsPages',
  TasmeeTourStop.settings: 'setting',
  TasmeeTourStop.closing: 'mushafTourClosingTitle',
};

String tasmeeTourTitleKey(TasmeeTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String tasmeeTourDescKey(TasmeeTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(TasmeeTourStop stop) {
  final name = stop.name;
  return 'tasmeeTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف المحطات: الشريط يُركَّب في مقبض ورقة سفلية قد يُبنى
/// أكثر من مرة، فلا يصلح لها GlobalKey. تُبرز الجولة آخر نسخة ظاهرة من الهدف.
///
/// مواضع تركيبها: [modeButton] و[teacherReader] في quran_home.dart، والبقية
/// في tasmee_bar_widget.dart. زر الإعدادات هدف مشترك مع جولة المصحف
/// (MushafTourKeys.settings).
abstract final class TasmeeTourKeys {
  static const modeButton = ValueKey<String>('tasmee_tour.mode_button');
  static const teacherReader = ValueKey<String>('tasmee_tour.teacher_reader');
  static const startRecording = ValueKey<String>('tasmee_tour.start_recording');
  static const status = ValueKey<String>('tasmee_tour.status');
  static const showWords = ValueKey<String>('tasmee_tour.show_words');
  static const retry = ValueKey<String>('tasmee_tour.retry');
  static const pagesList = ValueKey<String>('tasmee_tour.pages_list');
}

const Map<TasmeeTourStop, Key> _plainKeys = {
  TasmeeTourStop.modeButton: TasmeeTourKeys.modeButton,
  TasmeeTourStop.teacherReader: TasmeeTourKeys.teacherReader,
  TasmeeTourStop.startRecording: TasmeeTourKeys.startRecording,
  TasmeeTourStop.status: TasmeeTourKeys.status,
  TasmeeTourStop.showWords: TasmeeTourKeys.showWords,
  TasmeeTourStop.retry: TasmeeTourKeys.retry,
  TasmeeTourStop.pagesList: TasmeeTourKeys.pagesList,
};

const Map<TasmeeTourStop, IconData> _icons = {
  TasmeeTourStop.intro: Icons.record_voice_over_outlined,
  TasmeeTourStop.modeButton: Icons.tune_outlined,
  TasmeeTourStop.teacherReader: Icons.record_voice_over_outlined,
  TasmeeTourStop.startRecording: Icons.mic_none,
  TasmeeTourStop.status: Icons.info_outline,
  TasmeeTourStop.showWords: Icons.visibility_outlined,
  TasmeeTourStop.retry: Icons.loop,
  TasmeeTourStop.pagesList: Icons.playlist_add_check_outlined,
  TasmeeTourStop.settings: Icons.settings_outlined,
  TasmeeTourStop.closing: Icons.task_alt,
};

/// سيناريو جولة التسميع: خطواتها بحسب النمط الجاري، وما يجهّزه التطبيق لكل
/// خطوة.
///
/// لا خطوة تنتظر تفاعلاً ولا تفتح ورقة: ورقة النتيجة تحتاج جلسة تسميع
/// حقيقية، وبطاقات ورقة النمط تشرح نفسها. التجهيز مركزي في [onStepChanged]
/// (يُربط بـ `SpotlightTourController.onStepChanged`) كما في سيناريو المصحف:
/// كل محطة عدا البطاقتين تُظهر أشرطة التحكم إن كانت مخفية وتُطوي الأوراق
/// المفتوحة، وتعاد حالة المستخدم حالما تصل الجولة إلى بطاقة أو تنتهي.
class TasmeeTourScript {
  TasmeeTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required TasmeeMode mode,
  }) : stops = tasmeeTourStopsFor(mode);

  final SpotlightTourController tour;
  final TourControlsHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب النمط الذي بدئت فيه، بترتيب سيرها.
  final List<TasmeeTourStop> stops;

  late final TourControlsSync _controls = TourControlsSync(hooks);

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(TasmeeTourStop stop) => TourStep(
    targetKey: switch (stop) {
      TasmeeTourStop.intro || TasmeeTourStop.closing => null,
      TasmeeTourStop.settings => MushafTourKeys.settings,
      _ => _plainKeys[stop],
    },
    title: tasmeeTourTitleKey(stop).tr,
    description: tasmeeTourDescKey(stop).tr,
    icon: _icons[stop],
    style: style,
  );

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _controls.sync(visible: tasmeeTourNeedsControls(stop) ? true : null);
  }

  /// انتهت الجولة (إتماماً أو تخطياً أو مغادرة الشاشة): تعود الأشرطة إلى
  /// المستخدم.
  void onTourEnd() => _controls.restore();

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  TasmeeTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}
