part of '../../quran.dart';

class QuranState {
  /// -------- [Variables] ----------
  List<SurahModel> surahs = [];
  List<List<AyahModel>> pages = [];
  List<AyahModel> allAyahs = [];

  /// Page Controller
  // PageController quranPageController = PageController();
  final FocusNode quranPageRLFocusNode = FocusNode();
  final FocusNode quranPageUDFocusNode = FocusNode();
  ScrollController ScrollUpDownQuranPage = ScrollController();

  RxInt currentPageNumber = 0.obs;
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
  bool isQuranLoaded = false;
  RxInt selectedAyahNumber = 0.obs;
  RxInt selectedSurahNumber = 0.obs;
  var qPackage = QuranLibrary();
}
