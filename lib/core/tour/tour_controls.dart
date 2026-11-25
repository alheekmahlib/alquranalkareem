/// أشرطة التحكم في شاشة المصحف كما تحتاجها الجولات.
///
/// يشاركه سيناريو المصحف وسيناريو التسميع، لأن كليهما يستهدف أزراراً لا
/// تُركَّب إلا حين تظهر الأشرطة.
library;

/// ما تنفّذه خدمة الجولة (AppTour) لأي سيناريو بحلول تُحقن من main.dart.
abstract interface class TourControlsHooks {
  /// هل أشرطة التحكم ظاهرة؟
  bool get isControlsVisible;

  /// يبدّل ظهور أشرطة التحكم.
  void toggleControls();

  /// يطوي ورقتي الأعلى والأسفل إن كانت إحداهما مفتوحة.
  void collapsePanels();
}

/// يتولى الجولةُ أشرطةَ التحكم نيابةً عن المستخدم ثم يعيدها إليه.
///
/// أول طلب يحمل حالة معيّنة يحفظ حالة المستخدم، وكل طلب لاحق يتركها محفوظة
/// فلا تُستبدل بحالة وفّقتها الجولة بنفسها. [restore] يعيد الحالة المحفوظة.
class TourControlsSync {
  TourControlsSync(this.hooks);

  final TourControlsHooks hooks;

  /// حالة الأشرطة التي تركها المستخدم حين تولّتها الجولة (null: لم
  /// تتولاها بعد).
  bool? _userControls;

  /// يضبط الأشرطة لخطوة قادمة:
  /// * `true`: ظاهرة، وتُطوى الأوراق المفتوحة كي لا تغطي أهدافها.
  /// * `false`: مخفية، فهدف الخطوة يقع تحتها.
  /// * `null`: كما تركها المستخدم.
  void sync({required bool? visible}) {
    if (visible == null) {
      restore();
      return;
    }
    if (visible) hooks.collapsePanels();
    _userControls ??= hooks.isControlsVisible;
    if (hooks.isControlsVisible != visible) hooks.toggleControls();
  }

  /// يعيد الأشرطة إلى حالة المستخدم إن كانت الجولة قد غيّرتها.
  void restore() {
    final user = _userControls;
    if (user == null) return;
    _userControls = null;
    if (hooks.isControlsVisible != user) hooks.toggleControls();
  }
}
