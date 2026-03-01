import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/elevated_button_controller.dart';
import 'elevated_layer_button.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final Color? color;
  final Color? colorShadow;
  final void Function()? onClick;
  final int index;
  final BoxBorder? border;
  final int? delayed;

  const ElevatedButtonWidget({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.color,
    this.onClick,
    required this.index,
    this.colorShadow,
    this.border,
    this.delayed,
  });

  @override
  Widget build(BuildContext context) {
    ElevatedButtonController.instance.initElevatedButton(
      index,
      delayed: delayed,
    );
    return ElevatedLayerButton(
      index: index,
      onClick: onClick,
      buttonHeight: height ?? 65,
      buttonWidth: width ?? Get.width,
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.easeOutBack,
      topDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (color ?? Theme.of(context).colorScheme.primary),
            (color ?? Theme.of(context).colorScheme.primary).withValues(
              alpha: 0.85,
            ),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: border,
      ),
      topLayerChild: child,
    );
  }
}
