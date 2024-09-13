import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/presentation/screens/quran_page/extensions/surah_name_with_banner.dart';
import '../data/data_source/tafsir_database.dart';
import '../data/model/tafsir.dart';
import '../widgets/show_tafseer.dart';

class TafsirController extends GetxController {
  static TafsirController get instance => Get.isRegistered<TafsirController>()
      ? Get.find<TafsirController>()
      : Get.put<TafsirController>(TafsirController());
  var tafseerList = <TafsirTableData>[].obs;
  String? selectedDBName;
  var dBName;
  // RxInt radioValue = 0.obs;
  RxString ayahTextNormal = ''.obs;
  RxInt ayahNumber = (-1).obs;
  RxInt ayahUQNumber = (-1).obs;
  RxInt surahNumber = 1.obs;
  String tafseerAyah = '';
  String tafseerText = '';
  RxString currentAyahNumber = '1'.obs;
  var isSelected = (-1.0).obs;
  var currentPageLoading = RxBool(false);
  var currentPageError = RxString('');
  ValueNotifier<int> selectedTafseerIndex = ValueNotifier<int>(0);
  RxBool isTafseer = false.obs;
  TafsirTableData? selectedTafsir;
  List<TafsirTableData>? currentPageTafseer;
  final box = GetStorage();

  Rx<TafsirDatabase?> database = Rx<TafsirDatabase?>(null);
  RxString selectedTableName = MufaserName.ibnkatheer.name.obs;

  // استخدام getTafsirByPage لجلب التفسير حسب رقم الصفحة
  Future<List<TafsirTableData>> fetchTafsirPage(int pageNum) async {
    if (database.value == null) {
      throw Exception('Database not initialized');
    }

    // استدعاء getTafsirByPage لجلب التفسير
    List<TafsirTableData> tafsir =
        await database.value!.getTafsirByPage(pageNum);
    return tafsir;
  }

  Future<List<TafsirTableData>> fetchTafsirAyah(
      int ayahUQNumber, int surahNumber) async {
    if (database.value == null) {
      throw Exception('Database not initialized');
    }

    // استدعاء getTafsirByPage لجلب التفسير
    List<TafsirTableData> tafsir =
        await database.value!.getTafsirByAyah(ayahUQNumber);
    return tafsir;
  }

  void fetchTafsir(int pageNum) async {
    if (database.value == null) {
      print("Database not initialized");
      return;
    }

    // جلب التفسير بناءً على رقم الصفحة
    List<TafsirTableData> tafsir = await fetchTafsirPage(pageNum);

    // استخدام التفسير لعرضه في واجهة المستخدم
    if (tafsir.isNotEmpty) {
      tafseerList.value = tafsir; // تحديث واجهة المستخدم بقائمة التفسير
    } else {
      print('No Tafsir found for page $pageNum');
    }
  }

  // تغيير قاعدة البيانات بناءً على الاختيار
  // Future<void> handleRadioValueChanged(int val) async {
  //   String? dbFileName;
  //   radioValue.value = val;
  //   switch (val) {
  //     case 0:
  //       isTafseer.value = true;
  //       selectedTableName.value = MufaserName.ibnkatheer.name;
  //       dbFileName = 'ibnkatheerV2.sqlite';
  //       // database.value = TafsirDatabase(dbFileName);
  //       break;
  //     case 1:
  //       isTafseer.value = true;
  //       selectedTableName.value = MufaserName.baghawy.name;
  //       dbFileName = 'baghawyV2.db';
  //       // database.value = TafsirDatabase(dbFileName);
  //       break;
  //     case 2:
  //       isTafseer.value = true;
  //       selectedTableName.value = MufaserName.qurtubi.name;
  //       dbFileName = 'qurtubiV2.db';
  //       // database.value = TafsirDatabase(dbFileName);
  //       break;
  //     case 3:
  //       isTafseer.value = true;
  //       selectedTableName.value = MufaserName.saadi.name;
  //       dbFileName = 'saadiV3.db';
  //       // database.value = TafsirDatabase(dbFileName);
  //       break;
  //     case 4:
  //       isTafseer.value = true;
  //       selectedTableName.value = MufaserName.tabari.name;
  //       dbFileName = 'tabariV2.db';
  //       // database.value = TafsirDatabase(dbFileName);
  //       break;
  //     case 5:
  //       // لغات الترجمة
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'en';
  //       box.write(TRANS, 'en');
  //       break;
  //     case 6:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'es';
  //       box.write(TRANS, 'es');
  //       break;
  //     case 7:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'be';
  //       box.write(TRANS, 'be');
  //       break;
  //     case 8:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'urdu';
  //       box.write(TRANS, 'urdu');
  //       break;
  //     case 9:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'so';
  //       box.write(TRANS, 'so');
  //       break;
  //     case 10:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'in';
  //       box.write(TRANS, 'in');
  //       break;
  //     case 11:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'ku';
  //       box.write(TRANS, 'ku');
  //       break;
  //     case 12:
  //       isTafseer.value = false;
  //       sl<TranslateDataController>().trans.value = 'tr';
  //       box.write(TRANS, 'tr');
  //       break;
  //     default:
  //       dbFileName = 'ibnkatheerV2.sqlite';
  //       selectedTableName.value = MufaserName.ibnkatheer.name;
  //   }
  //
  //   // تحديث الفهرس المختار للتفسير
  //   selectedTafseerIndex.value = val;
  //
  //   if (isTafseer.value) {
  //     // تحديث قاعدة البيانات الحالية
  //     database.value = TafsirDatabase(dbFileName!);
  //     log('Database initialized for: $dbFileName');
  //   }
  //   update();
  // }

  Future<void> getTafsir(int ayahUQNumber, int surahNumber) async {
    try {
      currentPageTafseer = await database.value!.getTafsirByAyah(ayahUQNumber);
      selectedTafsir = currentPageTafseer!
          .firstWhereOrNull((ayah) => ayah.id == ayahUQNumber);
    } catch (e) {
      log('Error fetching Tafsir: $e');
    }
  }

  Future<List<TafsirTableData>> ayahsTafseer(
          int ayahUQNumber, int surahNumber) async =>
      await database.value!.getTafsirByAyah(ayahUQNumber);

  Future<void> loadTafseer() async {
    // radioValue.value = await box.read(TAFSEER_VAL) ?? 0;
  }

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

  // Future<void> getTranslatedPage(int pageNum, BuildContext context) async {
  //   currentPageLoading.value = true;
  //   try {
  //     await handleRadioValueChanged(radioValue.value).getPageTafsir(pageNum);
  //     currentPageLoading.value = false;
  //     // Update other observables if needed
  //   } catch (e) {
  //     currentPageLoading.value = false;
  //     currentPageError.value = "Error fetching Translated Page: $e";
  //   }
  // }
}
