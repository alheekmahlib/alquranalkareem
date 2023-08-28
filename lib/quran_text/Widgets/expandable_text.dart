import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../shared/widgets/controllers_put.dart';

class ExpandableText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          AnimatedSize(
            duration: animationDuration,
            child: ConstrainedBox(
              constraints: generalController.isExpanded.value
                  ? const BoxConstraints()
                  : BoxConstraints(maxHeight: maxHeight),
              child: generalController.isExpanded.value
                  ? SelectableText(
                      text,
                      textAlign: textAlign,
                      style: TextStyle(
                        fontSize: generalController.fontSizeArabic.value - 10,
                        fontFamily: 'kufi',
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white
                            : Colors.black,
                        // overflow: TextOverflow.fade,
                      ),
                      textDirection: TextDirection.ltr,
                    )
                  : Text(
                      text,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: textAlign,
                      style: TextStyle(
                        fontSize: generalController.fontSizeArabic.value - 10,
                        fontFamily: 'kufi',
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white
                            : Colors.black,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
            ),
          ),
          generalController.isExpanded.value
              ? ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: TextButton.icon(
                    icon: Text(
                      readLessText ?? 'Read less',
                      style: buttonTextStyle ??
                          Theme.of(context).textTheme.titleMedium,
                    ),
                    label: iconExpanded ??
                        Icon(
                          Icons.arrow_drop_up,
                          color: iconColor,
                        ),
                    onPressed: () => generalController.isExpanded.value = false,
                  ),
                )
              : TextButton.icon(
                  icon: Text(
                    readMoreText ?? 'Read more',
                    style: buttonTextStyle ??
                        Theme.of(context).textTheme.titleMedium,
                  ),
                  label: iconCollapsed ??
                      Icon(
                        Icons.arrow_drop_down,
                        color: iconColor,
                      ),
                  onPressed: () => generalController.isExpanded.value = true,
                )
        ],
      ),
    );
  }
}
