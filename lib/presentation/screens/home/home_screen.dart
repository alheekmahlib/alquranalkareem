import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/widgets/daily_ayah/ayah_widget.dart';
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: SafeArea(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  const TabBarWidget(
                    isFirstChild: false,
                    isCenterChild: false,
                  ),
                  Flexible(
                    child: context.customOrientation(
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            HijriDate(),
                            const Gap(16),
                            const ScreensList(),
                            const Gap(8),
                            const LastRead(),
                            AyahWidget(),
                            const Gap(16),
                            DailyZeker(),
                            const Gap(16),
                          ],
                        ),
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const Gap(8),
                            Row(
                              children: [
                                Expanded(flex: 4, child: HijriDate()),
                                const Expanded(flex: 4, child: ScreensList()),
                              ],
                            ),
                            const Gap(8),
                            const LastRead(),
                            AyahWidget(),
                            const Gap(16),
                            DailyZeker(),
                            const Gap(16),
                          ],
                        )),
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
