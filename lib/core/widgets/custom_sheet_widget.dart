import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    final sheetController = controller ?? SheetController();
    final minSnap = SheetOffset((Get.height * dynamicMinOffset) / 1000);
    final maxSnap = SheetOffset((Get.height * dynamicMaxOffset) / 1000);
    return SheetViewport(
      child: Sheet(
        controller: sheetController,
        scrollConfiguration: const SheetScrollConfiguration(),
        decoration: const MaterialSheetDecoration(
          size: SheetSize.fit,
          color: Colors.transparent,
        ),
        initialOffset: SheetOffset((Get.height * dynamicMaxOffset) / 1000),
        physics: const ClampingSheetPhysics(),
        snapGrid: SheetSnapGrid(snaps: [minSnap, maxSnap]),
        child: SheetContentScaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: _DragHandle(
              sheetController: sheetController,
              minSnap: minSnap,
              maxSnap: maxSnap,
              dynamicMinOffset: dynamicMinOffset,
              dynamicMaxOffset: dynamicMaxOffset,
              color: context.theme.primaryColorLight,
              child: Expanded(
                child: Container(
                  width: context.customOrientation(Get.width, Get.width * .5),
                  padding:
                      padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
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
            ),
          ),
        ),
      ),
    );
  }
}

/// مقبض السحب الذي يدعم الماوس والتراكباد على سطح المكتب.
///
/// حزمة smooth_sheets تدعم اللمس فقط ([PointerDeviceKind.touch])
/// في [SheetDraggable] الداخلي، لذلك نضيف [GestureDetector]
/// يدعم الماوس والتراكباد للنقر والسحب العمودي.
class _DragHandle extends StatelessWidget {
  final SheetController sheetController;
  final SheetOffset minSnap;
  final SheetOffset maxSnap;
  final double dynamicMinOffset;
  final double dynamicMaxOffset;
  final Color color;
  final Widget child;

  const _DragHandle({
    required this.sheetController,
    required this.minSnap,
    required this.maxSnap,
    required this.dynamicMinOffset,
    required this.dynamicMaxOffset,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      supportedDevices: const {
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      },
      onTap: () {
        final current = sheetController.value ?? 0;
        final midOffset =
            (Get.height * dynamicMinOffset + Get.height * dynamicMaxOffset) /
            2000;
        if (current > midOffset) {
          sheetController.animateTo(minSnap);
        } else {
          sheetController.animateTo(maxSnap);
        }
      },
      onVerticalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy > 0) {
          sheetController.animateTo(minSnap);
        } else {
          sheetController.animateTo(maxSnap);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeUpDown,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 8,
                width: 350,
                margin: const EdgeInsets.symmetric(horizontal: 62.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
