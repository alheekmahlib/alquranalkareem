part of '../quran.dart';

class ShareController extends GetxController {
  static ShareController get instance =>
      GetInstance().putOrFind(() => ShareController());

  final ScreenshotController ayahScreenController = ScreenshotController();
  final ScreenshotController tafseerScreenController = ScreenshotController();
  Uint8List? ayahToImageBytes;
  Uint8List? tafseerToImageBytes;
  RxString? tafseerOrTranslateName;
  RxString currentTranslate = 'English'.obs;
  RxString? textTafseer;
  RxBool isTafseer = false.obs;
  ArabicNumbers arabicNumber = ArabicNumbers();
  final box = GetStorage();

  Future<void> createAndShowVerseImage() async {
    try {
      final Uint8List? imageBytes =
          await ayahScreenController.capture(pixelRatio: 7);
      ayahToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  Future<void> createAndShowTafseerImage() async {
    try {
      final Uint8List? imageBytes =
          await tafseerScreenController.capture(pixelRatio: 7);
      tafseerToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  Future<void> shareButtonOnTap(
      BuildContext context,
      int selectedIndex,
      int verseUQNumber,
      int surahNumber,
      int verseNumber,
      int pageNumber) async {
    sl<TafsirAndTranslateController>().shareTransValue.value == selectedIndex;
    box.write(SHARE_TRANSLATE_VALUE, selectedIndex);
    box.write(CURRENT_TRANSLATE, shareTranslateName[selectedIndex]);
    currentTranslate.value = shareTranslateName[selectedIndex];
    QuranLibrary().changeTafsirSwitch(selectedIndex, pageNumber: pageNumber);
    await QuranLibrary().fetchTranslation();
    sl<TafsirAndTranslateController>().update();
    Get.back();
  }

  void fetchTafseerSaadi(int surahNum, int ayahNum, int ayahUQNum) {
    if (isTafseer.value &&
        sl<TafsirAndTranslateController>().shareTransValue.value == 8) {
      // sl<TafsirController>().dBName =
      //     sl<TafsirController>().saadiClient?.database;
      // sl<TafsirController>().selectedDBName = MufaserName.saadi.name;
      // sl<TafsirController>()
      //     .fetchTafsirPage(sl<QuranController>().state.currentPageNumber.value);
      // sl<TafsirController>().ayahsTafseer(ayahUQNum, surahNum);
    }
  }

  shareText(String verseText, surahName, int verseNumber) {
    Get.back();
    Share.share(
        '﴿$verseText﴾ '
        '[$surahName-'
        '$verseNumber]',
        subject: '$surahName');
  }

  Future<void> shareVerseWithTranslate(BuildContext context) async {
    Get.back();
    if (tafseerToImageBytes != null) {
      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/verse_tafseer_image.png').create();
      await imagePath.writeAsBytes(tafseerToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
    }
  }

  Future<void> shareVerse(BuildContext context) async {
    Get.back();
    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/verse_image.png').create();
    await imagePath.writeAsBytes(ayahToImageBytes!);
    await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
  }
}
