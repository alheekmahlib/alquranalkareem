import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        BlendMode,
        BuildContext,
        Color,
        Colors,
        Curves,
        LinearGradient,
        Opacity,
        ShaderMask,
        SizedBox,
        StatelessWidget,
        Widget;

import '../utils/constants/svg_constants.dart';

class AnimatedDrawingWidget extends StatelessWidget {
  final String? svgPath;
  final double? height;
  final double? width;
  final double? opacity;
  final int? duration;
  final AnimationDirection? animationDirection;
  final Color? customColor;
  final bool? isRepeat;
  final PaintMode? paintMode;

  const AnimatedDrawingWidget({
    super.key,
    this.height,
    this.width,
    this.opacity,
    this.duration,
    this.animationDirection,
    this.customColor,
    this.svgPath,
    this.isRepeat,
    this.paintMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 90,
      width: width ?? 170,
      child: Opacity(
        opacity: opacity ?? 1.0,
        child: _buildAnimatedDrawing(context),
      ),
    );
  }

  Widget _buildAnimatedDrawing(BuildContext context) {
    final effectiveColor = customColor ?? Colors.white;

    final gradient = LinearGradient(
      colors: [effectiveColor, effectiveColor],
      begin: Alignment.center,
      end: Alignment.center,
    );

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: BlendMode.modulate,
      child: AnimatedDrawing.svg(
        paintMode: paintMode ?? PaintMode.fillOnly,
        svgPath ?? SvgPath.svgHomeQuranLogo,
        animationDirection:
            animationDirection ?? AnimationDirection.rightToLeft,
        run: true,
        duration: Duration(seconds: duration ?? 3),
        height: height ?? 90,
        width: width ?? 170,
        scaleToViewport: true,
        repeat: isRepeat ?? false,
        lineAnimation: LineAnimation.oneByOne,
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}
