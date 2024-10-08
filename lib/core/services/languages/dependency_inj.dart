import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_constants.dart';
import 'language_models.dart';
import 'localization_controller.dart';

Future<Map<String, Map<String, String>>> init() async {
  Get.lazyPut(() => LocalizationController());

  Map<String, Map<String, String>> _languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/locales/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);

    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });

    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  return _languages;
}
