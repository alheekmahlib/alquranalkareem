import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/theme_controller.dart';
import '../prayers/prayers.dart';
import 'widgets/ayah_tafsir_widget.dart';
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
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                const TabBarWidget(
                  isFirstChild: false,
                  isCenterChild: false,
                  isQuranSetting: false,
                  isNotification: true,
                ),
                Flexible(
                  child: context.customOrientation(
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // HijriDate(),
                          PrayerProgressBar(),
                          const Gap(16),
                          const ScreensList(),
                          const Gap(8),
                          LastRead(),
                          AyahTafsirWidget(),
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
                          LastRead(),
                          AyahTafsirWidget(),
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
      ));
    });
  }
}
