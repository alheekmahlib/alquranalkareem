import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/tour/app_tour.dart';
import '../screens/adhkar/controller/adhkar_controller.dart';
import 'daily_ayah_controller.dart';
import 'general/general_controller.dart';

/// يشغّل جولة الصفحة الرئيسية تلقائياً أول مرة بعد جاهزية المحتوى اليومي
/// (آية اليوم وذكر اليوم)، أو انقضاء مهلة انتظارهما.
///
/// الحقلان حقول عادية (لا Rx) تُملأ بعد جلبهما من قاعدتي البيانات،
/// فينتظر الكنترولر حضورهما بالتقطيع الزمني كما فعلت بطاقة التشغيل
/// السابقة داخل الشاشة. وقبل البدء يتحقق من ظهور تبويب الرئيسية (0 في
/// screenSelect) كي لا تبدأ الجولة فوق شاشة أخرى بعد مغادرة سريعة،
/// ويُعاد الانتظار عند العودة إلى التبويب قبل بدئها. علم «مرة واحدة»
/// في [AppTour] يمنع تكرارها مهما تعددت المحاولات.
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
    ever<int>(GeneralController.instance.state.screenSelectedValue, (tab) {
      if (tab == 0 && !_started && _timer == null) _startWaiting();
    });
  }

  bool get _dailyContentReady =>
      DailyAyahController.instance.ayahOfTheDay != null &&
      AzkarController.instance.state.dhekrOfTheDay != null;

  bool get _isHomeTabVisible =>
      GeneralController.instance.state.screenSelectedValue.value == 0;

  void _startWaiting() {
    var waited = Duration.zero;
    _timer = Timer.periodic(_checkInterval, (timer) {
      waited += _checkInterval;
      if (!_dailyContentReady && waited < _waitLimit) return;
      timer.cancel();
      _timer = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isHomeTabVisible) return;
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
