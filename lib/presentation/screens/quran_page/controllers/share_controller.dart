import 'dart:io';
import 'dart:typed_data';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../data/model/tafsir.dart';
import 'ayat_controller.dart';
import 'quran/quran_controller.dart';
import 'translate_controller.dart';

class ShareController extends GetxController {
  static ShareController get instance => Get.isRegistered<ShareController>()
      ? Get.find<ShareController>()
      : Get.put<ShareController>(ShareController());
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

  Future<void> shareButtonOnTap(BuildContext context, int selectedIndex,
      int verseUQNumber, int surahNumber, int verseNumber) async {
    sl<TranslateDataController>().shareTransValue.value == selectedIndex;
    box.write(SHARE_TRANSLATE_VALUE, selectedIndex);
    box.write(CURRENT_TRANSLATE, shareTranslateName[selectedIndex]);
    currentTranslate.value = shareTranslateName[selectedIndex];
    sl<TranslateDataController>().shareTranslateHandleRadioValue(selectedIndex);
    if (isTafseer.value) {
      await sl<AyatController>().fetchTafseerPage(
          sl<QuranController>().state.currentPageNumber.value);
      sl<AyatController>().ayahsTafseer(verseUQNumber, surahNumber);
    } else {
      sl<TranslateDataController>().fetchTranslate(context);
    }
    sl<TranslateDataController>().update();
    Get.back();
  }

  void fetchTafseerSaadi(int surahNum, int ayahNum, int ayahUQNum) {
    if (isTafseer.value &&
        sl<TranslateDataController>().shareTransValue.value == 8) {
      sl<AyatController>().dBName = sl<AyatController>().saadiClient?.database;
      sl<AyatController>().selectedDBName = MufaserName.saadi.name;
      sl<AyatController>().fetchTafseerPage(
          sl<QuranController>().state.currentPageNumber.value);
      sl<AyatController>().ayahsTafseer(ayahUQNum, surahNum);
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