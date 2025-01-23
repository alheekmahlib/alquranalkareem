import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  const ElevatedButtonWidget(
      {super.key,
      this.height,
      this.width,
      required this.child,
      this.color,
      this.onClick,
      required this.index,
      this.colorShadow,
      this.border});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ElevatedLayerButton(
        index: index,
        onClick: onClick,
        buttonHeight: height ?? 65,
        buttonWidth: width ?? Get.width,
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.ease,
        topDecoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: border,
        ),
        topLayerChild: child,
        baseDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: colorShadow ??
                      Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: .4),
                  // offset: const Offset(6, 6),
                  spreadRadius: 0,
                  blurRadius: 0)
            ]),
      ),
    );
  }
}
