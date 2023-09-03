import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring/spring.dart';

import '/quran_page/screens/quran_page.dart';
import '../database/notificationDatabase.dart';
import '../quran_page/widget/sliding_up.dart';
import '../shared/controller/general_controller.dart';
import '../shared/widgets/audio_widget.dart';
import '../shared/widgets/controllers_put.dart';
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
  late final GeneralController generalController = Get.put(GeneralController());

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
                generalController.cuMPage,
              ),
            ),
            Spring.slide(
                springController: springController,
                slideType: SlideType.slide_in_left,
                delay: const Duration(milliseconds: 0),
                animDuration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                extend: -500,
                withFade: false,
                child: const AudioWidget()),
            Align(
              alignment: Alignment.bottomRight,
              child: Obx(
                () => Visibility(
                  visible: generalController.isShowControl.value,
                  child: Sliding(
                    myWidget1: quranPageSearch(
                      context,
                      MediaQuery.of(context).size.width / 1 / 2,
                    ),
                    myWidget2: quranPageSorahList(
                      context,
                      MediaQuery.of(context).size.width / 1 / 2,
                    ),
                    myWidget3: notesList(
                      context,
                      MediaQuery.of(context).size.width / 1 / 2,
                    ),
                    myWidget4: bookmarksList(
                      context,
                      MediaQuery.of(context).size.width / 1 / 2,
                    ),
                    myWidget5: ShowTafseer(),
                    cHeight: 90.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
