import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/elevated_button_controller.dart';

class ElevatedLayerButton extends StatelessWidget {
  final double? buttonHeight;
  final double? buttonWidth;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final VoidCallback? onClick;
  final BoxDecoration? baseDecoration;
  final BoxDecoration? topDecoration;
  final Widget? topLayerChild;
  final BorderRadius? borderRadius;
  final int index;

  ElevatedLayerButton({
    Key? key,
    required this.buttonHeight,
    this.buttonWidth,
    required this.animationDuration,
    required this.animationCurve,
    required this.onClick,
    this.baseDecoration,
    this.topDecoration,
    this.topLayerChild,
    this.borderRadius,
    required this.index,
  }) : super(key: key);

  bool get _enabled => onClick != null;

  bool get _disabled => !_enabled;

  final elevatedCtrl = ElevatedButtonController.instance;

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: _disabled ? 0.5 : 1,
        child: GetBuilder<ElevatedButtonController>(
          id: 'buttonIndex_$index',
          builder: (elevatedCtrl) => GestureDetector(
            onTap: () {
              onClick!();
              log('Button $index clicked', name: 'ElevatedLayerButton');
              if (!_disabled) {
                elevatedCtrl.buttonPressed.value = true;
                elevatedCtrl.animationCompleted.value = false;
                // elevatedCtrl.isClicked.value = true;
                elevatedCtrl.update(['buttonIndex_$index']);
              }
            },
            child: SizedBox(
              height: buttonHeight,
              width: buttonWidth,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: (buttonWidth ?? 100) - 10,
                      height: (buttonHeight ?? 40) - 10,
                      decoration: baseDecoration?.copyWith(
                            borderRadius: borderRadius,
                          ) ??
                          BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                          ),
                    ),
                  ),
                  AnimatedPositioned(
                    bottom: _enabled
                        ? (elevatedCtrl.buttonPressed.value ? 0 : 4)
                        : 4,
                    right: _enabled
                        ? (elevatedCtrl.buttonPressed.value ? 0 : 4)
                        : 4,
                    duration:
                        animationDuration ?? const Duration(milliseconds: 300),
                    curve: animationCurve ?? Curves.ease,
                    onEnd: () {
                      if (!elevatedCtrl.animationCompleted.value) {
                        elevatedCtrl.animationCompleted.value = true;
                        elevatedCtrl.buttonPressed.value = false;
                        // if (elevatedCtrl.isClicked.value) {
                        //   onClick!();
                        //   elevatedCtrl.isClicked.value = false;
                        // }
                        elevatedCtrl.update(['buttonIndex_$index']);
                      }
                    },
                    child: Container(
                      width: (buttonWidth ?? 100) - 10,
                      height: (buttonHeight ?? 100) - 10,
                      alignment: Alignment.center,
                      decoration: topDecoration?.copyWith(
                            borderRadius: borderRadius,
                          ) ??
                          BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                          ),
                      child: topLayerChild,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
