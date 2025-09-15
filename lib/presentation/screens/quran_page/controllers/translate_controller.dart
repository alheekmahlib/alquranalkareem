part of '../quran.dart';

class TafsirAndTranslateController extends GetxController {
  static TafsirAndTranslateController get instance =>
      GetInstance().putOrFind(() => TafsirAndTranslateController());
  // var data = [].obs;
  // var isLoading = false.obs;
  var trans = 'en'.obs;
  // RxInt transValue = 0.obs;
  RxInt shareTransValue = 0.obs;
  var expandedMap = <int, bool>{}.obs;
  RxList<TafsirTableData> tafsirList = QuranLibrary().tafsirList.obs;
  // RxBool isTafsir = QuranLibrary().isTafsir.obs;
  RxInt tafsirRadioValue = QuranLibrary().selectedTafsirIndex.obs;
  final box = GetStorage();

  shareTranslateHandleRadioValue(int translateVal) async {
    shareTransValue.value = translateVal;
    switch (shareTransValue.value) {
      case 0:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'en';
        box.write(TRANS, 'en');
      case 1:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'es';
        box.write(TRANS, 'es');
      case 2:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'be';
        box.write(TRANS, 'be');
      case 3:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'urdu';
        box.write(TRANS, 'urdu');
      case 4:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'so';
        box.write(TRANS, 'so');
      case 5:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'in';
        box.write(TRANS, 'in');
      case 6:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'ku';
        box.write(TRANS, 'ku');
      case 7:
        sl<ShareController>().isTafseer.value = false;
        trans.value = 'tr';
        box.write(TRANS, 'tr');
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

  void loadTranslateValue() {
    // transValue.value = box.read(TRANSLATE_VALUE) ?? 0;
    shareTransValue.value = box.read(SHARE_TRANSLATE_VALUE) ?? 0;
    trans.value = box.read(TRANS) ?? 'en';
    ShareController.instance.currentTranslate.value =
        box.read(CURRENT_TRANSLATE) ?? 'English';
    sl<ShareController>().isTafseer.value = (box.read(IS_TAFSEER)) ?? false;
    print('trans.value ${trans.value}');
    // print('translateـvalue $transValue');
    ShareController.instance.update(['currentTranslate']);
  }

  @override
  void onInit() {
    // fetchTranslate();
    super.onInit();
  }
}
