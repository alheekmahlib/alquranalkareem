import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/model/surahs_model.dart';

class QuranState {
  /// -------- [Variables] ----------
  List<Surah> surahs = [];
  List<List<Ayah>> pages = [];
  List<Ayah> allAyahs = [];

  /// Page Controller
  PageController quranPageController = PageController();
  final FocusNode quranPageRLFocusNode = FocusNode();
  final FocusNode quranPageUDFocusNode = FocusNode();
  ScrollController ScrollUpDownQuranPage = ScrollController();

  RxInt currentPageNumber = 1.obs;
  RxInt lastReadSurahNumber = 1.obs;
  var selectedAyahIndexes = <int>[].obs;
  bool isSelected = false;
  final ScrollController scrollIndicatorController = ScrollController();
  final ScrollController ayahsScrollController = ScrollController();
  RxInt selectedIndicatorIndex = 0.obs;
  PreferDirection preferDirection = PreferDirection.topCenter;
  RxDouble textWidgetPosition = (-240.0).obs;
  RxBool isPlayExpanded = false.obs;
  RxBool isSajda = false.obs;
  RxInt isPages = 0.obs;
  RxInt isBold = 0.obs;
  RxBool isMoreOptions = false.obs;
  ItemScrollController itemScrollController = ItemScrollController();
  final ItemScrollController ayahsItemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  var moreOptionsMap = <String, bool>{}.obs;
  RxInt selectMushafSettingsPage = 0.obs;
  RxDouble ayahsWidgetHeight = 0.0.obs;
  RxInt currentListPage = 1.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxDouble baseScaleFactor = 1.0.obs;
  final box = GetStorage();
  int? lastDisplayedHizbQuarter;
  Map<int, int> pageToHizbQuarterMap = {};

  double surahItemHeight = 90.0;
  ScrollController? surahController;
  ScrollController? juzListController;
  RxBool isPageMode = false.obs;
  RxInt backgroundPickerColor = 0xfffaf7f3.obs;
  RxInt temporaryBackgroundColor = 0xfffaf7f3.obs;

  RxBool isScrolling = false.obs;
}
