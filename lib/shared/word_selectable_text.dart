import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WordSelectableText extends StatefulWidget {
  final List<InlineSpan> text;
  // final String text;
  final Function(String word, int? index)? onWordTapped;
  final bool highlight;
  final Color? highlightColor;
  final String alphabets;
  final TextStyle? style;
  final TextDirection textDirection;
  final bool selectable;
  WordSelectableText(
      {Key? key,
        required this.text,
        this.onWordTapped,
        this.highlight = true,
        this.highlightColor,
        this.alphabets = '[a-zA-Z]',
        this.style,
        this.selectable = true,
        this.textDirection = TextDirection.ltr})
      : super(key: key);

  @override
  _WordSelectableTextState createState() => _WordSelectableTextState();
}

class _WordSelectableTextState extends State<WordSelectableText> {
  int? selectedWordIndex;
  Color? highlightColor;
  @override
  void initState() {
    selectedWordIndex = -1;
    if (widget.highlightColor == null)
      highlightColor = Colors.pink.withOpacity(0.3);
    else
      highlightColor = widget.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> wordList = widget.text
        .map((span) => span.toPlainText())  // Convert InlineSpan to String
        .join(' ')  // Join all elements of list into one String
        .replaceAll(RegExp(r'(\n)+'), "#")
        .trim()
        .split(RegExp(r'\s|(?<=#)'));
    return widget.selectable
        ? SelectableText.rich(
      textAlign: TextAlign.justify,
      TextSpan(
        children: [
          for (int i = 0; i < wordList.length; i++)
            TextSpan(
              children: [
                TextSpan(
                    text: wordList[i].replaceAll("#", ""),
                    style: TextStyle(

                        backgroundColor:
                        selectedWordIndex == i && widget.highlight
                            ? highlightColor
                            : Colors.transparent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          selectedWordIndex = i;
                        });
                        if (widget.onWordTapped != null)
                          widget.onWordTapped!(
                              wordList[i]
                                  .trim()
                                  .replaceAll(
                                  RegExp(r'${widget.alphabets}'), "")
                                  .trim(),
                              selectedWordIndex);
                      }),
                wordList[i].contains("#")
                    ? const TextSpan(text: "\n\n")
                    : const TextSpan(text: " "),
              ],
            )
          // generateSpans()
        ],
      ),
      style: widget.style ?? const TextStyle(),
      textDirection: widget.textDirection,
    )
        : Text.rich(
      TextSpan(
        children: [
          for (int i = 0; i < wordList.length; i++)
            TextSpan(
              children: [
                TextSpan(
                    text: wordList[i].replaceAll("#", ""),
                    style: TextStyle(
                        backgroundColor:
                        selectedWordIndex == i && widget.highlight
                            ? highlightColor
                            : Colors.transparent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          selectedWordIndex = i;
                        });
                        if (widget.onWordTapped != null)
                          widget.onWordTapped!(
                              wordList[i]
                                  .trim()
                                  .replaceAll(
                                  RegExp(r'${widget.alphabets}'), "")
                                  .trim(),
                              selectedWordIndex);
                      }),
                wordList[i].contains("#")
                    ? const TextSpan(text: "\n\n")
                    : const TextSpan(text: " "),
              ],
            )
          // generateSpans()
        ],
      ),
      style: widget.style ?? const TextStyle(),
      textDirection: widget.textDirection,
    );
  }
}