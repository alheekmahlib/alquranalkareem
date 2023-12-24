import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:theme_provider/theme_provider.dart';

import 'core/utils/helpers/app_themes.dart';
import 'presentation/screens/splashScreen/splash_screen.dart';

/// Used for Background Updates using Workmanager Plugin
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     print('Background task started: $taskName'); // Added print statement
//
//     // Generate a random Zikr
//     Set<int> usedIndices = {};
//     int randomIndex;
//     do {
//       randomIndex = Random().nextInt(zikr.length);
//     } while (usedIndices.contains(randomIndex));
//     usedIndices.add(randomIndex);
//     final randomZikr = zikr[randomIndex];
//
//     return Future.wait<bool?>([
//       HomeWidget.saveWidgetData(
//         'zikr',
//         randomZikr,
//       ),
//       HomeWidget.updateWidget(
//         name: 'ZikerWidget',
//         iOSName: 'ZikerWidget',
//       ),
//     ]).then((value) {
//       print('Background task completed: $taskName'); // Added print statement
//       return !value.contains(false);
//     });
//   });
// }

/// Called when Doing Background Work initiated from Widget
// @pragma("vm:entry-point")
// void backgroundCallback(Uri? data) async {
//   print(data);
//
//   if (data!.host == 'zikr') {
//     Set<int> usedIndices = {};
//     int randomIndex;
//     do {
//       randomIndex = Random().nextInt(zikr.length);
//     } while (usedIndices.contains(randomIndex));
//     usedIndices.add(randomIndex);
//     final randomZikr = zikr[randomIndex];
//
//     await HomeWidget.saveWidgetData<String>('zikr', randomZikr);
//     await HomeWidget.updateWidget(name: 'ZikerWidget', iOSName: 'ZikerWidget');
//   }
// }

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
  @override
  void initState() {
    initialization();
    super.initState();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }
  // Set<int> usedIndices = {};
  //
  // Future<void> _saveRandomZikr() async {
  //   if (usedIndices.length == zikr.length) {
  //     usedIndices.clear();
  //   }
  //
  //   int randomIndex;
  //   do {
  //     randomIndex = Random().nextInt(zikr.length);
  //   } while (usedIndices.contains(randomIndex));
  //
  //   usedIndices.add(randomIndex);
  //   final randomZikr = zikr[randomIndex];
  //
  //   try {
  //     await HomeWidget.saveWidgetData<String>('zikr', randomZikr);
  //   } on PlatformException catch (exception) {
  //     debugPrint('Error Saving Random Zikr. $exception');
  //   }
  // }
  //
  // Future<void> saveHijriDate() async {
  //   ArabicNumbers arabicNumber = ArabicNumbers();
  //   // HijriCalendar.setLocal('en');
  //   var _today = HijriCalendar.now();
  //   String day = arabicNumber.convert(_today.hDay);
  //   String year = arabicNumber.convert(_today.hYear);
  //   await HomeWidget.saveWidgetData<String>('hijriDay', day);
  //   await HomeWidget.saveWidgetData<String>(
  //       'hijriMonth', _today.hMonth.toString());
  //   await HomeWidget.saveWidgetData<String>('hijriYear', year);
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   if (Platform.isIOS || Platform.isAndroid) {
  //     // Initialize Workmanager
  //     // final workManager = Workmanager();
  //     // workManager.initialize(
  //     //   callbackDispatcher, // Your callbackDispatcher function
  //     //   isInDebugMode: false, // Set to false in production builds
  //     // );
  //     HomeWidget.setAppGroupId('group.com.alheekmah.alquranalkareem.widget');
  //     saveHijriDate();
  //     Timer.periodic(const Duration(minutes: 1), (timer) async {
  //       await _saveRandomZikr();
  //       await _updateWidget();
  //     });
  //     HomeWidget.registerBackgroundCallback(backgroundCallback);
  //     // _startBackgroundUpdate();
  //   }
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // HomeWidget.widgetClicked.listen(_launchedFromWidget);
  // }

  // @override
  // void dispose() async {
  //   super.dispose();
  // }

  // Future<void> _updateWidget() async {
  //   try {
  //     await HomeWidget.updateWidget(
  //         name: 'ZikerWidget', iOSName: 'ZikerWidget');
  //   } on PlatformException catch (exception) {
  //     debugPrint('Error Updating Widget. $exception');
  //   }
  // }

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
    return ThemeProvider(
      defaultThemeId: 'green',
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance.platformDispatcher.platformBrightness;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('green');
          }
          controller.forgetSavedTheme();
        }
      },
      themes: AppThemes.list,
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
        // child: WillPopScope(
        //     onWillPop: () async => false, child: SplashScreen()),
        // child: const HomePage(),
      ),
    );
  }
}
