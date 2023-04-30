import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:alquranalkareem/azkar/screens/azkar_item.dart';
import 'package:alquranalkareem/quran_page/screens/quran_page.dart';
import 'package:alquranalkareem/cubit/states.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bloc/bloc.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< Updated upstream
=======
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
>>>>>>> Stashed changes
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:theme_provider/theme_provider.dart';
import '../l10n/app_localizations.dart';
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
<<<<<<< Updated upstream
=======
import '../screens/menu_screen.dart';
import '../shared/local_notifications.dart';
import '../shared/reminder_model.dart';
>>>>>>> Stashed changes
import '../shared/widgets/show_tafseer.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../shared/widgets/widgets.dart';




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
  String greeting = '';
  TimeOfDay? changedTimeOfDay;
  bool isReminderEnabled = false;
  Time time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;
  List<Reminder> reminders = [];
  bool selected = false;
  ArabicNumbers arabicNumber = ArabicNumbers();




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
    soMName = prefs.getString('mLast_sorah') ?? '1';
    print('cuMPage $cuMPage');
    print('last_sorah ${prefs.getString('mLast_sorah')}');
    emit(loadMCurrentPageState());
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
    initialLang = prefs.getString("lang") == null ? const Locale('ar', 'AE')
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

  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
    emit(greetingState());
  }

  void initState() {
    loadMCurrentPage();
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
    TimeOfDay initialTimeOfDay = TimeOfDay(hour: initialTime.hour, minute: initialTime.minute);


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

    if (cubit.changedTimeOfDay != null && cubit.changedTimeOfDay != initialTimeOfDay) {
      final int hour = cubit.changedTimeOfDay!.hour;
      final int minute = cubit.changedTimeOfDay!.minute;
      // Update the reminder's time
        reminder.time = Time(hour: hour, minute: minute);
      emit(ShowTimePickerState());
      // Schedule the notification with the reminder's ID
      await NotifyHelper().scheduledNotification(context, reminder.id, hour, minute, reminder.name);
      isConfirmed = true;
    }

    return isConfirmed;
  }

  // void _addReminder() {
  //   DateTime now = DateTime.now();
  //   setState(() {
  //     reminders.add(Reminder(id: reminders.length, isEnabled: false, time: Time(hour: now.hour, minute: now.minute)));
  //   });
  //   ReminderStorage.saveReminders(reminders);
  // }

  Future<void> addReminder() async {
    String reminderName = "";

    DateTime now = DateTime.now();
    Time currentTime = Time(hour: now.hour, minute: now.minute);

      reminders.add(Reminder(id: reminders.length, isEnabled: false, time: currentTime, name: reminderName));
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

  /// Share Ayah
  Future<Uint8List> createVerseImage(int verseNumber,
      surahNumber, String verseText) async {
    // Set a fixed canvas width
    const canvasWidth = 960.0;
    const fixedWidth = canvasWidth;

    final textPainter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$verseText',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: const Color(0xff161f07),
              ),
            ),
            TextSpan(
              text: ' ${arabicNumber.convert(verseNumber)}\n',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: const Color(0xff161f07),
              ),
            ),
          ],
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.justify
    );
    textPainter.layout(maxWidth: 800);

    final padding = 32.0;
    // final imagePadding = 20.0;

    // Load the PNG image
    final pngBytes = await rootBundle.load('assets/share_images/Sorah_name_ba.png');
    final codec = await ui.instantiateImageCodec(pngBytes.buffer.asUint8List());
    final frameInfo = await codec.getNextFrame();
    final pngImage = frameInfo.image;

    // Load the second PNG image
    final pngBytes2 = await rootBundle.load('assets/share_images/surah_name/00$surahNumber.png');
    final codec2 = await ui.instantiateImageCodec(pngBytes2.buffer.asUint8List());
    final frameInfo2 = await codec2.getNextFrame();
    final pngImage2 = frameInfo2.image;

    // Calculate the image sizes and positions
    final imageWidth = pngImage.width.toDouble() / 1.0;
    final imageHeight = pngImage.height.toDouble() / 1.0;
    final imageX = (canvasWidth - imageWidth) / 2; // Center the first image
    final imageY = padding;

    final image2Width = pngImage2.width.toDouble() / 4.0;
    final image2Height = pngImage2.height.toDouble() / 4.0;
    final image2X = (canvasWidth - image2Width) / 2; // Center the second image
    final image2Y = imageHeight + padding - 90; // Adjust this value as needed

    // Set the text position
    final textX = (canvasWidth - textPainter.width) / 2; // Center the text horizontally
    final textY = image2Y + image2Height + padding + 20; // Position the text below the second image

    final pngBytes3 = await rootBundle.load('assets/share_images/Logo_line2.png');
    final codec3 = await ui.instantiateImageCodec(pngBytes3.buffer.asUint8List());
    final frameInfo3 = await codec3.getNextFrame();
    final pngImage3 = frameInfo3.image;

    // Calculate the canvas width and height
    double canvasHeight = textPainter.height + imageHeight + 3 * padding;

    // Calculate the new image sizes and positions
    final image3Width = pngImage3.width.toDouble() / 5.0;
    final image3Height = pngImage3.height.toDouble() / 5.0;
    final image3X = (canvasWidth - image3Width) / 2; // Center the image horizontally

// Calculate the position of the new image to be below the new text
    final image3Y = textPainter.height + padding + 70;

    // Calculate the minimum height
    final minHeight = imageHeight + image2Height + image3Height + 4 * padding;

    // Set the canvas width and height
    canvasHeight = textPainter.height + imageHeight + image2Height + image3Height + 5 * padding;

    // Check if the total height is less than the minimum height
    if (canvasHeight < minHeight) {
      canvasHeight = minHeight;
    }

    // Update the canvas height
    canvasHeight += image3Height + textPainter.height + 3 + padding;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight)); // Add Rect to fix the canvas size

    final borderRadius = 25.0;
    final borderPaint = Paint()
      ..color = const Color(0xff91a57d)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final backgroundPaint = Paint()..color = const Color(0xfff3efdf);

    final rRect = RRect.fromLTRBR(0, 0, canvasWidth, canvasHeight, Radius.circular(borderRadius));

    canvas.drawRRect(rRect, backgroundPaint);
    canvas.drawRRect(rRect, borderPaint);

    textPainter.paint(canvas, Offset(textX, textY));
    canvas.drawImageRect(
      pngImage,
      Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()),
      Rect.fromLTWH(imageX, imageY, imageWidth, imageHeight),
      Paint(),
    );

    canvas.drawImageRect(
      pngImage2,
      Rect.fromLTWH(0, 0, pngImage2.width.toDouble(), pngImage2.height.toDouble()),
      Rect.fromLTWH(image2X, image2Y, image2Width, image2Height),
      Paint(),
    );

    canvas.drawImageRect(
      pngImage3,
      Rect.fromLTWH(0, 0, pngImage3.width.toDouble(), pngImage3.height.toDouble()),
      Rect.fromLTWH(image3X, image3Y, image3Width, image3Height),
      Paint(),
    );


    final picture = pictureRecorder.endRecording();
    final imgWidth = canvasWidth.toInt(); // Use canvasWidth instead of (textPainter.width + 2 * padding)
    final imgHeight = (textPainter.height + imageHeight + image3Height + 4 * padding - 90).toInt();
    final imgScaleFactor = 1; // Increase this value for a higher resolution image
    final imgScaled = await picture.toImage(imgWidth * imgScaleFactor, imgHeight * imgScaleFactor);

    // Convert the image to PNG bytes
    final pngResultBytes = await imgScaled.toByteData(format: ui.ImageByteFormat.png);

    // Decode the PNG bytes to an image object
    final decodedImage = img.decodePng(pngResultBytes!.buffer.asUint8List());

    // Scale down the image to the desired resolution
    final resizedImage = img.copyResize(decodedImage!, width: imgWidth, height: imgHeight);

    // Convert the resized image back to PNG bytes
    final resizedPngBytes = img.encodePng(resizedImage);

    return resizedPngBytes;
  }

  Future<Uint8List> createVerseWithTranslateImage(BuildContext context, int verseNumber,
      surahNumber, String verseText, textTranslate,
      {double dividerWidth = 2.0,
        double textNextToDividerWidth = 100.0}) async {

    // if (textTranslate.split(' ').length > 300) {
    //   customSnackBar(context, "The translation cannot be shared because it is too long.");
    //   // Fluttertoast.showToast(
    //   //     msg: "The translation cannot be shared because it is too long.",
    //   //     toastLength: Toast.LENGTH_LONG,
    //   //     gravity: ToastGravity.BOTTOM,
    //   //     timeInSecForIosWeb: 1,
    //   //     backgroundColor: Colors.red,
    //   //     textColor: Colors.white,
    //   //     fontSize: 16.0);
    //   return Uint8List(0); // Return an empty Uint8List to indicate that no image was created
    // }
    // Set a fixed canvas width
    const canvasWidth = 960.0;
    const fixedWidth = canvasWidth;

    final textPainter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$verseText',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : const Color(0xff161f07),
              ),
            ),
            TextSpan(
              text: ' ${arabicNumber.convert(verseNumber)}\n',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : const Color(0xff161f07),
              ),
            ),
          ],
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.justify
    );
    textPainter.layout(maxWidth: 800);

    final padding = 32.0;
    // final imagePadding = 20.0;

    // Load the PNG image
    final pngBytes = await rootBundle.load('assets/share_images/Sorah_name_ba.png');
    final codec = await ui.instantiateImageCodec(pngBytes.buffer.asUint8List());
    final frameInfo = await codec.getNextFrame();
    final pngImage = frameInfo.image;

    // Load the second PNG image
    final pngBytes2 = await rootBundle.load('assets/share_images/surah_name/00$surahNumber.png');
    final codec2 = await ui.instantiateImageCodec(pngBytes2.buffer.asUint8List());
    final frameInfo2 = await codec2.getNextFrame();
    final pngImage2 = frameInfo2.image;

    // Calculate the image sizes and positions
    final imageWidth = pngImage.width.toDouble() / 1.0;
    final imageHeight = pngImage.height.toDouble() / 1.0;
    final imageX = (canvasWidth - imageWidth) / 2; // Center the first image
    final imageY = padding;

    final image2Width = pngImage2.width.toDouble() / 4.0;
    final image2Height = pngImage2.height.toDouble() / 4.0;
    final image2X = (canvasWidth - image2Width) / 2; // Center the second image
    final image2Y = imageHeight + padding - 90; // Adjust this value as needed

    // Set the text position
    final textX = (canvasWidth - textPainter.width) / 2; // Center the text horizontally
    final textY = image2Y + image2Height + padding + 20; // Position the text below the second image

    final pngBytes3 = await rootBundle.load('assets/share_images/Logo_line2.png');
    final codec3 = await ui.instantiateImageCodec(pngBytes3.buffer.asUint8List());
    final frameInfo3 = await codec3.getNextFrame();
    final pngImage3 = frameInfo3.image;

    // Calculate the canvas width and height
    double canvasHeight = textPainter.height + imageHeight + 3 * padding;

    // Calculate the new image sizes and positions
    final image3Width = pngImage3.width.toDouble() / 5.0;
    final image3Height = pngImage3.height.toDouble() / 5.0;
    final image3X = (canvasWidth - image3Width) / 2; // Center the image horizontally

    final tafseerNamePainter = TextPainter(
        text: TextSpan(
          text: AppLocalizations.of(context)!.tafSaadiN,
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: 'kufi',
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : const Color(0xff161f07),
              backgroundColor: Theme.of(context).dividerColor
          ),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center
    );
    tafseerNamePainter.layout(maxWidth: 800);

    final tafseerNameX = padding + 628;
    final tafseerNameY = textY + textPainter.height + padding - 50;

    // Calculate the position of the new image to be below the new text
    // final image3Y = tafseerNameY + tafseerNamePainter.height + padding - 20;

    // Create the new text painter
    final newTextPainter = TextPainter(
        text: TextSpan(
          text: '$textTranslate\n',
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: 'kufi',
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : const Color(0xff161f07),
              backgroundColor: const Color(0xff91a57d).withOpacity(.3)
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center
    );
    newTextPainter.layout(maxWidth: 800);

    final newTextX = padding + 50;
    final newTextY = textY + textPainter.height + padding + 20;

    // Calculate the position of the new image to be below the new text
    final image3Y = newTextY + newTextPainter.height + padding - 50;

    // Calculate the minimum height
    final minHeight = imageHeight + image2Height + image3Height + 4 * padding;

    // Set the canvas width and height
    canvasHeight = textPainter.height + newTextPainter.height + imageHeight + image2Height + image3Height + 5 * padding;

    // Check if the total height is less than the minimum height
    if (canvasHeight < minHeight) {
      canvasHeight = minHeight;
    }

    // Update the canvas height
    canvasHeight += image3Height + newTextPainter.height + 3 + padding;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight)); // Add Rect to fix the canvas size

    final borderRadius = 25.0;
    final borderPaint = Paint()
      ..color = const Color(0xff91a57d)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final backgroundPaint = Paint()..color = const Color(0xfff3efdf);

    final rRect = RRect.fromLTRBR(0, 0, canvasWidth, canvasHeight, Radius.circular(borderRadius));

    canvas.drawRRect(rRect, backgroundPaint);
    canvas.drawRRect(rRect, borderPaint);

    textPainter.paint(canvas, Offset(textX, textY));
    canvas.drawImageRect(
      pngImage,
      Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()),
      Rect.fromLTWH(imageX, imageY, imageWidth, imageHeight),
      Paint(),
    );

    canvas.drawImageRect(
      pngImage2,
      Rect.fromLTWH(0, 0, pngImage2.width.toDouble(), pngImage2.height.toDouble()),
      Rect.fromLTWH(image2X, image2Y, image2Width, image2Height),
      Paint(),
    );

    canvas.drawImageRect(
      pngImage3,
      Rect.fromLTWH(0, 0, pngImage3.width.toDouble(), pngImage3.height.toDouble()),
      Rect.fromLTWH(image3X, image3Y, image3Width, image3Height),
      Paint(),
    );

    newTextPainter.paint(canvas, Offset(newTextX, newTextY));
    tafseerNamePainter.paint(canvas, Offset(tafseerNameX, tafseerNameY));

    final picture = pictureRecorder.endRecording();
    final imgWidth = canvasWidth.toInt(); // Use canvasWidth instead of (textPainter.width + 2 * padding)
    final imgHeight = (textPainter.height + newTextPainter.height + imageHeight + image3Height + 4 * padding).toInt();
    final imgScaleFactor = 1; // Increase this value for a higher resolution image
    final imgScaled = await picture.toImage(imgWidth * imgScaleFactor, imgHeight * imgScaleFactor);

    // Convert the image to PNG bytes
    final pngResultBytes = await imgScaled.toByteData(format: ui.ImageByteFormat.png);

    // Decode the PNG bytes to an image object
    final decodedImage = img.decodePng(pngResultBytes!.buffer.asUint8List());

    // Scale down the image to the desired resolution
    final resizedImage = img.copyResize(decodedImage!, width: imgWidth, height: imgHeight);

    // Convert the resized image back to PNG bytes
    final resizedPngBytes = img.encodePng(resizedImage);

    return resizedPngBytes;
  }

  shareText(String verseText, surahName, int verseNumber) {
    Share.share(
        '﴿$verseText﴾ '
            '[$surahName-'
            '$verseNumber]',
        subject: '$surahName');
  }

  Future<void> shareVerseWithTranslate(BuildContext context, int verseNumber,
      surahNumber, String verseText, textTranslate) async {
    final imageData = await createVerseWithTranslateImage(context, verseNumber,
        surahNumber, verseText, textTranslate);

    // Save the image to a temporary directory
    final directory = await getTemporaryDirectory();
    final filename = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
    final imagePath = '${directory.path}/$filename';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData);

    if (imageFile.existsSync()) {
      await Share.shareFiles([imagePath], text: 'Sharing verse image');
    } else {
      print('Failed to save and share image');
    }
  }

  Future<void> shareVerse(int verseNumber,
      surahNumber, String verseText) async {
    final imageData2 = await createVerseImage(verseNumber,
        surahNumber, verseText);

    // Save the image to a temporary directory
    final directory = await getTemporaryDirectory();
    final filename = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
    final imagePath = '${directory.path}/$filename';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData2);

    if (imageFile.existsSync()) {
      await Share.shareFiles([imagePath], text: 'Sharing verse image');
    } else {
      print('Failed to save and share image');
    }
  }

  void showVerseOptionsBottomSheet(BuildContext context,
      int verseNumber, surahNumber, String verseText,
      textTranslate, surahName) async {
    // Call createVerseWithTranslateImage and get the image data
    Uint8List imageData = await createVerseWithTranslateImage(context, verseNumber, surahNumber, verseText, textTranslate);
    Uint8List imageData2 = await createVerseImage(verseNumber, surahNumber, verseText);

    modalBottomSheet(
      context,
      MediaQuery.of(context).size.height / 1/2,
      MediaQuery.of(context).size.width,
      Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context).dividerColor)),
                      child: Icon(
                        Icons.close_outlined,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Lottie.asset('assets/lottie/share.json',
                    width: 120),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: orientation(context, MediaQuery.of(context).size.width * .6, MediaQuery.of(context).size.width / 1/3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppLocalizations.of(context)!.shareText,
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context).id ==
                                      'dark'
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).primaryColorDark,
                                  fontSize: 16,
                                  fontFamily: 'kufi'
                              ),),
                            Container(
                              height: 2,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: MediaQuery.of(context).size.width / 1/3,
                              color: Theme.of(context).dividerColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        // height: 60,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor.withOpacity(.3),
                            borderRadius: BorderRadius.all(Radius.circular(4))
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.text_fields,
                              color: Theme.of(context).colorScheme.surface,
                              size: 24,
                            ),
                            SizedBox(
                              width: orientation(context, MediaQuery.of(context).size.width * .7, MediaQuery.of(context).size.width / 1/3),
                              child: Text("﴿ $verseText ﴾",
                                style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                        'dark'
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context).primaryColorDark,
                                    fontSize: 16,
                                    fontFamily: 'uthmanic2'
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        shareText(verseText, surahName, verseNumber);
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      width: MediaQuery.of(context).size.width * .3,
                      color: Theme.of(context).dividerColor,
                    ),
                    Wrap(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1/2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(AppLocalizations.of(context)!.shareImage,
                                  style: TextStyle(
                                      color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                          ? Theme.of(context).colorScheme.surface
                                          : Theme.of(context).primaryColorDark,
                                      fontSize: 16,
                                      fontFamily: 'kufi'
                                  ),),
                              ),
                              GestureDetector(
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * .4,
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  margin: EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor.withOpacity(.3),
                                      borderRadius: BorderRadius.all(Radius.circular(4))
                                  ),
                                  child: Image.memory(imageData2,
                                    // height: 150,
                                    // width: 150,
                                  ),
                                ),
                                onTap: () {
                                  shareVerse(
                                      verseNumber, surahNumber, verseText
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1/2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 1/3,
                                  child: Text(AppLocalizations.of(context)!.shareImageWTrans,
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                            ? Theme.of(context).colorScheme.surface
                                            : Theme.of(context).primaryColorDark,
                                        fontSize: 16,
                                        fontFamily: 'kufi'
                                    ),),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * .4,
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  margin: EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor.withOpacity(.3),
                                      borderRadius: BorderRadius.all(Radius.circular(4))
                                  ),
                                  child: Image.memory(imageData,
                                    // height: 150,
                                    // width: 150,
                                  ),
                                ),
                                onTap: () {
                                  shareVerseWithTranslate(
                                      context, verseNumber, surahNumber, verseText, textTranslate
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 1/3,
                                  child: Text(AppLocalizations.of(context)!.shareTrans,
                                    style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                            ? Theme.of(context).colorScheme.surface
                                            : Theme.of(context).primaryColorDark,
                                        fontSize: 12,
                                        fontFamily: 'kufi'
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

}
