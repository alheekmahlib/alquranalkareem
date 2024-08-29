import 'package:flutter/material.dart';

import 'expandable_text_button.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    required this.textStyle,
    Key? key,
    this.readLessText,
    this.readMoreText,
    this.animationDuration = const Duration(milliseconds: 200),
    this.collapsedHeight = 70,
    this.iconCollapsed,
    this.iconExpanded,
    this.customButtonBuilder,
    this.textAlign = TextAlign.center,
    this.iconColor = Colors.black,
    this.buttonTextStyle,
  }) : super(key: key);

  final List<TextSpan> text;
  final String? readLessText;
  final String? readMoreText;
  final Duration animationDuration;
  final double collapsedHeight;
  final TextStyle textStyle;
  final Widget? iconExpanded;
  final Widget? iconCollapsed;
  final Widget Function(bool isCollapsed, VoidCallback onPressed)?
      customButtonBuilder;
  final TextAlign textAlign;
  final Color iconColor;
  final TextStyle? buttonTextStyle;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  void _toggleExpand() {
    setState(() {
      _crossFadeState = _crossFadeState == CrossFadeState.showSecond
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedCrossFade(
          duration: widget.animationDuration,
          firstChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.collapsedHeight),
            child: RichText(
              text: TextSpan(
                children: widget.text,
                style: widget.textStyle,
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: widget.textAlign,
            ),
          ),
          secondChild: RichText(
            text: TextSpan(
              children: widget.text,
              style: widget.textStyle,
            ),
            softWrap: true,
            overflow: TextOverflow.fade,
            textAlign: widget.textAlign,
          ),
          crossFadeState: _crossFadeState,
        ),
        if (widget.customButtonBuilder != null)
          widget.customButtonBuilder!(
              _crossFadeState == CrossFadeState.showFirst, _toggleExpand)
        else
          ExpandableTextButton(
            expanded: _crossFadeState == CrossFadeState.showSecond,
            toggleExpand: _toggleExpand,
            readLessText: widget.readLessText,
            readMoreText: widget.readMoreText,
            iconCollapsed: widget.iconCollapsed,
            iconExpanded: widget.iconExpanded,
            iconColor: widget.iconColor,
            buttonTextStyle: widget.buttonTextStyle,
          ),
      ],
    );
  }
}
