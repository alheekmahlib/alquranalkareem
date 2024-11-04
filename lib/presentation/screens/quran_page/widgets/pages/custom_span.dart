part of '../../quran.dart';

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
          height: 2,
          letterSpacing: quranCtrl.state.isPages.value == 1 ? 10 : 30,
          color: Get.theme.colorScheme.inversePrimary,
          backgroundColor: quranCtrl.state.isPages.value == 1
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
          height: 2,
          letterSpacing: 5,
          // wordSpacing: wordSpacing + 10,
          color: Get.theme.colorScheme.inversePrimary,
          backgroundColor: quranCtrl.state.isPages.value == 1
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
        height: 2,
        letterSpacing: 5,
        color: Get.theme.colorScheme.inversePrimary,
        backgroundColor: quranCtrl.state.isPages.value == 1
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

    var lastCharacterSpan =
        sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
            ? WidgetSpan(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
                child: SvgPicture.asset(
                  SvgPath.svgAyahBookmarked,
                  height: 100,
                ),
              ))
            : TextSpan(
                text: lastCharacter,
                style: TextStyle(
                  fontFamily: 'page${pageIndex + 1}',
                  fontSize: fontSize,
                  height: 2,
                  letterSpacing: 5,
                  color: sl<BookmarksController>()
                          .hasBookmark(surahNum, ayahNum)
                          .value
                      ? Get.theme.colorScheme.inversePrimary
                      : const Color(0xff77554B),
                  backgroundColor: quranCtrl.state.isPages.value == 1
                      ? Colors.transparent
                      : sl<BookmarksController>()
                              .hasBookmark(surahNum, ayahNum)
                              .value
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
            height: 2,
            color: Get.theme.colorScheme.inversePrimary,
            backgroundColor: quranCtrl.state.isPages.value == 1
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
        sl<BookmarksController>().hasBookmark(surahNum, ayahNum).value
            ? WidgetSpan(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                child: SvgPicture.asset(
                  SvgPath.svgAyahBookmarked,
                  height: 35,
                ),
              ))
            : TextSpan(
                text: ayahNumber.toString(),
                style: TextStyle(
                  fontFamily: 'uthmanic2',
                  fontSize: fontSize,
                  height: 2,
                  color: sl<BookmarksController>()
                          .hasBookmark(surahNum, ayahNum)
                          .value
                      ? Get.theme.colorScheme.inversePrimary
                      : const Color(0xff77554B),
                  backgroundColor: quranCtrl.state.isPages.value == 1
                      ? Colors.transparent
                      : sl<BookmarksController>()
                              .hasBookmark(surahNum, ayahNum)
                              .value
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
