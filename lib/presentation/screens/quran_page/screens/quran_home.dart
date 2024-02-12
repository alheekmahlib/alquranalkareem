import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../database/notificationDatabase.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/notifications_controller.dart';
import '../../../controllers/translate_controller.dart';
import '../widgets/surah_juz_list.dart';
import '/core/utils/constants/extensions.dart';
import 'quran_page.dart';

class QuranPage extends StatelessWidget {
  QuranPage({Key? key}) : super(key: key);

  bool hasUnopenedNotifications() {
    return sl<NotificationsController>()
        .sentNotifications
        .any((notification) => !notification['opened']);
  }

  @override
  Widget build(BuildContext context) {
    NotificationDatabaseHelper.loadNotifications();
    sl<TranslateDataController>().fetchTranslate(context);
    double width = MediaQuery.sizeOf(context).width;
    final generalCtrl = sl<GeneralController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Get.theme.colorScheme.primary,
      body: SafeArea(
        child: SliderDrawer(
          key: generalCtrl.drawerKey,
          splashColor: Theme.of(context).colorScheme.background,
          slideDirection: generalCtrl.checkRtlLayout(
              SlideDirection.RIGHT_TO_LEFT, SlideDirection.LEFT_TO_RIGHT),
          sliderOpenSize: context.customOrientation(width * .7, width * .8),
          isCupertino: true,
          isDraggable: true,
          appBar: const SizedBox.shrink(),
          slider: SurahJuzList(),
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.primaryColorDark,
            ),
            child: Stack(
              children: <Widget>[
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Center(
                      child: MPages(),
                    )),

                // Obx(
                //   () => AnimatedPositioned(
                //     duration: const Duration(milliseconds: 300),
                //     curve: Curves.easeInOut,
                //     bottom: sl<GeneralController>().audioWidgetPosition.value,
                //     left: 0,
                //     right: 0,
                //     child: audioContainer(context, height: 140.0, AudioWidget()),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
