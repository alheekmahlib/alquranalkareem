import 'package:flutter/material.dart';

extension HighlightExtension on String {
  List<TextSpan> highlightLine(String searchTerm) {
    List<TextSpan> spans = [];
    int start = 0;

    String lineWithoutDiacritics = removeDiacritics(this);
    String searchTermWithoutDiacritics = removeDiacritics(searchTerm);

    while (start < lineWithoutDiacritics.length) {
      final startIndex =
          lineWithoutDiacritics.indexOf(searchTermWithoutDiacritics, start);
      if (startIndex == -1) {
        spans.add(TextSpan(text: this.substring(start)));
        break;
      }

      if (startIndex > start) {
        spans.add(TextSpan(text: this.substring(start, startIndex)));
      }

      int endIndex = startIndex + searchTermWithoutDiacritics.length;
      endIndex = endIndex <= this.length ? endIndex : this.length;

      spans.add(TextSpan(
        text: this.substring(startIndex, endIndex),
        style: const TextStyle(
            color: Color(0xffa24308), fontWeight: FontWeight.bold),
      ));

      start = endIndex;
    }
    return spans;
  }

  String removeDiacritics(String input) {
    final diacriticsMap = {
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'إٔ': 'ا',
      'إٕ': 'ا',
      'إٓ': 'ا',
      'أَ': 'ا',
      'إَ': 'ا',
      'آَ': 'ا',
      'إُ': 'ا',
      'إٌ': 'ا',
      'إً': 'ا',
      'ة': 'ه',
      'ً': '',
      'ٌ': '',
      'ٍ': '',
      'َ': '',
      'ُ': '',
      'ِ': '',
      'ّ': '',
      'ْ': '',
      'ـ': '',
      'ٰ': '',
      'ٖ': '',
      'ٗ': '',
      'ٕ': '',
      'ٓ': '',
      'ۖ': '',
      'ۗ': '',
      'ۘ': '',
      'ۙ': '',
      'ۚ': '',
      'ۛ': '',
      'ۜ': '',
      '۝': '',
      '۞': '',
      '۟': '',
      '۠': '',
      'ۡ': '',
      'ۢ': '',
    };

    StringBuffer buffer = StringBuffer();
    Map<int, int> indexMapping =
        {}; // Ensure indexMapping is declared if not already globally declared
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      String? mappedChar = diacriticsMap[char];
      if (mappedChar != null) {
        buffer.write(mappedChar);
        if (mappedChar.isNotEmpty) {
          indexMapping[buffer.length - 1] = i;
        }
      } else {
        buffer.write(char);
        indexMapping[buffer.length - 1] = i;
      }
    }
    return buffer.toString();
  }
}
