import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:alquranalkareem/core/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/controllers/theme_controller.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/screens/about_app/about_app.dart';
import '../../presentation/screens/calendar/widgets/calender_settings.dart';
import '../../presentation/screens/ourApp/screen/our_apps_screen.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../utils/helpers/app_text_styles.dart';
import 'language_list.dart';
import 'mushaf_settings.dart';
import 'select_screen.dart';
import 'theme_change.dart';

class SettingsList extends StatelessWidget {
  final bool? isQuranSetting;
  final bool? isCalendarSetting;
  SettingsList({Key? key, this.isQuranSetting, this.isCalendarSetting = false})
    : super(key: key);
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GetBuilder<ThemeController>(
      builder: (_) {
        return Container(
          height: size.height,
          width: size.width,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: ListView(
            children: [
              const Gap(16),
              TitleWidget(
                title: 'setting',
                textStyle: AppTextStyles.titleLarge(),
                containerColor: context.theme.primaryColorLight,
              ),
              const Gap(16),
              LanguageList(),
              isQuranSetting! ? const Gap(24) : const SizedBox.shrink(),
              isQuranSetting! ? MushafSettings() : const SizedBox.shrink(),
              isCalendarSetting! ? const Gap(24) : const SizedBox.shrink(),
              isCalendarSetting!
                  ? const CalenderSettings()
                  : const SizedBox.shrink(),
              const Gap(24),
              const ThemeChange(),
              const Gap(24),
              const SelectScreen(),
              const Gap(24),
              Divider(
                thickness: 1.0,
                height: 1.0,
                endIndent: 32.0,
                indent: 32.0,
                color: Theme.of(
                  context,
                ).primaryColorLight.withValues(alpha: .5),
              ),
              const Gap(4),
              Column(
                children: [
                  ContainerButton(
                    onPressed: () => Get.to(
                      () => const OurApps(),
                      transition: Transition.downToUp,
                    ),
                    withArrow: true,
                    width: double.infinity,
                    title: 'ourApps',
                    horizontalPadding: 8.0,
                    verticalPadding: 12.0,
                    horizontalMargin: 16.0,
                  ),
                  const Gap(8),
                  Column(
                    children: [
                      ContainerButton(
                        onPressed: () => Get.to(
                          () => const AboutApp(),
                          transition: Transition.downToUp,
                        ),
                        withArrow: true,
                        width: double.infinity,
                        title: 'aboutApp',
                        horizontalPadding: 8.0,
                        verticalPadding: 12.0,
                        horizontalMargin: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
