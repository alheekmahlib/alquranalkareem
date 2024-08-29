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

  Widget vDivider({double? height, Color? color}) {
    return Container(
      height: height ?? 20,
      width: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: color ?? Get.theme.colorScheme.surface,
    );
  }

  Widget hDivider({double? width, double? height, Color? color}) {
    return Container(
      height: height ?? 2,
      width: width ?? MediaQuery.sizeOf(this).width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: color ?? Get.theme.colorScheme.surface,
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
        onTap: close ??
            () {
              Get.back();
            },
      ),
    );
  }

  Widget customArrowDown(
      {var close, double? height, double? width, bool? isBorder}) {
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
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Theme.of(this).colorScheme.primary,
                    width: 1,
                  ))
              : null,
          child: SvgPicture.asset(
            SvgPath.svgArrowDown,
          ),
        ),
        onTap: close ??
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
        onTap: close ??
            () {
              Get.back();
            },
      ),
    );
  }
}
