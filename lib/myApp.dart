import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'core/services/languages/app_constants.dart';
import 'core/services/languages/localization_controller.dart';
import 'core/services/languages/messages.dart';
import 'core/services/services_locator.dart';
import 'presentation/controllers/general_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/screens/onboarding/widgets/postPage.dart';
import 'presentation/screens/splashScreen/splash_screen.dart';

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({
    Key? key,
    required this.languages,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    initialization();
    sl<ThemeController>().checkTheme();
    return GetBuilder<LocalizationController>(builder: (localizationCtrl) {
      return GetMaterialApp(
        navigatorKey: sl<GeneralController>().navigatorNotificationKey,
        debugShowCheckedModeBanner: false,
        title: 'Al Quran Al Kareem',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: localizationCtrl.locale,
        translations: Messages(languages: languages),
        fallbackLocale: Locale(AppConstants.languages[0].languageCode,
            AppConstants.languages[0].countryCode),
        theme: sl<ThemeController>().currentThemeData,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        routes: {
          // Other routes...
          '/post': (context) {
            int postId = ModalRoute.of(context)!.settings.arguments as int;
            return PostPage(postId);
          },
        },
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: SplashScreen(),
          // child: WillPopScope(
          //     onWillPop: () async => false, child: SplashScreen()),
          // child: const HomePage(),
        ),
      );
    });
  }
}
