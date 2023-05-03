import 'package:flutter/material.dart';

class InsetShadowPainter extends CustomPainter {
  final Color color;
  final double blurRadius;
  final Offset offset;

  InsetShadowPainter({required this.color, required this.blurRadius, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;

    var paint = Paint()
      ..color = Colors.white
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, blurRadius);

    canvas.saveLayer(Offset.zero & size, paint);
    canvas.drawColor(color, BlendMode.srcATop);
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(path, paint);
    canvas.translate(-offset.dx, -offset.dy);
    canvas.restore();
  }

  @override
  bool shouldRepaint(InsetShadowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.offset != offset;
  }
}
