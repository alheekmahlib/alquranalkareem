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
  final bool? isDownloading;
  final bool? isPreparingDownload;
  final String? downloadProgress;
  final Color? progressBackgroundColor;
  final Color? progressColor;
  final bool? isTitleCentered;
  final double? selectedValueMargin;
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
    this.isDownloading = false,
    this.downloadProgress,
    this.isPreparingDownload = false,
    this.progressBackgroundColor,
    this.isTitleCentered = false,
    this.progressColor,
    this.selectedValueMargin = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: IntrinsicHeight(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalMargin ?? 0.0,
              vertical: verticalMargin ?? 0.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: height ?? null,
                    width: width ?? null,
                    alignment: isTitleCentered == true
                        ? Alignment.center
                        : null,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? 4.0,
                      vertical: verticalPadding ?? 4.0,
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
                      mainAxisAlignment:
                          mainAxisAlignment ??
                          (isTitleCentered ?? false
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start),
                      children: [
                        if (value?.value ?? false)
                          Container(
                            // height: 10,
                            width: 8,
                            margin: EdgeInsets.symmetric(
                              vertical: selectedValueMargin ?? 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: value?.value ?? false
                                  ? selectedColor ??
                                        Theme.of(
                                          context,
                                        ).colorScheme.inverseSurface
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
                            color:
                                svgColor ??
                                Theme.of(context).colorScheme.surface,
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
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius ?? 8),
                              ),
                            ),
                          ),
                        if (isButton ?? false) const Gap(8),
                        if (title != null && (withArrow ?? false))
                          Expanded(
                            flex: 9,
                            child: Text(
                              title!.tr,
                              style: AppTextStyles.titleMedium(
                                color:
                                    titleColor ??
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                              ),
                            ),
                          )
                        else if (title != null)
                          Text(
                            title!.tr,
                            style: AppTextStyles.titleMedium(
                              color:
                                  titleColor ??
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        if (isDownloading ?? false) ...[
                          const Gap(12),
                          Text(
                            '${downloadProgress ?? '0'}%',
                            style: AppTextStyles.titleMedium(
                              color:
                                  titleColor ??
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                        if (isPreparingDownload ?? false) ...[
                          const Gap(12),
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                titleColor ??
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                              ),
                            ),
                          ),
                        ],
                        if (child != null) child!,
                        if (withArrow ?? false) const Spacer(),
                        if (withArrow ?? false)
                          Expanded(
                            flex: 1,
                            child: RotatedBox(
                              quarterTurns: alignmentLayout(1, 3),
                              child: customSvgWithColor(
                                SvgPath.svgHomeArrowDown,
                                color: context.theme.colorScheme.surface,
                                height: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (isDownloading ?? false) ...[
                    SizedBox(
                      height: 8,
                      width: width ?? null,
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        backgroundColor:
                            progressBackgroundColor ??
                            Theme.of(context).primaryColorLight,
                        value: (isDownloading ?? false)
                            ? (int.parse(downloadProgress ?? '0') / 100).clamp(
                                0.0,
                                1.0,
                              )
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor ??
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
