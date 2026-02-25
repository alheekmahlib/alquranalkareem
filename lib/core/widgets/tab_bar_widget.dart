import 'dart:developer';

import 'package:flexible_sheet/flexible_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/screens/home/home_screen.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/services_locator.dart';
import 'local_notification/notification_screen.dart';
import 'local_notification/widgets/notification_icon_widget.dart';
import 'settings_list.dart';

enum TopBarType { none, search, settings }

class TopBarWidget extends StatelessWidget {
  final bool isHomeChild;
  final bool isCenterChild;
  final Widget? centerChild;
  final bool? isQuranSetting;
  final bool isNotification;
  final bool? isCalendarSetting;
  final void Function()? settingOnTap;
  TopBarWidget({
    super.key,
    required this.isHomeChild,
    required this.isCenterChild,
    this.centerChild,
    this.isQuranSetting,
    required this.isNotification,
    this.settingOnTap,
    this.isCalendarSetting = false,
  });

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FlexibleSheet(
          maxHeight: constraints.maxHeight - 150,
          minHeight: 0,
          initialHeight: 0,
          direction: SheetDirection.topToBottom,
          snapBehavior: SheetSnapBehavior.snapToEdge,
          controller: quranCtrl.state.searchController,
          onStateChanged: (state) => log('isOpen: $state'),
          handleBuilder: (currentHeight) {
            final isExpanded = currentHeight >= 155;
            return Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      height: 53,
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: isHomeChild
                                ? GestureDetector(
                                    onTap: () {
                                      Get.offAll(
                                        () => const HomeScreen(),
                                        transition: Transition.upToDown,
                                      );
                                      sl<QuranController>()
                                          .state
                                          .selectedAyahIndexes
                                          .clear();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: customSvgWithColor(
                                        SvgPath.svgHomeHome,
                                        height: 35.0,
                                        width: 35.0,
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : isNotification
                                ? GestureDetector(
                                    onTap: () => customBottomSheet(
                                      NotificationsScreen(),
                                    ),
                                    child: const NotificationIconWidget(
                                      isCurve: true,
                                      iconHeight: 25,
                                      padding: 4.0,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Expanded(
                            flex: 12,
                            child: isCenterChild
                                ? centerChild!
                                : const SizedBox.shrink(),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap:
                                  settingOnTap ??
                                  () {
                                    quranCtrl.setTopBarType =
                                        TopBarType.settings;
                                    quranCtrl.state.searchController.toggle();
                                    // customBottomSheet(
                                    //   SettingsList(
                                    //     isQuranSetting: isQuranSetting,
                                    //     isCalendarSetting: isCalendarSetting,
                                    //   ),
                                    // );
                                  },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: customSvgWithColor(
                                  isExpanded
                                      ? SvgPath.svgHomeClose
                                      : SvgPath.svgHomeSetting,
                                  height: 35.0,
                                  width: 35.0,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 8,
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 62.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            );
          },
          childBuilder: (currentHeight) {
            if (quranCtrl.getTopBarType(TopBarType.search)) {
              return QuranSearch();
            } else {
              return SettingsList(
                isQuranSetting: isQuranSetting,
                isCalendarSetting: isCalendarSetting,
              );
            }
          },
        );
      },
    );
  }
}
