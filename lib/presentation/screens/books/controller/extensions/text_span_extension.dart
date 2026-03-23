part of '../../books.dart';

extension TextSpanExtension on String {
  List<InlineSpan> toFlutterText(bool isDark) {
    final dom.Document document = html_parser.parse(this);
    final List<InlineSpan> children = [];

    void parseNode(dom.Node node, TextStyle? parentStyle) {
      if (node is dom.Element) {
        TextStyle? textStyle;
        switch (node.localName) {
          case 'br':
            // Convert <br> tags to newline characters
            children.add(
              TextSpan(
                text: '\n',
                style:
                    parentStyle ??
                    TextStyle(color: Get.theme.colorScheme.inversePrimary),
              ),
            );
            return;
          case 'qpc-hafs':
            textStyle =
                parentStyle?.merge(
                  const TextStyle(
                    color: Color(0xff008000),
                    fontFamily: 'hafs',
                    package: "quran_library",
                  ),
                ) ??
                const TextStyle(
                  color: Color(0xff008000),
                  fontFamily: 'hafs',
                  package: "quran_library",
                );
            return;
          case 'p':
            textStyle =
                parentStyle?.merge(
                  TextStyle(color: Get.theme.colorScheme.inversePrimary),
                ) ??
                TextStyle(color: Get.theme.colorScheme.inversePrimary);
            // Process children of paragraph
            for (var child in node.nodes) {
              parseNode(child, textStyle);
            }
            // After </p>, ensure a single newline
            bool needsNewline = true;
            if (children.isNotEmpty && children.last is TextSpan) {
              final lastText = (children.last as TextSpan).text ?? '';
              if (lastText.endsWith('\n')) needsNewline = false;
            }
            if (needsNewline) {
              children.add(TextSpan(text: '\n', style: textStyle));
            }
            return;
          case 'span':
            if (node.classes.contains('c5')) {
              textStyle = parentStyle?.merge(
                const TextStyle(color: Color(0xff008000)),
              );
            } else if (node.classes.contains('qpc-hafs')) {
              textStyle = parentStyle?.merge(
                const TextStyle(
                  color: Color(0xff008000),
                  fontFamily: 'hafs',
                  package: "quran_library",
                ),
              );
            } else if (node.classes.contains('c4')) {
              textStyle = parentStyle?.merge(
                const TextStyle(color: Color(0xff814714)),
              );
            } else if (node.classes.contains('c2')) {
              textStyle = parentStyle?.merge(
                const TextStyle(color: Color(0xff814714)),
              );
            } else if (node.classes.contains('c1')) {
              textStyle = parentStyle?.merge(
                const TextStyle(color: Color(0xffa24308)),
              );
            } else {
              textStyle = parentStyle?.merge(
                TextStyle(color: Get.theme.colorScheme.inversePrimary),
              );
            }
            break;
          case 'div':
            textStyle = parentStyle?.merge(
              TextStyle(color: Get.theme.colorScheme.inversePrimary),
            );
            break;
          default:
            textStyle = parentStyle?.merge(
              TextStyle(color: Get.theme.colorScheme.inversePrimary),
            );
        }

        for (var child in node.nodes) {
          parseNode(child, textStyle);
        }
      } else if (node is dom.Text) {
        // النص الخام
        String rawText = node.text;
        // تنقيحات طفيفة للمسافات/الفواصل كما كانت سابقًا
        final cleanedText = rawText
            .trim()
            .replaceAllMapped(RegExp(r'\s"'), (match) => ' "')
            .replaceAllMapped(RegExp(r'"\s'), (match) => '" ')
            .replaceAllMapped(RegExp(r',(?=\S)'), (match) => ', ')
            .replaceAll(RegExp(r'<[^>]+>'), ' ')
            .replaceAllMapped(RegExp(r'(?<=\S)(?=<|$)'), (match) => ' ');

        // تطبيق تنسيق خاص على المقاطع بين الأقواس/المعقوفات/المربعات/الشرطات
        final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
        final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
        final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
        final RegExp regExpDash = RegExp(r'\-(.*?)\-');
        final RegExp regExpAngle = RegExp(r'«(.*?)»');

        final Iterable<Match> matchesBraces = regExpBraces.allMatches(
          cleanedText,
        );
        final Iterable<Match> matchesParentheses = regExpParentheses.allMatches(
          cleanedText,
        );
        final Iterable<Match> matchesSquareBrackets = regExpSquareBrackets
            .allMatches(cleanedText);
        final Iterable<Match> matchesDash = regExpDash.allMatches(cleanedText);
        final Iterable<Match> matchesAngle = regExpAngle.allMatches(
          cleanedText,
        );

        final List<Match> allMatches = [
          ...matchesBraces,
          ...matchesParentheses,
          ...matchesSquareBrackets,
          ...matchesDash,
          ...matchesAngle,
        ]..sort((a, b) => a.start.compareTo(b.start));

        if (allMatches.isEmpty) {
          // لا توجد أنماط خاصة؛ أضف النص كما هو بأسلوب الأب
          children.add(
            TextSpan(
              text: cleanedText,
              style:
                  parentStyle ??
                  TextStyle(color: Get.theme.colorScheme.inversePrimary),
            ),
          );
        } else {
          int last = 0;
          for (final m in allMatches) {
            if (m.start < last || m.end > cleanedText.length) continue;

            // مقطع قبل المطابقة
            final pre = cleanedText.substring(last, m.start);
            if (pre.isNotEmpty) {
              children.add(
                TextSpan(
                  text: pre,
                  style:
                      parentStyle ??
                      TextStyle(color: Get.theme.colorScheme.inversePrimary),
                ),
              );
            }

            final matchText = cleanedText.substring(m.start, m.end);
            final bool isBraceMatch = regExpBraces.hasMatch(matchText);
            final bool isParenthesesMatch = regExpParentheses.hasMatch(
              matchText,
            );
            final bool isSquareBracketMatch = regExpSquareBrackets.hasMatch(
              matchText,
            );
            final bool isDashMatch = regExpDash.hasMatch(matchText);
            final bool isAngleMatch = regExpAngle.hasMatch(matchText);

            // أنماط خاصة كما طُلب
            TextStyle special;
            if (isBraceMatch) {
              special = const TextStyle(
                color: Color(0xff008000),
                fontFamily: 'hafs',
                package: "quran_library",
              );
            } else if (isParenthesesMatch) {
              special = const TextStyle(
                color: Color(0xff008000),
                fontFamily: 'naskh',
              );
            } else if (isSquareBracketMatch) {
              special = const TextStyle(color: Color(0xff814714));
            } else if (isDashMatch) {
              special = const TextStyle(color: Color(0xff814714));
            } else if (isAngleMatch) {
              // نفترض أن <<>> تمثل ملاحظة/اقتباس مشابه لـ [] من حيث اللون بدون أسطر إضافية
              special = const TextStyle(color: Color(0xff814714));
            } else {
              // افتراضي: أسلوب الأب
              special =
                  parentStyle ??
                  TextStyle(color: Get.theme.colorScheme.inversePrimary);
            }

            // دمج مع أسلوب الأب للحفاظ على الحجم/الوزن مع تغيير اللون/الخط المطلوب
            final applied = (parentStyle ?? const TextStyle()).merge(special);

            // في حالة الأقواس المربعة، أضف أسطرًا قبل/بعد كما كان السلوك السابق
            if (isSquareBracketMatch) {
              // children.add(TextSpan(
              //     text: '\n',
              //     style: parentStyle ??
              //         TextStyle(color: Get.theme.colorScheme.inversePrimary)));
              children.add(TextSpan(text: matchText, style: applied));
              // children.add(TextSpan(
              //     text: '\n',
              //     style: parentStyle ??
              //         TextStyle(color: Get.theme.colorScheme.inversePrimary)));
            } else {
              children.add(TextSpan(text: matchText, style: applied));
            }

            last = m.end;
          }

          // الباقي بعد آخر مطابقة
          if (last < cleanedText.length) {
            children.add(
              TextSpan(
                text: cleanedText.substring(last),
                style:
                    parentStyle ??
                    TextStyle(color: Get.theme.colorScheme.inversePrimary),
              ),
            );
          }
        }
      }
    }

    for (var node in document.body?.nodes ?? []) {
      parseNode(node, null);
    }

    return children;
  }
}
