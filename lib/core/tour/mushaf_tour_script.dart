import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

import 'tour_controls.dart';

/// محطات جولة المصحف. ترتيب التعداد هو ترتيب الجولة.
enum MushafTourStop {
  intro,
  pageFlip,
  controlsBar,
  displayModes,
  alwaqf,
  search,
  settings,
  surahIndex,
  audioBar,
  bookmarks,
  pageBookmark,
  ayahLongPress,

  /// ما يلي يُبرز عنصراً داخل ورقة خيارات الآية، متتالية مباشرة بعد
  /// [ayahLongPress].
  ayahText,
  playWord,
  playAyahWords,
  searchWord,
  wordInfo,
  tafsir,
  playAyah,
  playSurah,
  addAyahBookmark,
  copy,
  share,
  mutashabihat,
  closing,
}

/// المحطات التي تحتاج ظهور أشرطة التحكم لتكون أهدافها مركّبة.
const Set<MushafTourStop> _controlsStops = {
  MushafTourStop.controlsBar,
  MushafTourStop.displayModes,
  MushafTourStop.alwaqf,
  MushafTourStop.search,
  MushafTourStop.settings,
  MushafTourStop.surahIndex,
  MushafTourStop.audioBar,
  MushafTourStop.bookmarks,
};

/// محطات ورقة خيارات الآية: متتالية، ولا يليها إلا ما ليس منها.
const Set<MushafTourStop> _ayahMenuStops = {
  MushafTourStop.ayahText,
  MushafTourStop.playWord,
  MushafTourStop.playAyahWords,
  MushafTourStop.searchWord,
  MushafTourStop.wordInfo,
  MushafTourStop.tafsir,
  MushafTourStop.playAyah,
  MushafTourStop.playSurah,
  MushafTourStop.addAyahBookmark,
  MushafTourStop.copy,
  MushafTourStop.share,
  MushafTourStop.mutashabihat,
};

/// ما تحتاجه المحطة من أشرطة التحكم.
enum MushafTourControls {
  /// كما تركها المستخدم.
  any,

  /// ظاهرة: أهدافها أزرار فيها.
  visible,

  /// مخفية: هدفها يقع تحتها.
  hidden,
}

MushafTourControls mushafTourControlsFor(MushafTourStop stop) => switch (stop) {
  MushafTourStop.pageBookmark => MushafTourControls.hidden,
  _ when _controlsStops.contains(stop) => MushafTourControls.visible,
  _ => MushafTourControls.any,
};

bool mushafTourIsInAyahMenu(MushafTourStop stop) =>
    _ayahMenuStops.contains(stop);

/// مفاتيح ترجمة نصوص المحطة في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة.
const Map<MushafTourStop, String> _featureNameTitleKeys = {
  MushafTourStop.alwaqf: 'stopSigns',
  MushafTourStop.settings: 'setting',
  MushafTourStop.copy: 'copy',
  MushafTourStop.mutashabihat: 'mutashabihat',
};

String mushafTourTitleKey(MushafTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String mushafTourDescKey(MushafTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(MushafTourStop stop) {
  final name = stop.name;
  return 'mushafTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف المحطات التي يُركَّب هدفها أكثر من مرة في آنٍ واحد،
/// فلا يصلح لها GlobalKey:
///
/// * محتوى ورقة خيارات الآية: family_bottom_sheet تركّب صفحتها مرتين (نسخة
///   قياس مخفية ونسخة ظاهرة).
/// * علامة الصفحة: تُبنى لكل صفحة من الصفحات المجاورة في العرض.
/// * مقبض علامات الوقف وأزرار الشريطين: لها نسخ في المسارات الأسفل.
///
/// تُبرز الجولة آخر نسخة ظاهرة من الهدف.
abstract final class MushafTourKeys {
  static const displayModes = ValueKey<String>('mushaf_tour.display_modes');
  static const alwaqf = ValueKey<String>('mushaf_tour.alwaqf');
  static const search = ValueKey<String>('mushaf_tour.search');
  static const settings = ValueKey<String>('mushaf_tour.settings');
  static const surahIndex = ValueKey<String>('mushaf_tour.surah_index');
  static const audioBar = ValueKey<String>('mushaf_tour.audio_bar');
  static const bookmarks = ValueKey<String>('mushaf_tour.bookmarks');
  static const pageBookmark = ValueKey<String>('mushaf_tour.page_bookmark');
  static const ayahText = ValueKey<String>('mushaf_tour.ayah_text');
  static const playWord = ValueKey<String>('mushaf_tour.play_word');
  static const playAyahWords = ValueKey<String>('mushaf_tour.play_ayah_words');
  static const searchWord = ValueKey<String>('mushaf_tour.search_word');
  static const wordInfo = ValueKey<String>('mushaf_tour.word_info');
  static const tafsir = ValueKey<String>('mushaf_tour.tafsir');
  static const playAyah = ValueKey<String>('mushaf_tour.play_ayah');
  static const playSurah = ValueKey<String>('mushaf_tour.play_surah');
  static const addAyahBookmark = ValueKey<String>(
    'mushaf_tour.add_ayah_bookmark',
  );
  static const copy = ValueKey<String>('mushaf_tour.copy');
  static const share = ValueKey<String>('mushaf_tour.share');
  static const mutashabihat = ValueKey<String>('mushaf_tour.mutashabihat');
}

const Map<MushafTourStop, Key> _plainKeys = {
  MushafTourStop.displayModes: MushafTourKeys.displayModes,
  MushafTourStop.alwaqf: MushafTourKeys.alwaqf,
  MushafTourStop.search: MushafTourKeys.search,
  MushafTourStop.settings: MushafTourKeys.settings,
  MushafTourStop.surahIndex: MushafTourKeys.surahIndex,
  MushafTourStop.audioBar: MushafTourKeys.audioBar,
  MushafTourStop.bookmarks: MushafTourKeys.bookmarks,
  MushafTourStop.pageBookmark: MushafTourKeys.pageBookmark,
  MushafTourStop.ayahText: MushafTourKeys.ayahText,
  MushafTourStop.playWord: MushafTourKeys.playWord,
  MushafTourStop.playAyahWords: MushafTourKeys.playAyahWords,
  MushafTourStop.searchWord: MushafTourKeys.searchWord,
  MushafTourStop.wordInfo: MushafTourKeys.wordInfo,
  MushafTourStop.tafsir: MushafTourKeys.tafsir,
  MushafTourStop.playAyah: MushafTourKeys.playAyah,
  MushafTourStop.playSurah: MushafTourKeys.playSurah,
  MushafTourStop.addAyahBookmark: MushafTourKeys.addAyahBookmark,
  MushafTourStop.copy: MushafTourKeys.copy,
  MushafTourStop.share: MushafTourKeys.share,
  MushafTourStop.mutashabihat: MushafTourKeys.mutashabihat,
};

const Map<MushafTourStop, IconData> _icons = {
  MushafTourStop.intro: Icons.menu_book_outlined,
  MushafTourStop.pageFlip: Icons.swipe_outlined,
  MushafTourStop.controlsBar: Icons.tune_outlined,
  MushafTourStop.displayModes: Icons.view_carousel_outlined,
  MushafTourStop.alwaqf: Icons.bookmarks_outlined,
  MushafTourStop.search: Icons.search,
  MushafTourStop.settings: Icons.settings_outlined,
  MushafTourStop.surahIndex: Icons.list_outlined,
  MushafTourStop.audioBar: Icons.headphones_outlined,
  MushafTourStop.bookmarks: Icons.bookmark_border,
  MushafTourStop.pageBookmark: Icons.bookmark_added_outlined,
  MushafTourStop.ayahLongPress: Icons.touch_app_outlined,
  MushafTourStop.ayahText: Icons.short_text,
  MushafTourStop.playWord: Icons.record_voice_over_outlined,
  MushafTourStop.playAyahWords: Icons.queue_music_outlined,
  MushafTourStop.searchWord: Icons.find_in_page_outlined,
  MushafTourStop.wordInfo: Icons.info_outline,
  MushafTourStop.tafsir: Icons.menu_book_outlined,
  MushafTourStop.playAyah: Icons.play_circle_outline,
  MushafTourStop.playSurah: Icons.playlist_play_outlined,
  MushafTourStop.addAyahBookmark: Icons.bookmark_add_outlined,
  MushafTourStop.copy: Icons.copy_outlined,
  MushafTourStop.share: Icons.share_outlined,
  MushafTourStop.mutashabihat: Icons.compare_arrows,
  MushafTourStop.closing: Icons.task_alt,
};

/// ما ينفّذه السيناريو في التطبيق. تنفّذه خدمة الجولة (AppTour) بحلول
/// تُحقن من main.dart، فيبقى السيناريو خالياً من وحدات التحكم وقابلاً
/// للاختبار.
abstract interface class MushafTourHooks implements TourControlsHooks {
  /// يحفظ موضع القراءة قبل عرض قلب الصفحة.
  Future<void> captureReadingPage();

  /// يستعيد موضع القراءة بعد مغادرة عرض قلب الصفحة.
  Future<void> restoreReadingPage();

  /// هل ورقة خيارات الآية مفتوحة؟
  bool get isAyahMenuOpen;

  /// يفتح ورقة خيارات الآية (آخر آية فُتحت، وإلا أول آية في الصفحة).
  /// لا يُنتظر وعد الإغلاق.
  void openAyahMenu();

  /// يغلق ورقة خيارات الآية.
  void closeAyahMenu();
}

/// سيناريو جولة المصحف: خطواتها، وما يجهّزه التطبيق لكل خطوة.
///
/// التجهيز مركزي في [onStepChanged] (يُربط بـ
/// `SpotlightTourController.onStepChanged`) بدل [TourStep.onEnter] و
/// [TourStep.onExit] لكل خطوة، لأن ما تحتاجه الخطوة من التطبيق يعتمد على
/// الخطوة الجديدة وحدها:
///
/// * محطة شريط: تظهر أشرطة التحكم إن كانت مخفية، وتبقى ظاهرة ما دامت
///   الجولة في محطات الأشرطة (بلا وميض بينها).
/// * محطة علامة الصفحة: تُخفى الأشرطة إن كانت ظاهرة، فالعلامة تقع تحت
///   الشريط العلوي حين تظهر.
/// * في كل ذلك تحفظ الجولة حالة المستخدم وتعيدها إليه عند وصولها إلى محطة
///   لا تتطلب من الأشرطة شيئاً أو عند انتهائها.
/// * محطة داخل ورقة خيارات الآية: الورقة مفتوحة؛ وغير ذلك: مغلقة.
class MushafTourScript {
  MushafTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required this.swipeDemo,
    required this.pageKey,
    required this.controlsBarKey,
  });

  final SpotlightTourController tour;
  final MushafTourHooks hooks;
  final TourStepStyle style;
  final PageSwipeDemo swipeDemo;

  /// مفتاح منطقة الصفحة كاملة: هدف قلب الصفحة والضغطة المطوّلة.
  final Key pageKey;

  /// مفتاح الشريط العلوي.
  final Key controlsBarKey;

  late final List<TourStep> steps = [
    for (final stop in MushafTourStop.values) _build(stop),
  ];

  /// الجولة تنتظر ضغطة مطوّلة من المستخدم (خطوة [MushafTourStop.ayahLongPress]).
  bool _awaitingAyahLongPress = false;

  /// يتولى أشرطة التحكم ويعيد إليه حالما تصل الجولة إلى محطة لا تتطلب من
  /// الأشرطة شيئاً أو عند انتهائها.
  late final TourControlsSync _controls = TourControlsSync(hooks);

  TourStep _build(MushafTourStop stop) {
    final isPageFlip = stop == MushafTourStop.pageFlip;
    final isLongPress = stop == MushafTourStop.ayahLongPress;
    return TourStep(
      targetKey: switch (stop) {
        MushafTourStop.intro || MushafTourStop.closing => null,
        MushafTourStop.pageFlip || MushafTourStop.ayahLongPress => pageKey,
        MushafTourStop.controlsBar => controlsBarKey,
        _ => _plainKeys[stop],
      },
      title: mushafTourTitleKey(stop).tr,
      description: mushafTourDescKey(stop).tr,
      icon: _icons[stop],
      style: style,
      indicator: isPageFlip
          ? TourIndicator.swipeLeftToRight
          : TourIndicator.pulse,
      // الجولة تشغّل العرض وتلغيه بنفسها: تنتظر ثانية بعد ظهور الخطوة
      // (settleDuration) ثم تقلب الصفحة كاملة وتعيدها، والمؤشر يتحرك
      // معها. مغادرة الخطوة بأي طريقة تلغي العرض وتعيد الصفحة فوراً.
      swipeDemo: isPageFlip ? swipeDemo : null,
      // العرض يقلب الصفحة فعلياً فيتحرك معه رقم الصفحة الحالية و«آخر
      // صفحة» المحفوظة مؤقتاً. عند الإكمال الطبيعي تصحّحهما قلبة العودة
      // تلقائياً، وهذان الخطافان حارسان لما عدا ذلك: يحفظ الأول موضع
      // المستخدم قبل العرض، ويستعيده الثاني إن غادر المستخدم الخطوة أو
      // الشاشة أثناءها فلا يبقى موضع قراءته على صفحة العرض.
      onEnter: switch (stop) {
        MushafTourStop.pageFlip => _captureReadingPage,
        MushafTourStop.ayahLongPress => _awaitAyahLongPress,
        _ => null,
      },
      onExit: switch (stop) {
        MushafTourStop.pageFlip => _restoreReadingPage,
        MushafTourStop.ayahLongPress => _forgetAyahLongPress,
        _ => null,
      },
      // الضغطة المطوّلة الحقيقية تمر عبر الستارة إلى الصفحة.
      interaction: isLongPress
          ? TourTargetInteraction.longPress
          : TourTargetInteraction.none,
      requireInteraction: isLongPress,
      interactionHint: isLongPress ? 'mushafTourAyahLongPressHint'.tr : null,
    );
  }

  Future<void> _captureReadingPage() => hooks.captureReadingPage();

  Future<void> _restoreReadingPage() => hooks.restoreReadingPage();

  void _awaitAyahLongPress() => _awaitingAyahLongPress = true;

  void _forgetAyahLongPress() => _awaitingAyahLongPress = false;

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _syncControls(stop);
    _syncAyahMenu(stop);
  }

  /// ورقة خيارات الآية فُتحت (بضغطة مطوّلة حقيقية أو بغيرها). إن كانت
  /// الجولة تنتظر الضغطة انتقلت إلى شرح الورقة.
  void onAyahMenuOpened() {
    if (!_awaitingAyahLongPress) return;
    if (tour.isBusy) {
      // أثناء انتقال الخطوات يُتجاهل next: يُعاد الطلب بعد الإطار.
      _nextFrame(onAyahMenuOpened);
      return;
    }
    _awaitingAyahLongPress = false;
    tour.next();
  }

  /// أُغلقت ورقة خيارات الآية. إن كانت الجولة تشرح داخلها فالمستخدم هو من
  /// أغلقها بغير الجولة (زر الرجوع): تعود الجولة إلى خطوة الضغط المطوّل
  /// ليعيد فتحها، ولا تبقى خطواتها بلا هدف.
  void onAyahMenuClosed() {
    if (tour.status != TourStatus.running) return;
    final stop = _stopAt(tour.index);
    if (stop == null || !mushafTourIsInAyahMenu(stop)) return;
    if (tour.isBusy) {
      _nextFrame(onAyahMenuClosed);
      return;
    }
    tour.start(initialIndex: MushafTourStop.ayahLongPress.index);
  }

  /// انتهت الجولة (إتماماً أو تخطياً أو مغادرة الشاشة): لا يبقى منها شيء.
  void onTourEnd() {
    _awaitingAyahLongPress = false;
    _controls.restore();
    if (hooks.isAyahMenuOpen) hooks.closeAyahMenu();
  }

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  MushafTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= MushafTourStop.values.length) return null;
    return MushafTourStop.values[index];
  }

  void _syncControls(MushafTourStop stop) {
    _controls.sync(
      visible: switch (mushafTourControlsFor(stop)) {
        MushafTourControls.any => null,
        MushafTourControls.visible => true,
        MushafTourControls.hidden => false,
      },
    );
  }

  void _syncAyahMenu(MushafTourStop stop) {
    if (mushafTourIsInAyahMenu(stop)) {
      if (!hooks.isAyahMenuOpen) hooks.openAyahMenu();
    } else if (hooks.isAyahMenuOpen) {
      hooks.closeAyahMenu();
    }
  }

  static void _nextFrame(void Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }
}
