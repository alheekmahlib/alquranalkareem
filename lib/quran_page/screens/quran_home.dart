import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/quran_page/screens/quran_page.dart';
import '../../database/notificationDatabase.dart';
import '../../services_locator.dart';
import '../../shared/controller/notifications_controller.dart';
import '../../shared/services/controllers_put.dart';
import '../../shared/widgets/audio_widget.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Stack(
          children: <Widget>[
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: MPages(),
                )),
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: generalController.audioWidgetPosition.value,
                left: 0,
                right: 0,
                child: AudioWidget(),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Sliding(
                  myWidget1: quranPageSearch(
                      context, MediaQuery.sizeOf(context).width),
                  myWidget2: quranPageSorahList(
                      context, MediaQuery.sizeOf(context).width),
                  myWidget3:
                      notesList(context, MediaQuery.sizeOf(context).width),
                  myWidget4:
                      bookmarksList(context, MediaQuery.sizeOf(context).width),
                  myWidget5: ShowTafseer(),
                  cHeight: 110.0,
                )),
          ],
        ),
      ),
    );
  }
}
