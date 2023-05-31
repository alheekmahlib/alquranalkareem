
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../quran_page/data/model/ayat.dart';
import '../../quran_page/data/model/translate.dart';
import '../../quran_page/data/repository/translate_repository.dart';
import '../bookmarksTextAyah_controller.dart';
import '../bookmarksText_controller.dart';
import '../model/bookmark_text.dart';

import '../model/bookmark_text_ayah.dart';
import '../text_page_view.dart';


part 'quran_text_state.dart';

class QuranTextCubit extends Cubit<QuranTextState> {
  QuranTextCubit() : super(QuranTextInitial());

  static QuranTextCubit get(context) => BlocProvider.of(context);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final BookmarksTextController bookmarksTextController =
  Get.put(BookmarksTextController());
  late final BookmarksTextAyahController bookmarksTextAyahController =
  Get.put(BookmarksTextAyahController());
  late Animation<Offset> offset;
  late AnimationController controller;
  int? id;
  String? ayahNum;
  String? sorahName;
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
  int isSelected = -1;
  bool selected = false;
  String? juz;
  String? juz2;
  bool? sajda;
  bool? sajda2;
  int value = 0;
  var trans;
  late int transValue;
  double scrollSpeed = 0.05;
  bool scrolling = false;
  late AnimationController animationController;
  ValueNotifier<double>? scrollSpeedNotifier;




  void updateTextText(String ayatext, String translate) {
    // print("updateTextText called with: $ayatext, $translate");
    emit(TextTextUpdated(ayatext, translate));
  }

  void getNewTranslationAndNotify(BuildContext context, int selectedSurahNumber, int selectedAyahNumber) async {
    List<Ayat> ayahs = await handleRadioValueChanged(context, QuranCubit.get(context).radioValue).getAyahTranslate(selectedSurahNumber);

    // Now you have a list of ayahs of the Surah. Find the Ayah with the same number as the previously selected Ayah.
    Ayat selectedAyah = ayahs.firstWhere((ayah) => ayah.ayaNum == selectedAyahNumber);

    // Update the text with the Ayah text and its translation
    updateTextText("${selectedAyah.ayatext}", "${selectedAyah.translate}");
  }

  /// Shared Preferences

  // Save & Load Last Page For Quran Text
  saveTextLastPlace(int textCurrentPage, String lastTime, sorahTextName) async {
    textCurrentPage = TextPageView.textCurrentPage;
    lastTime = TextPageView.lastTime;
    sorahTextName = TextPageView.sorahTextName;
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setInt("last_page", textCurrentPage);
    await prefService.setString("last_time", lastTime);
    await prefService.setString("last_sorah_name", sorahTextName);
  }

  loadTextCurrentPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TextPageView.textCurrentPage = prefs.getInt('last_page') ?? 1;
    TextPageView.lastTime = prefs.getString('last_time') ?? '';
    TextPageView.sorahTextName = prefs.getString('last_sorah_name') ?? '';
    print('get ${prefs.getInt('last_page')}');
  }

  // Save & Load Last Switch Page For Quran Text
  saveSwitchValue(int switchValue) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("switchـvalue", switchValue);
    emit(SharedPreferencesState());
  }
  loadSwitchValue() async {
    SharedPreferences prefs = await _prefs;
    value = prefs.getInt('switchـvalue') ?? 0;
    print('switchـvalue $value');
    emit(SharedPreferencesState());
  }

  // Save & Load Scroll Speed For Quran Text
  saveScrollSpeedValue(double scroll) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("scroll_speed", scroll);
    emit(SharedPreferencesState());
  }
  loadScrollSpeedValue() async {
    SharedPreferences prefs = await _prefs;
    scrollSpeed = prefs.getDouble('scroll_speed') ?? .05;
    print('scroll_speed $scrollSpeed');
    emit(SharedPreferencesState());
  }

  // Save & Load Translate For Quran Text
  saveTranslateValue(int translateValue) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("translateـvalue", translateValue);
    emit(SharedPreferencesState());
  }
  loadTranslateValue() async {
    SharedPreferences prefs = await _prefs;
    transValue = prefs.getInt('translateـvalue') ?? 0;
    print('translateـvalue $transValue');
    emit(SharedPreferencesState());
  }

  textPageChanged(int textCurrentPage, String lastTime, sorahTextName) {
    saveTextLastPlace(TextPageView.textCurrentPage, TextPageView.lastTime,
        TextPageView.sorahTextName);
  }


  changeSelectedIndex(newValue) {

    isSelected = newValue;
    emit(ChangeSelectedIndexState());
  }


  String? tableName;

  handleRadioValueChanged(BuildContext context, int val) {
    TranslateRepository translateRepository = TranslateRepository(context);

    radioValue = val;
    switch (radioValue) {
      case 0:
        tableName = Translate.tableName2;
        return showTaf = translateRepository;
      case 1:
        tableName = Translate.tableName;
        return showTaf = translateRepository;
      case 2:
        tableName = Translate.tableName3;
        return showTaf = translateRepository;
      case 3:
        tableName = Translate.tableName4;
        return showTaf = translateRepository;
      case 4:
        tableName = Translate.tableName5;
        return showTaf = translateRepository;
      default:
        tableName = Translate.tableName2;
        return showTaf = translateRepository;
    }
  }

  translateHandleRadioValueChanged(int translateVal) {

    transValue = translateVal;
    switch (transValue) {
      case 0:
        return trans = 'en';
      case 1:
        return trans = 'es';
      default:
        return trans = 'en';
    }
  }


  addBookmarkText(String sorahName, int sorahNum, pageNum, nomPageF, nomPageL, lastRead,) async {
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

  addBookmarkAyahText(String sorahName, int sorahNum, ayahNum, nomPageF, nomPageL, lastRead,) async {
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

  addBookmarkText2(String sorahName, int sorahNum, pageNum, nomPageF, nomPageL, lastRead,) async {
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
  String lastRead = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  /// scroll
  void toggleScroll(var widget) {
    if (scrolling) {
      // Stop scrolling
      animationController.stop();
    } else {
      // Calculate the new duration
      double newDuration = ((widget.surah!.ayahs!.length -
          (animationController.value *
              widget.surah!.ayahs!.length)
              .round()) /
          scrollSpeedNotifier!.value);

      // Check if the calculated value is finite and not NaN
      if (newDuration.isFinite && !newDuration.isNaN) {
        // Start scrolling
        animationController.duration =
            Duration(seconds: newDuration.round());
        animationController.forward();
      }
    }
    // setState(() {
      scrolling =
      !scrolling;

      if (scrolling) {
        animationController.addListener(scroll);
      } else {
        animationController.removeListener(scroll);
      }
    // });
  }

  void scroll() {
    scrollController.jumpTo(
        animationController.value *
            (scrollController
                .position
                .maxScrollExtent));
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
          index:
          (value == 1 ? pageNum : pageNum - 1),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut);
      // setState(() {
        isSelected =
        value == 1 ? pageNum : pageNum - 1;
      // });
    }
  }
}
