import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final double width;
  final double height;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.width = 61,
    this.height = 31,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackColor = value
        ? (activeColor ?? context.theme.primaryColorLight)
        : (inactiveTrackColor ?? context.theme.colorScheme.primaryContainer);
    const thumbPadding = 3.0;
    final thumbWidth = 40.0;
    final maxOffset = width - thumbWidth - (thumbPadding * 2);

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 0 && !value) {
          onChanged?.call(true);
        } else if (details.primaryVelocity! < 0 && value) {
          onChanged?.call(false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: trackColor,
        ),
        padding: const EdgeInsets.all(thumbPadding),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? maxOffset : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: thumbWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: thumbColor ?? context.theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitchListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? contentMargin;

  const CustomSwitchListTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.leading,
    this.activeColor,
    this.inactiveTrackColor,
    this.contentPadding,
    this.contentMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      margin: contentMargin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: value
            ? Theme.of(context).primaryColorLight.withValues(alpha: .1)
            : Theme.of(context).primaryColorLight.withValues(alpha: .15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 1,
          color: !value
              ? Colors.transparent
              : Theme.of(context).colorScheme.surface.withValues(alpha: .7),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
            const Gap(8),
            if (leading != null) ...[leading!, const SizedBox(width: 16)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium().copyWith(height: 2),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.titleMedium().copyWith(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
            CustomSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              inactiveTrackColor: inactiveTrackColor,
            ),
          ],
        ),
      ),
    );
  }
}
