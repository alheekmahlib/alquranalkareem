import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

extension SvgExtensionWithColor on Widget {
  Widget customSvgWithColor(String path,
      {double? height, double? width, Color? color}) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
          color ?? Get.theme.colorScheme.primary, BlendMode.srcIn),
    );
  }
}

extension SvgExtension on Widget {
  Widget customSvg(String path, {double? height, double? width}) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
    );
  }
}
