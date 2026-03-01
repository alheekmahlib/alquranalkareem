import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/screens/home/home_screen.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/services_locator.dart';
import 'local_notification/notification_screen.dart';
import 'local_notification/widgets/notification_icon_widget.dart';
import 'settings_list.dart';

class TabBarWidget extends StatelessWidget {
  final bool isFirstChild;
  final bool isCenterChild;
  final Widget? centerChild;
  final bool? isQuranSetting;
  final bool isNotification;
  final bool? isCalendarSetting;
  final void Function()? settingOnTap;
  const TabBarWidget({
    super.key,
    required this.isFirstChild,
    required this.isCenterChild,
    this.centerChild,
    this.isQuranSetting,
    required this.isNotification,
    this.settingOnTap,
    this.isCalendarSetting = false,
  });

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    return Container(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left button
                _buildPillButton(
                  context,
                  isFirstChild
                      ? () {
                          Get.offAll(() => const HomeScreen());
                          sl<QuranController>().state.selectedAyahIndexes
                              .clear();
                        }
                      : isNotification
                      ? () => customBottomSheet(NotificationsScreen())
                      : null,
                  isFirstChild
                      ? customSvgWithColor(
                          SvgPath.svgHome,
                          height: 22.0,
                          width: 22.0,
                          color: Get.theme.colorScheme.secondary,
                        )
                      : isNotification
                      ? const NotificationIconWidget(
                          isCurve: false,
                          iconHeight: 22,
                          padding: 0.0,
                        )
                      : const SizedBox(width: 40),
                ),
                // Center child
                Expanded(
                  child: isCenterChild ? centerChild! : const SizedBox.shrink(),
                ),
                // Right button (settings)
                _buildPillButton(
                  context,
                  settingOnTap ??
                      () {
                        customBottomSheet(
                          SettingsList(
                            isQuranSetting: isQuranSetting,
                            isCalendarSetting: isCalendarSetting,
                          ),
                        );
                        generalCtrl.state.showSelectScreenPage.value = false;
                      },
                  customSvgWithColor(
                    SvgPath.svgOptions,
                    height: 22.0,
                    width: 22.0,
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(
    BuildContext context,
    VoidCallback? onTap,
    Widget child,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: child,
      ),
    );
  }
}
