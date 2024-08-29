import 'package:flutter/material.dart';

import 'expandable_text.dart';

class ReadMoreLess extends StatelessWidget {
  const ReadMoreLess({
    Key? key,
    required this.text,
    this.readLessText,
    this.readMoreText,
    this.animationDuration = const Duration(milliseconds: 200),
    this.collapsedHeight = 70,
    this.maxLines = 4,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.iconCollapsed,
    this.iconExpanded,
    this.customButtonBuilder,
    this.iconColor = Colors.black,
    this.buttonTextStyle,
  })  : assert(
          ((iconCollapsed == null && iconExpanded == null) ||
              customButtonBuilder == null),
          'You cannot use custom icons while using a custom button builder',
        ),
        assert(
          (buttonTextStyle == null || customButtonBuilder == null),
          'You cannot use a custom button style while using a custom button builder',
        ),
        assert(
          ((readLessText == null && readMoreText == null) ||
              customButtonBuilder == null),
          'You cannot provide readLess or readMore text when using a custom button builder',
        ),
        super(key: key);

  /// The main text to be displayed.
  final List<TextSpan> text;

  /// The text on the button when the text is expanded, in case the text overflows
  final String? readLessText;

  /// The text on the button when the text is collapsed, in case the text overflows
  final String? readMoreText;

  /// The duration of the animation when transitioning between read more and read less.
  final Duration animationDuration;

  /// The height of the [text] in the collapsed state.
  final double collapsedHeight;

  /// The maximum number of lines of the [text] in the collapsed state.
  final int maxLines;

  /// The main textstyle used for [text]
  final TextStyle? textStyle;

  /// Whether and how to align [text] horizontally.
  final TextAlign textAlign;

  /// Allows a widget to replace the icon in the read more/less button in the collapsed state.
  final Widget? iconCollapsed;

  /// Allows a widget to replace the icon in the read more/less button in the expanded state.
  final Widget? iconExpanded;

  /// Allows for a function that builds a custom clickable widget. [isCollapsed] is provided to detimine in what state
  /// the widget has to be built. [onPressed] is provided to allow for the widget to be clickable and to trigger the collapsed state.
  final Widget Function(bool isCollapsed, VoidCallback onPressed)?
      customButtonBuilder;

  /// The color of the icon in the read more/less button. Does not work when [iconCollapsed] or [iconExpanded] are specified.
  final Color iconColor;

  /// The textstyle used for the read more/less button
  final TextStyle? buttonTextStyle;

  bool exceedsMaxLines(TextStyle textStyle, BoxConstraints size) {
    final span = TextSpan(children: text, style: textStyle);

    final tp = TextPainter(
      maxLines: maxLines,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
      text: span,
    );

    tp.layout(maxWidth: size.maxWidth);

    return tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle ts = textStyle ?? Theme.of(context).textTheme.bodyMedium!;

    return Column(
      children: <Widget>[
        LayoutBuilder(
          builder: (context, size) {
            return exceedsMaxLines(ts, size)
                ? ExpandableText(
                    text: text,
                    animationDuration: animationDuration,
                    collapsedHeight: collapsedHeight,
                    readLessText: readLessText,
                    readMoreText: readMoreText,
                    textAlign: textAlign,
                    textStyle: ts,
                    iconCollapsed: iconCollapsed,
                    iconExpanded: iconExpanded,
                    customButtonBuilder: customButtonBuilder,
                    iconColor: iconColor,
                    buttonTextStyle: buttonTextStyle,
                  )
                : RichText(
                    text: TextSpan(children: text, style: ts),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: textAlign,
                  );
          },
        ),
      ],
    );
  }
}
