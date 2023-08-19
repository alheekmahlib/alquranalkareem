import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateDataController extends GetxController {
  var data = [].obs;
  var isLoading = false.obs;
  var trans = 'en'.obs;
  RxInt transValue = 1.obs;

  Future<void> fetchSura(BuildContext context) async {
    isLoading.value = true; // Set isLoading to true
    String loadedData = await DefaultAssetBundle.of(context)
        .loadString("assets/json/${trans.value}.json");
    Map<String, dynamic> showData = json.decode(loadedData);
    // List<dynamic> sura = showData[surahNumber];
    data.value = showData['translations'];
    isLoading.value = false; // Set isLoading to false and update the data
  }

  translateHandleRadioValueChanged(int translateVal) {
    transValue.value = translateVal;
    switch (transValue.value) {
      case 0:
        return trans.value = 'en';
      case 1:
        return trans.value = 'es';
      case 2:
        return trans.value = 'be';
      case 3:
        return trans.value = 'urdu';
      default:
        return trans.value = 'en';
    }
  }

  // Save & Load Translate For Quran Text
  Future<void> saveTranslateValue(int translateValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("translateـvalue", translateValue);
  }

  Future<void> loadTranslateValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    transValue.value = prefs.getInt('translateـvalue') ?? 0;
    print('translateـvalue $transValue');
  }
}
