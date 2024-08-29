import 'package:alquranalkareem/presentation/screens/quran_page/extensions/surah_name_with_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/presentation/screens/quran_page/data/model/aya.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../data/data_source/baghawy_data_client.dart';
import '../data/data_source/ibnkatheer_data_client.dart';
import '../data/data_source/qurtubi_data_client.dart';
import '../data/data_source/saadi_data_client.dart';
import '../data/data_source/tabari_data_client.dart';
import '../data/model/tafsir.dart';
import '../data/repository/ayat_repository.dart';
import '../data/repository/tafseer_repository.dart';
import '../widgets/show_tafseer.dart';
import 'translate_controller.dart';

class AyatController extends GetxController {
  static AyatController get instance => Get.isRegistered<AyatController>()
      ? Get.find<AyatController>()
      : Get.put<AyatController>(AyatController());
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
  var tafseerList = <Tafsir>[].obs;
  String? selectedDBName;
  var dBName;
  RxInt radioValue = 0.obs;
  RxString ayahTextNormal = ''.obs;
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
  final box = GetStorage();

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
        box.write(TRANS, 'en');
      case 6:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'es';
        box.write(TRANS, 'es');
      case 7:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'be';
        box.write(TRANS, 'be');
      case 8:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'urdu';
        box.write(TRANS, 'urdu');
      case 9:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'so';
        box.write(TRANS, 'so');
      case 10:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'in';
        box.write(TRANS, 'in');
      case 11:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'ku';
        box.write(TRANS, 'ku');
      case 12:
        isTafseer.value = false;
        sl<TranslateDataController>().trans.value = 'tr';
        box.write(TRANS, 'tr');
      default:
        dBName = ibnkatheerClient?.database;
        selectedDBName = MufaserName.ibnkatheer.name;
    }
    selectedTafseerIndex.value = val;
    // Set the tableName property in the translateRepository
    translateRepository.dBName = dBName;
    translateRepository.tableName = selectedDBName;
    update();
    return translateRepository;
  }

  Future<void> loadTafseer() async {
    radioValue.value = await box.read(TAFSEER_VAL) ?? 0;
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
      int pageIndex, String ayahTextN, int ayahUQNum, int index) {
    tafseerAyah = ayahText;
    surahNumber.value = surahNum;
    ayahTextNormal.value = ayahTextN;
    ayahUQNumber.value = ayahUQNum;
    quranCtrl.state.currentPageNumber.value = pageIndex;
    quranCtrl.state.selectedAyahIndexes.clear();
    Get.bottomSheet(
      ShowTafseer(
        ayahUQNumber: ayahUQNum,
        index: index,
      ),
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 400),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> copyOnTap(String tafsirName, String tafsir) async {
    await Clipboard.setData(ClipboardData(
            text: '﴿${ayahTextNormal.value}﴾\n\n$tafsirName\n${tafsir}'))
        .then(
            (value) => Get.context!.showCustomErrorSnackBar('copyTafseer'.tr));
  }
}
