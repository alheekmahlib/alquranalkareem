import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/helpers/ui_helper.dart';
import '../controllers/general_controller.dart';
import 'desktop/main_screen.dart';
import 'home/home_screen.dart';

class ScreenTypeL extends StatelessWidget {
  const ScreenTypeL({super.key});

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.showRateDialog(context);
    }
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        sl<GeneralController>()
            .setScreenSize(MediaQuery.sizeOf(context), context);
        return const HomeScreen();
      },
      desktop: (BuildContext context) {
        sl<GeneralController>()
            .setScreenSize(MediaQuery.sizeOf(context), context);
        return const MainDScreen();
      },
      breakpoints:
          const ScreenBreakpoints(desktop: 650, tablet: 450, watch: 300),
    );
  }
}
