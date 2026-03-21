import 'package:flutter/material.dart';

import '../../../../presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';

extension TextSpanExtension on String {
  List<TextSpan> buildTextSpans() {
    String text = this;

    // Insert line breaks after specific punctuation marks unless they are within square brackets
    text = text.replaceAllMapped(
      RegExp(r'(\.|\:)(?![^\[]*\])\s*'),
      (match) => '${match[0]}\n',
    );

    final RegExp regExpQuotes = RegExp(r'\"(.*?)\"');
    final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
    final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
    final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
    final RegExp regExpDash = RegExp(r'\-(.*?)\-');

    final Iterable<Match> matchesQuotes = regExpQuotes.allMatches(text);
    final Iterable<Match> matchesBraces = regExpBraces.allMatches(text);
    final Iterable<Match> matchesParentheses = regExpParentheses.allMatches(
      text,
    );
    final Iterable<Match> matchesSquareBrackets = regExpSquareBrackets
        .allMatches(text);
    final Iterable<Match> matchesDash = regExpDash.allMatches(text);

    final List<Match> allMatches = [
      ...matchesQuotes,
      ...matchesBraces,
      ...matchesParentheses,
      ...matchesSquareBrackets,
      ...matchesDash,
    ]..sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in allMatches) {
      if (match.start >= lastMatchEnd && match.end <= text.length) {
        final String preText = text.substring(lastMatchEnd, match.start);
        final String matchedText = text.substring(match.start, match.end);
        final bool isBraceMatch = regExpBraces.hasMatch(matchedText);
        final bool isParenthesesMatch = regExpParentheses.hasMatch(matchedText);
        final bool isSquareBracketMatch = regExpSquareBrackets.hasMatch(
          matchedText,
        );
        final bool isDashMatch = regExpDash.hasMatch(matchedText);

        if (preText.isNotEmpty) {
          spans.add(TextSpan(text: preText));
        }

        TextStyle matchedTextStyle;
        if (isBraceMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'uthmanic2',
          );
        } else if (isParenthesesMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'uthmanic2',
          );
        } else if (isSquareBracketMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else if (isDashMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else {
          matchedTextStyle = const TextStyle(
            color: Color(0xffa24308),
            fontFamily: 'naskh',
          );
        }

        spans.add(TextSpan(text: matchedText, style: matchedTextStyle));

        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  Widget buildTextString() {
    String text = this;

    // Insert line breaks after specific punctuation marks unless they are within square brackets
    text = text.replaceAllMapped(
      RegExp(r'(\.|\:)(?![^\[]*\])\s*'),
      (match) => '${match[0]}\n',
    );

    final RegExp regExpQuotes = RegExp(r'\"(.*?)\"');
    final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
    final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
    final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
    final RegExp regExpDash = RegExp(r'\-(.*?)\-');

    final Iterable<Match> matchesQuotes = regExpQuotes.allMatches(text);
    final Iterable<Match> matchesBraces = regExpBraces.allMatches(text);
    final Iterable<Match> matchesParentheses = regExpParentheses.allMatches(
      text,
    );
    final Iterable<Match> matchesSquareBrackets = regExpSquareBrackets
        .allMatches(text);
    final Iterable<Match> matchesDash = regExpDash.allMatches(text);

    final List<Match> allMatches = [
      ...matchesQuotes,
      ...matchesBraces,
      ...matchesParentheses,
      ...matchesSquareBrackets,
      ...matchesDash,
    ]..sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in allMatches) {
      if (match.start >= lastMatchEnd && match.end <= text.length) {
        final String preText = text.substring(lastMatchEnd, match.start);
        final String matchedText = text.substring(match.start, match.end);
        final bool isBraceMatch = regExpBraces.hasMatch(matchedText);
        final bool isParenthesesMatch = regExpParentheses.hasMatch(matchedText);
        final bool isSquareBracketMatch = regExpSquareBrackets.hasMatch(
          matchedText,
        );
        final bool isDashMatch = regExpDash.hasMatch(matchedText);

        if (preText.isNotEmpty) {
          spans.add(
            TextSpan(
              text: preText,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }

        TextStyle matchedTextStyle;
        if (isBraceMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'uthmanic2',
          );
        } else if (isParenthesesMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'uthmanic2',
          );
        } else if (isSquareBracketMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else if (isDashMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else {
          matchedTextStyle = const TextStyle(
            color: Color(0xffa24308),
            fontFamily: 'naskh',
          );
        }

        spans.add(TextSpan(text: matchedText, style: matchedTextStyle));

        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(color: Colors.black),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }

  /// دالة لبناء TextSpans مع معالجة أكواد HTML وتطبيق الأنماط
  /// Build TextSpans with HTML code processing and style application
  List<TextSpan> buildHtmlTextSpans() {
    String text = this;

    // إزالة علامات HTML غير المرغوب فيها / Remove unwanted HTML tags
    text = text.replaceAll(RegExp(r'</?p[^>]*>'), ' ');
    text = text.replaceAll(RegExp(r'<hr[^>]*>'), ' ');

    // تحويل <br> إلى \n / Convert <br> to \n
    text = text.replaceAll(RegExp(r'<br[^>]*>'), '\n');

    List<TextSpan> spans = [];

    // معالجة النص بتقسيمه لقطع وتطبيق الأنماط / Process text by splitting and applying styles
    _processHtmlText(text, spans);

    return spans;
  }

  /// دالة مساعدة لتنظيف النصوص من HTML مع الحفاظ على المسافات / Helper to clean HTML while preserving spaces
  String _cleanHtmlWithSpaces(String text) {
    // إضافة مسافة بدلاً من حذف HTML لمنع دمج الكلمات / Add space instead of removing HTML to prevent word merging
    String cleanText = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    // تنظيف المسافات المتعددة وترك مسافة واحدة / Clean multiple spaces and leave single space
    cleanText = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleanText;
  }

  /// دالة مساعدة لمعالجة النص مع HTML / Helper function to process text with HTML
  void _processHtmlText(String text, List<TextSpan> spans) {
    if (text.isEmpty) return;

    // البحث عن أول span أو p مع class
    RegExp htmlRegex = RegExp(r'<(span|p)\s+class="([^"]*)"[^>]*>');
    Match? match = htmlRegex.firstMatch(text);

    if (match == null) {
      // لا توجد أكواد HTML، معالج النص كنص عادي
      String cleanText = text.replaceAll(RegExp(r'<br[^>]*>'), '\n');
      cleanText = _cleanHtmlWithSpaces(cleanText);
      if (cleanText.isNotEmpty) {
        spans.addAll(_processSpecialCharacters(cleanText));
      }
      return;
    }

    // إضافة النص قبل أول HTML tag
    if (match.start > 0) {
      String beforeText = text.substring(0, match.start);
      beforeText = beforeText.replaceAll(RegExp(r'<br[^>]*>'), '\n');
      beforeText = _cleanHtmlWithSpaces(beforeText);
      if (beforeText.isNotEmpty) {
        spans.addAll(_processSpecialCharacters(beforeText));
      }
    }

    // العثور على الـ closing tag المناسب
    String tagName = match.group(1)!;
    String className = match.group(2)!;

    int startPos = match.end;
    int openTags = 1;
    int endPos = startPos;

    // البحث عن الـ closing tag مع مراعاة التداخل
    RegExp openRegex = RegExp('<$tagName[^>]*>');
    RegExp closeRegex = RegExp('</$tagName>');

    String remainingText = text.substring(startPos);

    while (openTags > 0 && endPos < text.length) {
      Match? openMatch = openRegex.firstMatch(remainingText);
      Match? closeMatch = closeRegex.firstMatch(remainingText);

      if (closeMatch == null) break;

      if (openMatch != null && openMatch.start < closeMatch.start) {
        openTags++;
        remainingText = remainingText.substring(openMatch.end);
        endPos += openMatch.end;
      } else {
        openTags--;
        if (openTags == 0) {
          endPos = startPos + closeMatch.start;
          break;
        }
        remainingText = remainingText.substring(closeMatch.end);
        endPos += closeMatch.end;
      }
    }

    // استخراج المحتوى داخل الـ tag
    String content = '';
    if (endPos > startPos) {
      content = text.substring(startPos, endPos);
    }

    // تطبيق الأنماط حسب نوع الكلاس
    _applyStyleForClass(className, content, spans);

    // معالجة النص المتبقي
    int nextStart = endPos + tagName.length + 3; // </tagName>
    if (nextStart < text.length) {
      _processHtmlText(text.substring(nextStart), spans);
    }
  }

  /// دالة مساعدة لمعالجة الرموز الخاصة / Helper function to process special characters
  List<TextSpan> _processSpecialCharacters(String text) {
    // تنظيف النص من HTML أولاً مع إضافة مسافات لمنع دمج الكلمات / Clean HTML first with spaces to prevent word merging
    text = _cleanHtmlWithSpaces(text);

    if (text.isEmpty) return [];

    final RegExp regExpQuotes = RegExp(r'\"(.*?)\"');
    final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
    final RegExp regExpCustomParentheses = RegExp(r'\﴾(.*?)\﴿');
    final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
    final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
    final RegExp regExpDash = RegExp(r'\-(.*?)\-');

    final List<Match> allMatches = [
      ...regExpQuotes.allMatches(text),
      ...regExpBraces.allMatches(text),
      ...regExpParentheses.allMatches(text),
      ...regExpCustomParentheses.allMatches(text),
      ...regExpSquareBrackets.allMatches(text),
      ...regExpDash.allMatches(text),
    ]..sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in allMatches) {
      if (match.start >= lastMatchEnd && match.end <= text.length) {
        final String preText = text.substring(lastMatchEnd, match.start);
        final String matchedText = text.substring(match.start, match.end);
        final bool isBraceMatch = regExpBraces.hasMatch(matchedText);
        final bool isParenthesesMatch = regExpParentheses.hasMatch(matchedText);
        final bool isCustomParenthesesMatch = regExpCustomParentheses.hasMatch(
          matchedText,
        );
        final bool isSquareBracketMatch = regExpSquareBrackets.hasMatch(
          matchedText,
        );
        final bool isDashMatch = regExpDash.hasMatch(matchedText);

        if (preText.isNotEmpty) {
          spans.add(
            TextSpan(
              text: preText,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }

        TextStyle matchedTextStyle;
        if (isBraceMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'uthmanic2',
          );
        } else if (isParenthesesMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'naskh',
          );
        } else if (isCustomParenthesesMatch) {
          matchedTextStyle = const TextStyle(
            color: Color(0xff008000),
            fontFamily: 'uthmanic2',
          );
        } else if (isSquareBracketMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else if (isDashMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else {
          matchedTextStyle = const TextStyle(
            color: Color(0xffa24308),
            fontFamily: 'naskh',
          );
        }

        spans.add(TextSpan(text: matchedText, style: matchedTextStyle));

        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(color: Colors.black),
        ),
      );
    }

    return spans;
  }

  /// تطبيق الأنماط حسب نوع الكلاس / Apply styles based on class type
  void _applyStyleForClass(
    String className,
    String content,
    List<TextSpan> spans,
  ) {
    // تحويل <br> إلى \n أولاً / Convert <br> to \n first
    content = content.replaceAll(RegExp(r'<br[^>]*>'), '\n');

    switch (className) {
      case 'special':
        // معالجة المحتوى كما في buildTextSpans / Process content like in buildTextSpans
        if (content.contains('<')) {
          // إذا كان يحتوي على HTML متداخل، معالجه بشكل خاص
          _processNestedHtml(
            content,
            spans,
            const TextStyle(
              color: Color(0xff008000),
              fontFamily: 'uthmanic2',
              fontSize: 18,
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: content,
              style: const TextStyle(
                color: Color(0xff008000),
                fontFamily: 'uthmanic2',
                fontSize: 18,
              ),
            ),
          );
        }
        break;
      case 'c2':
        if (content.contains('<')) {
          _processNestedHtml(
            content,
            spans,
            const TextStyle(color: Color(0xff0066cc), fontFamily: 'naskh'),
          );
        } else {
          spans.add(
            TextSpan(
              text: content,
              style: const TextStyle(
                color: Color(0xff0066cc),
                fontFamily: 'naskh',
              ),
            ),
          );
        }
        break;
      case 'c5':
        if (content.contains('<')) {
          _processNestedHtml(
            content,
            spans,
            const TextStyle(color: Color(0xff814714), fontFamily: 'naskh'),
          );
        } else {
          spans.add(
            TextSpan(
              text: content,
              style: const TextStyle(
                color: Color(0xff814714),
                fontFamily: 'naskh',
              ),
            ),
          );
        }
        break;
      case 'hamesh':
        // معالجة الهوامش مع منع دمج الكلمات / Process footnotes with word merge prevention
        String cleanContent = _cleanHtmlWithSpaces(content);
        spans.add(
          TextSpan(
            text: cleanContent,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 12,
              fontFamily: 'naskh',
            ),
          ),
        );
        break;
      default:
        // معالجة النص العادي مع منع دمج الكلمات / Process normal text with word merge prevention
        String cleanContent = _cleanHtmlWithSpaces(content);
        if (cleanContent.isNotEmpty) {
          spans.addAll(_processSpecialCharacters(cleanContent));
        }
    }
  }

  /// معالجة HTML المتداخل / Process nested HTML
  void _processNestedHtml(
    String content,
    List<TextSpan> spans,
    TextStyle baseStyle,
  ) {
    // البحث عن span متداخل
    RegExp nestedSpanRegex = RegExp(
      r'<span\s+class="([^"]*)"[^>]*>(.*?)</span>',
    );

    int lastIndex = 0;

    for (Match match in nestedSpanRegex.allMatches(content)) {
      // إضافة النص قبل المطابقة
      if (match.start > lastIndex) {
        String beforeText = content.substring(lastIndex, match.start);
        beforeText = _cleanHtmlWithSpaces(beforeText);
        if (beforeText.isNotEmpty) {
          spans.add(TextSpan(text: beforeText, style: baseStyle));
        }
      }

      String nestedClassName = match.group(1) ?? '';
      String nestedContent = match.group(2) ?? '';
      nestedContent = _cleanHtmlWithSpaces(nestedContent);

      // تطبيق نمط للنص المتداخل
      TextStyle nestedStyle;
      switch (nestedClassName) {
        case 'c5':
          nestedStyle = const TextStyle(
            color: Color(0xff814714),
            fontFamily: 'naskh',
          );
          break;
        case 'c2':
          nestedStyle = const TextStyle(
            color: Color(0xff0066cc),
            fontFamily: 'naskh',
          );
          break;
        default:
          nestedStyle = baseStyle;
      }

      if (nestedContent.isNotEmpty) {
        spans.add(TextSpan(text: nestedContent, style: nestedStyle));
      }

      lastIndex = match.end;
    }

    // إضافة النص المتبقي
    if (lastIndex < content.length) {
      String remainingText = content.substring(lastIndex);
      remainingText = _cleanHtmlWithSpaces(remainingText);
      if (remainingText.isNotEmpty) {
        spans.add(TextSpan(text: remainingText, style: baseStyle));
      }
    }
  }
}

extension TextSpanListExtension on List<TextSpan> {
  /// تسطيح الـ TextSpans المتداخلة إلى قائمة مسطحة
  /// Flatten nested TextSpans into a flat list
  List<TextSpan> _flattenSpans() {
    final result = <TextSpan>[];
    for (var span in this) {
      if (span.children != null && span.children!.isNotEmpty) {
        for (var child in span.children!) {
          if (child is TextSpan) {
            if (child.children != null && child.children!.isNotEmpty) {
              result.addAll([child].cast<TextSpan>()._flattenSpans());
            } else if (child.text != null && child.text!.isNotEmpty) {
              result.add(
                TextSpan(text: child.text, style: child.style ?? span.style),
              );
            }
          }
        }
      } else if (span.text != null && span.text!.isNotEmpty) {
        result.add(span);
      }
    }
    return result;
  }

  /// دالة لتمييز النص المبحوث عنه في قائمة من TextSpans
  /// Function to highlight searched text in a list of TextSpans
  List<TextSpan> highlightSearchText(String searchTerm) {
    if (searchTerm.isEmpty) return this;

    // تسطيح الـ spans المتداخلة أولاً
    // Flatten nested spans first
    final flatSpans = _flattenSpans();

    List<TextSpan> highlightedSpans = [];

    for (TextSpan span in flatSpans) {
      String text = span.text!;
      List<TextSpan> highlighted = text.highlightLine(searchTerm);

      if (span.style != null) {
        List<TextSpan> styledHighlighted = [];
        for (TextSpan highlightedSpan in highlighted) {
          if (highlightedSpan.style != null) {
            styledHighlighted.add(highlightedSpan);
          } else {
            styledHighlighted.add(
              TextSpan(text: highlightedSpan.text, style: span.style),
            );
          }
        }
        highlightedSpans.addAll(styledHighlighted);
      } else {
        highlightedSpans.addAll(highlighted);
      }
    }

    return highlightedSpans;
  }
}
