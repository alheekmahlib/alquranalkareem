import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/core/utils/constants/svg_constants.dart';
import '../../../widgets/container_button.dart';

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
      child: ContainerButton(
        svgHeight: height ?? 35,
        svgWidth: width ?? 35,
        horizontalMargin: 4.0,
        verticalMargin: 5.0,
        svgWithColorPath: SvgPath.svgHomeClose,
        backgroundColor: Colors.transparent,
        svgColor: Get.theme.primaryColorLight,
        onPressed:
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
    Color? backgroundColor,
    Color? dotsColor,
  }) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        child: Container(
          height: height ?? 20,
          width: width ?? 83,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            color: backgroundColor ?? Get.theme.colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: dotsColor ?? Get.theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: dotsColor ?? Get.theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
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
}
