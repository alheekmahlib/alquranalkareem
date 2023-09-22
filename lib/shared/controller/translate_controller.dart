import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/controllers_put.dart';
import '../utils/constants/shared_preferences_constants.dart';

class TranslateDataController extends GetxController {
  var data = [].obs;
  var isLoading = false.obs;
  var trans = 'en'.obs;
  RxInt transValue = 1.obs;

  Future<void> fetchSura(BuildContext context) async {
    isLoading.value = true; // Set isLoading to true
    String loadedData = await DefaultAssetBundle.of(context)
        .loadString("assets/json/translate/${trans.value}.json");
    Map<String, dynamic> showData = json.decode(loadedData);
    // List<dynamic> sura = showData[surahNumber];
    data.value = showData['translations'];
    isLoading.value = false; // Set isLoading to false and update the data
    print('trans.value ${trans.value}');
  }

  translateHandleRadioValueChanged(int translateVal) async {
    transValue.value = translateVal;
    switch (transValue.value) {
      case 0:
        trans.value = 'en';
        await pref.saveString(TRANS, 'en');
      case 1:
        trans.value = 'es';
        await pref.saveString(TRANS, 'es');
      case 2:
        trans.value = 'be';
        await pref.saveString(TRANS, 'be');
      case 3:
        trans.value = 'urdu';
        await pref.saveString(TRANS, 'urdu');
      case 4:
        trans.value = 'so';
        await pref.saveString(TRANS, 'so');
      default:
        trans.value = 'en';
    }
  }

  Future<void> loadTranslateValue() async {
    transValue.value = await pref.getInteger(TRANSLATE_VALUE, defaultValue: 0);
    // String? tValue = await pref.getString(TRANS);
    // if (tValue == null) {
    //   trans.value = tValue;
    // } else {
    //   trans.value = 'en'; // Setting to a valid default value
    // }
    trans.value = await pref.getString(TRANS, defaultValue: 'en');
    print('trans.value ${trans.value}');
    print('translateـvalue $transValue');
  }
}
