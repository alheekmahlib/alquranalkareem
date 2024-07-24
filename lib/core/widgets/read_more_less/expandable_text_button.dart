import 'package:flutter/material.dart';

class ExpandableTextButton extends StatelessWidget {
  const ExpandableTextButton({
    super.key,
    required this.expanded,
    required this.toggleExpand,
    this.readLessText,
    this.readMoreText,
    this.buttonTextStyle,
    this.iconExpanded,
    this.iconCollapsed,
    this.iconColor,
  });

  final bool expanded;
  final VoidCallback toggleExpand;

  final String? readLessText;
  final String? readMoreText;
  final TextStyle? buttonTextStyle;
  final Widget? iconExpanded;
  final Widget? iconCollapsed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return expanded
        ? ConstrainedBox(
            constraints: const BoxConstraints(),
            child: TextButton.icon(
              icon: Text(
                readLessText ?? 'Read less',
                style: buttonTextStyle,
              ),
              label: iconExpanded ??
                  Icon(
                    Icons.arrow_drop_up,
                    color: iconColor,
                  ),
              onPressed: toggleExpand,
            ),
          )
        : TextButton.icon(
            icon: Text(
              readMoreText ?? 'Read more',
              style: buttonTextStyle,
            ),
            label: iconCollapsed ??
                Icon(
                  Icons.arrow_drop_down,
                  color: iconColor,
                ),
            onPressed: toggleExpand,
          );
  }
}
