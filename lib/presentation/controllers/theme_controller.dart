import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/app_themes.dart';

enum AppTheme { blue, brown, dark }

class ThemeController extends GetxController {
  AppTheme? initialTheme;
  ThemeData? initialThemeData;
  Rx<AppTheme> _currentTheme = AppTheme.blue.obs;

  @override
  void onInit() async {
    initialTheme = await loadThemePreference();
    super.onInit();
  }

  ThemeData get currentThemeData {
    switch (_currentTheme.value) {
      case AppTheme.blue:
        return blueTheme;
      case AppTheme.brown:
        return brownTheme;
      case AppTheme.dark:
        return darkTheme;
      default:
        return blueTheme;
    }
  }

  void checkTheme() {
    switch (initialTheme) {
      case AppTheme.blue:
        initialThemeData = blueTheme;
        break;
      case AppTheme.brown:
        initialThemeData = brownTheme;
        break;
      case AppTheme.dark:
        initialThemeData = darkTheme;
        break;
      default:
        initialThemeData = blueTheme; // Default theme
    }
  }

  Future<AppTheme> loadThemePreference() async {
    String themeString = sl<SharedPreferences>().getString(SET_THEME) ??
        AppTheme.blue.toString();
    return initialTheme = AppTheme.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => AppTheme.blue,
    );
  }

  void setTheme(AppTheme theme) {
    _currentTheme.value = theme;
    Get
      ..changeTheme(currentThemeData)
      ..forceAppUpdate();
    sl<SharedPreferences>().setString(SET_THEME, theme.toString());
    // if (theme == AppTheme.blue) {
    //   Get.changeTheme(blueTheme);
    // } else if (theme == AppTheme.brown) {
    //   Get.changeTheme(brownTheme);
    // } else {
    //   Get.changeTheme(darkTheme);
    // }
    // update();
  }

  AppTheme get currentTheme => _currentTheme.value;

  bool get isBlueMode => _currentTheme.value == AppTheme.blue;
  bool get isBrownMode => _currentTheme.value == AppTheme.brown;
  bool get isDarkMode => _currentTheme.value == AppTheme.dark;
}
