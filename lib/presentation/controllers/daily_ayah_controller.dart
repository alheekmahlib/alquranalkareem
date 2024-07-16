import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '/presentation/screens/quran_page/controller/extensions/quran_getters.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/quran_page/controller/quran_controller.dart';
import '../screens/quran_page/data/model/surahs_model.dart';
import '../screens/quran_page/data/model/tafsir.dart';
import 'ayat_controller.dart';

class DailyAyahController extends GetxController {
  static DailyAyahController get instance =>
      Get.isRegistered<DailyAyahController>()
          ? Get.find<DailyAyahController>()
          : Get.put<DailyAyahController>(DailyAyahController());
  final ScrollController scrollController = ScrollController();
  final quranCtrl = QuranController.instance;
  final ayatCtrl = AyatController.instance;
  Ayah? ayahOfTheDay;
  Tafsir? selectedTafsir;
  List<Tafsir>? currentPageTafseer;
  RxInt radioValue = 0.obs;
  final box = GetStorage();

  Future<Ayah> getDailyAyah() async {
    print('missing daily Ayah');
    if (ayahOfTheDay != null) return ayahOfTheDay!;
    final String? ayahOfTheDayIdAndId =
        box.read(AYAH_OF_THE_DAY_AND_AYAH_NUMBER);
    ayahOfTheDay = await _getAyahForThisDay(
        _hasAyahSettedForThisDay ? ayahOfTheDayIdAndId : null);

    return ayahOfTheDay!;
  }

  bool get _hasAyahSettedForThisDay {
    final settedDate = box.read(SETTED_DATE_FOR_AYAH);
    return (settedDate != null && settedDate == HijriCalendar.now().fullDate());
  }

  Future<Ayah> _getAyahForThisDay([String? ayahOfTheDayIdAndAyahId]) async {
    log("ayahOfTheDayIdAndAyahId: ${ayahOfTheDayIdAndAyahId == null ? "null" : "NOT NULL"}");
    if (ayahOfTheDayIdAndAyahId != null) {
      log("before trying to get ayah", name: 'BEFORE');
      final cachedAyah =
          quranCtrl.state.allAyahs[int.parse(ayahOfTheDayIdAndAyahId) - 1];
      log("date: ${HijriCalendar.now().fullDate()}", name: 'CAHECH AYAH');
      return cachedAyah;
    }
    final random = math.Random().nextInt(quranCtrl.state.allAyahs.length);
    final tafsirRandom = math.Random().nextInt(tafsirNameRandom.length);
    radioValue.value = tafsirRandom;
    log('allAyahs length: ${quranCtrl.state.allAyahs.length}');
    Ayah? ayah = quranCtrl.state.allAyahs
        .firstWhereOrNull((a) => a.ayahUQNumber == random);
    currentPageTafseer = await ayatCtrl
        .handleRadioValueChanged(tafsirRandom)
        .getAyahTafseer(ayah!.ayahUQNumber,
            quranCtrl.getSurahDataByAyahUQ(ayah.ayahUQNumber).surahNumber);
    selectedTafsir = currentPageTafseer!
        .firstWhereOrNull((a) => a.index == ayah!.ayahUQNumber);
    log('allAyahs length: ${quranCtrl.state.allAyahs.length} 2222');
    while (ayah == null || selectedTafsir == null) {
      log('allAyahs length: ${quranCtrl.state.allAyahs.length} ',
          name: 'while');
      ayah = quranCtrl.state.allAyahs
          .firstWhereOrNull((a) => a.ayahUQNumber == random);
      selectedTafsir = currentPageTafseer!
          .firstWhereOrNull((t) => t.index == ayah!.ayahUQNumber);
      log('ayah is null  ' * 5);
    }
    log('before listing');
    box
      ..write(AYAH_OF_THE_DAY_AND_AYAH_NUMBER, '${ayah.ayahUQNumber}')
      ..write(TAFSIR_OF_THE_DAY_AND_TAFSIR_NUMBER, '${selectedTafsir!.index}')
      ..write(SETTED_DATE_FOR_AYAH, HijriCalendar.now().fullDate());
    return ayah;
  }

  // Future<void> saveKhatmahs(List<Ayah> ayah) async {
  //   final String encodedData =
  //   jsonEncode(ayah.map((a) => a.toMap()).toList());
  //   await prefs.setString(AYAH_OF_THE_DAY, encodedData);
  // }
  //
  // static Future<List<Ayah>> loadKhatmahs() async {
  //   final String? ayahData = prefs.getString(AYAH_OF_THE_DAY);
  //   if (ayahData != null) {
  //     List<dynamic> decodedData = jsonDecode(ayahData);
  //     return decodedData.map((item) => Ayah.fromMap(item)).toList();
  //   }
  //   return [];
  // }
}
