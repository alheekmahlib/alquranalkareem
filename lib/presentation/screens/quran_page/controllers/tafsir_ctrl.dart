import 'dart:developer';

import 'package:alquranalkareem/presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../data/data_source/tafsir_database.dart';
import '../data/model/tafsir.dart';
import 'translate_controller.dart';

class TafsirCtrl extends GetxController {
  static TafsirCtrl get instance => Get.isRegistered<TafsirCtrl>()
      ? Get.find<TafsirCtrl>()
      : Get.put<TafsirCtrl>(TafsirCtrl());

  var tafseerList = <TafsirTableData>[].obs;
  String? selectedDBName;
  Rx<TafsirDatabase?> database = Rx<TafsirDatabase?>(null);
  RxString selectedTableName = MufaserName.ibnkatheer.name.obs;
  var radioValue = 0.obs;
  RxBool isTafsir = true.obs;
  RxInt ayahUQNumber = (-1).obs;
  final box = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTafseer().then((_) async {
      if (isTafsir.value) {
        database =
            Rx<TafsirDatabase?>(TafsirDatabase(tafsirDBName[radioValue.value]));
        await initializeDatabase();
      }
    });
  }

  Future<void> loadTafseer() async {
    radioValue.value = box.read(TAFSEER_VAL) ?? 0;
    selectedTableName.value =
        box.read(TAFSEER_TABLE_VAL) ?? MufaserName.ibnkatheer.name;
    isTafsir.value = box.read(IS_TAFSEER) ?? true;
  }

  Future<void> initializeDatabase() async {
    log('Initializing database...');
    TafsirDatabase(tafsirDBName[radioValue.value]);
    log('Database object created.');
    log('Database initialized.');
  }

  Future<void> closeCurrentDatabase() async {
    if (database.value != null) {
      await database.value!.close(); // إغلاق قاعدة البيانات الحالية
      log('Closed current database!');
    }
  }

  Future<void> fetchData(int pageNum) async {
    if (TafsirCtrl.instance.isTafsir.value) {
      final db = await TafsirDatabase(tafsirDBName[radioValue.value]);

      try {
        final List<TafsirTableData> tafsir = await db.getTafsirByPage(pageNum);
        log('Fetched tafsir: ${tafsir.length} entries');

        if (tafsir.isNotEmpty) {
          tafseerList.assignAll(tafsir); // تحديث القائمة في الواجهة
        } else {
          log('No data found for this page.');
          tafseerList.clear(); // مسح القائمة إذا لم يكن هناك تفسير
        }
      } catch (e) {
        log('Error fetching data: $e');
      }
    }
  }

  // استخدام getTafsirByPage لجلب التفسير حسب رقم الصفحة
  Future<List<TafsirTableData>> fetchTafsirPage(int pageNum) async {
    if (database.value == null) {
      throw Exception('Database not initialized');
    }
    List<TafsirTableData> tafsir =
        await database.value!.getTafsirByPage(pageNum);
    return tafsir;
  }

  Future<List<TafsirTableData>> fetchTafsirAyah(
      int ayahUQNumber, int surahNumber) async {
    if (database.value == null) {
      throw Exception('Database not initialized');
    }
    List<TafsirTableData> tafsir =
        await database.value!.getTafsirByAyah(ayahUQNumber);
    return tafsir;
  }

  Future<void> handleRadioValueChanged(int val) async {
    log('start changing Tafsir');
    String? dbFileName;
    radioValue.value = val;

    switch (val) {
      case 0:
        isTafsir.value = true;
        selectedTableName.value = MufaserName.ibnkatheer.name;
        dbFileName = 'ibnkatheerV2.sqlite';
        box.write(IS_TAFSEER, true);
        break;
      case 1:
        isTafsir.value = true;
        selectedTableName.value = MufaserName.baghawy.name;
        dbFileName = 'baghawyV2.db';
        box.write(IS_TAFSEER, true);
        break;
      case 2:
        isTafsir.value = true;
        selectedTableName.value = MufaserName.qurtubi.name;
        dbFileName = 'qurtubiV2.db';
        box.write(IS_TAFSEER, true);
        break;
      case 3:
        isTafsir.value = true;
        selectedTableName.value = MufaserName.saadi.name;
        dbFileName = 'saadiV3.db';
        box.write(IS_TAFSEER, true);
        break;
      case 4:
        isTafsir.value = true;
        selectedTableName.value = MufaserName.tabari.name;
        dbFileName = 'tabariV2.db';
        box.write(IS_TAFSEER, true);
        break;
      case 5:
        // لغات الترجمة
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'en';
        box.write(TRANS, 'en');
        box.write(IS_TAFSEER, false);
        return;
      case 6:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'es';
        box.write(TRANS, 'es');
        box.write(IS_TAFSEER, false);
        return;
      case 7:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'be';
        box.write(TRANS, 'be');
        box.write(IS_TAFSEER, false);
        return;
      case 8:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'urdu';
        box.write(TRANS, 'urdu');
        box.write(IS_TAFSEER, false);
        return;
      case 9:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'so';
        box.write(TRANS, 'so');
        box.write(IS_TAFSEER, false);
        return;
      case 10:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'in';
        box.write(TRANS, 'in');
        box.write(IS_TAFSEER, false);
        return;
      case 11:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'ku';
        box.write(TRANS, 'ku');
        box.write(IS_TAFSEER, false);
        return;
      case 12:
        isTafsir.value = false;
        TranslateDataController.instance.trans.value = 'tr';
        box.write(TRANS, 'tr');
        box.write(IS_TAFSEER, false);
        return;
      default:
        isTafsir.value = true;
        dbFileName = 'ibnkatheerV2.sqlite';
        selectedTableName.value = MufaserName.ibnkatheer.name;
    }
    tafseerList.clear();
    if (isTafsir.value) {
      await closeCurrentDatabase();
      box.write(TAFSEER_TABLE_VAL, selectedTableName.value);
      database.value = TafsirDatabase(dbFileName);
      // initializeDatabase();
      await fetchData(
          QuranController.instance.state.currentPageNumber.value + 1);
      log('Database initialized for: $dbFileName');
    }
    update(['change_tafsir']);
  }
}
