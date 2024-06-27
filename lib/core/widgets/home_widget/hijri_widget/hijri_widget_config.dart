import 'dart:io';

import '../../../../presentation/controllers/home_widget_controller.dart';

class HijriWidgetConfig {
  final homeWCtrl = HomeWidgetController.instance;

  Future<void> updateHijriDate() async {
    if (Platform.isIOS) {
      // var path = await HomeWidget.renderFlutterWidget(
      //   HijriHomeWidget(),
      //   key: 'hijriDateImage',
      //   logicalSize: const Size(300, 300),
      //   pixelRatio: 7,
      //   // pixelRatio: MediaQuery.of(Get.context!!).devicePixelRatio,
      // );

      // homeWCtrl.hijriPathImage.value = (path as String?)!;

      // HomeWidget.updateWidget(
      //   iOSName: StringConstants.iosHijriWidget,
      //   androidName: StringConstants.androidHijriWidget,
      // );
    }
  }

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      // await HomeWidget.setAppGroupId(StringConstants.groupId);
    }
  }
}
