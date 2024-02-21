import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  const ContainerButton(
      {super.key, this.height, this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 65,
      width: width ?? MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.surface.withOpacity(.4),
                offset: const Offset(6, 6),
                spreadRadius: 0,
                blurRadius: 0)
          ]),
      child: child,
    );
  }
}
