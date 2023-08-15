import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class AppThemes {
  static final AppTheme green = AppTheme(
    id: 'green',
    description: "My green Theme",
    data: ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff232c13),
        onPrimary: Color(0xff161f07),
        secondary: Color(0xff39412a),
        onSecondary: Color(0xff39412a),
        error: Color(0xff91a57d),
        onError: Color(0xff91a57d),
        background: Color(0xfff3efdf),
        onBackground: Color(0xfff3efdf),
        surface: Color(0xff91a57d),
        onSurface: Color(0xff91a57d),
      ),
      primaryColor: const Color(0xff232c13),
      primaryColorLight: const Color(0xff39412a),
      primaryColorDark: const Color(0xff161f07),
      dialogBackgroundColor: const Color(0xfff2f1da),
      dividerColor: const Color(0xffcdba72),
      highlightColor: const Color(0xff91a57d).withOpacity(0.3),
      indicatorColor: const Color(0xffcdba72),
      scaffoldBackgroundColor: const Color(0xff232c13),
      canvasColor: const Color(0xfff3efdf),
      hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
      disabledColor: const Color(0Xffffffff),
      hintColor: const Color(0xff232c13),
      focusColor: const Color(0xff91a57d),
      secondaryHeaderColor: const Color(0xff39412a),
      cardColor: const Color(0xff232c13),
      dividerTheme: const DividerThemeData(
        color: Color(0xffcdba72),
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: const Color(0xff91a57d).withOpacity(0.3),
          selectionHandleColor: const Color(0xff91a57d)),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: Color(0xff606c38),
      ),
    ).copyWith(useMaterial3: true),
  );

  static final AppTheme blue = AppTheme(
    id: 'blue',
    description: "My blue Theme",
    data: ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xffbc6c25),
        onPrimary: Color(0xff814714),
        secondary: Color(0xfffcbb76),
        onSecondary: Color(0xfffcbb76),
        error: Color(0xff606c38),
        onError: Color(0xff606c38),
        background: Color(0xfffefae0),
        onBackground: Color(0xfffefae0),
        surface: Color(0xff606c38),
        onSurface: Color(0xff606c38),
      ),
      primaryColor: const Color(0xffbc6c25),
      primaryColorLight: const Color(0xfffcbb76),
      primaryColorDark: const Color(0xff814714),
      dialogBackgroundColor: const Color(0xfffefae0),
      dividerColor: const Color(0xfffcbb76),
      highlightColor: const Color(0xfffcbb76).withOpacity(0.3),
      indicatorColor: const Color(0xfffcbb76),
      scaffoldBackgroundColor: const Color(0xff814714),
      canvasColor: const Color(0xffF2E5D5),
      hoverColor: const Color(0xffF2E5D5).withOpacity(0.3),
      disabledColor: const Color(0Xffffffff),
      hintColor: const Color(0xff814714),
      focusColor: const Color(0xffbc6c25),
      secondaryHeaderColor: const Color(0xffbc6c25),
      cardColor: const Color(0xff814714),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: const Color(0xff606c38).withOpacity(0.3),
          selectionHandleColor: const Color(0xff606c38)),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: Color(0xff606c38),
      ),
    ).copyWith(useMaterial3: true),
  );

  static final AppTheme dark = AppTheme(
    id: 'dark',
    description: "My dark Theme",
    data: ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff3F3F3F),
        onPrimary: Color(0xff252526),
        secondary: Color(0xff4d4d4d),
        onSecondary: Color(0xff4d4d4d),
        error: Color(0xff91a57d),
        onError: Color(0xff91a57d),
        background: Color(0xff19191a),
        onBackground: Color(0xff3F3F3F),
        surface: Color(0xff91a57d),
        onSurface: Color(0xff91a57d),
      ),
      primaryColor: const Color(0xff3F3F3F),
      primaryColorLight: const Color(0xff4d4d4d),
      primaryColorDark: const Color(0xff010101),
      dialogBackgroundColor: const Color(0xff3F3F3F),
      dividerColor: const Color(0xff91a57d),
      highlightColor: const Color(0xff91a57d).withOpacity(0.3),
      indicatorColor: const Color(0xff91a57d),
      scaffoldBackgroundColor: const Color(0xff252526),
      canvasColor: const Color(0xfff3efdf),
      hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
      disabledColor: const Color(0Xffffffff),
      hintColor: const Color(0xff252526),
      focusColor: const Color(0xff91a57d),
      secondaryHeaderColor: const Color(0xff91a57d),
      cardColor: const Color(0xfff3efdf),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: const Color(0xff91a57d).withOpacity(0.3),
          selectionHandleColor: const Color(0xff91a57d)),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: Color(0xff606c38),
      ),
    ).copyWith(useMaterial3: true),
  );

  static List<AppTheme> get list =>
      [AppThemes.green, AppThemes.blue, AppThemes.dark];
}
