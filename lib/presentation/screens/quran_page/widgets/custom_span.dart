import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/bookmarksText_controller.dart';

TextSpan span({
  required String text,
  required int pageIndex,
  required bool isSelected,
  required double fontSize,
  required int surahNum,
  required int ayahNum,
  required LongPressStartDetailsFunction onLongPressStart,
  required bool isFirstAyah,
}) {
  if (text.isNotEmpty) {
    final String partOne = text.length < 3 ? text[0] : text[0] + text[1];
    final String? partTwo =
        text.length > 2 ? text.substring(2, text.length - 1) : null;
    final String initialPart = text.substring(0, text.length - 1);
    final String lastCharacter = text.substring(text.length - 1);
    TextSpan? first;
    TextSpan? second;
    if (isFirstAyah) {
      first = TextSpan(
        text: partOne,
        style: TextStyle(
          fontFamily: 'page${pageIndex + 1}',
          fontSize: fontSize,
          height: 2,
          letterSpacing: 8,
          color: Colors.black,
          backgroundColor:
              isSelected ? Get.theme.highlightColor : Colors.transparent,
        ),
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressStart = onLongPressStart,
      );
      second = TextSpan(
        text: partTwo,
        style: TextStyle(
          fontFamily: 'page${pageIndex + 1}',
          fontSize: fontSize,
          height: 2,
          letterSpacing: 2,
          // wordSpacing: wordSpacing + 10,
          color: Colors.black,
          backgroundColor:
              isSelected ? Get.theme.highlightColor : Colors.transparent,
        ),
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressStart = onLongPressStart,
      );
    }

    final TextSpan initialTextSpan = TextSpan(
      text: initialPart,
      style: TextStyle(
        fontFamily: 'page${pageIndex + 1}',
        fontSize: fontSize,
        height: 2,
        letterSpacing: 2,
        color: Get.theme.colorScheme.inversePrimary,
        backgroundColor:
            sl<BookmarksTextController>().hasBookmark(surahNum, ayahNum).value
                ? const Color(0xffCD9974).withOpacity(.5)
                : isSelected
                    ? Get.theme.highlightColor
                    : Colors.transparent,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );

    final TextSpan lastCharacterSpan = TextSpan(
      text: lastCharacter,
      style: TextStyle(
        fontFamily: 'page${pageIndex + 1}',
        fontSize: fontSize,
        height: 2,
        letterSpacing: 2,
        color:
            sl<BookmarksTextController>().hasBookmark(surahNum, ayahNum).value
                ? Get.theme.colorScheme.inversePrimary
                : const Color(0xffa24308),
        backgroundColor:
            sl<BookmarksTextController>().hasBookmark(surahNum, ayahNum).value
                ? const Color(0xffCD9974).withOpacity(.5)
                : isSelected
                    ? Get.theme.highlightColor
                    : Colors.transparent,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );

    return TextSpan(
      children: isFirstAyah
          ? [first!, second!, lastCharacterSpan]
          : [initialTextSpan, lastCharacterSpan],
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );
  } else {
    return const TextSpan(text: '');
  }
}

typedef LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
