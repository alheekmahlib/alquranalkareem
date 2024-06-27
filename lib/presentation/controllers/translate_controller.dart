import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/presentation/controllers/share_controller.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';

class TranslateDataController extends GetxController {
  static TranslateDataController get instance =>
      Get.isRegistered<TranslateDataController>()
          ? Get.find<TranslateDataController>()
          : Get.put<TranslateDataController>(TranslateDataController());
  var data = [].obs;
  var isLoading = false.obs;
  var trans = 'en'.obs;
  RxInt transValue = 0.obs;
  RxInt shareTransValue = 0.obs;
  var expandedMap = <int, bool>{}.obs;
  final box = GetStorage();

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
        await box.write(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        await box.write(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        await box.write(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        await box.write(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        await box.write(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        await box.write(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        await box.write(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        await box.write(TRANS, 'tr');
      case 8:
        sl<ShareController>().isTafseer.value = true;
        box.write(IS_TAFSEER, true);
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
        await box.write(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        await box.write(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        await box.write(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        await box.write(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        await box.write(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        await box.write(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        await box.write(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        await box.write(TRANS, 'tr');
      // case 8:
      //   sl<ShareController>().isTafseer.value = true;
      //   sl<AyatController>().dBName =
      //       sl<AyatController>().saadiClient?.database;
      //   sl<AyatController>().selectedDBName = MufaserName.saadi.name;
      //   box.write(IS_TAFSEER, true);
      default:
        trans.value = 'en';
    }
  }

  Future<void> loadTranslateValue() async {
    transValue.value = await box.read(TRANSLATE_VALUE) ?? 0;
    shareTransValue.value = await box.read(SHARE_TRANSLATE_VALUE) ?? 0;
    trans.value = await box.read(TRANS) ?? 'en';
    sl<ShareController>().currentTranslate.value =
        await box.read(CURRENT_TRANSLATE) ?? 'English';
    sl<ShareController>().isTafseer.value =
        (await box.read(IS_TAFSEER)) ?? false;
    print('trans.value ${trans.value}');
    print('translateـvalue $transValue');
  }

  @override
  void onInit() {
    fetchTranslate(Get.context!);
    super.onInit();
  }

  void changeTranslateOnTap(int index) {
    transValue.value == index;
    box.write(TRANSLATE_VALUE, index);
    translateHandleRadioValueChanged(index);
    fetchTranslate(Get.context!);
    Get.back();
  }
}
