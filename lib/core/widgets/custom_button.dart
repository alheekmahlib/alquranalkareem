import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../utils/constants/svg_constants.dart';

class CustomButton extends StatelessWidget {
  final String? svgPath;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? svgColor;
  final IconData? icon;
  final double? iconSize;
  final String? title;
  final Color? titleColor;
  const CustomButton(
      {super.key,
      this.svgPath,
      required this.onPressed,
      this.width,
      this.backgroundColor,
      this.shadowColor,
      this.svgColor,
      this.icon,
      this.iconSize,
      this.title,
      this.titleColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 30,
      width: width ?? 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            shadowColor: shadowColor ?? Colors.transparent,
            padding: const EdgeInsets.all(4.0)),
        onPressed: onPressed,
        child: title != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  title != null
                      ? Text(
                          title!.tr,
                          style: TextStyle(
                              color: titleColor ??
                                  context.theme.colorScheme.secondaryContainer,
                              fontFamily: 'kufi',
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
                  title != null ? const Gap(16) : const SizedBox.shrink(),
                  svgPath != null
                      ? customSvgWithCustomColor(
                          svgPath ?? SvgPath.svgPlayAll,
                          width: iconSize ?? 25,
                          color: svgColor ?? context.theme.primaryColorLight,
                        )
                      : Icon(icon ?? Icons.cloud_download_outlined,
                          size: iconSize ?? 25,
                          color: svgColor ?? context.theme.primaryColorLight),
                ],
              )
            : svgPath != null
                ? customSvgWithCustomColor(
                    svgPath ?? SvgPath.svgPlayAll,
                    width: iconSize ?? 25,
                    color: svgColor ?? context.theme.primaryColorLight,
                  )
                : Icon(icon ?? Icons.cloud_download_outlined,
                    size: iconSize ?? 25,
                    color: svgColor ?? context.theme.primaryColorLight),
      ),
    );
  }
}
