import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/services/languages/app_constants.dart';
import 'core/services/languages/localization_controller.dart';
import 'core/services/languages/messages.dart';
import 'core/services/notifications_helper.dart';
import 'core/services/services_locator.dart';
import 'core/widgets/local_notification/controller/local_notifications_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/screens/splash/splash.dart';

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({
    super.key,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    sl<ThemeController>().checkTheme();
    final localizationCtrl = Get.find<LocalizationController>();
    LocalNotificationsController.instance;
    NotifyHelper().requistPermissions();
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return GetBuilder<ThemeController>(
            builder: (themeCtrl) => GetMaterialApp(
              // navigatorKey: sl<GeneralController>().navigatorNotificationKey,
              debugShowCheckedModeBanner: false,
              title: 'Al Quran Al Kareem',
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: localizationCtrl.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[1].languageCode,
                  AppConstants.languages[1].countryCode),
              theme: themeCtrl.currentThemeData,
              // theme: brownTheme,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: Directionality(
                textDirection: TextDirection.rtl,
                child: SplashScreen(),
                // child: WillPopScope(
                //     onWillPop: () async => false, child: SplashScreen()),
                // child: const HomePage(),
              ),
            ),
          );
        });
  }
}
