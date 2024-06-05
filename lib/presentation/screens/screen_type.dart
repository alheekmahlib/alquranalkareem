import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/helpers/ui_helper.dart';
import '../controllers/general_controller.dart';
import '../controllers/notification_controller.dart';

class ScreenTypeL extends StatelessWidget {
  ScreenTypeL({super.key});

  final notificationCtrl = sl<NotificationController>();

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
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
