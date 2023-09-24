import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';

import '../../quran_page/data/model/sorah_bookmark.dart';
import '../../quran_page/data/repository/translate_repository.dart';
import '../services/controllers_put.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '../widgets/time_now.dart';

class GeneralController extends GetxController {
  final GlobalKey<NavigatorState> navigatorNotificationKey =
      GlobalKey<NavigatorState>();

  /// Slide and Scroll Controller
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelTextController = SlidingUpPanelController();
  bool isPanelControllerDisposed = false;

  /// Page Controller
  PageController? dPageController;

  RxInt cuMPage = 1.obs;
  RxString soMName = '1'.obs;
  RxDouble fontSizeArabic = 24.0.obs;
  List<InlineSpan> text = [];

  RxBool isShowControl = true.obs;
  RxBool opened = false.obs;
  // RxBool menuOpened = false.obs;
  double? height;
  double width = 800;
  RxString greeting = ''.obs;
  RxInt shareTafseerValue = 1.obs;
  RxInt pageIndex = 0.obs;
  RxBool isExpanded = false.obs;
  int? onboardingPageNumber;
  bool isReversed = false;
  RxBool showSettings = true.obs;
  RxDouble widgetPosition = (-240.0).obs;
  RxDouble textWidgetPosition = (-740.0).obs;
  RxDouble audioWidgetPosition = (0.0).obs;
  var viewport = 1 / 2;
  TimeNow timeNow = TimeNow();

  Future<void> getLastPageAndFontSize() async {
    try {
      cuMPage.value = await pref.getInteger(MSTART_PAGE,
          defaultValue: 1); // Set a default value
      soMName.value = await pref.getString(MLAST_URAH,
          defaultValue: '1'); // Set a default value
      double? fontSizeFromPref = await pref.getDouble(FONT_SIZE);
      if (fontSizeFromPref != null && fontSizeFromPref > 0) {
        fontSizeArabic.value = fontSizeFromPref;
      } else {
        fontSizeArabic.value = 24.0; // Setting to a valid default value
      }
      print('Font size from preferences: $fontSizeFromPref');
      print('mstart_page: ${cuMPage.value}');
      print('fontSizeArabic: ${fontSizeArabic.value}');
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }

  showControl() {
    isShowControl.value = !isShowControl.value;
    generalController.audioWidgetPosition.value =
        generalController.audioWidgetPosition.value == 0.0 ? -220.0 : 0.0;
    if (SlidingUpPanelStatus.hidden == panelController.status) {
      panelController.collapse();
    } else {
      panelController.hide();
    }
  }

  Future<void> pageChanged(int index) async {
    cuMPage.value = index + 1;
    ayaListNotFut = null;
    panelController.hide();
    isShowControl.value = false;
    audioWidgetPosition.value = -240;
    ayatController.isSelected.value = (-1.0);
    audioController.pageAyahNumber = '0';

    bookmarksController.getBookmarks();
    SoraBookmark soraBookmark = bookmarksController.soraBookmarkList![index];
    soMName.value = '${soraBookmark.SoraNum! + 1}';
    await pref.saveInteger(MSTART_PAGE, index + 1);
    await pref.saveString(MLAST_URAH, (soraBookmark.SoraNum! + 1).toString());
    ayatController.currentAyahNumber.value =
        '${ayatController.ayatList.first.ayaNum!}';
  }

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }

  closeSlider() {
    generalController.widgetPosition.value =
        generalController.widgetPosition.value == 0.0 ? -220.0 : 0.0;
  }
}
