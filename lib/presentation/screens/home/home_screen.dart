import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:theme_provider/theme_provider.dart'; // import 'package:wakelock/wakelock.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/services/l10n/app_localizations.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/helpers/ui_helper.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/settings_controller.dart';
import '../desktop/main_screen.dart';
import '../onboarding/widgets/postPage.dart';
import '../quran_page/screens/quran_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.showRateDialog(context);
    }
    return ThemeConsumer(
      child: GetBuilder<SettingsController>(
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
          locale: sl<SettingsController>().initialLang,
          theme: ThemeProvider.themeOf(context).data,
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          routes: {
            // Other routes...
            '/post': (context) {
              int postId = ModalRoute.of(context)!.settings.arguments as int;
              return PostPage(postId);
            },
          },
          home: ScreenTypeLayout.builder(
            mobile: (BuildContext context) {
              sl<GeneralController>()
                  .setScreenSize(MediaQuery.sizeOf(context), context);
              return const QuranPageScreen();
            },
            desktop: (BuildContext context) {
              sl<GeneralController>()
                  .setScreenSize(MediaQuery.sizeOf(context), context);
              return const MainDScreen();
            },
            breakpoints:
                const ScreenBreakpoints(desktop: 650, tablet: 450, watch: 300),
          ),
        ),
      ),
    );
  }
}
