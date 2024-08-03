import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/controllers/general/general_controller.dart';
import '../../utils/constants/svg_constants.dart';
import 'controller/local_notifications_controller.dart';
import 'widgets/notification_icon_widget.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .8,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                context.customWhiteClose(height: 30),
                const Gap(8),
                context.vDivider(height: 20),
                const Gap(8),
                Text(
                  'notification'.tr,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Gap(32),
            Flexible(
              child: GetBuilder<LocalNotificationsController>(
                builder: (notiCtrl) => notiCtrl.postsList.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            const Gap(64),
                            customSvg(SvgPath.svgNotifications, width: 80),
                            const Gap(32),
                            Text(
                              'noNotifications'.tr,
                              style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: NotificationIconWidget(
                              isCurve: false,
                              iconHeight: 60,
                              padding: 8.0,
                            ),
                          ),
                          const Gap(16),
                          Flexible(
                            child: ListView.builder(
                              itemCount: notiCtrl.postsList.length,
                              itemBuilder: (context, index) {
                                // عكس القائمة
                                var reversedList =
                                    notiCtrl.postsList.reversed.toList();
                                var noti = reversedList[index];

                                return ExpansionTileCard(
                                  elevation: 0.0,
                                  initialElevation: 0.0,
                                  baseColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.2),
                                  expandedColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.2),
                                  onExpansionChanged: (_) =>
                                      notiCtrl.markNotificationAsRead(noti.id),
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: noti.opened
                                          ? Theme.of(context)
                                              .canvasColor
                                              .withOpacity(.1)
                                          : Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.15),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(
                                        width: 1,
                                        color: noti.opened
                                            ? Colors.transparent
                                            : Theme.of(context)
                                                .colorScheme
                                                .surface,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          noti.title,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontFamily: 'kufi',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        customSvgWithColor(
                                          SvgPath.svgNotifications,
                                          height: 25,
                                          color: noti.opened
                                              ? Theme.of(context).canvasColor
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: <Widget>[
                                    Text(
                                      noti.title,
                                      style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        fontSize: GeneralController.instance
                                            .state.fontSizeArabic.value,
                                      ),
                                    ),
                                    context.hDivider(width: Get.width),
                                    const Gap(16),
                                    Text(
                                      noti.body,
                                      style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        fontSize: GeneralController.instance
                                                .state.fontSizeArabic.value -
                                            2,
                                      ),
                                    ),
                                    const Gap(32),
                                    noti.isLottie && noti.lottie.isNotEmpty
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .canvasColor
                                                  .withOpacity(.15),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                            ),
                                            child: Lottie.network(
                                              noti.lottie,
                                              width: Get.width * .5,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const CircularProgressIndicator
                                                      .adaptive(),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    const Gap(32),
                                    noti.isImage && noti.image.isNotEmpty
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .canvasColor
                                                  .withOpacity(.15),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                            ),
                                            child: Image.network(
                                              noti.image,
                                              width: Get.width * .5,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const CircularProgressIndicator
                                                      .adaptive(),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    const Gap(8),
                                    context.hDivider(width: Get.width),
                                    const Gap(16),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
