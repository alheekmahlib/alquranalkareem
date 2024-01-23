import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions.dart';

class ContainerWithLines extends StatelessWidget {
  final Widget child;
  final Color? linesColor;
  final Color? containerColor;
  final double? width;
  const ContainerWithLines(
      {super.key,
      required this.child,
      this.linesColor,
      this.containerColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          context.hDivider(
              width: width ?? MediaQuery.sizeOf(context).width,
              color: linesColor),
          Container(
            width: width ?? MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: containerColor ?? Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: child,
          ),
          context.hDivider(
              width: width ?? MediaQuery.sizeOf(context).width,
              color: linesColor),
        ],
      ),
    );
  }
}
