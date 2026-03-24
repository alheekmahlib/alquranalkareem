import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';

import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/calendar/events.dart';
import '../screens/quran_page/quran.dart';

class DailyAyahController extends GetxController {
  static DailyAyahController get instance =>
      GetInstance().putOrFind(() => DailyAyahController());

  final ScrollController scrollController = ScrollController();
  final quranCtrl = QuranController.instance;
  AyahModel? ayahOfTheDay;
  TafsirTableData? selectedTafsir;
  List<TafsirTableData>? currentAyahTafseer;
  RxInt radioValue = 0.obs;
  final box = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  bool get _hasAyahSettedForThisDay {
    final settedDate = box.read(SETTED_DATE_FOR_AYAH);
    return (settedDate != null &&
        settedDate == EventController.instance.hijriNow.fullDate());
  }

  String get tafsirRadioValue => box.read(TAFSIR_OF_THE_DAY_RADIO_VALUE) ?? '0';

  Future<AyahModel> getDailyAyah() async {
    if (ayahOfTheDay != null) return ayahOfTheDay!;
    final String? ayahOfTheDayIdAndId = box.read(
      AYAH_OF_THE_DAY_AND_AYAH_NUMBER,
    );

    ayahOfTheDay = await _getAyahForThisDay(
      _hasAyahSettedForThisDay ? ayahOfTheDayIdAndId : null,
    );
    return ayahOfTheDay!;
  }

  Future<AyahModel> _getAyahForThisDay([
    String? ayahOfTheDayIdAndAyahId,
  ]) async {
    final allAyahs = quranCtrl.state.allAyahs;
    if (allAyahs.isEmpty) {
      throw StateError('allAyahs is empty — Quran data not loaded yet');
    }

    log(
      "ayahOfTheDayIdAndAyahId: ${ayahOfTheDayIdAndAyahId == null ? "null" : "NOT NULL"}",
    );

    // --- المسار المُخزّن: استرجاع آية اليوم من الكاش ---
    if (ayahOfTheDayIdAndAyahId != null) {
      log("before trying to get ayah", name: 'BEFORE');
      final index = int.parse(ayahOfTheDayIdAndAyahId) - 1;
      if (index < 0 || index >= allAyahs.length) {
        // بيانات كاش غير صالحة — سيتم توليد آية جديدة
        return _generateNewAyah(allAyahs);
      }
      final cachedAyah = allAyahs[index];

      await TafsirCtrl.instance.fetchData(cachedAyah.page);

      selectedTafsir = QuranLibrary().tafsirList.firstWhere(
        (a) => a.id == cachedAyah.ayahUQNumber,
        orElse: () => const TafsirTableData(
          id: 0,
          tafsirText: '',
          ayahNum: 0,
          pageNum: 0,
          surahNum: 0,
        ),
      );
      log(
        "date: ${EventController.instance.hijriNow.fullDate()}",
        name: 'CACHED AYAH',
      );
      return cachedAyah;
    }

    // --- المسار الجديد: توليد آية عشوائية ---
    return _generateNewAyah(allAyahs);
  }

  Future<AyahModel> _generateNewAyah(List<AyahModel> allAyahs) async {
    // اختيار فهرس عشوائي مباشرة من القائمة (لا حاجة للبحث بـ ayahUQNumber)
    final randomIndex = math.Random().nextInt(allAyahs.length);
    final ayah = allAyahs[randomIndex];

    // اختيار تفسير عشوائي من المُحمّلة فقط
    final filteredList = TafsirCtrl.instance.tafsirDownloadIndexList
        .where((index) => index < 4)
        .toList();

    final tafsirRandom = filteredList.isNotEmpty
        ? filteredList[math.Random().nextInt(filteredList.length)]
        : 0;

    box.write(TAFSIR_OF_THE_DAY_RADIO_VALUE, '$tafsirRandom');
    radioValue.value = tafsirRandom;

    await TafsirCtrl.instance.fetchData(ayah.page);

    selectedTafsir = TafsirCtrl.instance.tafseerList.firstWhere(
      (a) => a.id == ayah.ayahUQNumber,
      orElse: () => const TafsirTableData(
        id: 0,
        tafsirText: '',
        ayahNum: 0,
        pageNum: 0,
        surahNum: 0,
      ),
    );

    box
      ..write(AYAH_OF_THE_DAY_AND_AYAH_NUMBER, '${ayah.ayahUQNumber}')
      ..write(TAFSIR_OF_THE_DAY_AND_TAFSIR_NUMBER, '${selectedTafsir!.id}')
      ..write(TAFSIR_OF_THE_DAY_RADIO_VALUE, '${radioValue.value}')
      ..write(
        SETTED_DATE_FOR_AYAH,
        EventController.instance.hijriNow.fullDate(),
      );
    return ayah;
  }
}
