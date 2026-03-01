import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/widgets/select_screen_build.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/screens/about_app/about_app.dart';
import '../../presentation/screens/calendar/widgets/calender_settings.dart';
import '../../presentation/screens/ourApp/screen/ourApps_screen.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../utils/constants/extensions/extensions.dart';
import '../utils/constants/svg_constants.dart';
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
          height: size.height * .9,
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(
                () => generalCtrl.state.showSelectScreenPage.value
                    ? const SelectScreenBuild(
                        isButtonBack: true,
                        isButton: false,
                      )
                    : Column(
                        children: [
                          // Drag handle
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.4),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                context.customClose(),
                                const Gap(8),
                                context.vDivider(height: 20),
                                const Gap(8),
                                Text(
                                  'setting'.tr,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontFamily: 'kufi',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Flexible(
                            child: ListView(
                              children: [
                                const Gap(16),
                                const LanguageList(),
                                isQuranSetting!
                                    ? const Gap(24)
                                    : const SizedBox.shrink(),
                                isQuranSetting!
                                    ? MushafSettings()
                                    : const SizedBox.shrink(),
                                isCalendarSetting!
                                    ? const Gap(24)
                                    : const SizedBox.shrink(),
                                isCalendarSetting!
                                    ? const CalenderSettings()
                                    : const SizedBox.shrink(),
                                const Gap(24),
                                const ThemeChange(),
                                const Gap(24),
                                const SelectScreen(),
                                const Gap(24),
                                _buildSettingsGroup(context),
                              ],
                            ),
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

  Widget _buildSettingsGroup(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: customSvgWithColor(
              SvgPath.svgAlheekmahLogo,
              width: 50.0,
              color: Get.theme.colorScheme.primary,
            ),
            title: 'ourApps'.tr,
            onTap: () {
              Get.to(() => const OurApps());
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: context.hDivider(width: double.infinity),
          ),
          _buildSettingsItem(
            context,
            icon: customSvgWithCustomColor(SvgPath.svgSplashIcon, height: 30),
            title: 'aboutApp'.tr,
            onTap: () {
              Get.to(() => const AboutApp());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            SizedBox(width: 40, child: icon),
            const Gap(12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 16,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).hintColor.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
