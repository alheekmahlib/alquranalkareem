import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';

extension BottomSheetExtension on void {
  void customBottomSheet(
    Widget child, {
    Color? backgroundColor,
    double? rightPadding,
    double? leftPadding,
    Widget? handleChild,
    Color? handleBackgroundColor,
    Color? handleDotsColor,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      // showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: Get.context!.customOrientation(Get.width, Get.width * .5),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          right: rightPadding ?? 8.0,
          left: leftPadding ?? 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (handleChild != null) handleChild,
            Container(
              height: 8,
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 62.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Gap(8.0),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color:
                    backgroundColor ??
                    Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(8.0),
                  context.customArrowDown(
                    backgroundColor: handleBackgroundColor,
                    dotsColor: handleDotsColor,
                  ),
                  const Gap(8.0),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
