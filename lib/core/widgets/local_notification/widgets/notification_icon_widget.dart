import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../utils/constants/svg_constants.dart';
import '../controller/local_notifications_controller.dart';

class NotificationIconWidget extends StatelessWidget {
  final double iconHeight;
  const NotificationIconWidget({super.key, required this.iconHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GetX<LocalNotificationsController>(
          builder: (notiCtrl) {
            return badges.Badge(
              showBadge: notiCtrl.unreadCount > 0,
              position: badges.BadgePosition.bottomEnd(bottom: -22, end: -20),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.square,
                badgeColor: Theme.of(context).colorScheme.primaryContainer,
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                borderRadius: BorderRadius.circular(4),
                elevation: 0,
              ),
              badgeContent: Text(
                notiCtrl.unreadCount.toString().convertNumbersToCurrentLang(),
                style: TextStyle(
                  fontFamily: 'naskh',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: customSvgWithColor(
                SvgPath.svgHomeNotifications,
                height: iconHeight,
              ),
            );
          },
        ),
      ],
    );
  }
}
