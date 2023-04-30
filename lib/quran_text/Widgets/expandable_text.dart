import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../text_page_view.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    Key? key,
    this.readLessText,
    this.readMoreText,
    this.animationDuration = const Duration(milliseconds: 200),
    this.maxHeight = 70,
    this.textStyle,
    this.iconCollapsed,
    this.iconExpanded,
    this.textAlign = TextAlign.center,
    this.iconColor = Colors.black,
    this.buttonTextStyle,
  }) : super(key: key);

  final String text;
  final String? readLessText;
  final String? readMoreText;
  final Duration animationDuration;
  final double maxHeight;
  final TextStyle? textStyle;
  final Widget? iconExpanded;
  final Widget? iconCollapsed;
  final TextAlign textAlign;
  final Color iconColor;
  final TextStyle? buttonTextStyle;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedSize(
          duration: widget.animationDuration,
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                : BoxConstraints(maxHeight: widget.maxHeight),
            child: isExpanded ? SelectableText(
              widget.text,
              textAlign: widget.textAlign,
              style: TextStyle(
                fontSize: TextPageView.fontSizeArabic - 10,
                fontFamily: 'kufi',
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : Colors.black,
                // overflow: TextOverflow.fade,
              ),
              textDirection: TextDirection.ltr,
            ) : Text(widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: widget.textAlign,
                style: TextStyle(
                  fontSize: TextPageView.fontSizeArabic - 10,
                  fontFamily: 'kufi',
                  color: ThemeProvider.themeOf(context).id == 'dark'
                      ? Colors.white
                      : Colors.black,
                ),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
        isExpanded
            ? ConstrainedBox(
          constraints: const BoxConstraints(),
          child: TextButton.icon(
            icon: Text(
              widget.readLessText ?? 'Read less',
              style: widget.buttonTextStyle ??
                  Theme.of(context).textTheme.subtitle1,
            ),
            label: widget.iconExpanded ??
                Icon(
                  Icons.arrow_drop_up,
                  color: widget.iconColor,
                ),
            onPressed: () => setState(() => isExpanded = false),
          ),
        )
            : TextButton.icon(
          icon: Text(
            widget.readMoreText ?? 'Read more',
            style: widget.buttonTextStyle ??
                Theme.of(context).textTheme.subtitle1,
          ),
          label: widget.iconCollapsed ??
              Icon(
                Icons.arrow_drop_down,
                color: widget.iconColor,
              ),
          onPressed: () => setState(() => isExpanded = true),
        )
      ],
    );
  }
}