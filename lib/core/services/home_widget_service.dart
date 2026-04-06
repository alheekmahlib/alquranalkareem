import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quran_library/quran_library.dart';

import '../utils/constants/shared_preferences_constants.dart';

/// خدمة إدارة Home Widgets عبر المنصات (iOS, Android, macOS)
/// Manages Home Widgets across platforms (iOS, Android, macOS)
class HomeWidgetService {
  HomeWidgetService._();
  static final HomeWidgetService instance = HomeWidgetService._();

  static const String _appGroupId = 'group.com.alheekmah.quran_widget';
  static const String _androidWidgetName = 'QuranWidget';

  static const int _totalQuranPages = 604;

  final _box = GetStorage();

  /// MethodChannel لمنصة macOS (لأن home_widget لا تدعم macOS)
  static const _macChannel = MethodChannel(
    'com.alheekmah.quran_widget/macos_widget',
  );

  /// حفظ قيمة في UserDefaults على macOS عبر MethodChannel
  Future<void> _macSave(String key, Object value) async {
    await _macChannel.invokeMethod('saveWidgetData', {
      'groupId': _appGroupId,
      'key': key,
      'value': value,
    });
  }

  /// تهيئة Home Widgets وتحديث البيانات
  Future<void> initializeHomeWidgets() async {
    try {
      if (!Platform.isMacOS) {
        await HomeWidget.setAppGroupId(_appGroupId);
      }
      await updateAllWidgets();
    } catch (e) {
      log(
        '[HomeWidget] initializeHomeWidgets error: $e',
        name: 'HomeWidgetService',
      );
    }
  }

  /// تحديث جميع بيانات الـ Widget
  Future<void> updateAllWidgets() async {
    try {
      await _saveHijriData();
    } catch (e) {
      log('[HomeWidget] _saveHijriData error: $e', name: 'HomeWidgetService');
    }
    try {
      await _saveReadingProgress();
    } catch (e) {
      log(
        '[HomeWidget] _saveReadingProgress error: $e',
        name: 'HomeWidgetService',
      );
    }
    try {
      await _saveThemeData();
    } catch (e) {
      log('[HomeWidget] _saveThemeData error: $e', name: 'HomeWidgetService');
    }
    try {
      await _saveTextData();
    } catch (e) {
      log('[HomeWidget] _saveTextData error: $e', name: 'HomeWidgetService');
    }
    await _triggerWidgetUpdate();
  }

  /// تحديث بيانات التاريخ الهجري فقط
  Future<void> updateHijriDate() async {
    try {
      await _saveHijriData();
    } catch (e) {
      log('[HomeWidget] updateHijriDate error: $e', name: 'HomeWidgetService');
    }
    await _triggerWidgetUpdate();
  }

  /// تحديث بيانات تقدم القراءة فقط
  Future<void> updateReadingProgress() async {
    try {
      await _saveReadingProgress();
    } catch (e) {
      log(
        '[HomeWidget] updateReadingProgress error: $e',
        name: 'HomeWidgetService',
      );
    }
    await _triggerWidgetUpdate();
  }

  /// تحديث بيانات النصوص فقط
  Future<void> updateTextData() async {
    try {
      await _saveTextData();
    } catch (e) {
      log('[HomeWidget] updateTextData error: $e', name: 'HomeWidgetService');
    }
    await _triggerWidgetUpdate();
  }

  /// تحديث بيانات الثيم فقط
  Future<void> updateTheme() async {
    try {
      await _saveThemeData();
    } catch (e) {
      log('[HomeWidget] updateTheme error: $e', name: 'HomeWidgetService');
    }
    await _triggerWidgetUpdate();
  }

  Future<void> _saveHijriData() async {
    final adjustDays = _box.read('adjustHijriDays') ?? 0;
    final hijriNow = _getAdjustedHijriDate(adjustDays);

    final now = DateTime.now();
    final locale = Get.locale?.languageCode ?? 'ar';
    String gregorianDate;
    try {
      await initializeDateFormatting(locale);
      gregorianDate = '${now.day} ${DateFormat('MMM', locale).format(now)}';
    } catch (_) {
      gregorianDate = '${now.day}/${now.month}';
    }

    final hijriMonthNumber = hijriNow.hMonth.toString();
    final lengthOfMonth = hijriNow.getDaysInMonth(
      hijriNow.hYear,
      hijriNow.hMonth,
    );

    if (Platform.isMacOS) {
      await Future.wait([
        _macSave('hijri_day', hijriNow.hDay),
        _macSave('hijri_month', hijriNow.hMonth),
        _macSave('hijri_year', hijriNow.hYear),
        _macSave('hijri_month_name', hijriMonthNumber),
        _macSave('gregorian_date', gregorianDate),
        _macSave('length_of_month', lengthOfMonth),
        _macSave('adjustHijriDays', adjustDays),
      ]);
    } else {
      await Future.wait([
        HomeWidget.saveWidgetData<int>('hijri_day', hijriNow.hDay),
        HomeWidget.saveWidgetData<int>('hijri_month', hijriNow.hMonth),
        HomeWidget.saveWidgetData<int>('hijri_year', hijriNow.hYear),
        HomeWidget.saveWidgetData<String>('hijri_month_name', hijriMonthNumber),
        HomeWidget.saveWidgetData<String>('gregorian_date', gregorianDate),
        HomeWidget.saveWidgetData<int>('length_of_month', lengthOfMonth),
      ]);
    }
  }

  Future<void> _saveReadingProgress() async {
    final storedPage = _box.read('last_page');
    final lastPage = (storedPage is int && storedPage > 0) ? storedPage : 1;

    int surahNumber = 1;
    try {
      final surah = QuranCtrl.instance.getCurrentSurahByPageNumber(lastPage);
      surahNumber = surah.surahNumber;
    } catch (_) {}

    final progress = ((lastPage) / _totalQuranPages * 100).round();

    if (Platform.isMacOS) {
      await Future.wait([
        _macSave('last_read_page', lastPage),
        _macSave('last_surah_number', surahNumber),
        _macSave('surah_number', surahNumber),
        _macSave('total_pages', _totalQuranPages),
        _macSave('reading_progress', progress),
      ]);
    } else {
      await Future.wait([
        HomeWidget.saveWidgetData<int>('last_read_page', lastPage),
        HomeWidget.saveWidgetData<int>('last_surah_number', surahNumber),
        HomeWidget.saveWidgetData<int>('surah_number', surahNumber),
        HomeWidget.saveWidgetData<int>('total_pages', _totalQuranPages),
        HomeWidget.saveWidgetData<int>('reading_progress', progress),
      ]);
    }
  }

  Future<void> _saveTextData() async {
    final lastReadText = 'lastRead'.tr == 'lastRead'
        ? 'آخر قراءة'
        : 'lastRead'.tr;
    final pageText = 'pageNo'.tr == 'pageNo' ? 'رقم الصفحة' : 'pageNo'.tr;
    final languageCode = Get.locale?.languageCode ?? 'ar';
    final useEnglishNumbers = _box.read('isUseEnglishNumbers') ?? false;

    if (Platform.isMacOS) {
      await Future.wait([
        _macSave('last_read_text', lastReadText),
        _macSave('page_text', pageText),
        _macSave('language_code', languageCode),
        _macSave('use_english_numbers', useEnglishNumbers),
      ]);
    } else {
      await Future.wait([
        HomeWidget.saveWidgetData<String>('last_read_text', lastReadText),
        HomeWidget.saveWidgetData<String>('page_text', pageText),
        HomeWidget.saveWidgetData<String>('language_code', languageCode),
        HomeWidget.saveWidgetData<bool>(
          'use_english_numbers',
          useEnglishNumbers,
        ),
      ]);
    }
  }

  Future<void> _saveThemeData() async {
    final themeString = _box.read(SET_THEME) ?? 'AppTheme.green';
    if (Platform.isMacOS) {
      await _macSave('theme', themeString);
    } else {
      await HomeWidget.saveWidgetData<String>('theme', themeString);
    }
  }

  Future<void> _triggerWidgetUpdate() async {
    try {
      if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: 'quran_widget');
      }
      if (Platform.isMacOS) {
        await _macChannel.invokeMethod('updateWidget');
      }
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          androidName: _androidWidgetName,
          qualifiedAndroidName:
              'com.alheekmah.alquranalkareem.alquranalkareem.$_androidWidgetName',
        );
      }
    } catch (e) {
      log(
        '[HomeWidget] _triggerWidgetUpdate error: $e',
        name: 'HomeWidgetService',
      );
    }
  }

  HijriDate _getAdjustedHijriDate(int adjustDays) {
    final currentHijri = HijriDate.now();
    var adjustedDay = currentHijri.hDay + adjustDays;
    var adjustedMonth = currentHijri.hMonth;
    var adjustedYear = currentHijri.hYear;

    var daysInMonth = currentHijri.getDaysInMonth(adjustedYear, adjustedMonth);

    while (adjustedDay > daysInMonth) {
      adjustedDay -= daysInMonth;
      adjustedMonth++;
      if (adjustedMonth > 12) {
        adjustedMonth = 1;
        adjustedYear++;
      }
      daysInMonth = currentHijri.getDaysInMonth(adjustedYear, adjustedMonth);
    }

    while (adjustedDay < 1) {
      adjustedMonth--;
      if (adjustedMonth < 1) {
        adjustedMonth = 12;
        adjustedYear--;
      }
      daysInMonth = currentHijri.getDaysInMonth(adjustedYear, adjustedMonth);
      adjustedDay += daysInMonth;
    }

    return HijriDate.fromHijri(adjustedYear, adjustedMonth, adjustedDay);
  }
}
