import 'dart:io';
import 'dart:typed_data';

import 'package:alquranalkareem/core/widgets/widgets.dart';
import 'package:alquranalkareem/presentation/controllers/translate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/services/l10n/app_localizations.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../screens/quran_text/widgets/widgets.dart';
import 'ayat_controller.dart';
import 'general_controller.dart';

class ShareController extends GetxController {
  final ScreenshotController ayahScreenController = ScreenshotController();
  final ScreenshotController tafseerScreenController = ScreenshotController();
  Uint8List? ayahToImageBytes;
  Uint8List? tafseerToImageBytes;
  RxString? tafseerOrTranslateName;
  RxString currentTranslate = 'English'.obs;
  RxString? textTafseer;
  RxBool isTafseer = false.obs;

  Future<void> createAndShowVerseImage() async {
    try {
      final Uint8List? imageBytes = await ayahScreenController.capture();
      ayahToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  Future<void> createAndShowTafseerImage() async {
    try {
      final Uint8List? imageBytes = await tafseerScreenController.capture();
      tafseerToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing verse image: $e');
    }
  }

  void changeTafseer(
      BuildContext context, int verseUQNumber, int surahNum, int ayahNum) {
    if (isTafseer.value) {
      // textTafseer!.value = sl<AyatController>().currentText.value!.translate;
      if (sl<AyatController>().radioValue.value != 3 ||
          sl<TranslateDataController>().shareTransValue.value == 8) {
        sl<AyatController>().handleRadioValueChanged(3);
        sl<AyatController>()
            .fetchTafseerPage(sl<GeneralController>().currentPage.value);
        sl<AyatController>().getNewTranslationAndNotify(surahNum, ayahNum);
        customErrorSnackBar(context,
            'تم تغيير التفسير إلى: ${AppLocalizations.of(context)!.tafSaadiN}');
      }
      // tafseerOrTranslateName!.value = sl<AyatController>().radioValue.value != 3
      //     ? ''
      //     : AppLocalizations.of(context)!.tafSaadiN;
    }
    // else {
    //   sl<TranslateDataController>().fetchTranslate(context);
    //   textTafseer!.value =
    //       sl<TranslateDataController>().data[verseUQNumber - 1]['text'];
    // }
    // else if (sl<GeneralController>().shareTafseerValue.value == 2) {
    //   tafseerOrTranslateName!.value =
    //       translateName[sl<TranslateDataController>().transValue.value];
    // }
  }

  bool isRtlLanguage(String languageName) {
    return rtlLang.contains(languageName);
  }

  AlignmentGeometry checkAndApplyRtlLayout(String language) {
    if (isRtlLanguage(language)) {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }

  TextDirection checkApplyRtlLayout(String language) {
    if (isRtlLanguage(language)) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  shareText(String verseText, surahName, int verseNumber) {
    Share.share(
        '﴿$verseText﴾ '
        '[$surahName-'
        '$verseNumber]',
        subject: '$surahName');
  }

  Future<void> shareVerseWithTranslate(BuildContext context) async {
    if (tafseerToImageBytes! != null) {
      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/verse_tafseer_image.png').create();
      await imagePath.writeAsBytes(tafseerToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))],
          text: AppLocalizations.of(context)!.appName);
    }
  }

  Future<void> shareVerse(BuildContext context) async {
    if (ayahToImageBytes! != null) {
      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/verse_image.png').create();
      await imagePath.writeAsBytes(ayahToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))],
          text: AppLocalizations.of(context)!.appName);
    }
  }

  String shareNumber(String verseText, int verseNumber) {
    if (sl<GeneralController>().shareTafseerValue.value == 1) {
      return '﴿ $verseText ﴾';
    } else {
      return '﴿ $verseText ${arabicNumber.convert(verseNumber)} ﴾\n';
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
