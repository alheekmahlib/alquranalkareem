import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../utils/constants/svg_constants.dart';
import '../../../utils/helpers/app_text_styles.dart';
import '../controller/local_notifications_controller.dart';

class NotificationIconWidget extends StatelessWidget {
  final double iconHeight;
  final bool? inScreen;
  const NotificationIconWidget({
    super.key,
    required this.iconHeight,
    this.inScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GetX<LocalNotificationsController>(
          builder: (notiCtrl) {
            return badges.Badge(
              showBadge: notiCtrl.unreadCount > 0,
              position: badges.BadgePosition.center(),
              badgeStyle: const badges.BadgeStyle(
                shape: badges.BadgeShape.square,
                badgeColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                elevation: 0,
              ),
              badgeContent: Text(
                notiCtrl.unreadCount.toString().convertNumbersToCurrentLang(),
                style: AppTextStyles.titleSmall(
                  height: inScreen == true ? 2.3 : 2.3,
                  fontSize: inScreen == true ? 28 : 14,
                  color: context.theme.canvasColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: customSvgWithColor(
                SvgPath.svgHomeNotifications,
                height: iconHeight,
                color: notiCtrl.unreadCount > 0
                    ? context.theme.colorScheme.surface
                    : context.theme.colorScheme.primary,
              ),
            );
          },
        ),
      ],
    );
  }
}
