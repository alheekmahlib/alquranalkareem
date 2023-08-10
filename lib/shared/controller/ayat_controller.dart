import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../quran_page/data/model/ayat.dart';
import '../../quran_page/data/model/translate.dart';
import '../../quran_page/data/repository/translate_repository.dart';

class AyatController extends GetxController {
  var ayatList = <Ayat>[].obs; // Observable list
  String? tableName;
  late int radioValue;
  RxString currentAyahNumber = '1'.obs;
  var isSelected = 0.0.obs;
  ValueNotifier<int> selectedTafseerIndex = ValueNotifier<int>(0);

  void fetchAyat(int pageNum) async {
    List<Ayat>? ayat =
        await handleRadioValueChanged(radioValue).getPageTranslate(pageNum);
    if (ayat != null) {
      ayatList.value = ayat; // Update the observable list
    }
  }

  handleRadioValueChanged(int val) {
    TranslateRepository translateRepository = TranslateRepository();

    radioValue = val;
    switch (radioValue) {
      case 0:
        tableName = Translate.tableName2;
        break;
      case 1:
        tableName = Translate.tableName;
        break;
      case 2:
        tableName = Translate.tableName3;
        break;
      case 3:
        tableName = Translate.tableName4;
        break;
      case 4:
        tableName = Translate.tableName5;
        break;
      default:
        tableName = Translate.tableName2;
    }
    selectedTafseerIndex.value = val;
    // Set the tableName property in the translateRepository
    translateRepository.tableName = tableName;
    return translateRepository;
  }
}
