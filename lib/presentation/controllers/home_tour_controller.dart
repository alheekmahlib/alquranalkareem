import 'dart:async';

import 'package:get/get.dart';

import '../../core/tour/app_tour.dart';
import '../../core/tour/tour_auto_start.dart';
import '../screens/adhkar/controller/adhkar_controller.dart';
import 'daily_ayah_controller.dart';
import 'general/app_section.dart';

/// يشغّل جولة الصفحة الرئيسية تلقائياً أول مرة بعد جاهزية المحتوى اليومي
/// (آية اليوم وذكر اليوم)، أو انقضاء مهلة انتظارهما.
///
/// الحقلان حقول عادية (لا Rx) تُملأ بعد جلبهما من قاعدتي البيانات،
/// فينتظر الكنترولر حضورهما بالتقطيع الزمني كما فعلت بطاقة التشغيل
/// السابقة داخل الشاشة. وقبل البدء يتحقق من كون الصفحة الرئيسية هي
/// الشاشة الجارية كي لا تبدأ الجولة فوق شاشة أخرى بعد مغادرة سريعة،
/// ويُعاد الانتظار عند العودة إليها قبل بدئها. علم «مرة واحدة» في
/// [AppTour] يمنع تكرارها مهما تعددت المحاولات.
class HomeTourController extends GetxController {
  static HomeTourController get instance =>
      GetInstance().putOrFind(() => HomeTourController());

  static const _checkInterval = Duration(milliseconds: 250);
  static const _waitLimit = Duration(seconds: 4);

  Timer? _timer;
  bool _started = false;

  @override
  void onInit() {
    super.onInit();
    _startWaiting();
    // كل حدث تنقل يُعيد الانتظار إن عاد المستخدم إلى الرئيسية قبل بدئها.
    ever(routeChanges, (_) {
      if (!_started && _timer == null && AppSection.home.isShowing) {
        _startWaiting();
      }
    });
  }

  bool get _dailyContentReady =>
      DailyAyahController.instance.ayahOfTheDay != null &&
      AzkarController.instance.state.dhekrOfTheDay != null;

  void _startWaiting() {
    var waited = Duration.zero;
    _timer = Timer.periodic(_checkInterval, (timer) {
      waited += _checkInterval;
      if (!_dailyContentReady && waited < _waitLimit) return;
      timer.cancel();
      _timer = null;
      startTourWhenSectionShows(AppSection.home, () {
        _started = true;
        AppTour.instance.startHomeTourOnce();
      });
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
