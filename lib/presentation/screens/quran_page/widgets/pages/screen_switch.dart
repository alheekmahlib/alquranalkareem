import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../controllers/quran_controller.dart';
import '../../screens/quran_page.dart';
import '../ayahs/ayahs_widget.dart';

class ScreenSwitch extends StatelessWidget {
  ScreenSwitch({super.key});

  final quranCtrl = sl<QuranController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranController>(builder: (quranCtrl) {
      return Container(
        child: quranCtrl.isPages.value == 1 ? AyahsWidget() : QuranPages(),
      );
    });
  }
}
