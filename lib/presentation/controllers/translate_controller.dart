import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/quran_page/data/model/tafsir.dart';
import '/presentation/controllers/share_controller.dart';
import 'ayat_controller.dart';

class TranslateDataController extends GetxController {
  var data = [].obs;
  var isLoading = false.obs;
  var trans = 'en'.obs;
  RxInt transValue = 0.obs;
  RxInt shareTransValue = 0.obs;
  var expandedMap = <int, bool>{}.obs;

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
        await sl<SharedPreferences>().setString(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        await sl<SharedPreferences>().setString(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        await sl<SharedPreferences>().setString(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        await sl<SharedPreferences>().setString(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        await sl<SharedPreferences>().setString(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        await sl<SharedPreferences>().setString(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        await sl<SharedPreferences>().setString(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        await sl<SharedPreferences>().setString(TRANS, 'tr');
      case 8:
        sl<ShareController>().isTafseer.value = true;
        sl<SharedPreferences>().setBool(IS_TAFSEER, true);
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
        await sl<SharedPreferences>().setString(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        await sl<SharedPreferences>().setString(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        await sl<SharedPreferences>().setString(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        await sl<SharedPreferences>().setString(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        await sl<SharedPreferences>().setString(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        await sl<SharedPreferences>().setString(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        await sl<SharedPreferences>().setString(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        await sl<SharedPreferences>().setString(TRANS, 'tr');
      case 8:
        sl<ShareController>().isTafseer.value = true;
        sl<AyatController>().dBName =
            sl<AyatController>().saadiClient?.database;
        sl<AyatController>().selectedDBName = MufaserName.saadi.name;
        sl<SharedPreferences>().setBool(IS_TAFSEER, true);
      default:
        trans.value = 'en';
    }
  }

  Future<void> loadTranslateValue() async {
    transValue.value =
        await sl<SharedPreferences>().getInt(TRANSLATE_VALUE) ?? 0;
    shareTransValue.value =
        await sl<SharedPreferences>().getInt(SHARE_TRANSLATE_VALUE) ?? 0;
    trans.value = await sl<SharedPreferences>().getString(TRANS) ?? 'en';
    sl<ShareController>().currentTranslate.value =
        await sl<SharedPreferences>().getString(CURRENT_TRANSLATE) ?? 'English';
    sl<ShareController>().isTafseer.value =
        (await sl<SharedPreferences>().getBool(IS_TAFSEER)) ?? false;
    print('trans.value ${trans.value}');
    print('translateـvalue $transValue');
  }

  @override
  void onInit() {
    fetchTranslate(Get.context!);
    super.onInit();
  }
}
