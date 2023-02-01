import 'dart:async';
import 'package:alquranalkareem/azkar/screens/azkar_item.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/quran_page/screens/quran_page.dart';
import 'package:alquranalkareem/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../quran_page/data/model/aya.dart';
import '../quran_page/data/model/sorah.dart';
import '../quran_page/data/repository/aya_repository.dart';
import '../quran_page/data/repository/sorah_repository.dart';
import '../quran_page/data/repository/translate2_repository.dart';
import '../quran_page/data/repository/translate3_repository.dart';
import '../quran_page/data/repository/translate4_repository.dart';
import '../quran_page/data/repository/translate5_repository.dart';
import '../quran_page/data/repository/translate_repository.dart';
import '../quran_text/text_page_view.dart';
import '../shared/widgets/audio_widget.dart';
import '../shared/widgets/show_tafseer.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';




class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(SoundPageState());

  static QuranCubit get(context) => BlocProvider.of(context);


  SorahRepository sorahRepository = SorahRepository();
  AyaRepository ayaRepository = AyaRepository();
  List<Sorah>? sorahList;
  List<Aya>? ayaList;
  late PageController pageController;
  late int currentPage;
  int? current;
  late int currentIndex;
  bool isShowControl = true;
  bool isShowBookmark = true;
  String translateAyah = '';
  String translate = '';
  String textTranslate = '';
  String? value;
  double? height;
  double width = 800;
  double height2 = 2000;
  double width2 = 4000;
  String? title;
  bool? isPageNeedChange;
  late int radioValue;
  int? tafseerValue;
  int tafIbnkatheer = 1;
  int tafBaghawy = 2;
  int tafQurtubi = 3;
  int tafSaadi = 4;
  int tafTabari = 5;
  var showTaf;
  late Database database;
  PageController? dPageController;
  String? lastSorah;

  ///The controller of sliding up panel
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late AnimationController controller;
  late Animation<Offset> offset;
  SharedPreferences? prefs;
  String? sorahName;
  String? soMName;
  Locale? initialLang;
  bool opened = false;
  late int cuMPage;
  late int lastBook;




  /// Shared Preferences
  // Save & Load Last Page For Quran Page
  saveMLastPlace(int currentPage, String lastSorah) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("mstart_page", currentPage);
    await prefs.setString("mLast_sorah", lastSorah);
    emit(SharedPreferencesState());
  }
  loadMCurrentPage() async {
    SharedPreferences prefs = await _prefs;
    cuMPage = (prefs.getInt('mstart_page') == null ? 1 : prefs.getInt('mstart_page'))!;
    soMName = prefs.getString('mLast_sorah') ?? 'لا يوجد';
    print('cuMPage $cuMPage');
    print('last_sorah ${prefs.getString('mLast_sorah')}');
    emit(SharedPreferencesState());
  }

  // Save & Load Font Size
  saveTafseer(int radioValue) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("tafseer_val", radioValue);
    emit(SharedPreferencesState());
  }

  loadTafseer() async {
    SharedPreferences prefs = await _prefs;
    radioValue = prefs.getInt('tafseer_val') ?? 0;
    print('get tafseer value ${prefs.getInt('tafseer_val')}');
    print('get radioValue $radioValue');
    emit(SharedPreferencesState());
  }

  // Save & Load Last Bookmark
  savelastBookmark(int Value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("last_bookmark", Value);
    emit(SharedPreferencesState());
  }

  Future<int> loadlastBookmark() async {
    SharedPreferences prefs = await _prefs;
    lastBook = prefs.getInt('last_bookmark') ?? 0;
    print('get last_bookmark ${prefs.getInt('last_bookmark')}');
    print('get radioValue $lastBook');
    // emit(SharedPreferencesState());
    return lastBook;
  }

  // Save & Load Tafseer Font Size
  saveFontSize(double fontSizeArabic) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_size", fontSizeArabic);
    emit(SharedPreferencesState());
  }
  loadFontSize() async {
    SharedPreferences prefs = await _prefs;
    ShowTafseer.fontSizeArabic = prefs.getDouble('font_size') ?? 18;
    print('get font size ${prefs.getDouble('font_size')}');
    emit(SharedPreferencesState());
  }

  // Save & Load Quran Text Font Size
  saveQuranFontSize(double fontSizeArabic) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_quran_size", fontSizeArabic);
    emit(SharedPreferencesState());
  }
  loadQuranFontSize() async {
    SharedPreferences prefs = await _prefs;
    TextPageView.fontSizeArabic = prefs.getDouble('font_quran_size') ?? 18;
    print('get font size ${prefs.getDouble('font_quran_size')}');
    emit(SharedPreferencesState());
  }

  // Save & Load Azkar Text Font Size
  saveAzkarFontSize(double fontSizeAzkar) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_azkar_size", fontSizeAzkar);
    emit(SharedPreferencesState());
  }
  loadAzkarFontSize() async {
    SharedPreferences prefs = await _prefs;
    AzkarItem.fontSizeAzkar = prefs.getDouble('font_azkar_size') ?? 18;
    print('get font size ${prefs.getDouble('font_azkar_size')}');
    emit(SharedPreferencesState());
  }

  // Save & Load Last Page For Quran Page
  saveLang(String lan) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString("lang", lan);
    emit(SharedPreferencesState());
  }
  loadLang() async {
    SharedPreferences prefs = await _prefs;
    initialLang = prefs.getString("lang") == null ? const Locale('ar', 'AE')
        : Locale(prefs.getString("lang")!);
    print('get lang $initialLang');
    emit(SharedPreferencesState());
  }




  showControl() {
    isShowControl = !isShowControl;
    emit(QuranPageState());
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
          // translate = '${aya!.translate}';
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



  void initState() {
    loadMCurrentPage();
    MPages.currentPage2 = cuMPage;
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
          scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    isShowControl = false;
    isShowBookmark = false;
    title = null;
    isPageNeedChange = false;
    currentIndex = DPages.currentPage2 - 1;
    getList();
    loadLang();
    emit(QuranPageState());
  }




  getList() async {
    sorahRepository.all().then((values) {
      sorahList = values;
    });
    ayaRepository.all().then((values) {
      ayaList = values;
    });

  }

  pageChanged(BuildContext context, int index) {
    print("on Page Changed $index");
    DPages.currentPage2 = index + 1;
    MPages.currentPage2 = index + 1;
    cuMPage = index + 1;
    // cuDPage = index + 1;
    DPages.currentIndex2 = index;
    currentIndex = index;
    isShowControl = false;
    isShowBookmark = false;
    controller.forward();
    emit(SoundPageState());
  }


  @override
  void dispose() {
    dPageController?.dispose();
    emit(QuranPageState());
  }


  bool isShowBottomSheet = false;
  IconData searchFabIcon = Icons.search_outlined;
  IconData sorahFabIcon = Icons.list_alt_outlined;
  IconData bookmarksFabIcon = Icons.bookmarks_outlined;



  void sorahCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isShowBottomSheet = isShow;
    sorahFabIcon = icon;
    emit(CloseBottomShowState());
  }
  void searchCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isShowBottomSheet = isShow;
    searchFabIcon = icon;
    emit(CloseBottomShowState());
  }
  void sorahChangeBottomSheetState({
  required bool isShow,
    required IconData icon,
}){
    isShowBottomSheet = isShow;
    sorahFabIcon = icon;
    emit(ChangeBottomShowState());
  }
  void searchChangeBottomSheetState({
  required bool isShow,
    required IconData icon,
}){
    isShowBottomSheet = isShow;
    searchFabIcon = icon;
    emit(ChangeBottomShowState());
  }


  /// Time

  // var now = DateTime.now();
  String lastRead = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";


}
