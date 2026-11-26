import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// محطات جولة الأذكار (شاشة الأذكار الرئيسية). ترتيب التعداد هو ترتيب
/// الجولة.
///
/// تسير الجولة من شريط التبويبات إلى زر المنبه بجانب الشعار ثم حقل البحث
/// وأول بطاقة تصنيف. ومحطة قد غاب هدفها بحسب حالة الشاشة لحظة البدء
/// تُحذف من الجولة ([azkarTourStopsFor]) لا أن تُعرض بلا إضاءة.
enum AzkarTourStop {
  intro,

  /// شريط التبويبات: الأذكار والمفضلة.
  tabs,

  /// زر المنبه بجانب الشعار: يفتح ورقة التذكيرات.
  alarm,

  /// حقل البحث المدمج أعلى قائمة الأقسام.
  search,

  /// أول بطاقة تصنيف: تدخل الجولة إن كانت قائمة الأقسام ظاهرة (لا بحث
  /// جارياً يستبدلها بنتائجه).
  categories,
  closing,
}

/// محطات جولة الأذكار بحسب حالة الشاشة لحظة بدئها، بترتيب سيرها.
List<AzkarTourStop> azkarTourStopsFor({required bool hasCategoriesVisible}) => [
  for (final stop in AzkarTourStop.values)
    if (stop != AzkarTourStop.categories || hasCategoriesVisible) stop,
];

/// مفاتيح ترجمة نصوص محطات جولة الأذكار في ملفات اللغات.
// عناوين محطات لا تزيد على اسم الميزة نفسها تُقرأ بمفاتيحها القائمة في
// التطبيق، بدل تكرار الكلمة نفسها تحت مفتاح خاص بالجولة. وعنوان البطاقة
// الختامية نص عام تنتهي به كل جولة.
const Map<AzkarTourStop, String> _featureNameTitleKeys = {
  AzkarTourStop.alarm: 'reminders',
  AzkarTourStop.search: 'searchAzkar',
  AzkarTourStop.closing: 'mushafTourClosingTitle',
};

String azkarTourTitleKey(AzkarTourStop stop) =>
    _featureNameTitleKeys[stop] ?? '${_textKeyPrefix(stop)}Title';

String azkarTourDescKey(AzkarTourStop stop) => '${_textKeyPrefix(stop)}Desc';

String _textKeyPrefix(AzkarTourStop stop) {
  final name = stop.name;
  return 'azkarTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// محطات جولة شاشة القسم (أذكار التصنيف المحدد). ترتيب التعداد هو ترتيب
/// الجولة.
///
/// تشرح الجولة زر تغيير حجم الخط في شريط التطبيق، ثم شريط خيارات أول ذكر
/// ونصه — فتثبّت الشاشة على أعلاها خلال محطتيهما لأن القدوم من نتائج
/// البحث يمرّرها إلى ذكر بعيد — وتختم.
enum AzkarItemTourStop {
  intro,

  /// زر تغيير حجم الخط في شريط التطبيق.
  fontSize,

  /// شريط خيارات أول ذكر: مشاركة ونسخ وحفظ في المفضلة وشارة عدد التكرار.
  optionsRow,

  /// نص أول ذكر ومرجعه ووصفه.
  zekrText,
  closing,
}

/// مفاتيح ترجمة نصوص محطات شاشة القسم.
const Map<AzkarItemTourStop, String> _itemFeatureTitleKeys = {
  AzkarItemTourStop.fontSize: 'fontSize',
  AzkarItemTourStop.closing: 'mushafTourClosingTitle',
};

String azkarItemTourTitleKey(AzkarItemTourStop stop) =>
    _itemFeatureTitleKeys[stop] ?? '${_itemTextKeyPrefix(stop)}Title';

String azkarItemTourDescKey(AzkarItemTourStop stop) =>
    '${_itemTextKeyPrefix(stop)}Desc';

String _itemTextKeyPrefix(AzkarItemTourStop stop) {
  final name = stop.name;
  return 'azkarItemTour${name[0].toUpperCase()}${name.substring(1)}';
}

/// مفاتيح عادية لأهداف جولتي الأذكار، فلا يصلح لها GlobalKey: شاشات
/// الأذكار تدخل فوق شاشات أخر في المكدس، وشريط خيارات كل ذكر ونصه
/// يُركَّبان لكل ذكر في القسم فيُقتصر المفتاح على أول ذكر ظاهر أعلى
/// القائمة (درس شبكة الكتب في جولة المكتبة: مفاتيح كل الصفوف تجعل
/// الإضاءة تقع على آخر صف بناه في مدى الذاكرة). تُبرز الجولة آخر نسخة
/// ظاهرة من الهدف.
///
/// مواضع تركيبها: [tabs] على حاوية التبويبات في adhkar_view.dart، و[alarm]
/// على حاوية زر المنبه في tab_bar_view_widget.dart، و[search] على حقل
/// البحث و[categories] على أول بطاقة تصنيف في adhkar_list.dart، و[fontSize]
/// على زر حجم الخط في app_bar_widget.dart (شاشة القسم)، و[optionsRow] و
/// [zekrText] على أول عنصر ذكر في adhkar_item.dart.
abstract final class AzkarTourKeys {
  static const tabs = ValueKey<String>('azkar_tour.tabs');
  static const alarm = ValueKey<String>('azkar_tour.alarm');
  static const search = ValueKey<String>('azkar_tour.search');
  static const categories = ValueKey<String>('azkar_tour.categories');
  static const fontSize = ValueKey<String>('azkar_tour.font_size');
  static const optionsRow = ValueKey<String>('azkar_tour.options_row');
  static const zekrText = ValueKey<String>('azkar_tour.zekr_text');
}

const Map<AzkarTourStop, Key> _plainKeys = {
  AzkarTourStop.tabs: AzkarTourKeys.tabs,
  AzkarTourStop.alarm: AzkarTourKeys.alarm,
  AzkarTourStop.search: AzkarTourKeys.search,
  AzkarTourStop.categories: AzkarTourKeys.categories,
};

const Map<AzkarTourStop, IconData> _icons = {
  AzkarTourStop.intro: Icons.volunteer_activism,
  AzkarTourStop.tabs: Icons.tab,
  AzkarTourStop.alarm: Icons.alarm,
  AzkarTourStop.search: Icons.search,
  AzkarTourStop.categories: Icons.category_outlined,
  AzkarTourStop.closing: Icons.task_alt,
};

const Map<AzkarItemTourStop, Key> _itemPlainKeys = {
  AzkarItemTourStop.fontSize: AzkarTourKeys.fontSize,
  AzkarItemTourStop.optionsRow: AzkarTourKeys.optionsRow,
  AzkarItemTourStop.zekrText: AzkarTourKeys.zekrText,
};

const Map<AzkarItemTourStop, IconData> _itemIcons = {
  AzkarItemTourStop.intro: Icons.format_quote,
  AzkarItemTourStop.fontSize: Icons.format_size,
  AzkarItemTourStop.optionsRow: Icons.tune,
  AzkarItemTourStop.zekrText: Icons.format_align_right,
  AzkarItemTourStop.closing: Icons.task_alt,
};

/// ما تنفّذه خدمة الجولة (AppTour) لجولتي الأذكار بحلول تُحقن من main.dart،
/// فلا يستورد هذا الملف شاشات التطبيق وتبقى قابلة للاختبار: ظهور قائمة
/// الأقسام، وتمرير قائمتي الأقسام وشاشة القسم.
abstract interface class AzkarTourHooks {
  /// هل قائمة الأقسام ظاهرة (لا بحث جارياً يستبدلها بنتائجه)؟ يفصل
  /// محطتها في جولة الشاشة الرئيسية.
  bool get hasAzkarCategoriesVisible;

  /// موضع تمرير قائمة الأقسام (0 إن لم تُركَّب القائمة بعد).
  double get azkarListScrollOffset;

  /// يمرر قائمة الأقسام إلى موضع [offset].
  void scrollAzkarListTo(double offset);

  /// موضع تمرير شاشة القسم (0 إن لم تُركَّب الشاشة بعد).
  double get azkarItemScrollOffset;

  /// يمرر شاشة القسم إلى موضع [offset].
  void scrollAzkarItemTo(double offset);
}

/// سيناريو جولة الشاشة الرئيسية للأذكار: محطاتها بحسب حالة الشاشة لحظة
/// بدئها، والتجهيز مركزي في [onStepChanged] (يُربط بـ
/// `SpotlightTourController.onStepChanged`): يثبّت قائمة الأقسام على
/// أعلاها خلال محطة التصنيفات (هدفها أول بطاقة فيها)، ويعاد موضع المستخدم
/// حالما تغادر الجولة نطاقه أو تنتهي.
class AzkarTourScript {
  AzkarTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
    required bool hasCategoriesVisible,
  }) : stops = azkarTourStopsFor(hasCategoriesVisible: hasCategoriesVisible);

  final SpotlightTourController tour;
  final AzkarTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة بحسب الحالة التي بدئت فيها، بترتيب سيرها.
  final List<AzkarTourStop> stops;

  /// موضع القائمة الذي تركه المستخدم حين مرّرتها الجولة (null: لم تمررها
  /// بعد). هدف محطة التصنيفات أول بطاقة فيها، فتُثبَّت القائمة على أعلاها
  /// خلالها ثم يعاد موضع المستخدم.
  double? _userListOffset;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(AzkarTourStop stop) => TourStep(
    targetKey: switch (stop) {
      AzkarTourStop.intro || AzkarTourStop.closing => null,
      _ => _plainKeys[stop],
    },
    title: azkarTourTitleKey(stop).tr,
    description: azkarTourDescKey(stop).tr,
    icon: _icons[stop],
    style: style,
  );

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _syncListTop(top: stop == AzkarTourStop.categories);
  }

  /// انتهت الجولة (إتمامًا أو تخطيًا أو مغادرة الشاشة): يعاد موضع القائمة
  /// إلى المستخدم.
  void onTourEnd() => _syncListTop(top: false);

  /// يثبّت القائمة على أعلاها خلال محطتها أو يعيد موضع المستخدم.
  void _syncListTop({required bool top}) {
    if (!top) {
      final user = _userListOffset;
      if (user == null) return;
      _userListOffset = null;
      if (hooks.azkarListScrollOffset != user) {
        hooks.scrollAzkarListTo(user);
      }
      return;
    }
    _userListOffset ??= hooks.azkarListScrollOffset;
    if (hooks.azkarListScrollOffset != 0) hooks.scrollAzkarListTo(0);
  }

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  AzkarTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}

/// سيناريو جولة شاشة القسم: يثبّت الشاشة على أعلاها خلال محطتي شريط
/// الخيارات ونص أول ذكر (فالقدوم من نتائج البحث يمرّرها إلى ذكر بعيد
/// وأهدافها على أول عنصر)، ويعاد موضع المستخدم حالما تغادر الجولة نطاقه
/// أو تنتهي. والتجهيز مركزي في [onStepChanged].
class AzkarItemTourScript {
  AzkarItemTourScript({
    required this.tour,
    required this.hooks,
    required this.style,
  }) : stops = AzkarItemTourStop.values;

  final SpotlightTourController tour;
  final AzkarTourHooks hooks;
  final TourStepStyle style;

  /// محطات هذه الجولة، بترتيب سيرها.
  final List<AzkarItemTourStop> stops;

  /// موضع الشاشة الذي تركه المستخدم حين مرّرتها الجولة (null: لم تمررها
  /// بعد).
  double? _userItemOffset;

  late final List<TourStep> steps = [for (final stop in stops) _build(stop)];

  TourStep _build(AzkarItemTourStop stop) => TourStep(
    targetKey: switch (stop) {
      AzkarItemTourStop.intro || AzkarItemTourStop.closing => null,
      _ => _itemPlainKeys[stop],
    },
    title: azkarItemTourTitleKey(stop).tr,
    description: azkarItemTourDescKey(stop).tr,
    icon: _itemIcons[stop],
    style: style,
  );

  /// يُربط بـ `SpotlightTourController.onStepChanged`.
  void onStepChanged(int index) {
    final stop = _stopAt(index);
    if (stop == null) return;
    _syncItemTop(
      top:
          stop == AzkarItemTourStop.optionsRow ||
          stop == AzkarItemTourStop.zekrText,
    );
  }

  /// انتهت الجولة (إتمامًا أو تخطيًا أو مغادرة الشاشة): يعاد موضع الشاشة
  /// إلى المستخدم.
  void onTourEnd() => _syncItemTop(top: false);

  /// يثبّت الشاشة على أعلاها خلال محطتيها أو يعيد موضع المستخدم.
  void _syncItemTop({required bool top}) {
    if (!top) {
      final user = _userItemOffset;
      if (user == null) return;
      _userItemOffset = null;
      if (hooks.azkarItemScrollOffset != user) {
        hooks.scrollAzkarItemTo(user);
      }
      return;
    }
    _userItemOffset ??= hooks.azkarItemScrollOffset;
    if (hooks.azkarItemScrollOffset != 0) hooks.scrollAzkarItemTo(0);
  }

  /// محطة الخطوة [index] إن كانت الجولة الجارية هي هذا السيناريو.
  AzkarItemTourStop? _stopAt(int index) {
    if (!identical(tour.steps, steps)) return null;
    if (index < 0 || index >= stops.length) return null;
    return stops[index];
  }
}
