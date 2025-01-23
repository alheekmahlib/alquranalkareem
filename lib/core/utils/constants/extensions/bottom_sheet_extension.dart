import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension BottomSheetExtension on void {
  void customBottomSheet(Widget child) {
    Get.bottomSheet(
      Container(
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
            )),
        child: child,
      ),
      isScrollControlled: true,
    );
  }
}
