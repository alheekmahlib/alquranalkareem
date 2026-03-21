import 'package:alquranalkareem/core/widgets/expansion_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/title_widget.dart';
import '../../../presentation/controllers/general/general_controller.dart';
import '../../utils/constants/svg_constants.dart';
import 'controller/local_notifications_controller.dart';
import 'widgets/notification_icon_widget.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(title: 'notification'),
          const Gap(32),
          Expanded(
            child: GetBuilder<LocalNotificationsController>(
              builder: (notiCtrl) => notiCtrl.postsList.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          const Gap(64),
                          customSvgWithCustomColor(
                            SvgPath.svgNotifications,
                            width: 80,
                          ),
                          const Gap(32),
                          Text(
                            'noNotifications'.tr,
                            style: AppTextStyles.titleMedium(),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: NotificationIconWidget(
                            iconHeight: 60,
                            inScreen: true,
                          ),
                        ),
                        const Gap(16),
                        Flexible(
                          child: ListView.builder(
                            itemCount: notiCtrl.postsList.length,
                            itemBuilder: (context, index) {
                              var reversedList = notiCtrl.postsList.reversed
                                  .toList();
                              var noti = reversedList[index];
                              return noti.appName == 'quran'
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 2.0,
                                      ),
                                      child: ExpansionTileWidget(
                                        name:
                                            noti.appName +
                                            ' - ' +
                                            noti.id.toString(),
                                        title: noti.title,
                                        getxCtrl: notiCtrl,
                                        manager: GeneralController
                                            .instance
                                            .state
                                            .expansionManager,
                                        backgroundColor: noti.opened
                                            ? context.theme.primaryColorLight
                                                  .withValues(alpha: .1)
                                            : context.theme.primaryColorLight
                                                  .withValues(alpha: .3),
                                        onExpansionChanged: (_) => notiCtrl
                                            .markNotificationAsRead(noti.id),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              noti.title,
                                              style:
                                                  AppTextStyles.titleMedium(),
                                            ),
                                            context.hDivider(width: Get.width),
                                            const Gap(16),
                                            Text(
                                              noti.body,
                                              style: AppTextStyles.titleSmall(),
                                            ),
                                            const Gap(32),
                                            noti.isLottie &&
                                                    noti.lottie.isNotEmpty
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor
                                                          .withValues(
                                                            alpha: .15,
                                                          ),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.surface,
                                                      ),
                                                    ),
                                                    child: Lottie.network(
                                                      noti.lottie,
                                                      width: Get.width * .5,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) =>
                                                              const CircularProgressIndicator.adaptive(),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            const Gap(32),
                                            noti.isImage &&
                                                    noti.image.isNotEmpty
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor
                                                          .withValues(
                                                            alpha: .15,
                                                          ),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.surface,
                                                      ),
                                                    ),
                                                    child: Image.network(
                                                      noti.image,
                                                      width: Get.width * .5,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) =>
                                                              const CircularProgressIndicator.adaptive(),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            const Gap(8),
                                            context.hDivider(width: Get.width),
                                            const Gap(16),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
