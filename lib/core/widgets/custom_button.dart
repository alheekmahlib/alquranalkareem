import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../utils/constants/svg_constants.dart';

class CustomButton extends StatelessWidget {
  final String? svgPath;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? svgColor;
  final IconData? icon;
  final double? iconSize;
  final String? title;
  final Color? titleColor;
  final Color? borderColor;
  final Widget? iconWidget;
  final bool? isCustomSvgColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  const CustomButton(
      {super.key,
      this.svgPath,
      required this.onPressed,
      this.width,
      this.height,
      this.backgroundColor,
      this.shadowColor,
      this.svgColor,
      this.icon,
      this.iconSize,
      this.title,
      this.titleColor,
      this.borderColor,
      this.iconWidget,
      this.isCustomSvgColor = false,
      this.horizontalPadding,
      this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 30,
      width: width ?? 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          shadowColor: shadowColor ?? Colors.transparent,
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 4.0,
              vertical: verticalPadding ?? 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
        ),
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
                      ? isCustomSvgColor!
                          ? customSvgWithColor(
                              svgPath ?? SvgPath.svgPlayAll,
                              width: iconSize ?? 25,
                              color: svgColor ??
                                  context.theme.colorScheme.secondaryContainer,
                            )
                          : customSvgWithCustomColor(
                              svgPath ?? SvgPath.svgPlayAll,
                              width: iconSize ?? 25,
                              color:
                                  svgColor ?? context.theme.primaryColorLight,
                            )
                      : Icon(icon ?? Icons.cloud_download_outlined,
                          size: iconSize ?? 25,
                          color: svgColor ?? context.theme.primaryColorLight),
                ],
              )
            : svgPath != null
                ? isCustomSvgColor!
                    ? customSvgWithColor(
                        svgPath ?? SvgPath.svgPlayAll,
                        width: iconSize ?? 25,
                        color: svgColor ??
                            context.theme.colorScheme.secondaryContainer,
                      )
                    : customSvgWithCustomColor(
                        svgPath ?? SvgPath.svgPlayAll,
                        width: iconSize ?? 25,
                        color: svgColor ?? context.theme.primaryColorLight,
                      )
                : iconWidget ??
                    Icon(icon ?? Icons.cloud_download_outlined,
                        size: iconSize ?? 25,
                        color: svgColor ?? context.theme.primaryColorLight),
      ),
    );
  }
}
