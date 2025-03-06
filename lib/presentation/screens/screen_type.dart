import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/general/general_controller.dart';
import 'calendar/events.dart';

class ScreenTypeL extends StatelessWidget {
  ScreenTypeL({super.key});
  final generalCtrl = GeneralController.instance;
  final eventsCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    eventsCtrl.ramadhanOrEidGreeting();
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      // UiHelper.showRateDialog(context);
    }
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return generalCtrl.screenSelect();
      },
      desktop: (BuildContext context) {
        return generalCtrl.screenSelect();
      },
      breakpoints:
          const ScreenBreakpoints(desktop: 650, tablet: 450, watch: 300),
    );
  }
}
