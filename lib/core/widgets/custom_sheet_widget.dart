import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '/core/utils/constants/extensions/extensions.dart';

class CustomSheetWidget extends StatelessWidget {
  final Widget child;
  final double? minSheetOffset;
  final double? maxSheetOffset;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final SheetController? controller;
  const CustomSheetWidget({
    super.key,
    required this.child,
    this.minSheetOffset,
    this.maxSheetOffset,
    this.padding,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final dynamicMinOffset = minSheetOffset ?? 1.0;
    final dynamicMaxOffset = maxSheetOffset ?? 1.0;
    return SheetViewport(
      child: Sheet(
        controller: controller ?? SheetController(),
        scrollConfiguration: const SheetScrollConfiguration(),
        decoration: const MaterialSheetDecoration(
          size: SheetSize.fit,
          color: Colors.transparent,
        ),
        initialOffset: SheetOffset((Get.height * dynamicMaxOffset) / 1000),
        physics: const ClampingSheetPhysics(),
        snapGrid: SheetSnapGrid(
          snaps: [
            SheetOffset((Get.height * dynamicMinOffset) / 1000),
            SheetOffset((Get.height * dynamicMaxOffset) / 1000),
          ],
        ),
        child: SheetContentScaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 8,
                  width: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 62.0),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const Gap(8.0),
                Expanded(
                  child: Container(
                    width: context.customOrientation(Get.width, Get.width * .5),
                    padding:
                        padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: SheetScrollable(
                      builder: (context, scrollController) {
                        return child;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
