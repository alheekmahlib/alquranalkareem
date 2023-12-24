import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_pref_services.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '/presentation/controllers/share_controller.dart';

class TranslateDataController extends GetxController {
  var data = [].obs;
  var isLoading = false.obs;
  var trans = 'en'.obs;
  RxInt transValue = 0.obs;
  RxInt shareTransValue = 0.obs;

  Future<void> fetchTranslate(BuildContext context) async {
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
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'en';
        await sl<SharedPrefServices>().saveString(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        await sl<SharedPrefServices>().saveString(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        await sl<SharedPrefServices>().saveString(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        await sl<SharedPrefServices>().saveString(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        await sl<SharedPrefServices>().saveString(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        await sl<SharedPrefServices>().saveString(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        await sl<SharedPrefServices>().saveString(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        await sl<SharedPrefServices>().saveString(TRANS, 'tr');
      case 8:
        sl<ShareController>().isTafseer.value = true;
        sl<SharedPrefServices>().saveBoolean(IS_TAFSEER, true);
      default:
        trans.value = 'en';
    }
  }

  shareTranslateHandleRadioValue(int translateVal) async {
    shareTransValue.value = translateVal;
    switch (shareTransValue.value) {
      case 0:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'en';
        await sl<SharedPrefServices>().saveString(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        await sl<SharedPrefServices>().saveString(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        await sl<SharedPrefServices>().saveString(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        await sl<SharedPrefServices>().saveString(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        await sl<SharedPrefServices>().saveString(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        await sl<SharedPrefServices>().saveString(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        await sl<SharedPrefServices>().saveString(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        await sl<SharedPrefServices>().saveString(TRANS, 'tr');
      case 8:
        sl<ShareController>().isTafseer.value = true;
        sl<SharedPrefServices>().saveBoolean(IS_TAFSEER, true);
      default:
        trans.value = 'en';
    }
  }

  Future<void> loadTranslateValue() async {
    transValue.value = await sl<SharedPrefServices>()
        .getInteger(TRANSLATE_VALUE, defaultValue: 0);
    shareTransValue.value = await sl<SharedPrefServices>()
        .getInteger(SHARE_TRANSLATE_VALUE, defaultValue: 0);
    trans.value =
        await sl<SharedPrefServices>().getString(TRANS, defaultValue: 'en');
    sl<ShareController>().currentTranslate.value =
        await sl<SharedPrefServices>()
            .getString(CURRENT_TRANSLATE, defaultValue: 'English');
    sl<ShareController>().isTafseer.value =
        await sl<SharedPrefServices>().getBoolean(IS_TAFSEER);
    print('trans.value ${trans.value}');
    print('translateـvalue $transValue');
  }
}
