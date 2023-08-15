import 'dart:ui' show Locale;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services_locator.dart';

class SettingsController extends GetxController {
  Locale? initialLang;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setLocale(Locale value) {
    initialLang = value;
    update();
  }

  // Save & Load Last Page For Quran Page
  Future<void> saveLang(String lan) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString("lang", lan);
    update();
  }

  void loadLang() async {
    SharedPreferences prefs = await _prefs;
    initialLang = prefs.getString("lang") == null
        ? const Locale('ar', 'AE')
        : Locale(sl<SharedPreferences>().getString("lang")!);
    print('get lang $initialLang');
  }
}
