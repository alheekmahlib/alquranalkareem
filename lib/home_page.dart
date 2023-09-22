import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:wakelock/wakelock.dart';

import '../quran_page/screens/quran_screen.dart';
import 'desktop/main_screen.dart';
import 'l10n/app_localizations.dart';
import 'screens/postPage.dart';
import 'services_locator.dart';
import 'shared/controller/general_controller.dart';
import 'shared/controller/settings_controller.dart';
import 'shared/utils/helpers/ui_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return ThemeConsumer(child: Builder(builder: (themeContext) {
      UiHelper.showRateDialog(context);
      return GetBuilder<SettingsController>(
          builder: (settingsController) => MaterialApp(
                navigatorKey: sl<GeneralController>().navigatorNotificationKey,
                debugShowCheckedModeBanner: false,
                title: 'Al Quran Al Kareem',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('be'),
                  Locale('en'),
                  Locale('es'),
                  Locale('so'),
                  Locale('ur'),
                  Locale('ar')
                ],
                locale: settingsController.initialLang,
                theme: ThemeProvider.themeOf(themeContext).data,
                builder: BotToastInit(),
                navigatorObservers: [BotToastNavigatorObserver()],
                routes: {
                  // Other routes...
                  '/post': (context) {
                    int postId =
                        ModalRoute.of(context)!.settings.arguments as int;
                    return PostPage(postId);
                  },
                },
                home: ScreenTypeLayout.builder(
                  mobile: (BuildContext context) => const QuranPageScreen(),
                  desktop: (BuildContext context) => const MainDScreen(),
                  breakpoints: const ScreenBreakpoints(
                      desktop: 650, tablet: 450, watch: 300),
                ),
              ));
    }));
  }
}
