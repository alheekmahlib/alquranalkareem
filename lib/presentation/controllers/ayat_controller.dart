import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/quran_page/data/data_source/baghawy_data_client.dart';
import '../screens/quran_page/data/data_source/ibnkatheer_data_client.dart';
import '../screens/quran_page/data/data_source/qurtubi_data_client.dart';
import '../screens/quran_page/data/data_source/saadi_data_client.dart';
import '../screens/quran_page/data/data_source/tabari_data_client.dart';
import '../screens/quran_page/data/model/tafsir.dart';
import '../screens/quran_page/data/repository/ayat_repository.dart';
import '../screens/quran_page/data/repository/tafseer_repository.dart';
import '../screens/quran_page/widgets/show_tafseer.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/presentation/controllers/translate_controller.dart';
import '/presentation/screens/quran_page/data/model/aya.dart';
import 'general_controller.dart';

class AyatController extends GetxController {
  IbnkatheerDataBaseClient? ibnkatheerClient;
  BaghawyDataBaseClient? baghawyClient;
  QurtubiDataBaseClient? qurtubiClient;
  SaadiDataBaseClient? saadiClient;
  TabariDataBaseClient? tabariClient;
  AyatController() {
    ibnkatheerClient = IbnkatheerDataBaseClient.instance;
    baghawyClient = BaghawyDataBaseClient.instance;
    qurtubiClient = QurtubiDataBaseClient.instance;
    saadiClient = SaadiDataBaseClient.instance;
    tabariClient = TabariDataBaseClient.instance;
  }
  var ayatList = <Aya>[].obs;
  var allAyatList = <Aya>[].obs;
  var tafseerList = <Tafsir>[].obs;
  String? selectedDBName;
  var dBName;
  RxInt radioValue = 0.obs;
  RxInt numberOfAyahText = 1.obs;
  RxString ayahTextNumber = '1'.obs;
  RxString ayahTextNormal = ''.obs;
  RxString surahTextNumber = '1'.obs;
  RxInt ayahSelected = (-1).obs;
  RxInt ayahNumber = (-1).obs;
  RxInt ayahUQNumber = (-1).obs;
  RxInt surahNumber = 1.obs;
  String tafseerAyah = '';
  String tafseerText = '';
  RxString currentAyahNumber = '1'.obs;
  Aya? currentAyah;
  var isSelected = (-1.0).obs;
  var currentPageLoading = RxBool(false);
  var currentPageError = RxString('');
  ValueNotifier<int> selectedTafseerIndex = ValueNotifier<int>(0);
  final TafseerRepository translateRepository = TafseerRepository();
  final AyatRepository ayatRepository = AyatRepository();
  RxBool isTafseer = false.obs;
  Tafsir? selectedTafsir;
  List<Tafsir>? currentPageTafseer;

  Future<List<Tafsir>> fetchTafseerPage(int pageNum) async {
    List<Tafsir>? tafseer =
        await handleRadioValueChanged(radioValue.value).getPageTafseer(pageNum);
    if (tafseer.isNotEmpty) {
      tafseerList.value = tafseer;
    }
    return tafseer;
  }

  TafseerRepository handleRadioValueChanged(int val) {
    radioValue.value = val;
    switch (radioValue.value) {
      case 0:
        isTafseer.value = true;
        dBName = ibnkatheerClient?.database;
        selectedDBName = MufaserName.ibnkatheer.name;
        break;
      case 1:
        isTafseer.value = true;
        dBName = baghawyClient?.database;
        selectedDBName = MufaserName.baghawy.name;
        break;
      case 2:
        isTafseer.value = true;
        dBName = qurtubiClient?.database;
        selectedDBName = MufaserName.qurtubi.name;
        break;
      case 3:
        isTafseer.value = true;
        dBName = saadiClient?.database;
        selectedDBName = MufaserName.saadi.name;
        break;
      case 4:
        isTafseer.value = true;
        dBName = tabariClient?.database;
        selectedDBName = MufaserName.tabari.name;
        break;
      case 5:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'en';
        sl<SharedPreferences>().setString(TRANS, 'en');
      case 6:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'es';
        sl<SharedPreferences>().setString(TRANS, 'es');
      case 7:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'be';
        sl<SharedPreferences>().setString(TRANS, 'be');
      case 8:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'urdu';
        sl<SharedPreferences>().setString(TRANS, 'urdu');
      case 9:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'so';
        sl<SharedPreferences>().setString(TRANS, 'so');
      case 10:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'in';
        sl<SharedPreferences>().setString(TRANS, 'in');
      case 11:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'ku';
        sl<SharedPreferences>().setString(TRANS, 'ku');
      case 12:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'tr';
        sl<SharedPreferences>().setString(TRANS, 'tr');
      default:
        dBName = ibnkatheerClient?.database;
        selectedDBName = MufaserName.ibnkatheer.name;
    }
    selectedTafseerIndex.value = val;
    // Set the tableName property in the translateRepository
    translateRepository.dBName = dBName;
    translateRepository.tableName = selectedDBName;
    return translateRepository;
  }

  Future<void> loadTafseer() async {
    radioValue.value = await sl<SharedPreferences>().getInt(TAFSEER_VAL) ?? 0;
  }

  Future<void> getTranslatedPage(int pageNum, BuildContext context) async {
    currentPageLoading.value = true;
    try {
      await handleRadioValueChanged(radioValue.value).getPageTafseer(pageNum);
      currentPageLoading.value = false;
      // Update other observables if needed
    } catch (e) {
      currentPageLoading.value = false;
      currentPageError.value = "Error fetching Translated Page: $e";
    }
  }

  // Future<void> getTranslatedAyah(BuildContext context, int selectedSurahNumber,
  //     int selectedAyahNumber) async {
  //   currentPageLoading.value = true;
  //   try {
  //     List<Tafseer> ayahs = await handleRadioValueChanged(radioValue.value)
  //         .getAyahTafseer(selectedSurahNumber, selectedAyahNumber);
  //     currentPageLoading.value = false;
  //     // Update other observables if needed
  //     // Use the 'ayahs' as needed here, e.g., update UI or state
  //   } catch (e) {
  //     currentPageLoading.value = false;
  //     currentPageError.value = "Error fetching Translated Page: $e";
  //   }
  // }

  Future<void> getTafsir(int ayahUQNumber, int surahNumber) async {
    currentPageTafseer = await handleRadioValueChanged(radioValue.value)
        .getAyahTafseer(ayahUQNumber, surahNumber);
    selectedTafsir = currentPageTafseer!
        .firstWhereOrNull((ayah) => ayah.index == ayahUQNumber);
  }

  Future<List<Tafsir>> ayahsTafseer(int ayahUQNumber, int surahNumber) async =>
      await handleRadioValueChanged(radioValue.value)
          .getAyahTafseer(ayahUQNumber, surahNumber);

  void showTafsirOnTap(int surahNum, int ayahNum, String ayahText,
      int pageIndex, String ayahTextN, int ayahUQNum) {
    tafseerAyah = ayahText;
    numberOfAyahText.value = ayahNum;
    surahNumber.value = surahNum;
    ayahTextNumber.value = ayahUQNum.toString();
    ayahTextNormal.value = ayahTextN;
    ayahUQNumber.value = ayahUQNum;
    sl<GeneralController>().currentPageNumber.value = pageIndex;
    Get.bottomSheet(
      ShowTafseer(
        ayahUQNumber: ayahUQNum,
        ayahNumber: ayahNum,
      ),
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 400),
      exitBottomSheetDuration: const Duration(milliseconds: 400),
    );
  }

  Future<void> copyOnTap() async {
    await Clipboard.setData(ClipboardData(
            text:
                '﴿${ayahTextNormal.value}﴾\n\n${selectedTafsir!.text.buildTextSpans()}'))
        .then(
            (value) => Get.context!.showCustomErrorSnackBar('copyTafseer'.tr));
  }
}
