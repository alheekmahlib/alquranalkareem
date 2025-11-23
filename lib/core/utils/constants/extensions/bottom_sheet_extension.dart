import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';

extension BottomSheetExtension on void {
  void customBottomSheet(Widget child) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      // showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: Get.context!.customOrientation(Get.width, Get.width * .5),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          border: Border.all(
            width: 1,
            color: Get.theme.colorScheme.surface.withValues(alpha: .4),
          ),
        ),
        child: child,
      ),
    );
  }
}
