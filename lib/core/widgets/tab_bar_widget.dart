import 'dart:developer';

import 'package:flexible_sheet/flexible_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/screens/home/home_screen.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/services_locator.dart';
import '../utils/constants/extensions/extensions.dart';
import 'container_button.dart';
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
  final bool? isDraggable;
  final Widget? bodyChild;
  final bool? isBackButton;
  TopBarWidget({
    super.key,
    required this.isHomeChild,
    required this.isCenterChild,
    this.centerChild,
    this.isQuranSetting,
    required this.isNotification,
    this.settingOnTap,
    this.isCalendarSetting = false,
    this.isDraggable = true,
    this.bodyChild,
    this.isBackButton = false,
  });

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FlexibleSheet(
          maxHeight: context.customOrientation(
            constraints.maxHeight - 150,
            constraints.maxHeight - 70,
          ),
          minHeight: 0,
          initialHeight: 0,
          isDraggable: isDraggable ?? true,
          alignment: context.customOrientation(
            Alignment.topCenter,
            AlignmentDirectional.topEnd,
          ),
          width: context.customOrientation(Get.width, Get.width * 0.5),
          direction: SheetDirection.topToBottom,
          snapBehavior: SheetSnapBehavior.snapToEdge,
          controller: quranCtrl.state.tabBarController,
          onStateChanged: (state) => log('isOpen: $state'),
          handleBuilder: (currentHeight) {
            final isExpanded = currentHeight >= 155;
            return Material(
              elevation: 8,
              color: Colors.transparent,
              child: Column(
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
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
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
                                  ? ContainerButton(
                                      onPressed: () {
                                        if (isBackButton ?? false) {
                                          quranCtrl.setTopBarType =
                                              TopBarType.none;
                                          Get.back();
                                          return;
                                        }
                                        quranCtrl.setTopBarType =
                                            TopBarType.none;
                                        Get.offAll(
                                          () => const HomeScreen(),
                                          transition: Transition.upToDown,
                                        );
                                        sl<QuranController>()
                                            .state
                                            .selectedAyahIndexes
                                            .clear();
                                      },
                                      svgHeight: 35,
                                      svgWidth: 35,
                                      horizontalMargin: 4.0,
                                      verticalMargin: 5.0,
                                      backgroundColor: Colors.transparent,
                                      svgColor:
                                          context.theme.colorScheme.primary,
                                      svgWithColorPath: isBackButton ?? false
                                          ? SvgPath.svgHomeArrowBack
                                          : SvgPath.svgHomeHome,
                                    )
                                  : isNotification
                                  ? ContainerButton(
                                      onPressed: () => customBottomSheet(
                                        NotificationsScreen(),
                                      ),
                                      svgHeight: 35,
                                      svgWidth: 35,
                                      horizontalMargin: 6.0,
                                      verticalMargin: 8.0,
                                      backgroundColor: Colors.transparent,
                                      child: const NotificationIconWidget(
                                        iconHeight: 30,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            if (centerChild != null)
                              Expanded(
                                flex: 12,
                                child: isCenterChild
                                    ? centerChild!
                                    : const SizedBox.shrink(),
                              ),
                            Expanded(
                              flex: 2,
                              child: ContainerButton(
                                onPressed:
                                    settingOnTap ??
                                    () {
                                      quranCtrl.setTopBarType =
                                          TopBarType.settings;
                                      quranCtrl.state.tabBarController.toggle();
                                      quranCtrl.state.isPlayExpanded.value =
                                          false;
                                    },
                                svgHeight: 35,
                                svgWidth: 35,
                                horizontalMargin: 4.0,
                                verticalMargin: 5.0,
                                backgroundColor: Colors.transparent,
                                svgColor: context.theme.colorScheme.primary,
                                svgWithColorPath: isExpanded
                                    ? SvgPath.svgHomeClose
                                    : SvgPath.svgHomeSetting,
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
              ),
            );
          },
          childBuilder: (currentHeight) {
            if (quranCtrl.getTopBarType(TopBarType.search)) {
              return Material(
                elevation: 8,
                color: Colors.transparent,
                child: bodyChild ?? QuranSearch(),
              );
            } else {
              return Material(
                elevation: 8,
                color: Colors.transparent,
                child: SettingsList(
                  isQuranSetting: isQuranSetting,
                  isCalendarSetting: isCalendarSetting,
                ),
              );
            }
          },
        );
      },
    );
  }
}
