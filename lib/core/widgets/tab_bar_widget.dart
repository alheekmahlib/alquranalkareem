import 'package:alquranalkareem/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/screens/home/home_screen.dart';
import '../../presentation/controllers/general/general_controller.dart';
import '../../presentation/screens/quran_page/quran.dart';
import '../services/notifications_manager.dart';
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
  const TabBarWidget(
      {super.key,
      required this.isFirstChild,
      required this.isCenterChild,
      this.centerChild,
      this.isQuranSetting,
      required this.isNotification});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    return Column(
      children: [
        Container(
          height: 15,
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).colorScheme.primary,
        ),
        Transform.translate(
          offset: const Offset(0, -2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: isFirstChild
                    ? GestureDetector(
                        onTap: () {
                          NotificationManager().updateBookProgress(
                              'quran'.tr,
                              'notifyQuranBody'.trParams({
                                'currentPageNumber':
                                    '${quranCtrl.state.currentPageNumber.value}'
                                        .convertNumbers()
                              }),
                              quranCtrl.state.currentPageNumber.value);
                          Get.offAll(() => const HomeScreen(),
                              transition: Transition.upToDown);
                          sl<QuranController>()
                              .state
                              .selectedAyahIndexes
                              .clear();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            customSvgWithColor(SvgPath.svgButtonCurve,
                                height: 45.0,
                                width: 45.0,
                                color: Get.theme.colorScheme.primary),
                            Container(
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                                child: customSvgWithColor(SvgPath.svgHome,
                                    height: 25.0,
                                    width: 25.0,
                                    color: Get.theme.colorScheme.secondary)),
                          ],
                        ),
                      )
                    : isNotification
                        ? GestureDetector(
                            onTap: () => Get.bottomSheet(NotificationsScreen(),
                                isScrollControlled: true),
                            child: const NotificationIconWidget(
                              isCurve: true,
                              iconHeight: 25,
                              padding: 4.0,
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
              Expanded(
                  flex: 7,
                  child:
                      isCenterChild ? centerChild! : const SizedBox.shrink()),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      SettingsList(
                        isQuranSetting: isQuranSetting,
                      ),
                      isScrollControlled: true,
                    );
                    generalCtrl.state.showSelectScreenPage.value = false;
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      customSvgWithColor(SvgPath.svgButtonCurve,
                          height: 45.0,
                          width: 45.0,
                          color: Get.theme.colorScheme.primary),
                      Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          child: customSvgWithColor(SvgPath.svgOptions,
                              height: 25.0,
                              width: 25.0,
                              color: Get.theme.colorScheme.secondary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
