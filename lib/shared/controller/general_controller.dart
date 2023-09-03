import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring/spring.dart';

import '../widgets/controllers_put.dart';

class GeneralController extends GetxController {
  final GlobalKey<NavigatorState> navigatorNotificationKey =
      GlobalKey<NavigatorState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Slide and Scroll Controller
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelTextController = SlidingUpPanelController();

  /// Page Controller
  PageController? dPageController;

  int cuMPage = 1;
  RxString soMName = ''.obs;
  RxDouble fontSizeArabic = 18.0.obs;
  List<InlineSpan> text = [];

  RxBool isShowControl = true.obs;
  RxBool opened = false.obs;
  double? height;
  double width = 800;
  RxString greeting = ''.obs;
  int? shareTafseerValue;
  RxInt pageIndex = 0.obs;
  RxBool isExpanded = false.obs;
  int? onboardingPageNumber;
  bool isReversed = false;

  @override
  void onInit() {
    // springController = SpringController(initialAnim: Motion.play);
    super.onInit();
  }

  @override
  void onClose() {
    // dPageController?.dispose();
    // screenController!.dispose();
    // springController.controller.close();
    panelController.dispose();
  }

  /// Shared Preferences
  // Save & Load Last Page For Quran Page
  Future<void> saveMLastPlace(int currentPage, String lastSorah) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("mstart_page", currentPage);
    await prefs.setString("mLast_sorah", lastSorah);
  }

  Future<void> loadMCurrentPage() async {
    SharedPreferences prefs = await _prefs;
    cuMPage = (prefs.getInt('mstart_page') ?? 1);
    soMName.value = prefs.getString('mLast_sorah') ?? '1';
    print('cuMPage.value.value $cuMPage');
    print('last_sorah ${prefs.getString('mLast_sorah')}');
  }

  // Save & Load Tafseer Font Size
  Future<void> saveFontSize(double fontSizeArabic) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_size", fontSizeArabic);
  }

  Future<void> loadFontSize() async {
    SharedPreferences prefs = await _prefs;
    fontSizeArabic.value = prefs.getDouble('font_size') ?? 18;
    print('get font size ${prefs.getDouble('font_size')}');
  }

  showControl() {
    isShowControl.value = !isShowControl.value;
  }

  void pageChanged(BuildContext context, int index) {
    print("on Page Changed $index");
    // DPages.currentPage2 = index + 1;
    // MPages.currentPage2 = index + 1;
    cuMPage = index + 1;
    // cuDPage = index + 1;
    // DPages.currentIndex2 = index;
    // currentIndex = index;
    isShowControl.value = false;
    // isShowBookmark = false;
  }

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }

  /// Time
  // var now = DateTime.now();
  String lastRead =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  void toggleAnimation() {
    try {
      if (isReversed ||
          springController.controller.isClosed == AnimStatus.dismissed) {
        springController.play(motion: Motion.play);
        isReversed = false;
      } else {
        springController.play(motion: Motion.reverse);
        isReversed = true;
      }
    } catch (e) {
      if (e.toString().contains("Cannot add new events after calling close")) {
        // Handle the closed controller here, e.g., reinitialize it
        springController = SpringController(initialAnim: Motion.pause);
        toggleAnimation(); // Retry the animation after reinitializing
      }
    }
  }

  Motion? currentState;

  void sliderIsShow() {
    if (currentState == Motion.play) {
      null;
    } else {
      springController.play(motion: Motion.play);
      currentState = Motion.play;
    }
  }

  void showSlider() {
    if (currentState == Motion.play) {
      springController.play(motion: Motion.reverse);
      currentState = Motion.reverse;
    } else {
      springController.play(motion: Motion.play);
      currentState = Motion.play;
    }
  }
}
