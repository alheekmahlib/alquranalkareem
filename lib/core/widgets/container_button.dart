import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/svg_constants.dart';
import '../utils/constants/extensions/alignment_rotated_extension.dart';
import '../utils/constants/extensions/svg_extensions.dart';
import '../utils/helpers/app_text_styles.dart';

class ContainerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? selectedColor;
  final String? svgWithColorPath;
  final String? svgPath;
  final Color? svgColor;
  final double? svgHeight;
  final double? svgWidth;
  final String? title;
  final Color? titleColor;
  final RxBool? value;
  final Widget? child;
  final double? horizontalMargin;
  final double? verticalMargin;
  final bool? withArrow;
  final double? horizontalPadding;
  final double? verticalPadding;
  final MainAxisAlignment? mainAxisAlignment;
  final bool? isButton;
  const ContainerButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.selectedColor,
    this.svgWithColorPath,
    this.svgPath,
    this.svgColor,
    this.svgHeight,
    this.svgWidth,
    this.title,
    this.titleColor,
    this.value,
    this.child,
    this.horizontalMargin = 0.0,
    this.verticalMargin = 0.0,
    this.withArrow = false,
    this.horizontalPadding = 4.0,
    this.verticalPadding = 4.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: IntrinsicHeight(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            height: height ?? null,
            width: width ?? null,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 4.0,
              vertical: verticalPadding ?? 4.0,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin ?? 0.0,
              vertical: verticalMargin ?? 0.0,
            ),
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  Theme.of(context).primaryColorLight.withValues(
                    alpha: value?.value ?? false ? 0.5 : 0.2,
                  ),
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              children: [
                if (value?.value ?? false)
                  Container(
                    // height: 10,
                    width: 8,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: value?.value ?? false
                          ? selectedColor ??
                                Theme.of(context).colorScheme.inverseSurface
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(borderRadius ?? 8),
                      ),
                    ),
                  ),
                if (value?.value ?? false) const Gap(8),
                if (svgWithColorPath != null)
                  customSvgWithColor(
                    height: svgHeight ?? 24,
                    width: svgWidth ?? 24,
                    svgWithColorPath ?? SvgPath.svgAlert,
                    color: svgColor ?? Theme.of(context).colorScheme.surface,
                  ),
                if (svgPath != null)
                  customSvg(
                    height: svgHeight ?? 24,
                    width: svgWidth ?? 24,
                    svgPath ?? SvgPath.svgAlert,
                  ),
                if (isButton ?? false) const Gap(8),
                if (isButton ?? false)
                  Container(
                    // height: 10,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: BorderRadius.all(
                        Radius.circular(borderRadius ?? 8),
                      ),
                    ),
                  ),
                if (isButton ?? false) const Gap(8),
                if (title != null)
                  Text(
                    title!,
                    style: AppTextStyles.titleMedium(
                      color:
                          titleColor ??
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                if (child != null) child!,
                if (withArrow ?? false) const Spacer(),
                if (withArrow ?? false)
                  RotatedBox(
                    quarterTurns: alignmentLayout(1, 3),
                    child: customSvgWithColor(
                      SvgPath.svgHomeArrowDown,
                      color: context.theme.primaryColorDark,
                      height: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
