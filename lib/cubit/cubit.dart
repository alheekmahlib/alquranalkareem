import 'dart:async';

import 'package:alquranalkareem/azkar/screens/azkar_item.dart';
import 'package:alquranalkareem/cubit/states.dart';
import 'package:alquranalkareem/quran_page/data/model/ayat.dart';
import 'package:alquranalkareem/quran_page/screens/quran_page.dart';
import 'package:alquranalkareem/shared/controller/ayat_controller.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../l10n/app_localizations.dart';
import '../quran_text/text_page_view.dart';
import '../screens/menu_screen.dart';
import '../shared/local_notifications.dart';
import '../shared/reminder_model.dart';
import '../shared/widgets/show_tafseer.dart';
import '../shared/widgets/widgets.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(SoundPageState());
  static QuranCubit get(context) => BlocProvider.of<QuranCubit>(context);
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
  BuildContext? context;

  ///The controller of sliding up panel
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  SlidingUpPanelController panelTextController = SlidingUpPanelController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late AnimationController controller;
  late Animation<Offset> offset;
  SharedPreferences? prefs;
  String? sorahName;

  Locale? initialLang;
  bool opened = false;
  late int cuMPage;

  String greeting = '';
  TimeOfDay? changedTimeOfDay;
  bool isReminderEnabled = false;
  Time time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;
  List<Reminder> reminders = [];
  bool selected = false;
  ArabicNumbers arabicNumber = ArabicNumbers();
  AnimationController? screenController;
  Animation<double>? screenAnimation;
  String? translation;
  int? shareTafseerValue;
  int? transIndex;
  bool isShowSettings = false;
  int? audioChoise;
  late final AyatController ayatController = Get.put(AyatController());

  void updateText(String ayatext, String translate) {
    emit(TextUpdated(ayatext, translate));
  }

  Future<void> getTranslatedPage(int pageNum, BuildContext context) async {
    // emit(AyaLoading());
    try {
      // ignore: unused_local_variable
      final ayahList = await ayatController
          .handleRadioValueChanged(ayatController.radioValue)
          .getPageTranslate(pageNum);
      // emit(AyaLoaded(ayahList));
    } catch (e) {
      emit(AyaError("Error fetching Translated Page: $e"));
    }
  }

  Future<void> getTranslatedAyah(int pageNum, BuildContext context) async {
    emit(AyaLoading());
    try {
      final ayahList = await ayatController
          .handleRadioValueChanged(ayatController.radioValue)
          .getAyahTranslate(pageNum);
      emit(AyaLoaded(ayahList));
    } catch (e) {
      emit(AyaError("Error fetching Translated Page: $e"));
    }
  }

  Ayat? getAyaByIndex(int index) {
    if (state is AyaLoaded) {
      return (state as AyaLoaded).ayahList.elementAt(index);
    }
    return null;
  }

  void updateTranslation(String newTranslateAyah, String newTranslate) {
    emit(TranslationUpdatedState(
        translateAyah: newTranslateAyah, translate: newTranslate));
  }

  void getNewTranslationAndNotify(BuildContext context, int selectedSurahNumber,
      int selectedAyahNumber) async {
    List<Ayat> ayahs = await ayatController
        .handleRadioValueChanged(ayatController.radioValue)
        .getAyahTranslate(selectedSurahNumber);

    // Now you have a list of ayahs of the Surah. Find the Ayah with the same number as the previously selected Ayah.
    Ayat selectedAyah =
        ayahs.firstWhere((ayah) => ayah.ayaNum == selectedAyahNumber);

    // Update the text with the Ayah text and its translation
    updateText("${selectedAyah.ayatext}", "${selectedAyah.translate}");
  }

  // Save & Load Font Size
  saveTafseer(int radioValue) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("tafseer_val", radioValue);
    emit(SharedPreferencesState());
  }

  loadTafseer() async {
    SharedPreferences prefs = await _prefs;
    ayatController.radioValue = prefs.getInt('tafseer_val') ?? 0;
    print('get tafseer value ${prefs.getInt('tafseer_val')}');
    print('get radioValue ${ayatController.radioValue}');
    emit(SharedPreferencesState());
  }

  // Save & Load Tafseer Font Size
  saveFontSize(double fontSizeArabic) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_size", fontSizeArabic);
    // emit(SharedPreferencesState());
  }

  loadFontSize() async {
    SharedPreferences prefs = await _prefs;
    ShowTafseer.fontSizeArabic = prefs.getDouble('font_size') ?? 18;
    print('get font size ${prefs.getDouble('font_size')}');
    // emit(SharedPreferencesState());
  }

  // Save & Load Quran Text Font Size
  saveQuranFontSize(double fontSizeArabic) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_quran_size", fontSizeArabic);
    emit(SharedPreferencesState());
  }

  loadQuranFontSize() async {
    SharedPreferences prefs = await _prefs;
    TextPageView.fontSizeArabic = prefs.getDouble('font_quran_size') ?? 24;
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
    initialLang = prefs.getString("lang") == null
        ? const Locale('ar', 'AE')
        : Locale(prefs.getString("lang")!);
    print('get lang $initialLang');
    emit(SharedPreferencesState());
  }

// Save & Load Reminder Time
  saveReminderTime(int time) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("reminder_time", time);
    emit(SharedPreferencesState());
  }

  loadReminderTime() async {
    SharedPreferences prefs = await _prefs;
    // changedTimeOfDay = prefs.getString('reminder_time') ?? '1';
    print('cuMPage $cuMPage');
    print('last_sorah ${prefs.getString('mLast_sorah')}');
    emit(SharedPreferencesState());
  }

  // Clear SharedPreferences
  clear(String Value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.remove(Value);
    emit(SharedPreferencesState());
  }

  showControl() {
    isShowControl = !isShowControl;
    emit(QuranPageState());
  }

  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
    emit(greetingState());
  }

  void initState() {
    // MPages.currentPage2 = cuMPage;
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
    loadLang();
    emit(QuranPageState());
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

  void dispose() {
    dPageController?.dispose();
    screenController!.dispose();
    panelController.dispose();
    emit(QuranPageState());
  }

  /// Time
  // var now = DateTime.now();
  String lastRead =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  /// Reminder
  void loadReminders() async {
    List<Reminder> loadedReminders = await ReminderStorage.loadReminders();
    reminders = loadedReminders;
    emit(LoadRemindersState());
  }

  Future<bool> showTimePicker(BuildContext context, Reminder reminder) async {
    QuranCubit cubit = QuranCubit.get(context);
    bool isConfirmed = false;
    Time initialTime = time;
    TimeOfDay initialTimeOfDay =
        TimeOfDay(hour: initialTime.hour, minute: initialTime.minute);

    await Navigator.of(context).push(
      showPicker(
        context: context,
        value: time,
        onChange: (time) {
          cubit.changedTimeOfDay = time;
          print(cubit.changedTimeOfDay);
        },
        accentColor: Theme.of(context).colorScheme.surface,
        okText: AppLocalizations.of(context)!.ok,
        okStyle: TextStyle(
          fontFamily: 'kufi',
          fontSize: 14,
          color: Theme.of(context).colorScheme.surface,
        ),
        cancelText: AppLocalizations.of(context)!.cancel,
        cancelStyle: TextStyle(
            fontFamily: 'kufi',
            fontSize: 14,
            color: Theme.of(context).colorScheme.surface),
        themeData: ThemeData(
          cardColor: Theme.of(context).colorScheme.background,
        ),
      ),
    );

    if (cubit.changedTimeOfDay != null &&
        cubit.changedTimeOfDay != initialTimeOfDay) {
      final int hour = cubit.changedTimeOfDay!.hour;
      final int minute = cubit.changedTimeOfDay!.minute;
      // Update the reminder's time
      reminder.time = Time(hour: hour, minute: minute);
      emit(ShowTimePickerState());
      // Schedule the notification with the reminder's ID
      await NotifyHelper().scheduledNotification(
          context, reminder.id, hour, minute, reminder.name);
      isConfirmed = true;
    }

    return isConfirmed;
  }

  Future<void> addReminder() async {
    String reminderName = "";

    DateTime now = DateTime.now();
    Time currentTime = Time(hour: now.hour, minute: now.minute);

    reminders.add(Reminder(
        id: reminders.length,
        isEnabled: false,
        time: currentTime,
        name: reminderName));
    emit(AddReminderState());
    ReminderStorage.saveReminders(reminders);
  }

  deleteReminder(BuildContext context, int index) async {
    // Cancel the scheduled notification
    await NotifyHelper().cancelScheduledNotification(reminders[index].id);

    // Delete the reminder
    await ReminderStorage.deleteReminder(index).then((value) =>
        customSnackBar(context, AppLocalizations.of(context)!.deletedReminder));

    // Update the reminders list
    reminders.removeAt(index);
    emit(DeleteReminderState());

    // Update the reminder IDs
    for (int i = index; i < reminders.length; i++) {
      reminders[i].id = i;
    }

    // Save the updated reminders list
    ReminderStorage.saveReminders(reminders);
  }

  void onTimeChanged(Time newTime) {
    time = newTime;
    emit(OnTimeChangedState());
  }
}
