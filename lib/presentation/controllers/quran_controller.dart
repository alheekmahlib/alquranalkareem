import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../../core/utils/constants/svg_picture.dart';
import '../screens/quran_page/data/model/surahs_model.dart';

class QuranController extends GetxController {
  var currentPage = 1.obs;
  var surahs = <Surah>[].obs;
  RxInt selectedVerseIndex = 0.obs;
  RxBool selectedAyah = false.obs;
  var selectedAyahIndexes = <int>[].obs;
  bool? isSelected;

  void toggleAyahSelection(int index) {
    if (selectedAyahIndexes.contains(index)) {
      selectedAyahIndexes.remove(index);
    } else {
      selectedAyahIndexes.add(index);
    }
    selectedAyahIndexes.refresh();
  }

  void clearSelections() {
    selectedAyahIndexes.clear();
    selectedAyahIndexes.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    loadQuran();
  }

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    surahs.value = surahsJson.map((s) => Surah.fromJson(s)).toList();
  }

  List<Ayah> getAyahsForCurrentPage(int index) {
    List<Ayah> ayahs = [];
    for (var surah in surahs) {
      ayahs.addAll(surah.ayahs.where((ayah) => ayah.page == index));
    }
    return ayahs;
  }

  int getSurahNumberFromPage(int pageNumber) {
    for (var surah in surahs) {
      for (var ayah in surah.ayahs) {
        if (ayah.page == pageNumber && ayah.ayahNumber == 1) {
          return surah.surahNumber;
        }
      }
    }
    return -1;
  }

  Widget besmAllahWidget(int pageNumber) {
    int surahNumber = getSurahNumberFromPage(pageNumber);
    List<Ayah> ayahsOnPage = getAyahsForCurrentPage(pageNumber);

    if (surahNumber == -1 || surahNumber == 9 || surahNumber == 1) {
      return const SizedBox.shrink();
    } else if (ayahsOnPage.isNotEmpty && ayahsOnPage.first.ayahNumber == 1) {
      if (surahNumber == 95 || surahNumber == 97) {
        return besmAllah2();
      } else {
        return besmAllah();
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
