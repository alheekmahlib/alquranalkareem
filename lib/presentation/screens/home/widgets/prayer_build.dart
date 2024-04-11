import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/services_locator.dart';
import '/presentation/controllers/adhan_controller.dart';

class PrayerBuild extends StatelessWidget {
  PrayerBuild({super.key});

  final sharedCtrl = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdhanController>(builder: (adhanCtrl) {
      return SizedBox(
        height: 300,
        child: Wrap(
          children: adhanCtrl.buildPrayerTimeWidgets(),
        ),
      );
    });
  }
}
