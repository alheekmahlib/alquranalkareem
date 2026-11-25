import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// محطات جولة المصحف الصوتي. ترتيب التعداد هو ترتيب الجولة.
///
/// الجولة تسير في شاشة القائمة من أعلى إلى أسفل، ثم توسّع لوحة التشغيل
/// لتشرح كل زر فيها خطوةً خطوة، ثم تدخل شاشة المشغّل الكامل وتعود منها
/// بانتهائها.
enum AudioTourStop {
  intro,
  search,
  lastListen,
  fullScreenButton,
  surahList,
  download,

  /// الشريط المطبوع أسفل الشاشة: يُشترط أن تكون اللوحة مطوية.
  collapsedPlayer,

  /// لوحة التشغيل الموسّعة: تُشترط أن تكون مفتوحة، وكل زر فيها خطوة.
  reciterPicker,
  seekBar,
  backward,
  previousSurah,
  playPause,
  nextSurah,
  forward,
  repeat,

  /// شاشة المشغّل الكامل: تدخلها الجولة ولا تغادرها إلا بانتهائها.
  ayahTracker,
  readerRow,
  closeButton,
  closing,
}

/// هل تقع المحطة في لوحة التشغيل الموسّعة؟
bool audioTourNeedsExpandedPlayer(AudioTourStop stop) => switch (stop) {
  AudioTourStop.reciterPicker ||
  AudioTourStop.seekBar ||
  AudioTourStop.backward ||
  AudioTourStop.previousSurah ||
  AudioTourStop.playPause ||
  AudioTourStop.nextSurah ||
  AudioTourStop.forward ||
  AudioTourStop.repeat => true,
  _ => false,
};

/// هل تُعرض المحطة في شاشة المشغّل الكامل؟ البطاقة الختامية تعرض فيها ثم
/// تُغلق الجولة الشاشة وتعيد المستخدم حيث بدأ.
bool audioTourIsOnFullScreen(AudioTourStop stop) => switch (stop) {
  AudioTourStop.ayahTracker ||
  AudioTourStop.readerRow ||
  AudioTourStop.closeButton ||
  AudioTourStop.closing => true,
  _ => false,
};

/// مفاتيح ترجمة نصوص المحطة في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة. وعنوان البطاقة
// الختامية نص عام تنتهي به كل جولة.
const Map<AudioTourStop, String> _featureNameTitleKeys = {
  AudioTourStop.search: 'searchToSurah',
  AudioTourStop.lastListen: 'lastListen',
  AudioTourStop.surahList: 'surahsList',
  AudioTourStop.download: 'download',
  AudioTourStop.previousSurah: 'skipToPrevious',
  AudioTourStop.closing: 'mushafTourClosingTitle',
};

String audioTourTitleKey(AudioTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String audioTourDescKey(AudioTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(AudioTourStop stop) {
  final name = stop.name;
  return 'audioTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف المحطات، فلا يصلح لها GlobalKey: الشاشة الكاملة
/// تُركِّب لوحة التشغيل نفسها فوق نسخة الشاشة تحتها. تُبرز الجولة آخر نسخة
/// ظاهرة من الهدف، ولذلك هدف التنزيل زرُّ الصف الأول وحده: مفاتيح الصفوف
/// كلها تجعل الإضاءة تقع على آخر صف بناه ListView في cacheExtent تحت حافة
/// القائمة، خلف شريط التشغيل، فيظهر الهدف حيث لا يراه المستخدم.
///
/// مواضع تركيبها: [search] في audio_surah.dart، و[fullScreenButton]
/// و[surahList] و[download] و[LastListen] في back_drop_widget.dart،
/// و[collapsedPlayer] في audio_surah.dart، وأزرار اللوحة في play_widget.dart
/// وrepeat_widget.dart، وأهداف الشاشة الكاملة في audio_surah_with_ayahs.dart.
abstract final class AudioTourKeys {
  static const search = ValueKey<String>('audio_tour.search');
  static const lastListen = ValueKey<String>('audio_tour.last_listen');
  static const fullScreenButton = ValueKey<String>(
    'audio_tour.full_screen_button',
  );
  static const surahList = ValueKey<String>('audio_tour.surah_list');
  static const download = ValueKey<String>('audio_tour.download');
  static const collapsedPlayer = ValueKey<String>(
    'audio_tour.collapsed_player',
  );
  static const reciterPicker = ValueKey<String>('audio_tour.reciter_picker');
  static const seekBar = ValueKey<String>('audio_tour.seek_bar');
  static const backward = ValueKey<String>('audio_tour.backward');
  static const previousSurah = ValueKey<String>('audio_tour.previous_surah');
  static const playPause = ValueKey<String>('audio_tour.play_pause');
  static const nextSurah = ValueKey<String>('audio_tour.next_surah');
  static const forward = ValueKey<String>('audio_tour.forward');
  static const repeat = ValueKey<String>('audio_tour.repeat');
  static const ayahTracker = ValueKey<String>('audio_tour.ayah_tracker');
  static const readerRow = ValueKey<String>('audio_tour.reader_row');
  static const closeButton = ValueKey<String>('audio_tour.close_button');
}

const Map<AudioTourStop, Key> _plainKeys = {
  AudioTourStop.search: AudioTourKeys.search,
  AudioTourStop.lastListen: AudioTourKeys.lastListen,
  AudioTourStop.fullScreenButton: AudioTourKeys.fullScreenButton,
  AudioTourStop.surahList: AudioTourKeys.surahList,
  AudioTourStop.download: AudioTourKeys.download,
  AudioTourStop.collapsedPlayer: AudioTourKeys.collapsedPlayer,
  AudioTourStop.reciterPicker: AudioTourKeys.reciterPicker,
  AudioTourStop.seekBar: AudioTourKeys.seekBar,
  AudioTourStop.backward: AudioTourKeys.backward,
  AudioTourStop.previousSurah: AudioTourKeys.previousSurah,
  AudioTourStop.playPause: AudioTourKeys.playPause,
  AudioTourStop.nextSurah: AudioTourKeys.nextSurah,
  AudioTourStop.forward: AudioTourKeys.forward,
  AudioTourStop.repeat: AudioTourKeys.repeat,
  AudioTourStop.ayahTracker: AudioTourKeys.ayahTracker,
  AudioTourStop.readerRow: AudioTourKeys.readerRow,
  AudioTourStop.closeButton: AudioTourKeys.closeButton,
};

const Map<AudioTourStop, IconData> _icons = {
  AudioTourStop.intro: Icons.headset_outlined,
  AudioTourStop.search: Icons.search,
  AudioTourStop.lastListen: Icons.history,
  AudioTourStop.fullScreenButton: Icons.fullscreen,
  AudioTourStop.surahList: Icons.format_list_numbered,
  AudioTourStop.download: Icons.cloud_download_outlined,
  AudioTourStop.collapsedPlayer: Icons.play_circle_outline,
  AudioTourStop.reciterPicker: Icons.record_voice_over_outlined,
  AudioTourStop.seekBar: Icons.linear_scale,
  AudioTourStop.backward: Icons.fast_rewind,
  AudioTourStop.previousSurah: Icons.skip_previous,
  AudioTourStop.playPause: Icons.play_circle_fill,
  AudioTourStop.nextSurah: Icons.skip_next,
  AudioTourStop.forward: Icons.fast_forward,
  AudioTourStop.repeat: Icons.loop,
  AudioTourStop.ayahTracker: Icons.center_focus_strong,
  AudioTourStop.readerRow: Icons.person_outline,
  AudioTourStop.closeButton: Icons.fullscreen_exit,
  AudioTourStop.closing: Icons.task_alt,
};

/// ما تنفّذه خدمة الجولة (AppTour) لسيناريو المصحف الصوتي بحلول تُحقن من
/// main.dart، فلا يستورد هذا الملف شاشات التطبيق وتبقى قابلة للاختبار:
/// توسيط لوحة التشغيل السفلية، وتمرير قائمة السور، ودخول شاشة المشغّل
/// الكامل والخروج منها.
abstract interface class AudioTourHooks {
  /// هل لوحة التشغيل السفلية موسّعة؟
  bool get isPlayerExpanded;

  /// يوسّع اللوحة أو يطويها.
  void setPlayerExpanded(bool expanded);

  /// موضع تمرير قائمة السور (0 إن لم تُركَّب القائمة بعد).
  double get surahListOffset;

  /// يمرر قائمة السور إلى موضع [offset].
  void scrollSurahListTo(double offset);

  /// يدخل شاشة المشغّل الكامل إن لم تكن مفتوحة، ويُنتظر اكتمال انتقالها.
  Future<void> openFullScreen();

  /// يغلق الشاشة الكاملة إن كانت الجولة هي من فتحتها.
  void closeFullScreen();
}

/// يتولى الجولةُ لوحةَ التشغيل نيابةً عن المستخدم ثم يعيدها إليه، على نمط
/// TourControlsSync في شاشة المصحف: أول طلب يحفظ حالة المستخدم، وrestore
/// يعيدها.
class _PlayerPanelSync {
  _PlayerPanelSync(this.hooks);

  final AudioTourHooks hooks;

  /// حالة اللوحة التي تركها المستخدم حين تولّتها الجولة (null: لم
  /// تتولاها بعد).
  bool? _userExpanded;

  /// يضبط اللوحة لخطوة قادمة (null: كما تركها المستخدم).
  void sync({required bool? expanded}) {
    if (expanded == null) {
      restore();
      return;
    }
    _userExpanded ??= hooks.isPlayerExpanded;
    if (hooks.isPlayerExpanded != expanded) hooks.setPlayerExpanded(expanded);
  }

  /// يعيد اللوحة إلى حالة المستخدم إن كانت الجولة قد غيّرتها.
  void restore() {
    final user = _userExpanded;
    if (user == null) return;
    _userExpanded = null;
    if (hooks.isPlayerExpanded != user) hooks.setPlayerExpanded(user);
  }
}

/// سيناريو جولة المصحف الصوتي: كل أزرار القسم شرحُها خطوة، والتجهيز مركزي
/// في [onStepChanged] (يُربط بـ `SpotlightTourController.onStepChanged`):
/// محطات اللوحة الموسّعة تفتحها، ومحطة الشريط المطبوع تطويها، وتُعاد حالة
/// المستخدم حالما تغادر الجولة نطاق اللوحة أو تنتهي. ومحطات الشاشة
/// الكاملة تدخلها الجولة (وتنتظر انتقالها في onEnter محطة المتتبِّع) ثم
/// تخرج منها عند انتهاء الجولة فقط.
class AudioTourScript {
  AudioTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
  });

  final SpotlightTourController tour;
  final AudioTourHooks hooks;
  final TourStepStyle style;

  late final _PlayerPanelSync _panel = _PlayerPanelSync(hooks);

  /// موضع القائمة الذي تركه المستخدم حين مرّرتها الجولة (null: لم تمررها
  /// بعد). هدف التنزيل زرُّ الصف الأول، فتُثبَّت القائمة على أعلاها خلال
  /// محطتي القائمة والتنزيل ثم يعاد موضع المستخدم.
  double? _userListOffset;

  late final List<TourStep> steps = [
    for (final stop in AudioTourStop.values) _build(stop),
  ];

  TourStep _build(AudioTourStop stop) => TourStep(
    targetKey: switch (stop) {
      AudioTourStop.intro || AudioTourStop.closing => null,
      _ => _plainKeys[stop],
    },
    title: audioTourTitleKey(stop).tr,
    description: audioTourDescKey(stop).tr,
    icon: _icons[stop],
    style: style,
    onEnter: stop == AudioTourStop.ayahTracker ? _awaitFullScreen : null,
  );

  /// ينتظر دخول الشاشة الكاملة قبل أن تُعرض بطاقة المتتبِّع: بناء أهدافها
  /// يستغرق مدة انتقالها، والبطاقة تُعرض بعد اكتماله.
  Future<void> _awaitFullScreen() => hooks.openFullScreen();

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _panel.sync(expanded: _panelStateFor(stop));
    _syncListTop(
      top: stop == AudioTourStop.surahList || stop == AudioTourStop.download,
    );
    if (audioTourIsOnFullScreen(stop)) {
      hooks.openFullScreen();
    } else {
      hooks.closeFullScreen();
    }
  }

  /// انتهت الجولة (إتماماً أو تخطياً أو مغادرة الشاشة): تعاد لوحة التشغيل
  /// وموضع القائمة إلى المستخدم، وتُغلق الشاشة الكاملة إن كانت الجولة هي
  /// من فتحتها.
  void onTourEnd() {
    _panel.restore();
    _syncListTop(top: false);
    hooks.closeFullScreen();
  }

  /// يثبّت القائمة على أعلاها خلال محطتيها أو يعيد موضع المستخدم.
  void _syncListTop({required bool top}) {
    if (!top) {
      final user = _userListOffset;
      if (user == null) return;
      _userListOffset = null;
      if (hooks.surahListOffset != user) hooks.scrollSurahListTo(user);
      return;
    }
    _userListOffset ??= hooks.surahListOffset;
    if (hooks.surahListOffset != 0) hooks.scrollSurahListTo(0);
  }

  /// حالة اللوحة التي تحتاجها المحطة (null: كما تركها المستخدم).
  bool? _panelStateFor(AudioTourStop stop) {
    if (audioTourNeedsExpandedPlayer(stop)) return true;
    if (stop == AudioTourStop.collapsedPlayer) return false;
    return null;
  }

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  AudioTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= AudioTourStop.values.length) return null;
    return AudioTourStop.values[index];
  }
}
