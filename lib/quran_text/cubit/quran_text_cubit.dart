import 'dart:typed_data';

import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:meta/meta.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../quran_page/data/repository/translate2_repository.dart';
import '../../quran_page/data/repository/translate3_repository.dart';
import '../../quran_page/data/repository/translate4_repository.dart';
import '../../quran_page/data/repository/translate5_repository.dart';
import '../../quran_page/data/repository/translate_repository.dart';
import '../bookmarksTextAyah_controller.dart';
import '../bookmarksText_controller.dart';
import '../model/bookmark_text.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../model/bookmark_text_ayah.dart';


part 'quran_text_state.dart';

class QuranTextCubit extends Cubit<QuranTextState> {
  QuranTextCubit() : super(QuranTextInitial());

  static QuranTextCubit get(context) => BlocProvider.of(context);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isShowBottomSheet = false;
  IconData bookmarksFabIcon = Icons.bookmarks_outlined;
  IconData searchFabIcon = Icons.search_outlined;
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




  /// Shared Preferences
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

  changeSelectedIndex(newValue) {

    isSelected = newValue;
    emit(ChangeSelectedIndexState());
  }


  handleRadioValueChanged(int val) {
    TranslateRepository translateRepository = TranslateRepository();
    TranslateRepository2 translateRepository2 = TranslateRepository2();
    TranslateRepository3 translateRepository3 = TranslateRepository3();
    TranslateRepository4 translateRepository4 = TranslateRepository4();
    TranslateRepository5 translateRepository5 = TranslateRepository5();

    radioValue = val;
    switch (radioValue) {
      case 0:
        return showTaf = translateRepository2;
        break;
      case 1:
        return showTaf = translateRepository;
        break;
      case 2:
        return showTaf = translateRepository3;
        break;
      case 3:
        return showTaf = translateRepository4;
        break;
      case 4:
        return showTaf = translateRepository5;
        break;
      default:
        return showTaf = translateRepository2;
    }
  }

  translateHandleRadioValueChanged(int translateVal) {

    transValue = translateVal;
    switch (transValue) {
      case 0:
        return trans = 'en';
        break;
      case 1:
        return trans = 'es';
        break;
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

  void bookmarksChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(ChangeBottomShowState());
  }

  void bookmarksCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(CloseBottomShowState());
  }

  void searchTextChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    searchFabIcon = icon;
    emit(ChangeBottomShowState());
  }

  void searchTextCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    searchFabIcon = icon;
    emit(CloseBottomShowState());
  }

  void tafseerChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(ChangeBottomShowState());
  }

  void tafseerCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(CloseBottomShowState());
  }


}
