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

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    sl<ThemeController>().checkTheme();
    final localizationCtrl = Get.find<LocalizationController>();
    localizationCtrl
        .loadCurrentLanguage(); // تحميل اللغة المحفوظة أو الافتراضية
    LocalNotificationsController.instance;
    NotifyHelper().requistPermissions();
    final TextScaler fixedScaler = const TextScaler.linear(1.0);
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
              // languageCode غير قابل للـ null، لذا نستخدمه مباشرة
              PlatformDispatcher.instance.locale.languageCode,
              // قد تكون countryCode فارغة، فنوفّر بديلًا عند اللزوم
              PlatformDispatcher.instance.locale.countryCode ??
                  AppConstants.languages[1].countryCode,
            ),
            theme: themeCtrl.currentThemeData,
            // دمج BotToast مع تقييد مقياس النص ليبقى 1.0 بغض النظر عن إعدادات الجهاز
            builder: (context, child) {
              final botToastBuilder = BotToastInit();
              final botWrappedChild = botToastBuilder(context, child);
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(textScaler: fixedScaler),
                child: botWrappedChild,
              );
            },
            navigatorObservers: [BotToastNavigatorObserver()],
            home: Directionality(
              // تحديد اتجاه النصوص بناءً على اللغة المختارة
              textDirection: _getTextDirection(localizationCtrl.locale),
              child: SplashScreen(),
            ),
          ),
        );
      },
    );
  }

  // دالة لتحديد اتجاه النصوص بناءً على اللغة
  // Function to determine text direction based on the selected language.
  TextDirection _getTextDirection(Locale locale) {
    const rtlLanguages = [
      'ar',
      'ur',
      'ku',
      'fa',
    ]; // قائمة اللغات من اليمين لليسار
    return rtlLanguages.contains(locale.languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
