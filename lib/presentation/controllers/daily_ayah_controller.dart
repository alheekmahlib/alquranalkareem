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
    print('missing daily Ayah');
    if (ayahOfTheDay != null) return ayahOfTheDay!;
    final String? tafsirOfTheDayRadioValue = box.read(
      TAFSIR_OF_THE_DAY_RADIO_VALUE,
    );
    final String? ayahOfTheDayIdAndId = box.read(
      AYAH_OF_THE_DAY_AND_AYAH_NUMBER,
    );
    // ayahOfTheDay = await _getAyahForThisDay(
    //   _hasAyahSettedForThisDay ? ayahOfTheDayIdAndId : null,
    //   _hasAyahSettedForThisDay ? tafsirOfTheDayRadioValue : null,
    // );

    return await _getAyahForThisDay(
      _hasAyahSettedForThisDay ? ayahOfTheDayIdAndId : null,
      _hasAyahSettedForThisDay ? tafsirOfTheDayRadioValue : null,
    );
  }

  Future<AyahModel> _getAyahForThisDay([
    String? ayahOfTheDayIdAndAyahId,
    String? tafsirOfTheDayRadioValue,
  ]) async {
    // box.remove(TAFSIR_OF_THE_DAY_RADIO_VALUE);
    // box.remove(TAFSIR_OF_THE_DAY_AND_TAFSIR_NUMBER);
    // box.remove(AYAH_OF_THE_DAY_AND_AYAH_NUMBER);
    // box.remove(SETTED_DATE_FOR_AYAH);
    log(
      "ayahOfTheDayIdAndAyahId: ${ayahOfTheDayIdAndAyahId == null ? "null" : "NOT NULL"}",
    );
    if (ayahOfTheDayIdAndAyahId != null) {
      log("before trying to get ayah", name: 'BEFORE');
      final cachedAyah =
          quranCtrl.state.allAyahs[int.parse(ayahOfTheDayIdAndAyahId) - 1];

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
        name: 'CAHECH AYAH',
      );
      return cachedAyah;
    }
    final random = math.Random().nextInt(quranCtrl.state.allAyahs.length);
    final filteredList = TafsirCtrl.instance.tafsirDownloadIndexList
        .where((index) => index < 4)
        .toList();

    final tafsirRandom =
        filteredList[math.Random().nextInt(filteredList.length)];
    print("الرقم العشوائي المختار: $tafsirRandom"); // مثال: 0 أو 3

    box.write(TAFSIR_OF_THE_DAY_RADIO_VALUE, '$tafsirRandom');
    radioValue.value = tafsirRandom;
    log('allAyahs length: ${quranCtrl.state.allAyahs.length}');
    AyahModel? ayah = quranCtrl.state.allAyahs.firstWhereOrNull(
      (a) => a.ayahUQNumber == random,
    );
    await TafsirCtrl.instance.fetchData(ayah!.page);
    // await TafsirCtrl.instance.fetchTranslate();
    selectedTafsir = TafsirCtrl.instance.tafseerList.firstWhere(
      (a) => a.id == random,
      orElse: () => const TafsirTableData(
        id: 0,
        tafsirText: 'حدث خطأ أثناء عرض التفسير',
        ayahNum: 0,
        pageNum: 0,
        surahNum: 0,
      ),
    );
    log('allAyahs length: ${quranCtrl.state.allAyahs.length} 2222');
    while (ayah == null && selectedTafsir == null) {
      log(
        'allAyahs length: ${quranCtrl.state.allAyahs.length} ',
        name: 'while',
      );
      ayah = quranCtrl.state.allAyahs.firstWhereOrNull(
        (a) => a.ayahUQNumber == random,
      );
      selectedTafsir = QuranLibrary().tafsirList.firstWhereOrNull(
        (t) => t.id == ayah!.ayahUQNumber,
      );
      log('ayah is null  ' * 5);
    }
    log('before listing');
    box
      ..write(AYAH_OF_THE_DAY_AND_AYAH_NUMBER, '${ayah!.ayahUQNumber}')
      ..write(TAFSIR_OF_THE_DAY_AND_TAFSIR_NUMBER, '${selectedTafsir!.id}')
      ..write(TAFSIR_OF_THE_DAY_RADIO_VALUE, '${radioValue.value}')
      ..write(
        SETTED_DATE_FOR_AYAH,
        EventController.instance.hijriNow.fullDate(),
      );
    return ayah;
  }
}
