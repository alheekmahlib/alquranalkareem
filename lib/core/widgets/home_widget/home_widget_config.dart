import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

import '../../../presentation/controllers/adhan_controller.dart';
import '../../../presentation/controllers/general_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/string_constants.dart';
import 'hijri_home_widget.dart';

class HomeWidgetConfig {
  final generalCtrl = sl<GeneralController>();
  final adhanCtrl = sl<AdhanController>();

  Future<void> updateHijriDate() async {
    var path = await HomeWidget.renderFlutterWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 300,
          width: 300,
          child: GetBuilder<AdhanController>(builder: (adhanCtrl) {
            return SizedBox(
              height: 300,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                    adhanCtrl.prayerNameList.length,
                    (index) => GestureDetector(
                          onTap: () => adhanCtrl.prayerAlarmSwitch(index),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(Get.context!).colorScheme.primary,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                border: Border.all(
                                  color: adhanCtrl
                                          .getCurrentSelectedPrayer(index)
                                          .value
                                      ? const Color(0xfff16938)
                                      : Theme.of(Get.context!).canvasColor,
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignInside,
                                )),
                            child: Container(
                              width: 110,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Theme.of(Get.context!)
                                    .canvasColor
                                    .withOpacity(.2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${adhanCtrl.prayerNameList[index]['title']}'
                                          .tr,
                                      style: TextStyle(
                                        fontFamily: 'kufi',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(Get.context!).canvasColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    adhanCtrl.prayerNameList[index]['time']!,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(Get.context!).canvasColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
              ),
            );
          }),
        ),
      ),
      key: 'hijriDateImage',
      logicalSize: const Size(300, 300),
      // pixelRatio: MediaQuery.of(Get.context!).devicePixelRatio,
    );

    generalCtrl.imagePath.value = (path as String?)!;

    // HomeWidget.saveWidgetData<String>('hijriDate', 'تجربة');
    // HomeWidget.saveWidgetData<String>('hijriDate2', 'تجربة٢');
    HomeWidget.updateWidget(
      iOSName: StringConstants.iosWidget,
      androidName: StringConstants.androidWidget,
    );
  }
  // }

  static Future<void> homeWidgetUpdate() async {
    await HomeWidget.saveWidgetData<String>('hijriDate', "01 Muharram 1444");
    await HomeWidget.renderFlutterWidget(
      HijriHomeWidget(),
      key: 'hijriDate',
      logicalSize: const Size(100, 100),
    );
  }

  static Future<void> update() async {
    await HomeWidget.renderFlutterWidget(
      const Icon(
        Icons.flutter_dash,
        size: 76,
      ),
      key: 'hijriDate',
      logicalSize: const Size(100, 100),
    );
    // Uint8List bytes = await DavinciCapture.offStage(
    //   HijriHomeWidget(),
    //   returnImageUint8List: true,
    //   wait: const Duration(seconds: 1),
    //   openFilePreview: true,
    // );
    //
    // final directory = await getApplicationSupportDirectory();
    // File tempFile =
    //     File("${directory.path}/${DateTime.now().toIso8601String()}.png");
    // await tempFile.writeAsBytes(bytes);
    //
    // await HomeWidget.saveWidgetData('hijriDate', tempFile.path);
    await HomeWidget.updateWidget(
        iOSName: StringConstants.iosWidget,
        androidName: StringConstants.androidWidget);
  }

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(StringConstants.groupId);
  }
}
