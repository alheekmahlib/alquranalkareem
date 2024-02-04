import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/theme_controller.dart';
import 'widgets/daily_zeker.dart';
import 'widgets/hijri_date.dart';
import 'widgets/last_read.dart';
import 'widgets/screens_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (_) {
      return ScreenUtilInit(
        child: Scaffold(
          backgroundColor: Get.theme.colorScheme.primary,
          body: SafeArea(
            child: Container(
              color: Get.theme.colorScheme.background,
              child: Column(
                children: [
                  const TabBarWidget(
                    isChild: false,
                    isIndicator: false,
                  ),
                  Flexible(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const HijriDate(),
                        const ScreensList(),
                        const Gap(8),
                        const LastRead(),
                        const Gap(8),
                        DailyZeker(),
                        const Gap(16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
