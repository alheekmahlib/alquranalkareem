import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/extensions/surah_name_with_banner.dart';
import '../../../../controllers/bookmarks_controller.dart';

TextSpan span({
  required String text,
  required int pageIndex,
  required bool isSelected,
  double? fontSize,
  required int surahNum,
  required int ayahNum,
  LongPressStartDetailsFunction? onLongPressStart,
  required bool isFirstAyah,
}) {
  if (text.isNotEmpty) {
    final String partOne = text.length < 3 ? text[0] : text[0] + text[1];
    // final String partOne = pageIndex == 250
    //     ? text.length < 3
    //         ? text[0]
    //         : text[0] + text[1]
    //     : text.length < 3
    //         ? text[0]
    //         : text[0] + text[1];
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
          height: 1.8,
          letterSpacing: 30,
          color: Get.theme.colorScheme.inversePrimary,
          backgroundColor: quranCtrl.isPages.value == 1
              ? Colors.transparent
              : sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                  ? const Color(0xffCD9974).withOpacity(.4)
                  : isSelected
                      ? Get.theme.highlightColor
                      : Colors.transparent,
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
          height: 1.8,
          letterSpacing: 5,
          // wordSpacing: wordSpacing + 10,
          color: Get.theme.colorScheme.inversePrimary,
          backgroundColor: quranCtrl.isPages.value == 1
              ? Colors.transparent
              : sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                  ? const Color(0xffCD9974).withOpacity(.4)
                  : isSelected
                      ? Get.theme.highlightColor
                      : Colors.transparent,
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
        height: 1.8,
        letterSpacing: 5,
        color: Get.theme.colorScheme.inversePrimary,
        backgroundColor: quranCtrl.isPages.value == 1
            ? Colors.transparent
            : sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                ? const Color(0xffCD9974).withOpacity(.4)
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
        height: 1.8,
        letterSpacing: 5,
        color: sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
            ? Get.theme.colorScheme.inversePrimary
            : const Color(0xff77554B),
        backgroundColor: quranCtrl.isPages.value == 1
            ? Colors.transparent
            : sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                ? const Color(0xffCD9974).withOpacity(.4)
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

TextSpan customSpan({
  required String text,
  required String ayahNumber,
  required int pageIndex,
  required bool isSelected,
  double? fontSize,
  required int surahNum,
  required int ayahNum,
  LongPressStartDetailsFunction? onLongPressStart,
}) {
  if (text.isNotEmpty) {
    return TextSpan(
      children: [
        TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'uthmanic2',
            fontSize: fontSize,
            height: 1.8,
            color: Get.theme.colorScheme.inversePrimary,
            backgroundColor: quranCtrl.isPages.value == 1
                ? Colors.transparent
                : sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                    ? const Color(0xffCD9974).withOpacity(.4)
                    : isSelected
                        ? Get.theme.highlightColor
                        : Colors.transparent,
          ),
          recognizer: LongPressGestureRecognizer(
              duration: const Duration(milliseconds: 500))
            ..onLongPressStart = onLongPressStart,
        ),
        TextSpan(
          text: ayahNumber.toString(),
          style: TextStyle(
            fontFamily: 'uthmanic2',
            fontSize: fontSize,
            height: 1.8,
            color:
                sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                    ? Get.theme.colorScheme.inversePrimary
                    : const Color(0xff77554B),
            backgroundColor: quranCtrl.isPages.value == 1
                ? Colors.transparent
                : sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
                    ? const Color(0xffCD9974).withOpacity(.4)
                    : isSelected
                        ? Get.theme.highlightColor
                        : Colors.transparent,
          ),
          recognizer: LongPressGestureRecognizer(
              duration: const Duration(milliseconds: 500))
            ..onLongPressStart = onLongPressStart,
        ),
      ],
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );
  } else {
    return const TextSpan(text: '');
  }
}

typedef LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
