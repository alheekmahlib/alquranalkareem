import 'package:flutter/material.dart';

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
              color: color ?? Theme.of(context).colorScheme.primaryContainer,
              width: 1)),
      child: Container(
        // width: width ?? MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: child,
      ),
    );
  }
}
