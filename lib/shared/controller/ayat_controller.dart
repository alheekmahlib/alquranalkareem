import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../quran_page/data/model/ayat.dart';
import '../../quran_page/data/model/translate.dart';
import '../../quran_page/data/repository/translate_repository.dart';
import 'general_controller.dart';

class AyatController extends GetxController {
  var ayatList = <Ayat>[].obs;
  String? tableName;
  late int radioValue;
  String? ayahTextNumber;
  String? sorahTextNumber;
  String tafseerAyah = '';
  String tafseerText = '';
  int? translateIndex;
  RxString currentAyahNumber = '1'.obs;
  var isSelected = 0.0.obs;
  var currentText = Rx<TextUpdated?>(null);
  var currentPageLoading = RxBool(false);
  var currentPageError = RxString('');
  ValueNotifier<int> selectedTafseerIndex = ValueNotifier<int>(0);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final GeneralController generalController = Get.put(GeneralController());

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

  void saveTafseer(int radioValue) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("tafseer_val", radioValue);
  }

  Future<void> loadTafseer() async {
    SharedPreferences prefs = await _prefs;
    radioValue = prefs.getInt('tafseer_val') ?? 0;
    print('get tafseer value ${prefs.getInt('tafseer_val')}');
    print('get radioValue ${radioValue}');
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
