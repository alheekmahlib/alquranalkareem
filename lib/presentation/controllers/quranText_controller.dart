import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_pref_services.dart';
import '../../core/utils/constants/svg_picture.dart';
import '../screens/quran_text/data/models/Ahya.dart';
import '../screens/quran_text/data/models/QuranModel.dart';
import '/core/utils/constants/shared_preferences_constants.dart';
import 'ayat_controller.dart';
import 'surahTextController.dart';

class QuranTextController extends GetxController {
  int? id;
  // List<InlineSpan> text = [];
  String translateAyah = '';
  String translate = '';
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

  RxBool selected = false.obs;
  String? juz;
  String? juz2;
  bool? sajda;
  bool? sajda2;
  RxInt value = 0.obs;
  Color? backColor;
  double scrollSpeed = 0.05;
  bool scrolling = false;
  late AnimationController animationController;
  ValueNotifier<double>? scrollSpeedNotifier;
  List<List<List<Ayahs>>> surahPagesList = [];
  int currentSurahIndex = 1;
  List<List<Ayahs>> surahsAyahs = [];
  List<Ayahs> get currentSurahAyahs => surahsAyahs[currentSurahIndex];

  ayahText(SurahText surah) {
    int ayahLength = surah.ayahs!.length;
    for (int index = 0; index < ayahLength; index++) {
      if (surah.ayahs![index].text!.length > 1) {
        sajda2 = surah.ayahs![index].sajda;
        sl<AyatController>().surahTextNumber.value = surah.number!.toString();
        sl<AyatController>().ayahTextNumber.value =
            surah.ayahs![index].numberInSurah.toString();
        // lastAyah = textController.currentSurahAyahs.last.numberInSurah;
      }
    }
  }

  List<Ayahs> currentPageAyahText(int pageNumber) {
    return surahPagesList[currentSurahIndex][pageNumber];
  }

  @override
  void onInit() {
    super.onInit();
    // setSurahsPages();
  }

  Widget besmAllahWidget(SurahText? surah, int index) {
    return surah!.number == 9 || surah.number == 1
        ? const SizedBox.shrink()
        : surah.ayahs![index].numberInSurah == 1
            ? (surah.number == 95 || surah.number == 97)
                ? besmAllah2()
                : besmAllah()
            : const SizedBox.shrink();
  }

  void setSurahsPages() {
    for (final surah in sl<SurahTextController>().surahs) {
      List<Ayahs> allAyahs = [];

      for (final ayah in surah.ayahs!) {
        allAyahs.add(ayah);
      }
      for (int i = 1; i <= 604; i++) {
        surahsAyahs.add(allAyahs.where((ayah) => ayah.page == i).toList());
      }
      // List<> surahAyah
      List<Ayahs> tempAyahs = [];
      List<List<Ayahs>> tempSurah = [];

      for (int i = 1; i <= 114; i++) {
        surahPagesList.add(surahsAyahs
            .where((ayah) => getSurahNumberByAyah(ayah.first.number!) == i)
            .toList());
        int tempNumber = surahsAyahs[i].first.pageInSurah!;
        for (int l = 0; l <= tempNumber; l++) {
          tempAyahs.add(surahsAyahs[i][l]);
        }
        // surahPagesList.add(surahPages[i].where((e) => e. == i).toList());
        tempSurah.add(tempAyahs);
        surahPagesList.add(tempSurah);
      }
    }
    print('it wooooooooooooooooooooooooooooooorks');
  }

  int getSurahNumberByAyah(int ayahNumber) {
    return sl<SurahTextController>()
        .surahs
        .firstWhere((surah) => surah.ayahs!.first.number == ayahNumber)
        .number!;
  }

  /// Shared Preferences
  // Save & Load Last Page For Quran Text
  // Future<void> saveTextLastPlace(
  //     int textCurrentPage, String lastTime, sorahTextName) async {
  //   textCurrentPage = TextPageView.textCurrentPage;
  //   lastTime = TextPageView.lastTime;
  //   sorahTextName = TextPageView.sorahTextName;
  //   SharedPreferences prefService = await SharedPreferences.getInstance();
  //   await prefService.setInt("last_page", textCurrentPage);
  //   await prefService.setString("last_time", lastTime);
  //   await prefService.setString("last_sorah_name", sorahTextName);
  // }
  //
  // Future<void> loadTextCurrentPage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   TextPageView.textCurrentPage = prefs.getInt('last_page') ?? 1;
  //   TextPageView.lastTime = prefs.getString('last_time') ?? '';
  //   TextPageView.sorahTextName = prefs.getString('last_sorah_name') ?? '';
  //   print('get ${prefs.getInt('last_page')}');
  // }
  //
  // textPageChanged(int textCurrentPage, String lastTime, sorahTextName) {
  //   saveTextLastPlace(TextPageView.textCurrentPage, TextPageView.lastTime,
  //       TextPageView.sorahTextName);
  // }

  Future<void> loadSwitchValue() async {
    value.value = await sl<SharedPrefServices>()
        .getInteger(SWITCH_VALUE, defaultValue: 0);
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

  // addBookmarkText2(
  //   String sorahName,
  //   int sorahNum,
  //   pageNum,
  //   nomPageF,
  //   nomPageL,
  //   lastRead,
  // ) async {
  //   try {
  //     int? bookmark = await sl<BookmarksTextController>().addBookmarksText(
  //       BookmarksText(
  //         id,
  //         sorahName,
  //         sorahNum,
  //         pageNum,
  //         nomPageF,
  //         nomPageL,
  //         lastRead,
  //       ),
  //     );
  //     print('bookmark number: ${bookmark!}');
  //   } catch (e) {
  //     print('Error');
  //   }
  // }

  /// Time
  // var now = DateTime.now();
  // String lastRead =
  //     "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

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

  // jumbToPage(var pageNumber) async {
  //   int pageNum = pageNumber ??
  //       0; // Use the null coalescing operator to ensure pageNum is not null
  //
  //   if (pageNum == 0 ||
  //       pageNum == 1 ||
  //       pageNum == 585 ||
  //       pageNum == 586 ||
  //       pageNum == 587 ||
  //       pageNum == 589 ||
  //       pageNum == 590 ||
  //       pageNum == 591 ||
  //       pageNum == 592 ||
  //       pageNum == 593 ||
  //       pageNum == 594 ||
  //       pageNum == 595 ||
  //       pageNum == 596 ||
  //       pageNum == 597 ||
  //       pageNum == 598 ||
  //       pageNum == 599 ||
  //       pageNum == 600 ||
  //       pageNum == 601 ||
  //       pageNum == 602 ||
  //       pageNum == 603 ||
  //       pageNum == 604) {
  //   } else {
  //     await itemScrollController.scrollTo(
  //         index: (value.value == 1 ? pageNum + 1 : pageNum - 1),
  //         duration: const Duration(seconds: 1),
  //         curve: Curves.easeOut);
  //     sl<AudioController>().ayahSelected.value =
  //         value.value == 1 ? pageNum : pageNum - 1;
  //   }
  // }
}
