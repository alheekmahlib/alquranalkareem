import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/screens/home/widgets/hijri_widget.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/theme_controller.dart';
import 'widgets/books_section.dart';
import 'widgets/daily_zeker.dart';
import 'widgets/quran_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return ScreenUtilInit(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Stack(
                  children: [
                    context.customOrientation(
                      ListView(
                        padding: const EdgeInsets.only(top: 80),
                        children: [
                          HijriWidget(),
                          const Gap(16),
                          QuranSection(),
                          const Gap(16),
                          DailyZeker(),
                          const Gap(16),
                          const BooksSection(),
                          const Gap(16),
                        ],
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      HijriWidget(),
                                      const Gap(8),
                                      DailyZeker(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(children: [QuranSection()]),
                                ),
                              ],
                            ),
                            const Gap(16),
                            const BooksSection(),
                            const Gap(16),
                          ],
                        ),
                      ),
                    ),
                    TopBarWidget(
                      isHomeChild: false,
                      isQuranSetting: false,
                      isNotification: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
