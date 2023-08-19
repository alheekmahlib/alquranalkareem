import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../quran_text/bookmarksTextAyah_controller.dart';
import '../../quran_text/bookmarksText_controller.dart';
import '../../quran_text/model/bookmark_text.dart';
import '../../quran_text/model/bookmark_text_ayah.dart';
import '../../quran_text/text_page_view.dart';
import '../../services_locator.dart';
import '../widgets/widgets.dart';
import 'ayat_controller.dart';

class QuranTextController extends GetxController {
  late final BookmarksTextController bookmarksTextController =
      Get.put(BookmarksTextController());
  late final BookmarksTextAyahController bookmarksTextAyahController =
      Get.put(BookmarksTextAyahController());
  late Animation<Offset> offset;
  late AnimationController controller;
  int? id;

  String translateAyah = '';
  String translate = '';
  late int radioValue;
  var showTaf;
  String? selectedValue;
  Color? bColor;
  final ScrollController scrollController = ScrollController();
  // AutoScrollController? scrollController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  double verticalOffset = 0;
  double horizontalOffset = 0;
  PreferDirection preferDirection = PreferDirection.topCenter;

  bool selected = false;
  String? juz;
  String? juz2;
  bool? sajda;
  bool? sajda2;
  RxInt value = 0.obs;

  double scrollSpeed = 0.05;
  bool scrolling = false;
  late AnimationController animationController;
  ValueNotifier<double>? scrollSpeedNotifier;
  late final AyatController ayatController = Get.put(AyatController());

  /// Shared Preferences
  // Save & Load Last Page For Quran Text
  Future<void> saveTextLastPlace(
      int textCurrentPage, String lastTime, sorahTextName) async {
    textCurrentPage = TextPageView.textCurrentPage;
    lastTime = TextPageView.lastTime;
    sorahTextName = TextPageView.sorahTextName;
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setInt("last_page", textCurrentPage);
    await prefService.setString("last_time", lastTime);
    await prefService.setString("last_sorah_name", sorahTextName);
  }

  Future<void> loadTextCurrentPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TextPageView.textCurrentPage = prefs.getInt('last_page') ?? 1;
    TextPageView.lastTime = prefs.getString('last_time') ?? '';
    TextPageView.sorahTextName = prefs.getString('last_sorah_name') ?? '';
    print('get ${prefs.getInt('last_page')}');
  }

  textPageChanged(int textCurrentPage, String lastTime, sorahTextName) {
    saveTextLastPlace(TextPageView.textCurrentPage, TextPageView.lastTime,
        TextPageView.sorahTextName);
  }

// Save & Load Last Switch Page For Quran Text
  Future<void> saveSwitchValue(int switchValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("switchـvalue", switchValue);
  }

  Future<void> loadSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value.value = prefs.getInt('switchـvalue') ?? 0;
    print('switchـvalue ${value.value}');
  }

  // Save & Load Scroll Speed For Quran Text
  Future<void> saveScrollSpeedValue(double scroll) async {
    await sl<SharedPreferences>().setDouble("scroll_speed", scroll);
  }

  Future<void> loadScrollSpeedValue() async {
    scrollSpeed = sl<SharedPreferences>().getDouble('scroll_speed') ?? .05;
    print('scroll_speed $scrollSpeed');
  }

  addBookmarkText(
    String sorahName,
    int sorahNum,
    pageNum,
    nomPageF,
    nomPageL,
    lastRead,
  ) async {
    try {
      int? bookmark = await bookmarksTextController.addBookmarksText(
        BookmarksText(
          id,
          sorahName,
          sorahNum,
          pageNum,
          nomPageF,
          nomPageL,
          lastRead,
        ),
      );
      print('bookmark number: ${bookmark!}');
    } catch (e) {
      print('Error');
    }
  }

  addBookmarkAyahText(
    String sorahName,
    int sorahNum,
    ayahNum,
    nomPageF,
    nomPageL,
    lastRead,
  ) async {
    try {
      int? bookmark = await bookmarksTextAyahController.addBookmarksTextAyah(
        BookmarksTextAyah(
          id,
          sorahName,
          sorahNum,
          ayahNum,
          nomPageF,
          nomPageL,
          lastRead,
        ),
      );
      print('bookmark number: ${bookmark!}');
    } catch (e) {
      print('Error');
    }
  }

  addBookmarkText2(
    String sorahName,
    int sorahNum,
    pageNum,
    nomPageF,
    nomPageL,
    lastRead,
  ) async {
    try {
      int? bookmark = await bookmarksTextController.addBookmarksText(
        BookmarksText(
          id,
          sorahName,
          sorahNum,
          pageNum,
          nomPageF,
          nomPageL,
          lastRead,
        ),
      );
      print('bookmark number: ${bookmark!}');
    } catch (e) {
      print('Error');
    }
  }

  /// Time
  // var now = DateTime.now();
  String lastRead =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  /// scroll
  void toggleScroll(var widget) {
    if (scrolling) {
      // Stop scrolling
      animationController.stop();
    } else {
      // Calculate the new duration
      double newDuration = ((widget.surah!.ayahs!.length -
              (animationController.value * widget.surah!.ayahs!.length)
                  .round()) /
          scrollSpeedNotifier!.value);

      // Check if the calculated value is finite and not NaN
      if (newDuration.isFinite && !newDuration.isNaN) {
        // Start scrolling
        animationController.duration = Duration(seconds: newDuration.round());
        animationController.forward();
      }
    }
    // setState(() {
    scrolling = !scrolling;

    if (scrolling) {
      animationController.addListener(scroll);
    } else {
      animationController.removeListener(scroll);
    }
    // });
  }

  void scroll() {
    scrollController.jumpTo(animationController.value *
        (scrollController.position.maxScrollExtent));
  }

  jumbToPage(var widget) async {
    int pageNum = widget.pageNum ??
        0; // Use the null coalescing operator to ensure pageNum is not null

    if (pageNum == 0 ||
        pageNum == 1 ||
        pageNum == 585 ||
        pageNum == 586 ||
        pageNum == 587 ||
        pageNum == 589 ||
        pageNum == 590 ||
        pageNum == 591 ||
        pageNum == 592 ||
        pageNum == 593 ||
        pageNum == 594 ||
        pageNum == 595 ||
        pageNum == 596 ||
        pageNum == 597 ||
        pageNum == 598 ||
        pageNum == 599 ||
        pageNum == 600 ||
        pageNum == 601 ||
        pageNum == 602 ||
        pageNum == 603 ||
        pageNum == 604) {
    } else {
      await itemScrollController.scrollTo(
          index: (value.value == 1 ? pageNum : pageNum - 1),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
      audioController.ayahSelected = value.value == 1 ? pageNum : pageNum - 1;
    }
  }
}
