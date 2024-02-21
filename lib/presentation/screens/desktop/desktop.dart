import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/notificationDatabase.dart';
import 'desktop_quran_page.dart';

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
              child: DPages(),
            ),
          ],
        ),
      ),
    );
  }
}
