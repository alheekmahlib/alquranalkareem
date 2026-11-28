import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/utils/constants/shared_preferences_constants.dart';
import '../../screens/quran_page/quran.dart';
import 'app_section.dart';
import 'general_state.dart';

class GeneralController extends GetxController {
  static GeneralController get instance =>
      GetInstance().putOrFind(() => GeneralController());

  GeneralState state = GeneralState();

  Timer? _audioWidgetTimer;

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      try {
        await WakelockPlus.enable();
      } catch (e) {
        print('Failed to enable wakelock: $e');
      }
    });
    state.screenSelectedValue.value =
        state.box.read(SCREEN_SELECTED_VALUE) ?? 0;
    state.isUseEnglishNumbers.value =
        state.box.read('isUseEnglishNumbers') ?? false;
    // WidgetsBinding.instance.addObserver(this);

    super.onInit();
  }

  @override
  void onClose() {
    _audioWidgetTimer?.cancel();
    _audioWidgetTimer = null;
    state.expansionManager.dispose();
    super.onClose();
  }

  // @override
  // void onClose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.onClose();
  // }

  /// -------- [Methods] ----------

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    state.greeting.value = isMorning
        ? 'صبحكم الله بالخير'
        : 'مساكم الله بالخير';
  }

  scrollToAyah(int ayahNumber) {
    if (state.ayahListController.hasClients) {
      double position = (ayahNumber - 1) * state.ayahItemWidth;
      state.ayahListController.jumpTo(position);
    } else {
      print("Controller not attached to any scroll views.");
    }
  }

  /// مدة انتقال GetX الافتراضية: يُعطى بعدها المصحف وقت استقراره قبل
  /// القفز إلى آخر صفحة.
  static const _routeTransition = Duration(milliseconds: 300);

  /// يفتح شاشة البداية المختارة جذرًا للتطبيق (من شاشة الافتتاح)، باسم
  /// مسار القسم نفسه الذي يُفتح به من الرئيسية.
  void openStartScreen() {
    final section = AppSection.forStartIndex(state.screenSelectedValue.value);
    Get.offAll(
      section.builder,
      routeName: section.route,
      transition: Transition.fadeIn,
    );
  }

  /// يعيد المستخدم إلى الصفحة الرئيسية محافظًا على حالتها إن كانت في المكدس
  /// (ترتدّ الشاشات التي فوقها)، وإلا فتحها جذرًا كما يفعل زر Home. لا
  /// يكتمل إلا بخروج الشاشات القديمة من الشجعة، فلا يُفتح فوقها قسم قبل
  /// ذلك (تكرار المفاتيح العامة).
  Future<void> returnToHome() async {
    if (await popToHomeIfStacked()) return;
    final leaving = <Route<dynamic>>[];
    Get.offAll(
      AppSection.home.builder,
      routeName: AppSection.home.route,
      transition: Transition.upToDown,
      // كل الشاشات القديمة تُزال، فتُحصى لتُنتظر خروجها؛ وشاشة الرئيسية
      // الجديدة ليست منها.
      predicate: (route) {
        if (route.settings.name != AppSection.home.route) leaving.add(route);
        return false;
      },
    );
    await whenRoutesDisposed(leaving);
  }

  /// يفتح القسم كما من بطاقته في الصفحة الرئيسية؛ الطريق الوحيد لفتح
  /// الأقسام، فتستدعيه البطاقات ومشغّل الجولات من الإعدادات.
  Future<void> open(AppSection section) async {
    switch (section) {
      case AppSection.home:
        await returnToHome();
      case AppSection.mushaf:
        // أنهِ وضع التسميع إن كان مفعّلًا قبل فتح القراءة العادية.
        final tasmee = TasmeeCtrl.instance;
        if (tasmee.state.isTasmeeMode.value) tasmee.exitTasmeeMode();
        section.push();
        _jumpToLastReadPage();
      case AppSection.tasmee:
        final tasmee = TasmeeCtrl.instance;
        tasmee.state.showAllWords.value = false;
        await tasmee.enterTasmeeMode();
        section.push();
        _jumpToLastReadPage();
      case AppSection.audio:
        await AudioCtrl.instance.state.audioPlayer.stop();
        section.push();
      case AppSection.midad:
        section.push(transition: Transition.fadeIn);
      case AppSection.azkar:
      case AppSection.books:
        section.push();
    }
  }

  /// يفتح المصحف على آخر صفحة قرئها بعد استقرار الشاشة، كما من البطاقة.
  void _jumpToLastReadPage() {
    final quranCtrl = QuranController.instance;
    final lastReadPage = quranCtrl.state.box.read('last_page') ?? 1;
    Future.delayed(_routeTransition, () {
      quranCtrl.changeSurahListOnTap(lastReadPage);
    });
  }

  void showAudioWidgetFor([Duration duration = const Duration(seconds: 2)]) {
    state.showAudioWidgetTemporarily.value = true;
    _audioWidgetTimer?.cancel();
    _audioWidgetTimer = Timer(duration, () {
      state.showAudioWidgetTemporarily.value = false;
      update(['showControl']);
    });
    update(['showControl']);
  }
}
