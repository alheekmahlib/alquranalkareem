import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../presentation/controllers/settings_controller.dart';
import '../../utils/constants/shared_preferences_constants.dart';
import '../services_locator.dart';
import 'app_constants.dart';
import 'language_models.dart';

class LocalizationController extends GetxController implements GetxService {
  GetStorage box = GetStorage();

  LocalizationController() {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[1].languageCode,
      AppConstants.languages[1].countryCode);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  List<LanguageModel> _languages = [];
  Locale get locale => _locale;
  List<LanguageModel> get languages => _languages;

  void loadCurrentLanguage() {
    _locale = Locale(
        box.read(AppConstants.LANGUAGE_CODE) ??
            AppConstants.languages[1].languageCode,
        box.read(AppConstants.COUNTRY_CODE) ??
            AppConstants.languages[1].countryCode);

    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    saveLanguage(_locale);
    update();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void saveLanguage(Locale locale) async {
    box.write(AppConstants.LANGUAGE_CODE, locale.languageCode);
    box.write(AppConstants.COUNTRY_CODE, locale.countryCode!);
  }

  Future<void> changeLangOnTap(int index) async {
    final lang = AppConstants.languages[index];
    setLanguage(Locale(lang.languageCode, ''));
    await box.write(LANG, lang.languageCode);
    await box.write(LANG_NAME, lang.languageName);
    sl<SettingsController>().languageName.value = lang.languageName;
  }
}
