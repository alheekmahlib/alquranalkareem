import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/quran_page/data/repository/quarter_repository.dart';
import 'package:alquranalkareem/quran_text/cubit/quran_text_cubit.dart';
import 'package:alquranalkareem/quran_text/cubit/surah_text_cubit.dart';
import 'package:alquranalkareem/screens/splash_screen.dart';
import 'package:alquranalkareem/shared/lists.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:home_widget/home_widget.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:workmanager/workmanager.dart';

import 'cubit/ayaRepository/aya_cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/quarter/quarter_cubit.dart';
import 'cubit/sorahRepository/sorah_repository_cubit.dart';
import 'cubit/translateDataCubit/_cubit.dart';

/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print('Background task started: $taskName'); // Added print statement

    // Generate a random Zikr
    Set<int> usedIndices = {};
    int randomIndex;
    do {
      randomIndex = Random().nextInt(zikr.length);
    } while (usedIndices.contains(randomIndex));
    usedIndices.add(randomIndex);
    final randomZikr = zikr[randomIndex];

    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'zikr',
        randomZikr,
      ),
      HomeWidget.updateWidget(
        name: 'ZikerWidget',
        iOSName: 'ZikerWidget',
      ),
    ]).then((value) {
      print('Background task completed: $taskName'); // Added print statement
      return !value.contains(false);
    });
  });
}

/// Called when Doing Background Work initiated from Widget
@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  print(data);

  if (data!.host == 'zikr') {
    Set<int> usedIndices = {};
    int randomIndex;
    do {
      randomIndex = Random().nextInt(zikr.length);
    } while (usedIndices.contains(randomIndex));
    usedIndices.add(randomIndex);
    final randomZikr = zikr[randomIndex];

    await HomeWidget.saveWidgetData<String>('zikr', randomZikr);
    await HomeWidget.updateWidget(name: 'ZikerWidget', iOSName: 'ZikerWidget');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeData theme;

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Set<int> usedIndices = {};

  Future<void> _saveRandomZikr() async {
    if (usedIndices.length == zikr.length) {
      usedIndices.clear();
    }

    int randomIndex;
    do {
      randomIndex = Random().nextInt(zikr.length);
    } while (usedIndices.contains(randomIndex));

    usedIndices.add(randomIndex);
    final randomZikr = zikr[randomIndex];

    try {
      await HomeWidget.saveWidgetData<String>('zikr', randomZikr);
    } on PlatformException catch (exception) {
      debugPrint('Error Saving Random Zikr. $exception');
    }
  }

  Future<void> saveHijriDate() async {
    ArabicNumbers arabicNumber = ArabicNumbers();
    // HijriCalendar.setLocal('en');
    var _today = HijriCalendar.now();
    String day = "${arabicNumber.convert(_today.hDay)}";
    String year = "${arabicNumber.convert(_today.hYear)}";
    await HomeWidget.saveWidgetData<String>('hijriDay', "$day");
    await HomeWidget.saveWidgetData<String>(
        'hijriMonth', _today.hMonth.toString());
    await HomeWidget.saveWidgetData<String>('hijriYear', "$year");
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS || Platform.isAndroid) {
      // Initialize Workmanager
      final workManager = Workmanager();
      workManager.initialize(
        callbackDispatcher, // Your callbackDispatcher function
        isInDebugMode: false, // Set to false in production builds
      );
      HomeWidget.setAppGroupId('group.com.alheekmah.alquranalkareem.widget');
      saveHijriDate();
      Timer.periodic(const Duration(minutes: 1), (timer) async {
        await _saveRandomZikr();
        await _updateWidget();
      });
      HomeWidget.registerBackgroundCallback(backgroundCallback);
      // _startBackgroundUpdate();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Future<void> _updateWidget() async {
    try {
      await HomeWidget.updateWidget(
          name: 'ZikerWidget', iOSName: 'ZikerWidget');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  // void _startBackgroundUpdate() {
  //   Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
  //       frequency: const Duration(minutes: 1));
  // }
  //
  // void _stopBackgroundUpdate() {
  //   Workmanager().cancelByUniqueName('1');
  // }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Theme.of(context).primaryColorDark
    // ));
    // page.QuranCubit cubit = page.QuranCubit.get(context);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ThemeProvider(
            defaultThemeId: 'green',
            saveThemesOnChange: true,
            loadThemeOnInit: false,
            onInitCallback: (controller, previouslySavedThemeFuture) async {
              String? savedTheme = await previouslySavedThemeFuture;
              if (savedTheme != null) {
                controller.setTheme(savedTheme);
              } else {
                Brightness platformBrightness = SchedulerBinding
                        .instance.platformDispatcher.platformBrightness ??
                    Brightness.light;
                if (platformBrightness == Brightness.dark) {
                  controller.setTheme('dark');
                } else {
                  controller.setTheme('green');
                }
                controller.forgetSavedTheme();
              }
            },
            themes: <AppTheme>[
              AppTheme(
                id: 'green',
                description: "My green Theme",
                data: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xff232c13),
                    onPrimary: Color(0xff161f07),
                    secondary: Color(0xff39412a),
                    onSecondary: Color(0xff39412a),
                    error: Color(0xff91a57d),
                    onError: Color(0xff91a57d),
                    background: Color(0xfff3efdf),
                    onBackground: Color(0xfff3efdf),
                    surface: Color(0xff91a57d),
                    onSurface: Color(0xff91a57d),
                  ),
                  primaryColor: const Color(0xff232c13),
                  primaryColorLight: const Color(0xff39412a),
                  primaryColorDark: const Color(0xff161f07),
                  dialogBackgroundColor: const Color(0xfff2f1da),
                  dividerColor: const Color(0xffcdba72),
                  highlightColor: const Color(0xff91a57d).withOpacity(0.3),
                  indicatorColor: const Color(0xffcdba72),
                  scaffoldBackgroundColor: const Color(0xff232c13),
                  canvasColor: const Color(0xfff3efdf),
                  hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
                  disabledColor: const Color(0Xffffffff),
                  hintColor: const Color(0xff232c13),
                  focusColor: const Color(0xff91a57d),
                  secondaryHeaderColor: const Color(0xff39412a),
                  cardColor: const Color(0xff232c13),
                  dividerTheme: const DividerThemeData(
                    color: Color(0xffcdba72),
                  ),
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: const Color(0xff91a57d).withOpacity(0.3),
                      selectionHandleColor: const Color(0xff91a57d)),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Color(0xff606c38),
                  ),
                ).copyWith(useMaterial3: true),
              ),
              AppTheme(
                id: 'blue',
                description: "My blue Theme",
                data: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xffbc6c25),
                    onPrimary: Color(0xff814714),
                    secondary: Color(0xfffcbb76),
                    onSecondary: Color(0xfffcbb76),
                    error: Color(0xff606c38),
                    onError: Color(0xff606c38),
                    background: Color(0xfffefae0),
                    onBackground: Color(0xfffefae0),
                    surface: Color(0xff606c38),
                    onSurface: Color(0xff606c38),
                  ),
                  primaryColor: const Color(0xffbc6c25),
                  primaryColorLight: const Color(0xfffcbb76),
                  primaryColorDark: const Color(0xff814714),
                  dialogBackgroundColor: const Color(0xfffefae0),
                  dividerColor: const Color(0xfffcbb76),
                  highlightColor: const Color(0xfffcbb76).withOpacity(0.3),
                  indicatorColor: const Color(0xfffcbb76),
                  scaffoldBackgroundColor: const Color(0xff814714),
                  canvasColor: const Color(0xffF2E5D5),
                  hoverColor: const Color(0xffF2E5D5).withOpacity(0.3),
                  disabledColor: const Color(0Xffffffff),
                  hintColor: const Color(0xff814714),
                  focusColor: const Color(0xffbc6c25),
                  secondaryHeaderColor: const Color(0xffbc6c25),
                  cardColor: const Color(0xff814714),
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: const Color(0xff606c38).withOpacity(0.3),
                      selectionHandleColor: const Color(0xff606c38)),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Color(0xff606c38),
                  ),
                ).copyWith(useMaterial3: true),
              ),
              AppTheme(
                id: 'dark',
                description: "My dark Theme",
                data: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xff3F3F3F),
                    onPrimary: Color(0xff252526),
                    secondary: Color(0xff4d4d4d),
                    onSecondary: Color(0xff4d4d4d),
                    error: Color(0xff91a57d),
                    onError: Color(0xff91a57d),
                    background: Color(0xff19191a),
                    onBackground: Color(0xff3F3F3F),
                    surface: Color(0xff91a57d),
                    onSurface: Color(0xff91a57d),
                  ),
                  primaryColor: const Color(0xff3F3F3F),
                  primaryColorLight: const Color(0xff4d4d4d),
                  primaryColorDark: const Color(0xff010101),
                  dialogBackgroundColor: const Color(0xff3F3F3F),
                  dividerColor: const Color(0xff91a57d),
                  highlightColor: const Color(0xff91a57d).withOpacity(0.3),
                  indicatorColor: const Color(0xff91a57d),
                  scaffoldBackgroundColor: const Color(0xff252526),
                  canvasColor: const Color(0xfff3efdf),
                  hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
                  disabledColor: const Color(0Xffffffff),
                  hintColor: const Color(0xff252526),
                  focusColor: const Color(0xff91a57d),
                  secondaryHeaderColor: const Color(0xff91a57d),
                  cardColor: const Color(0xfff3efdf),
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: const Color(0xff91a57d).withOpacity(0.3),
                      selectionHandleColor: const Color(0xff91a57d)),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Color(0xff606c38),
                  ),
                ).copyWith(useMaterial3: true),
              ),
            ],
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<QuranCubit>(
                    create: (BuildContext context) => QuranCubit(),
                  ),
                  BlocProvider<AudioCubit>(
                    create: (BuildContext context) => AudioCubit(),
                  ),
                  BlocProvider<NotesCubit>(
                    create: (BuildContext context) => NotesCubit(),
                  ),
                  BlocProvider<QuranTextCubit>(
                    create: (BuildContext context) => QuranTextCubit(),
                  ),
                  BlocProvider<TranslateDataCubit>(
                    create: (BuildContext context) => TranslateDataCubit(),
                  ),
                  BlocProvider<QuarterCubit>(
                    create: (BuildContext context) =>
                        QuarterCubit(QuarterRepository())..getAllQuarters(),
                  ),
                  BlocProvider<SurahTextCubit>(
                    create: (BuildContext context) =>
                        SurahTextCubit()..loadQuranData(),
                  ),
                  BlocProvider<SorahRepositoryCubit>(
                    create: (BuildContext context) =>
                        SorahRepositoryCubit()..loadSorahs(),
                  ),
                  BlocProvider<AyaCubit>(
                    create: (BuildContext context) => AyaCubit()..getAllAyas(),
                  ),
                ],
                child: SplashScreen(),
                // child: const HomePage(),
              ),
            ),
          );
        });
  }
}
