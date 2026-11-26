import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// محطات جولة مداد الكاملة. ترتيب التعداد هو ترتيب الجولة.
///
/// تسير الجولة في وضع البحث الدلالي من أعلى الشاشة (شريط التطبيق) إلى شريط
/// الإدخال، ثم تنتقل إلى وضع المساعد الذكي وتختم فيه، ثم تعيد المستخدم إلى
/// وضعه الذي بدأ عليه. ومحطات قد غاب هدفها بحسب حالة الشاشة لحظة البدء
/// تُحذف من الجولة ([midadTourStopsFor]) لا أن تُعرض بلا إضاءة.
enum MidadTourStop {
  intro,
  modeToggle,
  newChat,
  history,
  floatingMenu,

  /// اقتراحات البداية في وضع البحث الدلالي: تدخل الجولة إن كانت حالة
  /// الفراغ ظاهرة حين بدأت (لا نتائج معروضة ولا بحث جارٍ).
  suggestionChips,
  inputField,
  sendButton,
  sectionFilter,

  /// وضع المساعد الذكي: لا تدخل الجولة محطاته إلا باتصال بالإنترنت.
  assistantChips,

  /// منتقي النموذج: لا يدخل الجولة إلا باتصال وبمزودين مُعدّين في البناء.
  modelSelector,
  closing,
}

/// هل تُعرض المحطة في وضع المساعد الذكي؟ البطاقة الختامية ليست منه: تُعرض
/// في الوضع الذي انتهت عنده الجولة ثم يعيد onTourEnd وضع المستخدم.
bool midadTourIsOnAssistant(MidadTourStop stop) => switch (stop) {
  MidadTourStop.assistantChips || MidadTourStop.modelSelector => true,
  _ => false,
};

/// محطات الجولة الكاملة بحسب حالة الشاشة لحظة بدئها، بترتيب سيرها.
List<MidadTourStop> midadTourStopsFor({
  required bool online,
  required bool hasProviders,
  required bool semanticEmpty,
  required bool assistantFresh,
}) => [
  for (final stop in MidadTourStop.values)
    if (switch (stop) {
      MidadTourStop.suggestionChips => semanticEmpty,
      MidadTourStop.assistantChips => online && assistantFresh,
      MidadTourStop.modelSelector => online && hasProviders,
      _ => true,
    })
      stop,
];

/// مفاتيح ترجمة نصوص محطة الجولة الكاملة في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة. وعنوان البطاقة
// الختامية نص عام تنتهي به كل جولة.
const Map<MidadTourStop, String> _featureNameTitleKeys = {
  MidadTourStop.newChat: 'newChat',
  MidadTourStop.history: 'chatHistory',
  MidadTourStop.inputField: 'askMidad',
  MidadTourStop.sectionFilter: 'sections',
  MidadTourStop.assistantChips: 'assistantMode',
  MidadTourStop.modelSelector: 'selectModel',
  MidadTourStop.closing: 'mushafTourClosingTitle',
};

String midadTourTitleKey(MidadTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String midadTourDescKey(MidadTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(MidadTourStop stop) {
  final name = stop.name;
  return 'midadTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف المحطتين (الكاملة والتحميل)، فلا يصلح لها GlobalKey:
/// شاشة مداد تدخل فوق شاشات أخر في المكدس، والمساعد المضمَّن في شاشات أخرى
/// يركّب بعض الأهداف نفسها. تُبرز الجولة آخر نسخة ظاهرة من الهدف.
///
/// مواضع تركيبها: [modeToggle] و[newChat] و[history] في أزرار شريط التطبيق
/// في ai_search_results.dart، و[floatingMenu] على مقبض القائمة العائمة في
/// floating_menu_widget.dart، و[suggestionChips] و[sharedCard] و[sectionCard]
/// في حالة التحميل بحسب الوضع في ai_search_results.dart، و[inputField]
/// و[sendButton] و[sectionFilter] و[modelSelector] في input_bar_widget.dart،
/// و[assistantChips] في unified_assistant_view.dart.
abstract final class MidadTourKeys {
  static const modeToggle = ValueKey<String>('midad_tour.mode_toggle');
  static const newChat = ValueKey<String>('midad_tour.new_chat');
  static const history = ValueKey<String>('midad_tour.history');
  static const floatingMenu = ValueKey<String>('midad_tour.floating_menu');
  static const suggestionChips = ValueKey<String>(
    'midad_tour.suggestion_chips',
  );
  static const inputField = ValueKey<String>('midad_tour.input_field');
  static const sendButton = ValueKey<String>('midad_tour.send_button');
  static const sectionFilter = ValueKey<String>('midad_tour.section_filter');
  static const assistantChips = ValueKey<String>('midad_tour.assistant_chips');
  static const modelSelector = ValueKey<String>('midad_tour.model_selector');
  static const sharedCard = ValueKey<String>('midad_tour.shared_card');
  static const sectionCard = ValueKey<String>('midad_tour.section_card');
}

const Map<MidadTourStop, Key> _plainKeys = {
  MidadTourStop.modeToggle: MidadTourKeys.modeToggle,
  MidadTourStop.newChat: MidadTourKeys.newChat,
  MidadTourStop.history: MidadTourKeys.history,
  MidadTourStop.floatingMenu: MidadTourKeys.floatingMenu,
  MidadTourStop.suggestionChips: MidadTourKeys.suggestionChips,
  MidadTourStop.inputField: MidadTourKeys.inputField,
  MidadTourStop.sendButton: MidadTourKeys.sendButton,
  MidadTourStop.sectionFilter: MidadTourKeys.sectionFilter,
  MidadTourStop.assistantChips: MidadTourKeys.assistantChips,
  MidadTourStop.modelSelector: MidadTourKeys.modelSelector,
};

const Map<MidadTourStop, IconData> _icons = {
  MidadTourStop.intro: Icons.water_drop,
  MidadTourStop.modeToggle: Icons.swap_horiz,
  MidadTourStop.newChat: Icons.add_comment_outlined,
  MidadTourStop.history: Icons.history,
  MidadTourStop.floatingMenu: Icons.menu_open,
  MidadTourStop.suggestionChips: Icons.lightbulb_outline,
  MidadTourStop.inputField: Icons.edit_outlined,
  MidadTourStop.sendButton: Icons.send,
  MidadTourStop.sectionFilter: Icons.tune,
  MidadTourStop.assistantChips: Icons.smart_toy_outlined,
  MidadTourStop.modelSelector: Icons.auto_awesome,
  MidadTourStop.closing: Icons.task_alt,
};

/// محطات جولة التحميل القصيرة: أول زيارة قبل تحميل أي قسم. تشرح بطاقات
/// التحميل ولا تبدّل الوضع، فالمساعد الذكي يُذكر في نصها لا يُعرض.
enum MidadDownloadTourStop {
  intro,
  modeToggle,

  /// بطاقة الملفات المشتركة: تدخل الجولة إن لم تُحمَّل بعد، فلا تُعرض
  /// البطاقة بعد تحميلها.
  sharedCard,
  sectionCard,
  laterHint,
  closing,
}

/// محطات جولة التحميل بحسب حالة الملفات المشتركة، بترتيب سيرها.
List<MidadDownloadTourStop> midadDownloadTourStopsFor({
  required bool sharedLoaded,
}) => [
  for (final stop in MidadDownloadTourStop.values)
    if (stop != MidadDownloadTourStop.sharedCard || !sharedLoaded) stop,
];

/// مفاتيح ترجمة نصوص محطات جولة التحميل. عنوان زر التبديل هو نفسه عنوان
/// محطته في الجولة الكاملة، وعنوان البطاقة الختامية نص كل الجولات.
const Map<MidadDownloadTourStop, String> _downloadFeatureTitleKeys = {
  MidadDownloadTourStop.modeToggle: 'midadTourModeToggleTitle',
  MidadDownloadTourStop.closing: 'mushafTourClosingTitle',
};

String midadDownloadTourTitleKey(MidadDownloadTourStop stop) =>
    _downloadFeatureTitleKeys[stop] ?? '${_downloadTextKeyPrefix(stop)}Title';

String midadDownloadTourDescKey(MidadDownloadTourStop stop) =>
    '${_downloadTextKeyPrefix(stop)}Desc';

String _downloadTextKeyPrefix(MidadDownloadTourStop stop) {
  final name = stop.name;
  return 'midadDownloadTour${name[0].toUpperCase()}${name.substring(1)}';
}

const Map<MidadDownloadTourStop, Key> _downloadPlainKeys = {
  MidadDownloadTourStop.modeToggle: MidadTourKeys.modeToggle,
  MidadDownloadTourStop.sharedCard: MidadTourKeys.sharedCard,
  MidadDownloadTourStop.sectionCard: MidadTourKeys.sectionCard,
};

const Map<MidadDownloadTourStop, IconData> _downloadIcons = {
  MidadDownloadTourStop.intro: Icons.water_drop,
  MidadDownloadTourStop.modeToggle: Icons.swap_horiz,
  MidadDownloadTourStop.sharedCard: Icons.folder_zip_outlined,
  MidadDownloadTourStop.sectionCard: Icons.cloud_download_outlined,
  MidadDownloadTourStop.laterHint: Icons.schedule,
  MidadDownloadTourStop.closing: Icons.task_alt,
};

/// ما تنفّذه خدمة الجولة (AppTour) لسيناريو مداد بحلول تُحقن من main.dart،
/// فلا يستورد هذا الملف شاشات التطبيق وتبقى قابلة للاختبار: وضع الشاشة
/// (دلالي ↔ مساعد) وحفظه، والاتصال، وانتظار اكتمال التهيئة، وحالة التحميل
/// والأقسام والمزودين. الوضع يُحفظ في التطبيق تلقائياً عند تغييره، فيكفي
/// الضبط بالقيمة والاسترجاع بعدها.
abstract interface class MidadTourHooks {
  /// هل وضع مداد الحالي هو المساعد الذكي؟
  bool get isMidasAssistantMode;

  /// يضبط الوضع (true: المساعد الذكي، false: البحث الدلالي).
  void setMidasAssistantMode(bool assistant);

  /// هل الجهاز متصل بالإنترنت؟ محطات المساعد تفترض الاتصال.
  bool get isMidadOnline;

  /// ينتظر اكتمال تهيئة مداد (أو انقضاء مهلة) قبل قراءة حالتها.
  Future<void> awaitMidadReady();

  /// هل حُمّل قسم واحد على الأقل؟ تفصل بين جولتي التحميل والكاملة.
  bool get hasMidadSectionLoaded;

  /// هل حُمّلت الملفات المشتركة؟ تفصل بطاقتها في جولة التحميل.
  bool get isMidadSharedLoaded;

  /// هل شاشة الدلالي في حالة الفراغ (اقتراحات البداية ظاهرة)؟
  bool get isMidadSemanticEmpty;

  /// هل محادثة المساعد فارغة (اقتراحات الترحيب ظاهرة)؟
  bool get isMidadAssistantFresh;

  /// هل مزوّدو LLM مُعدّون في هذا البناء؟ يفصل محطة منتقي النموذج.
  bool get hasMidadProviders;
}

/// يتولى الجولةُ وضعَ مداد نيابةً عن المستخدم ثم يعيده إليه، على نمط
/// _PlayerPanelSync في جولة الصوتي: أول طلب يحفظ وضع المستخدم، والبطاقة
/// الختامية لا تطلبه شيئاً (null) فتبقى في الوضع الذي انتهت عنده الجولة.
class _MidadModeSync {
  _MidadModeSync(this.hooks);

  final MidadTourHooks hooks;

  /// وضع المستخدم حين تولّته الجولة (null: لم تتوله بعد).
  bool? _userAssistant;

  /// يضبط الوضع لخطوة قادمة (null: يُترك كما هو).
  void sync({required bool? assistant}) {
    if (assistant == null) return;
    _userAssistant ??= hooks.isMidasAssistantMode;
    if (hooks.isMidasAssistantMode != assistant) {
      hooks.setMidasAssistantMode(assistant);
    }
  }

  /// يعيد الوضع إلى المستخدم إن كانت الجولة قد غيّرته.
  void restore() {
    final user = _userAssistant;
    if (user == null) return;
    _userAssistant = null;
    if (hooks.isMidasAssistantMode != user) {
      hooks.setMidasAssistantMode(user);
    }
  }
}

/// سيناريو جولة مداد الكاملة: محطاتها بحسب حالة الشاشة لحظة بدئها،
/// والتجهيز مركزي في [onStepChanged] (يُربط بـ
/// `SpotlightTourController.onStepChanged`): محطات الدلالي تعيد الشاشة إلى
/// الوضع الدلالي ومحطات المساعد تنقلها إليه، حالمة تُترك البطاقة الختامية
/// في وضعها، ويعاد وضع المستخدم عند انتهاء الجولة.
class MidadTourScript {
  MidadTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required bool online,
    required bool hasProviders,
    required bool semanticEmpty,
    required bool assistantFresh,
  }) : stops = midadTourStopsFor(
         online: online,
         hasProviders: hasProviders,
         semanticEmpty: semanticEmpty,
         assistantFresh: assistantFresh,
       );

  final SpotlightTourController tour;
  final MidadTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب الحالة التي بدئت فيها، بترتيب سيرها.
  final List<MidadTourStop> stops;

  late final _MidadModeSync _mode = _MidadModeSync(hooks);

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(MidadTourStop stop) => TourStep(
    targetKey: switch (stop) {
      MidadTourStop.intro || MidadTourStop.closing => null,
      _ => _plainKeys[stop],
    },
    title: midadTourTitleKey(stop).tr,
    description: midadTourDescKey(stop).tr,
    icon: _icons[stop],
    style: style,
  );

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _mode.sync(assistant: _modeFor(stop));
  }

  /// الوضع الذي تحتاجه المحطة (null: كما تُرك).
  bool? _modeFor(MidadTourStop stop) => switch (stop) {
    MidadTourStop.closing => null,
    _ => midadTourIsOnAssistant(stop),
  };

  /// انتهت الجولة (إتماماً أو تخطياً أو مغادرة الشاشة): يعاد وضع مداد إلى
  /// المستخدم.
  void onTourEnd() => _mode.restore();

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  MidadTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}

/// سيناريو جولة التحميل القصيرة: بطاقات بلا تبديل وضع ولا تجهيز، فلا
/// يغيّر السيناريو شيئاً في الشاشة. دالتا [onStepChanged] و[onTourEnd]
/// فارغتان عمداً: تُربطان كسابقتيهما حتى لا يبقى على الكنترولر ردُّ جولة
/// أقدم إذا انتهت هذه الجولة.
class MidadDownloadTourScript {
  MidadDownloadTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required bool sharedLoaded,
  }) : stops = midadDownloadTourStopsFor(sharedLoaded: sharedLoaded);

  final SpotlightTourController tour;
  final MidadTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب حالة الملفات المشتركة، بترتيب سيرها.
  final List<MidadDownloadTourStop> stops;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(MidadDownloadTourStop stop) => TourStep(
    targetKey: switch (stop) {
      MidadDownloadTourStop.intro ||
      MidadDownloadTourStop.laterHint ||
      MidadDownloadTourStop.closing => null,
      _ => _downloadPlainKeys[stop],
    },
    title: midadDownloadTourTitleKey(stop).tr,
    description: midadDownloadTourDescKey(stop).tr,
    icon: _downloadIcons[stop],
    style: style,
  );

  /// لا تجهيز لهذه الجولة؛ مربوطة لتُلغي ردّ أي جولة أقدم.
  void onStepChanged(int index) {}

  /// لا شيء لاسترجاعه؛ مربوطة لتُلغي ردّ أي جولة أقدم.
  void onTourEnd() {}
}

/// محطات جولة المساعد الذكي: وضع المساعد قبل تحميل أي قسم. المساعد يعمل
/// دون تحميلات فلا ينبغي أن يبقى شرحه محبوساً في الجولة الكاملة التي لا
/// تبدأ إلا بعد التحميل. أزرار شريط التطبيق ظاهرة دائماً، وشريط إدخال
/// المساعد ومحتواه اتصالٌ شرط.
enum MidadAssistantTourStop {
  intro,
  modeToggle,
  newChat,
  history,
  inputField,
  sendButton,

  /// اقتراحات الترحيب: اتصال ومحادثة فارغة.
  assistantChips,

  /// منتقي النموذج: اتصال ومزودون مُعدّون في البناء.
  modelSelector,
  closing,
}

/// محطات جولة المساعد بحسب حالة الشاشة لحظة بدئها، بترتيب سيرها.
List<MidadAssistantTourStop> midadAssistantTourStopsFor({
  required bool online,
  required bool assistantFresh,
  required bool hasProviders,
}) => [
  for (final stop in MidadAssistantTourStop.values)
    if (switch (stop) {
      MidadAssistantTourStop.inputField ||
      MidadAssistantTourStop.sendButton => online,
      MidadAssistantTourStop.assistantChips => online && assistantFresh,
      MidadAssistantTourStop.modelSelector => online && hasProviders,
      _ => true,
    })
      stop,
];

/// مفاتيح ترجمة نصوص جولة المساعد: عناوينها ومكثر أوصافها هي نصوص محطاتها
/// المقابلة في الجولتين الأخريين أو أسماء الميزات القائمة؛ الجديد وصفُ
/// الافتتاحية والحقل وزر الإرسال بصياغة المساعد.
const Map<MidadAssistantTourStop, String> _assistantTitleKeys = {
  MidadAssistantTourStop.intro: 'assistantMode',
  MidadAssistantTourStop.modeToggle: 'midadTourModeToggleTitle',
  MidadAssistantTourStop.newChat: 'newChat',
  MidadAssistantTourStop.history: 'chatHistory',
  MidadAssistantTourStop.inputField: 'askMidad',
  MidadAssistantTourStop.sendButton: 'midadTourSendButtonTitle',
  MidadAssistantTourStop.assistantChips: 'assistantMode',
  MidadAssistantTourStop.modelSelector: 'selectModel',
  MidadAssistantTourStop.closing: 'mushafTourClosingTitle',
};

const Map<MidadAssistantTourStop, String> _assistantDescKeys = {
  MidadAssistantTourStop.modeToggle: 'midadTourModeToggleDesc',
  MidadAssistantTourStop.newChat: 'midadTourNewChatDesc',
  MidadAssistantTourStop.history: 'midadTourHistoryDesc',
  MidadAssistantTourStop.assistantChips: 'midadTourAssistantChipsDesc',
  MidadAssistantTourStop.modelSelector: 'midadTourModelSelectorDesc',
  MidadAssistantTourStop.closing: 'midadTourClosingDesc',
};

String midadAssistantTourTitleKey(MidadAssistantTourStop stop) =>
    _assistantTitleKeys[stop] ?? '${_assistantTextKeyPrefix(stop)}Title';

String midadAssistantTourDescKey(MidadAssistantTourStop stop) =>
    _assistantDescKeys[stop] ?? '${_assistantTextKeyPrefix(stop)}Desc';

String _assistantTextKeyPrefix(MidadAssistantTourStop stop) {
  final name = stop.name;
  return 'midadAssistantTour${name[0].toUpperCase()}${name.substring(1)}';
}

const Map<MidadAssistantTourStop, Key> _assistantPlainKeys = {
  MidadAssistantTourStop.modeToggle: MidadTourKeys.modeToggle,
  MidadAssistantTourStop.newChat: MidadTourKeys.newChat,
  MidadAssistantTourStop.history: MidadTourKeys.history,
  MidadAssistantTourStop.inputField: MidadTourKeys.inputField,
  MidadAssistantTourStop.sendButton: MidadTourKeys.sendButton,
  MidadAssistantTourStop.assistantChips: MidadTourKeys.assistantChips,
  MidadAssistantTourStop.modelSelector: MidadTourKeys.modelSelector,
};

const Map<MidadAssistantTourStop, IconData> _assistantIcons = {
  MidadAssistantTourStop.intro: Icons.smart_toy_outlined,
  MidadAssistantTourStop.modeToggle: Icons.swap_horiz,
  MidadAssistantTourStop.newChat: Icons.add_comment_outlined,
  MidadAssistantTourStop.history: Icons.history,
  MidadAssistantTourStop.inputField: Icons.edit_outlined,
  MidadAssistantTourStop.sendButton: Icons.send,
  MidadAssistantTourStop.assistantChips: Icons.smart_toy_outlined,
  MidadAssistantTourStop.modelSelector: Icons.auto_awesome,
  MidadAssistantTourStop.closing: Icons.task_alt,
};

/// سيناريو جولة المساعد: لا تبديل وضع ولا تجهيز، فلا تُعرض إلا في وضع
/// المساعد أصلاً ولا تفاعل خلالها يغيّره. دالتا [onStepChanged] و
/// [onTourEnd] فارغتان عمداً كجولة التحميل: تُربطان حتى لا يبقى على
/// الكنترولر ردُّ جولة أقدم إذا انتهت هذه الجولة.
class MidadAssistantTourScript {
  MidadAssistantTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required bool online,
    required bool assistantFresh,
    required bool hasProviders,
  }) : stops = midadAssistantTourStopsFor(
         online: online,
         assistantFresh: assistantFresh,
         hasProviders: hasProviders,
       );

  final SpotlightTourController tour;
  final MidadTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب الحالة التي بدئت فيها، بترتيب سيرها.
  final List<MidadAssistantTourStop> stops;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(MidadAssistantTourStop stop) => TourStep(
    targetKey: switch (stop) {
      MidadAssistantTourStop.intro || MidadAssistantTourStop.closing => null,
      _ => _assistantPlainKeys[stop],
    },
    title: midadAssistantTourTitleKey(stop).tr,
    description: midadAssistantTourDescKey(stop).tr,
    icon: _assistantIcons[stop],
    style: style,
  );

  /// لا تجهيز لهذه الجولة؛ مربوطة لتُلغي ردّ أي جولة أقدم.
  void onStepChanged(int index) {}

  /// لا شيء لاسترجاعه؛ مربوطة لتُلغي ردّ أي جولة أقدم.
  void onTourEnd() {}
}
