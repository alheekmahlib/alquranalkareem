import 'package:alquranalkareem/presentation/screens/home/widgets/hijri_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/theme_controller.dart';
import 'widgets/ayah_tafsir_widget.dart';
import 'widgets/daily_zeker.dart';
import 'widgets/last_read.dart';
import 'widgets/screens_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                          HijriWidget(),
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
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      HijriWidget(),
                                      const Gap(8),
                                      LastRead(),
                                    ],
                                  )),
                              const Expanded(flex: 4, child: ScreensList()),
                            ],
                          ),
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
