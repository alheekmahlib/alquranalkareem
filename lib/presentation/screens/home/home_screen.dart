import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/helpers/ui_helper.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/theme_controller.dart';
import '../desktop/main_screen.dart';
import '../quran_page/screens/quran_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.showRateDialog(context);
    }
    return GetBuilder<ThemeController>(builder: (_) {
      return ScreenTypeLayout.builder(
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
      );
    });
  }
}
