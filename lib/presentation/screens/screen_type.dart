import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/widgets/occasions/controller/event_controller.dart';
import '../controllers/general/general_controller.dart';

class ScreenTypeL extends StatelessWidget {
  ScreenTypeL({super.key});
  final generalCtrl = GeneralController.instance;
  final occasionsCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    occasionsCtrl.ramadhanOrEidGreeting();
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
