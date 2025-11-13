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

  Locale _locale = Locale(PlatformDispatcher.instance.locale.languageCode);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  List<LanguageModel> _languages = [];
  Locale get locale => _locale;
  List<LanguageModel> get languages => _languages;

  void loadCurrentLanguage() {
    // قراءة لغة التطبيق المحفوظة من التخزين
    final savedLanguageCode = box.read(AppConstants.LANGUAGE_CODE);
    final savedCountryCode = box.read(AppConstants.COUNTRY_CODE);

    if (savedLanguageCode != null) {
      // إذا كانت هناك لغة محفوظة، يتم استخدامها
      _locale = Locale(savedLanguageCode, savedCountryCode);
    } else {
      // إذا لم تكن هناك لغة محفوظة، يتم استخدام لغة الهاتف أو اللغة الافتراضية
      setDefaultLanguage();
    }

    // تحديث قائمة اللغات واللغة المختارة
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = AppConstants.languages;
    update();
  }

  void setDefaultLanguage() {
    // تحديد لغة الجهاز باستخدام PlatformDispatcher
    final deviceLocale = PlatformDispatcher.instance.locale;
    // التحقق إذا كانت لغة الجهاز مدعومة
    final supportedLanguage = AppConstants.languages.firstWhere(
      (lang) => lang.languageCode == deviceLocale.languageCode,
      orElse: () => AppConstants.languages[1], // اللغة الافتراضية (العربية)
    );
    // تعيين اللغة الافتراضية
    _locale = Locale(
      supportedLanguage.languageCode,
      supportedLanguage.countryCode,
    );
    saveLanguage(_locale);
    _selectedIndex = AppConstants.languages.indexOf(supportedLanguage);
    update();
  }

  void setLanguage(Locale locale) {
    // تعيين اللغة التي اختارها المستخدم
    _locale = locale;
    saveLanguage(locale);
    Get.updateLocale(locale);
    update();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void saveLanguage(Locale locale) async {
    // حفظ اللغة المختارة في التخزين
    box.write(AppConstants.LANGUAGE_CODE, locale.languageCode);
    box.write(AppConstants.COUNTRY_CODE, locale.countryCode ?? '');
  }

  Future<void> changeLangOnTap(int index) async {
    final lang = AppConstants.languages[index];
    setLanguage(Locale(lang.languageCode, ''));
    await box.write(LANG, lang.languageCode);
    await box.write(LANG_NAME, lang.languageName);
    sl<SettingsController>().languageName.value = lang.languageName;
  }
}
