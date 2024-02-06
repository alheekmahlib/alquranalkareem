import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../database/notificationDatabase.dart';
import '../../../controllers/notifications_controller.dart';
import '../../../controllers/translate_controller.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Get.theme.primaryColorDark,
      body: SafeArea(
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
    );
  }
}
