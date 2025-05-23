import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
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
    localizationCtrl
        .loadCurrentLanguage(); // تحميل اللغة المحفوظة أو الافتراضية
    LocalNotificationsController.instance;
    NotifyHelper().requistPermissions();

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetBuilder<ThemeController>(
            builder: (themeCtrl) => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Al Quran Al Kareem',
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: localizationCtrl.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                PlatformDispatcher.instance.locale.languageCode ??
                    AppConstants.languages[1].languageCode,
                PlatformDispatcher.instance.locale.countryCode ??
                    AppConstants.languages[1].countryCode,
              ),
              theme: themeCtrl.currentThemeData,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: Directionality(
                // تحديد اتجاه النصوص بناءً على اللغة المختارة
                textDirection: _getTextDirection(localizationCtrl.locale),
                child: SplashScreen(),
              ),
            ),
          );
        });
  }

  // دالة لتحديد اتجاه النصوص بناءً على اللغة
  // Function to determine text direction based on the selected language.
  TextDirection _getTextDirection(Locale locale) {
    const rtlLanguages = [
      'ar',
      'ur',
      'ku',
      'fa'
    ]; // قائمة اللغات من اليمين لليسار
    return rtlLanguages.contains(locale.languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
