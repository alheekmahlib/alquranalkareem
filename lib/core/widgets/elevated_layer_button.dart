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
            if (!_disabled) {
              elevatedCtrl.buttonPressed.value = true;
              elevatedCtrl.animationCompleted.value = false;
              elevatedCtrl.update(['buttonIndex_$index']);
            }
          },
          child: AnimatedScale(
            scale: _enabled
                ? (elevatedCtrl.buttonPressed.value ? 0.96 : 1.0)
                : 1.0,
            duration: animationDuration ?? const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            onEnd: () {
              if (!elevatedCtrl.animationCompleted.value) {
                elevatedCtrl.animationCompleted.value = true;
                elevatedCtrl.buttonPressed.value = false;
                elevatedCtrl.update(['buttonIndex_$index']);
              }
            },
            child: Container(
              width: (buttonWidth ?? 100),
              height: (buttonHeight ?? 100),
              alignment: Alignment.center,
              decoration:
                  topDecoration?.copyWith(
                    borderRadius:
                        borderRadius ??
                        const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: (topDecoration?.color ?? Colors.black)
                            .withValues(alpha: 0.25),
                        blurRadius: elevatedCtrl.buttonPressed.value ? 4 : 10,
                        offset: Offset(
                          0,
                          elevatedCtrl.buttonPressed.value ? 2 : 5,
                        ),
                      ),
                    ],
                  ) ??
                  BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
              child: topLayerChild,
            ),
          ),
        ),
      ),
    );
  }
}
