import 'dart:ui' show Locale;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services_locator.dart';

class SettingsController extends GetxController {
  Locale? initialLang;

  void setLocale(Locale value) {
    initialLang = value;
    update();
  }

  // Save & Load Last Page For Quran Page
  Future<void> saveLang(String lan) async {
    await sl<SharedPreferences>().setString("lang", lan);
    update();
  }

  void loadLang() {
    initialLang = sl<SharedPreferences>().getString("lang") == null
        ? const Locale('ar', 'AE')
        : Locale(sl<SharedPreferences>().getString("lang")!);
    print('get lang $initialLang');
  }
}
