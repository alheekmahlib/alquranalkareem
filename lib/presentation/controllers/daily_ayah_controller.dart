import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../core/utils/constants/lists.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/quran_page/data/data_source/tafsir_database.dart';
import '../screens/quran_page/data/model/surahs_model.dart';
import '../screens/quran_page/data/model/tafsir.dart';
import '../screens/quran_page/quran.dart';

class DailyAyahController extends GetxController {
  static DailyAyahController get instance =>
      Get.isRegistered<DailyAyahController>()
          ? Get.find<DailyAyahController>()
          : Get.put<DailyAyahController>(DailyAyahController());
  final ScrollController scrollController = ScrollController();
  final quranCtrl = QuranController.instance;
  Ayah? ayahOfTheDay;
  TafsirTableData? selectedTafsir;
  List<TafsirTableData>? currentAyahTafseer;
  RxInt radioValue = 0.obs;
  final box = GetStorage();

  bool get _hasAyahSettedForThisDay {
    final settedDate = box.read(SETTED_DATE_FOR_AYAH);
    return (settedDate != null && settedDate == HijriCalendar.now().fullDate());
  }

  Future<Ayah> getDailyAyah() async {
    print('missing daily Ayah');
    if (ayahOfTheDay != null) return ayahOfTheDay!;
    final String? tafsirOfTheDayRadioValue =
        box.read(TAFSIR_OF_THE_DAY_RADIO_VALUE);
    final String? ayahOfTheDayIdAndId =
        box.read(AYAH_OF_THE_DAY_AND_AYAH_NUMBER);
    ayahOfTheDay = await _getAyahForThisDay(
      _hasAyahSettedForThisDay ? ayahOfTheDayIdAndId : null,
      _hasAyahSettedForThisDay ? tafsirOfTheDayRadioValue : null,
    );

    return ayahOfTheDay!;
  }

  Future<Ayah> _getAyahForThisDay(
      [String? ayahOfTheDayIdAndAyahId,
      String? tafsirOfTheDayRadioValue]) async {
    log("ayahOfTheDayIdAndAyahId: ${ayahOfTheDayIdAndAyahId == null ? "null" : "NOT NULL"}");
    if (ayahOfTheDayIdAndAyahId != null) {
      log("before trying to get ayah", name: 'BEFORE');
      final cachedAyah =
          quranCtrl.state.allAyahs[int.parse(ayahOfTheDayIdAndAyahId) - 1];

      currentAyahTafseer = await TafsirDatabase(
              tafsirDBName[int.parse(tafsirOfTheDayRadioValue!)])
          .getTafsirByAyah(cachedAyah.ayahUQNumber);
      selectedTafsir = currentAyahTafseer!.firstWhere(
        (a) => a.id == cachedAyah.ayahUQNumber,
        orElse: () => const TafsirTableData(
            id: 0, tafsirText: '', ayahNum: 0, pageNum: 0, surahNum: 0),
      );
      log("date: ${HijriCalendar.now().fullDate()}", name: 'CAHECH AYAH');
      return cachedAyah;
    }
    final random = math.Random().nextInt(quranCtrl.state.allAyahs.length);
    final tafsirRandom = math.Random().nextInt(tafsirNameRandom.length);
    radioValue.value = tafsirRandom;
    log('allAyahs length: ${quranCtrl.state.allAyahs.length}');
    Ayah? ayah = quranCtrl.state.allAyahs
        .firstWhereOrNull((a) => a.ayahUQNumber == random);
    currentAyahTafseer = await TafsirDatabase(tafsirDBName[tafsirRandom])
        .getTafsirByAyah(ayah!.ayahUQNumber);
    selectedTafsir = currentAyahTafseer!.firstWhere(
      (a) => a.id == ayah!.ayahUQNumber,
      orElse: () => const TafsirTableData(
          id: 0, tafsirText: '', ayahNum: 0, pageNum: 0, surahNum: 0),
    );
    log('allAyahs length: ${quranCtrl.state.allAyahs.length} 2222');
    while (ayah == null && selectedTafsir == null) {
      log('allAyahs length: ${quranCtrl.state.allAyahs.length} ',
          name: 'while');
      ayah = quranCtrl.state.allAyahs
          .firstWhereOrNull((a) => a.ayahUQNumber == random);
      selectedTafsir = currentAyahTafseer!
          .firstWhereOrNull((t) => t.id == ayah!.ayahUQNumber);
      log('ayah is null  ' * 5);
    }
    log('before listing');
    box
      ..write(AYAH_OF_THE_DAY_AND_AYAH_NUMBER, '${ayah!.ayahUQNumber}')
      ..write(TAFSIR_OF_THE_DAY_AND_TAFSIR_NUMBER, '${selectedTafsir!.id}')
      ..write(TAFSIR_OF_THE_DAY_RADIO_VALUE, '${radioValue.value}')
      ..write(SETTED_DATE_FOR_AYAH, HijriCalendar.now().fullDate());
    return ayah;
  }
}
