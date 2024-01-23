import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerWithBorder extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? width;
  const ContainerWithBorder(
      {super.key, required this.child, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
              color: color ?? Get.theme.colorScheme.background, width: 1)),
      child: Container(
        // width: width ?? MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: color ?? Get.theme.colorScheme.background,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: child,
      ),
    );
  }
}
