import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Theme 1: Teal / Emerald (was Blue)
final ThemeData blueTheme = ThemeData.light(useMaterial3: false).copyWith(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff254D32),
    onPrimary: Color(0xff254D32),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xffD4A76A),
    error: Color(0xffE0E1E0),
    onError: Color(0xffE0E1E0),
    surface: Color(0xffD4A76A),
    onSurface: Color(0xffE0E1E0),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffC49560),
    primaryContainer: Color(0xffF8F6F0),
    onPrimaryContainer: Color(0xffF0EDE4),
    onInverseSurface: Color(0xff000000),
    surfaceContainer: Color(0xffF5F2EB),
  ),
  primaryColor: const Color(0xff254D32),
  primaryColorLight: const Color(0xff4A9B56),
  primaryColorDark: const Color(0xff254D32),
  dividerColor: const Color(0xffD4A76A),
  highlightColor: const Color(0xffD4A76A).withValues(alpha: 0.25),
  scaffoldBackgroundColor: const Color(0xff254D32),
  canvasColor: const Color(0xffFFFFFF),
  hoverColor: const Color(0xffFFFFFF).withValues(alpha: 0.3),
  disabledColor: const Color(0Xff000000),
  hintColor: const Color(0xff254D32),
  focusColor: const Color(0xffE0E1E0),
  secondaryHeaderColor: const Color(0xff4A9B56),
  cardColor: const Color(0xff254D32),
  dividerTheme: const DividerThemeData(color: Color(0xffD4A76A)),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: const Color(0xffE0E1E0).withValues(alpha: 0.3),
    selectionHandleColor: const Color(0xffE0E1E0),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color(0xff4A9B56),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: const Color(0xffD4A76A),
    dialBackgroundColor: const Color(0xffFFFFFF),
    dialHandColor: const Color(0xffD4A76A),
    dialTextColor: const Color(0xff000000).withValues(alpha: .6),
    entryModeIconColor: const Color(0xff000000).withValues(alpha: .6),
    hourMinuteTextColor: const Color(0xff000000).withValues(alpha: .6),
    dayPeriodTextColor: const Color(0xff000000).withValues(alpha: .6),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xff000000).withValues(alpha: .6),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xffFFFFFF)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xff000000).withValues(alpha: .8),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xffFFFFFF)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
  ),
);

/// Theme 2: Warm Amber (was Brown)
final ThemeData brownTheme = ThemeData(
  useMaterial3: false,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff7B4B2A),
    onPrimary: Color(0xff7B4B2A),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xffE8A849),
    error: Color(0xffE8A849),
    onError: Color(0xffE8A849),
    surface: Color(0xffE8A849),
    onSurface: Color(0xffE8A849),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffD4923A),
    primaryContainer: Color(0xffFFF8F0),
    onPrimaryContainer: Color(0xffFFF8F0),
    onInverseSurface: Color(0xff000000),
    surfaceContainer: Color(0xffFFF5E8),
  ),
  primaryColor: const Color(0xff7B4B2A),
  primaryColorLight: const Color(0xff9C6038),
  primaryColorDark: const Color(0xff7B4B2A),
  dividerColor: const Color(0xffE8A849),
  highlightColor: const Color(0xffE8A849).withValues(alpha: 0.25),
  scaffoldBackgroundColor: const Color(0xff7B4B2A),
  canvasColor: const Color(0xffFFF0DC),
  hoverColor: const Color(0xffFFF0DC).withValues(alpha: 0.3),
  disabledColor: const Color(0xff000000),
  hintColor: const Color(0xff000000),
  focusColor: const Color(0xff7B4B2A),
  secondaryHeaderColor: const Color(0xff9C6038),
  cardColor: const Color(0xff7B4B2A),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: const Color(0xffE8A849).withValues(alpha: 0.3),
    selectionHandleColor: const Color(0xffE8A849),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color(0xffE8A849),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: const Color(0xffE8A849),
    dialBackgroundColor: const Color(0xffFFF8F0),
    dialHandColor: const Color(0xffE8A849),
    dialTextColor: const Color(0xff000000).withValues(alpha: .6),
    entryModeIconColor: const Color(0xff000000).withValues(alpha: .6),
    hourMinuteTextColor: const Color(0xff000000).withValues(alpha: .6),
    dayPeriodTextColor: const Color(0xff000000).withValues(alpha: .6),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xff000000).withValues(alpha: .6),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xffFFF8F0)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xff000000).withValues(alpha: .8),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xffFFF8F0)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
  ),
);

/// Theme 3: Sage / Forest (was Old)
final ThemeData oldTheme = ThemeData.light(useMaterial3: false).copyWith(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff254D32),
    onPrimary: Color(0xff254D32),
    secondary: Color(0xffF0F4EC),
    onSecondary: Color(0xff8BAF7F),
    error: Color(0xffE0E1E0),
    onError: Color(0xffE0E1E0),
    surface: Color(0xff8BAF7F),
    onSurface: Color(0xffE0E1E0),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffA0C090),
    primaryContainer: Color(0xffF0F4EC),
    onPrimaryContainer: Color(0xffF0F4EC),
    onInverseSurface: Color(0xff000000),
    surfaceContainer: Color(0xffEAF0E6),
  ),
  primaryColor: const Color(0xff254D32),
  primaryColorLight: const Color(0xff4A9B56),
  primaryColorDark: const Color(0xff254D32),
  dividerColor: const Color(0xff8BAF7F),
  highlightColor: const Color(0xff8BAF7F).withValues(alpha: 0.25),
  scaffoldBackgroundColor: const Color(0xff254D32),
  canvasColor: const Color(0xffF0F4EC),
  hoverColor: const Color(0xffF0F4EC).withValues(alpha: 0.3),
  disabledColor: const Color(0xff000000),
  hintColor: const Color(0xff254D32),
  focusColor: const Color(0xffE0E1E0),
  secondaryHeaderColor: const Color(0xff4A9B56),
  cardColor: const Color(0xff254D32),
  dividerTheme: const DividerThemeData(color: Color(0xff8BAF7F)),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: const Color(0xffE0E1E0).withValues(alpha: 0.3),
    selectionHandleColor: const Color(0xffE0E1E0),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color(0xff4A9B56),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: const Color(0xff8BAF7F),
    dialBackgroundColor: const Color(0xffF0F4EC),
    dialHandColor: const Color(0xff8BAF7F),
    dialTextColor: const Color(0xff000000).withValues(alpha: .6),
    entryModeIconColor: const Color(0xff000000).withValues(alpha: .6),
    hourMinuteTextColor: const Color(0xff000000).withValues(alpha: .6),
    dayPeriodTextColor: const Color(0xff000000).withValues(alpha: .6),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xff000000).withValues(alpha: .6),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xffF0F4EC)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xff000000).withValues(alpha: .8),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xffF0F4EC)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
  ),
);

/// Theme 4: Midnight (was Dark)
final ThemeData darkTheme = ThemeData.dark(useMaterial3: false).copyWith(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff1B2838),
    onPrimary: Color(0xff000000),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xff2A3A4E),
    error: Color(0xff1B2838),
    onError: Color(0xff1B2838),
    surface: Color(0xffC8A96E),
    onSurface: Color(0xff1B2838),
    inversePrimary: Color(0xffffffff),
    inverseSurface: Color(0xffB89A5E),
    primaryContainer: Color(0xff121820),
    onPrimaryContainer: Color(0xff121820),
    onInverseSurface: Color(0xff000000),
    surfaceContainer: Color(0xff121820),
  ),
  primaryColor: const Color(0xff121820),
  primaryColorLight: const Color(0xff2A3A4E),
  primaryColorDark: const Color(0xff080C12),
  dividerColor: const Color(0xff1B2838),
  highlightColor: const Color(0xff1B2838).withValues(alpha: 0.25),
  scaffoldBackgroundColor: const Color(0xff080C12),
  canvasColor: const Color(0xffEAE8E0),
  hoverColor: const Color(0xffEAE8E0).withValues(alpha: 0.3),
  disabledColor: const Color(0xff000000),
  hintColor: const Color(0xffffffff),
  focusColor: const Color(0xff1B2838),
  secondaryHeaderColor: const Color(0xff2A3A4E),
  cardColor: const Color(0xffEAE8E0),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: const Color(0xff1B2838).withValues(alpha: 0.3),
    selectionHandleColor: const Color(0xff1B2838),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color(0xff2A3A4E),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: const Color(0xffC8A96E),
    dialBackgroundColor: const Color(0xff121820),
    dialHandColor: const Color(0xffC8A96E),
    dialTextColor: const Color(0xffEAE8E0).withValues(alpha: .6),
    entryModeIconColor: const Color(0xffEAE8E0).withValues(alpha: .6),
    hourMinuteTextColor: const Color(0xffEAE8E0).withValues(alpha: .6),
    dayPeriodTextColor: const Color(0xffEAE8E0).withValues(alpha: .6),
    dayPeriodColor: const Color(0xff121820),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xffEAE8E0).withValues(alpha: .6),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xff121820)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        const Color(0xffEAE8E0).withValues(alpha: .8),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xff121820)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontFamily: 'kufi', fontSize: 16),
      ),
    ),
  ),
);
