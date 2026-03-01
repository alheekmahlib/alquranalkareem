import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';

class CustomButton extends StatefulWidget {
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
  const CustomButton({
    super.key,
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
    this.verticalPadding,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          height: widget.height ?? 30,
          width: widget.width ?? 30,
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding ?? 4.0,
            vertical: widget.verticalPadding ?? 4.0,
          ),
          decoration: BoxDecoration(
            gradient: widget.backgroundColor != null
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.theme.colorScheme.primary.withValues(alpha: 0.1),
                      context.theme.colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16.0),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1)
                : null,
            boxShadow:
                widget.backgroundColor != null &&
                    widget.backgroundColor != Colors.transparent
                ? [
                    BoxShadow(
                      color:
                          (widget.shadowColor ??
                                  widget.backgroundColor ??
                                  Colors.black)
                              .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.title != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title!.tr,
                        style: TextStyle(
                          color:
                              widget.titleColor ??
                              context.theme.colorScheme.secondaryContainer,
                          fontFamily: 'kufi',
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(16),
                      _buildIcon(context),
                    ],
                  )
                : _buildIcon(context),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (widget.svgPath != null) {
      return SvgPicture.asset(
        widget.svgPath!,
        width: widget.iconSize ?? 25,
        colorFilter: ColorFilter.mode(
          widget.svgColor ??
              (widget.isCustomSvgColor!
                  ? context.theme.colorScheme.primary
                  : context.theme.primaryColorLight),
          widget.isCustomSvgColor! ? BlendMode.srcIn : BlendMode.modulate,
        ),
      );
    }
    return widget.iconWidget ??
        Icon(
          widget.icon ?? Icons.cloud_download_outlined,
          size: widget.iconSize ?? 25,
          color: widget.svgColor ?? context.theme.primaryColorLight,
        );
  }
}
