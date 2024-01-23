import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/widgets/tap_bar.dart';
import '../../controllers/theme_controller.dart';
import 'widgets/hijri_date.dart';
import 'widgets/last_read.dart';
import 'widgets/screens_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO here theme GetBuilder for mobile
    return GetBuilder<ThemeController>(builder: (_) {
      return Scaffold(
        backgroundColor: Get.theme.colorScheme.primary,
        body: SafeArea(
          child: Container(
            color: Get.theme.colorScheme.background,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const TapBarWidget(
                  isChild: false,
                ),
                const HijriDate(),
                const ScreensList(),
                const Gap(8),
                const LastRead()
              ],
            ),
          ),
        ),
      );
    });
  }
}
