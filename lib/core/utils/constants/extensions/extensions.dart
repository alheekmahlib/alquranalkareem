import 'dart:io';

import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

extension ContextExtensions on BuildContext {
  dynamic customOrientation(var n1, var n2) {
    Orientation orientation = MediaQuery.orientationOf(this);
    return orientation == Orientation.portrait ? n1 : n2;
  }

  dynamic definePlatform(var p1, var p2) =>
      (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) ? p1 : p2;

  /// Gradient fading vertical divider
  Widget vDivider({double? height, Color? color}) {
    final c = color ?? Get.theme.colorScheme.surface;
    return Container(
      height: height ?? 20,
      width: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(1)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.withValues(alpha: 0.0), c, c, c.withValues(alpha: 0.0)],
          stops: const [0.0, 0.25, 0.75, 1.0],
        ),
      ),
    );
  }

  /// Gradient fading horizontal divider
  Widget hDivider({double? width, double? height, Color? color}) {
    final c = color ?? Get.theme.colorScheme.surface;
    return Container(
      height: height ?? 1.5,
      width: width ?? MediaQuery.sizeOf(this).width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(1)),
        gradient: LinearGradient(
          colors: [
            c.withValues(alpha: 0.0),
            c.withValues(alpha: 0.7),
            c.withValues(alpha: 0.7),
            c.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
    );
  }

  Widget customClose({var close, double? height, double? width}) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        child: SvgPicture.asset(
          SvgPath.svgClose,
          height: height ?? 30,
          width: width ?? 30,
        ),
        onTap:
            close ??
            () {
              Get.back();
            },
      ),
    );
  }

  Widget customArrowDown({
    var close,
    double? height,
    double? width,
    bool? isBorder,
  }) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        child: Container(
          height: height ?? 35,
          width: width ?? 35,
          padding: const EdgeInsets.all(6.0),
          decoration: isBorder!
              ? BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(
                    color: Theme.of(this).colorScheme.primary,
                    width: 1,
                  ),
                )
              : null,
          child: SvgPicture.asset(SvgPath.svgArrowDown),
        ),
        onTap:
            close ??
            () {
              Get.back();
            },
      ),
    );
  }

  Widget customWhiteClose({var close, double? height}) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        child: SvgPicture.asset(
          'assets/svg/close.svg',
          height: height ?? 30,
          width: 30,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        onTap:
            close ??
            () {
              Get.back();
            },
      ),
    );
  }

  /// Glassmorphic container decoration
  BoxDecoration glassmorphicDecoration({
    Color? color,
    double borderRadius = 16.0,
    double opacity = 0.12,
    double borderOpacity = 0.2,
  }) {
    final baseColor = color ?? Theme.of(this).colorScheme.primaryContainer;
    return BoxDecoration(
      color: baseColor.withValues(alpha: opacity),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      border: Border.all(
        color: Theme.of(
          this,
        ).colorScheme.surface.withValues(alpha: borderOpacity),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
