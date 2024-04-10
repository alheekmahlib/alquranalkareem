import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/helpers/ui_helper.dart';
import '../controllers/general_controller.dart';

class ScreenTypeL extends StatelessWidget {
  const ScreenTypeL({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    generalCtrl.ramadhanOrEidGreeting();
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) {
      UiHelper.showRateDialog(context);
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
