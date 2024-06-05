import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../presentation/controllers/home_widget_controller.dart';
import '../../../utils/constants/string_constants.dart';
import 'hijri_home_widget.dart';

class HijriWidgetConfig {
  final homeWCtrl = HomeWidgetController.instance;

  Future<void> updateHijriDate() async {
    var path = await HomeWidget.renderFlutterWidget(
      HijriHomeWidget(),
      key: 'hijriDateImage',
      logicalSize: const Size(300, 300),
      pixelRatio: 7,
      // pixelRatio: MediaQuery.of(Get.context!!).devicePixelRatio,
    );

    homeWCtrl.hijriPathImage.value = (path as String?)!;

    HomeWidget.updateWidget(
      iOSName: StringConstants.iosHijriWidget,
      androidName: StringConstants.androidHijriWidget,
    );
  }

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(StringConstants.groupId);
  }
}
