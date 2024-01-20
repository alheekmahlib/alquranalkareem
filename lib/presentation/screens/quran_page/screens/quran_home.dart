import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../database/notificationDatabase.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/notifications_controller.dart';
import '../../../controllers/translate_controller.dart';
import '../widgets/audio_widget.dart';
import '../widgets/sliding_up.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
          ),
          child: Stack(
            children: <Widget>[
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                    child: MPages(),
                  )),
              context.customOrientation(
                const SizedBox.shrink(),
                Obx(
                  () => AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    bottom: sl<GeneralController>().audioWidgetPosition.value,
                    left: 0,
                    right: 0,
                    child:
                        audioContainer(context, height: 140.0, AudioWidget()),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Obx(
                    () => Sliding(
                      myWidget1: quranPageSearch(
                          context, MediaQuery.sizeOf(context).width),
                      myWidget2: quranPageSorahList(
                          context, MediaQuery.sizeOf(context).width),
                      myWidget3:
                          notesList(context, MediaQuery.sizeOf(context).width),
                      myWidget4: bookmarksList(
                          context, MediaQuery.sizeOf(context).width),
                      myWidget5: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: sl<GeneralController>().slideWidget.value,
                      ),
                      cHeight: context.customOrientation(230.0, 90.0),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
