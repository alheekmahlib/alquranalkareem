import 'package:flutter/material.dart';

class ContainerWithBorder extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? width;
  const ContainerWithBorder({
    super.key,
    required this.child,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).colorScheme.primaryContainer)
            .withValues(alpha: 0.9),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: child,
      ),
    );
  }
}
