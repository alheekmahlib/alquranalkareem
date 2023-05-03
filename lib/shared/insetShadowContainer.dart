import 'package:flutter/material.dart';
import 'custom_paint/shadowPainter.dart';

class InsetShadowContainer extends StatelessWidget {
  final Widget child;
  final double blurRadius;
  final Offset offset;
  final Color shadowColor;

  InsetShadowContainer({
    required this.child,
    this.blurRadius = 1.0,
    this.offset = const Offset(2.0, 2.0),
    this.shadowColor = const Color(0xff91a57d),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 1
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(50)
        ),
      ),
      child: CustomPaint(
        painter: InsetShadowPainter(
          color: shadowColor,
          blurRadius: blurRadius,
          offset: offset,
        ),
        child: ClipRect(
          child: child,
        ),
      ),
    );
  }
}
