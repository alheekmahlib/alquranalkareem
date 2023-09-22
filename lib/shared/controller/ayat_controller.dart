import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../quran_page/data/model/ayat.dart';
import '../../quran_page/data/model/translate.dart';
import '../../quran_page/data/repository/translate_repository.dart';
import '../services/controllers_put.dart';
import '../utils/constants/shared_preferences_constants.dart';

class AyatController extends GetxController {
  var ayatList = <Ayat>[].obs;
  String? tableName;
  late int radioValue;
  RxString ayahTextNumber = '1'.obs;
  RxString sorahTextNumber = '1'.obs;
  RxInt ayahSelected = (-1).obs;
  RxInt ayahNumber = (-1).obs;
  RxInt surahNumber = 1.obs;
  String tafseerAyah = '';
  String tafseerText = '';
  int? translateIndex;
  RxString currentAyahNumber = '1'.obs;
  var isSelected = (-1.0).obs;
  var currentText = Rx<TextUpdated?>(null);
  var currentPageLoading = RxBool(false);
  var currentPageError = RxString('');
  ValueNotifier<int> selectedTafseerIndex = ValueNotifier<int>(0);

  void fetchAyat(int pageNum) async {
    List<Ayat>? ayat =
        await handleRadioValueChanged(radioValue).getPageTranslate(pageNum);
    if (ayat.isNotEmpty) {
      ayatList.value = ayat; // Update the observable list
    }
  }

  TranslateRepository handleRadioValueChanged(int val) {
    final TranslateRepository translateRepository = TranslateRepository();

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

  Future<void> loadTafseer() async {
    radioValue = await pref.getInteger(TAFSEER_VAL, defaultValue: 0);
  }

  void updateText(String ayatext, String translate) {
    currentText.value = TextUpdated(ayatext, translate);
  }

  Future<void> getTranslatedPage(int pageNum, BuildContext context) async {
    currentPageLoading.value = true;
    try {
      await handleRadioValueChanged(radioValue).getPageTranslate(pageNum);
      currentPageLoading.value = false;
      // Update other observables if needed
    } catch (e) {
      currentPageLoading.value = false;
      currentPageError.value = "Error fetching Translated Page: $e";
    }
  }

  Future<void> getTranslatedAyah(BuildContext context, int selectedSurahNumber,
      int selectedAyahNumber) async {
    currentPageLoading.value = true;
    try {
      await handleRadioValueChanged(radioValue)
          .getAyahTranslate(selectedSurahNumber);
      currentPageLoading.value = false;
      // Update other observables if needed
    } catch (e) {
      currentPageLoading.value = false;
      currentPageError.value = "Error fetching Translated Page: $e";
    }
  }

  void getNewTranslationAndNotify(BuildContext context, int selectedSurahNumber,
      int selectedAyahNumber) async {
    List<Ayat> ayahs = await handleRadioValueChanged(radioValue)
        .getAyahTranslate(selectedSurahNumber);

    Ayat selectedAyah =
        ayahs.firstWhere((ayah) => ayah.ayaNum == selectedAyahNumber);

    updateText("${selectedAyah.ayatext}", "${selectedAyah.translate}");
  }
}

class TextUpdated {
  final String translateAyah;
  final String translate;

  TextUpdated(this.translateAyah, this.translate);
}
