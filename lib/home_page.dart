import 'dart:async';
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/quran_page/screens/quran_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:theme_provider/theme_provider.dart';
import 'dart:io';
import 'desktop/main_screen.dart';
import 'l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static _HomePageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();
}

class _HomePageState extends State<HomePage> {
  void setLocale(Locale value) {
    setState(() {
      QuranCubit.get(context).initialLang = value;
    });
  }

  @override
  void initState() {
    QuranCubit.get(context).loadLang();
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Rate this app',
          // The dialog title.
          message:
              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
          // The dialog message.
          rateButton: 'RATE',
          // The dialog "rate" button text.
          noButton: 'NO THANKS',
          // The dialog "no" button text.
          laterButton: 'MAYBE LATER',
          // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreNativeDialog: Platform.isAndroid,
          // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: const DialogStyle(),
          // Custom dialog styles.

          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );
      }
    });
    // initialization();
    super.initState();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 5,
    minLaunches: 7,
    remindDays: 15,
    remindLaunches: 20,
    googlePlayIdentifier: 'com.alheekmah.alquranalkareem.alquranalkareem',
    appStoreIdentifier: '1500153222',
  );

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(child: Builder(builder: (themeContext) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Al Quran Al Kareem',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'AE'),
          Locale('en', ''),
        ],
        locale: QuranCubit.get(context).initialLang,
        theme: ThemeProvider.themeOf(themeContext).data,
        home: ScreenTypeLayout(
          mobile: QuranPageScreen(),
          desktop: const MainDScreen(),
          breakpoints:
              const ScreenBreakpoints(desktop: 650, tablet: 450, watch: 300),
        ),
      );
    }));
  }
}
