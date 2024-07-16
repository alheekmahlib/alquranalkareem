import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/quran_controller.dart';
import '../screens/quran_page.dart';
import 'ayahs/ayahs_widget.dart';

class ScreenSwitch extends StatelessWidget {
  ScreenSwitch({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranController>(builder: (quranCtrl) {
      return Container(
        child:
            quranCtrl.state.isPages.value == 1 ? AyahsWidget() : QuranPages(),
      );
    });
  }
}
