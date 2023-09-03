import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring/spring.dart';

import '/quran_page/screens/quran_page.dart';
import '../../database/notificationDatabase.dart';
import '../../services_locator.dart';
import '../../shared/controller/notifications_controller.dart';
import '../../shared/widgets/audio_widget.dart';
import '../../shared/widgets/controllers_put.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/widgets.dart';
import '../widget/sliding_up.dart';

class QuranPage extends StatelessWidget {
  late final int sorahNum;
  QuranPage({Key? key}) : super(key: key);

  late final String current;

  bool hasUnopenedNotifications() {
    return sl<NotificationsController>()
        .sentNotifications
        .any((notification) => !notification['opened']);
  }

  @override
  Widget build(BuildContext context) {
    NotificationDatabaseHelper.loadNotifications();
    springController = SpringController(initialAnim: Motion.play);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Stack(
            children: <Widget>[
              const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                    child: MPages(),
                  )),
              Spring.slide(
                  springController: springController,
                  slideType: SlideType.slide_in_left,
                  delay: const Duration(milliseconds: 0),
                  animDuration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  extend: -500,
                  withFade: false,
                  child: const AudioWidget()),
              Obx(
                () => Visibility(
                    visible: generalController.isShowControl.value,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Sliding(
                          myWidget1: quranPageSearch(
                              context, MediaQuery.of(context).size.width),
                          myWidget2: quranPageSorahList(
                              context, MediaQuery.of(context).size.width),
                          myWidget3: notesList(
                              context, MediaQuery.of(context).size.width),
                          myWidget4: bookmarksList(
                              context, MediaQuery.of(context).size.width),
                          myWidget5: ShowTafseer(),
                          cHeight: 110.0,
                        ))),
              ),
            ],
          ),
        );
      }),
    );
  }
}
