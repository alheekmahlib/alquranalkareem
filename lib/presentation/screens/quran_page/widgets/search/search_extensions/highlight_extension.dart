import 'package:flutter/material.dart';

extension HighlightExtension on String {
  /// الحد الأقصى لعدد التطابقات لمنع OOM
  /// Maximum number of highlighted matches to prevent OOM
  static const int _maxHighlights = 50;

  List<TextSpan> highlightLine(String searchTerm) {
    // حماية: إذا نص البحث فاضي بعد التنظيف، أرجع النص بدون تمييز
    // Guard: if search term is empty after cleaning, return plain text
    final cleanSearch = removeDiacriticsQuran(searchTerm);
    if (cleanSearch.isEmpty) {
      return [TextSpan(text: this)];
    }

    List<TextSpan> spans = [];
    int start = 0;
    int matchCount = 0;

    // بناء نص بدون تشكيل مع خريطة index mapping
    // Build diacritics-free text with index mapping
    final (cleanText, indexMap) = _removeDiacriticsWithMapping(this);

    while (start < cleanText.length && matchCount < _maxHighlights) {
      final matchIndex = cleanText.indexOf(cleanSearch, start);
      if (matchIndex == -1) {
        // لا يوجد تطابق — أضف باقي النص الأصلي
        // No match — add remaining original text
        spans.add(TextSpan(text: this.substring(indexMap[start]!)));
        break;
      }

      // أضف النص قبل التطابق (من النص الأصلي)
      // Add text before match (from original text)
      if (matchIndex > start) {
        spans.add(
          TextSpan(
            text: this.substring(indexMap[start]!, indexMap[matchIndex]!),
          ),
        );
      }

      // أضف النص المطابق مع تمييز (من النص الأصلي)
      // Add matched text with highlight (from original text)
      final matchEndClean = matchIndex + cleanSearch.length;
      final originalStart = indexMap[matchIndex]!;
      final originalEnd = matchEndClean < cleanText.length
          ? indexMap[matchEndClean]!
          : this.length;

      spans.add(
        TextSpan(
          text: this.substring(originalStart, originalEnd),
          style: const TextStyle(
            color: Color(0xffa24308),
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      matchCount++;
      start = matchEndClean;
    }

    // إذا وصلنا للحد الأقصى، أضف باقي النص بدون تمييز
    // If we hit the limit, add remaining text without highlight
    if (matchCount >= _maxHighlights && start < cleanText.length) {
      spans.add(TextSpan(text: this.substring(indexMap[start]!)));
    }

    return spans;
  }

  /// إزالة التشكيل مع بناء خريطة ربط بين الـ indices
  /// Remove diacritics and build index mapping between clean and original text
  (String, Map<int, int>) _removeDiacriticsWithMapping(String input) {
    final diacritics = {
      '\u064B', // ً
      '\u064C', // ٌ
      '\u064D', // ٍ
      '\u064E', // َ
      '\u064F', // ُ
      '\u0650', // ِ
      '\u0651', // ّ
      '\u0652', // ْ
      '\u0670', // ٰ
      '\u0653', // ٓ
      '\u0654', // ٔ
      '\u0655', // ٕ
      '\u0656', // ٖ
      '\u0657', // ٗ
      '\u0658', // ٘
      '\u0659', // ٙ
      '\u065A', // ٚ
      '\u065B', // ٛ
      '\u065C', // ٜ
      '\u065D', // ٝ
      '\u065E', // ٞ
      '\u0660', // ٠ (optional)
      '\u0640', // ـ (tatweel)
      '\u06D6', // ۖ
      '\u06D7', // ۗ
      '\u06D8', // ۘ
      '\u06D9', // ۙ
      '\u06DA', // ۚ
      '\u06DB', // ۛ
      '\u06DC', // ۜ
      '\u06DD', // ۝
      '\u06DE', // ۞
      '\u06DF', // ۟
      '\u06E0', // ۠
      '\u06E1', // ۡ
      '\u06E2', // ۢ
    };

    final buffer = StringBuffer();
    final indexMap = <int, int>{};

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      if (!diacritics.contains(char)) {
        indexMap[buffer.length] = i;
        buffer.write(char);
      }
    }

    return (buffer.toString(), indexMap);
  }

  /// إزالة التشكيل — دالة عامة تُستخدم في عدة أماكن
  /// Remove diacritics — public method used in multiple places
  String removeDiacriticsQuran(String input) {
    final diacritics = {
      '\u064B', '\u064C', '\u064D', '\u064E', '\u064F', '\u0650',
      '\u0651', '\u0652', '\u0670', '\u0653', '\u0654', '\u0655',
      '\u0656', '\u0657', '\u0658', '\u0659', '\u065A', '\u065B',
      '\u065C', '\u065D', '\u065E', '\u0640',
      '\u06D6', '\u06D7', '\u06D8', '\u06D9', '\u06DA', '\u06DB',
      '\u06DC', '\u06DD', '\u06DE', '\u06DF', '\u06E0', '\u06E1',
      '\u06E2',
      'أ', 'إ', 'آ',
    };

    final replacements = {'أ': 'ا', 'إ': 'ا', 'آ': 'ا'};

    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      if (diacritics.contains(char) && !replacements.containsKey(char)) {
        continue;
      }
      buffer.write(replacements[char] ?? char);
    }
    return buffer.toString();
  }
}
