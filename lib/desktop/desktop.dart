import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/quran_page/screens/quran_page.dart';
import '../database/notificationDatabase.dart';
import '../quran_page/widget/sliding_up.dart';
import '../shared/services/controllers_put.dart';
import '../shared/widgets/audio_widget.dart';
import '../shared/widgets/show_tafseer.dart';
import '../shared/widgets/widgets.dart';

class Desktop extends StatefulWidget {
  const Desktop({Key? key}) : super(key: key);

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> with TickerProviderStateMixin {
  SharedPreferences? prefs;
  late String current;
  late ScrollController slidingScrollController;
  SlidingUpPanelController slidingPanelController = SlidingUpPanelController();

  @override
  void initState() {
    super.initState();
    slidingScrollController = ScrollController();
    slidingScrollController.addListener(() {
      if (slidingScrollController.offset >=
              slidingScrollController.position.maxScrollExtent &&
          !slidingScrollController.position.outOfRange) {
        slidingPanelController.expand();
      } else if (slidingScrollController.offset <=
              slidingScrollController.position.minScrollExtent &&
          !slidingScrollController.position.outOfRange) {
        slidingPanelController.anchor();
      } else {}
    });

    NotificationDatabaseHelper.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: DPages(
                generalController.cuMPage.value,
              ),
            ),
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
              alignment: Alignment.bottomRight,
              child: Sliding(
                myWidget1: quranPageSearch(
                  context,
                  MediaQuery.sizeOf(context).width / 1 / 2,
                ),
                myWidget2: quranPageSorahList(
                  context,
                  MediaQuery.sizeOf(context).width / 1 / 2,
                ),
                myWidget3: notesList(
                  context,
                  MediaQuery.sizeOf(context).width / 1 / 2,
                ),
                myWidget4: bookmarksList(
                  context,
                  MediaQuery.sizeOf(context).width / 1 / 2,
                ),
                myWidget5: ShowTafseer(),
                cHeight: 90.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
