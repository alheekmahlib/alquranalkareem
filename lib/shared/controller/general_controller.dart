import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralController extends GetxController {
  final GlobalKey<NavigatorState> navigatorNotificationKey =
      GlobalKey<NavigatorState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Slide and Scroll Controller
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelTextController = SlidingUpPanelController();

  /// Animation Controller
  late AnimationController controller;
  late Animation<Offset> offset;
  AnimationController? screenController;
  Animation<double>? screenAnimation;

  /// Page Controller
  PageController? dPageController;

  late int cuMPage;
  RxString soMName = ''.obs;
  RxDouble fontSizeArabic = 18.0.obs;
  List<InlineSpan> text = [];

  RxBool isShowControl = true.obs;
  RxBool opened = false.obs;
  double? height;
  double width = 800;
  RxString greeting = ''.obs;
  int? shareTafseerValue;

  @override
  void onClose() {
    // dPageController?.dispose();
    // screenController!.dispose();
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
    cuMPage = (prefs.getInt('mstart_page') == null
        ? 1
        : prefs.getInt('mstart_page'))!;
    soMName.value = prefs.getString('mLast_sorah') ?? '1';
    print('cuMPage ${cuMPage}');
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
    controller.forward();
  }

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }
}
