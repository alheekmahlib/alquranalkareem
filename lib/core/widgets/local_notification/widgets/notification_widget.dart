import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../controller/local_notifications_controller.dart';

class NotificationWidget extends StatelessWidget {
  final int postId;
  NotificationWidget({required this.postId});

  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    final post = notiCtrl.postsList[postId - 1];
    return Container(
      height: Get.height * .9,
      width: Get.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.customClose(height: 40),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16.0),
          Text(
            post.body,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
