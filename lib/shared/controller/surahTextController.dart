import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../quran_text/model/Ahya.dart';
import '../../quran_text/model/QuranModel.dart';

class SurahTextController extends GetxController {
  var surahs = <SurahText>[].obs;
  List<List<Ayahs>> allPages = [];
  int currentSurahIndex = 0;
  int currentPageIndex = 0;

  SurahText get currentSurah => surahs[currentSurahIndex];

  void setCurrentSurahIndexByPageNumber(int pageNumber) {
    print('before changing currentSurah number => ${currentSurahIndex + 1}');
    currentSurahIndex = surahs
            .firstWhere((s) => s.ayahs!.any((a) => a.page! == pageNumber))
            .number! -
        1;
    print('After changing currentSurah number => ${currentSurahIndex + 1}');
    currentPageIndex = pageNumber - 1;
  }

  @override
  void onInit() {
    super.onInit();
    loadQuranData();
  }

  Future<void> loadQuranData() async {
    final jsondata = await rootBundle.loadString('assets/json/quran.json');
    final list = json.decode(jsondata);
    var data = list["data"]["surahs"];
    var loadedSurahs = <SurahText>[];
    for (int i = 0; i < data.length; i++) {
      loadedSurahs.add(SurahText.fromJson(data[i]));
    }
    // for (final surah in loadedSurahs){
    //   for (final ayah in surah.ayahs!){
    //
    //   }
    // }
    for (int i = 1; i <= 604; i++) {
      final currentPageSurahs =
          loadedSurahs.where((s) => s.ayahs!.first.page == i).toList();
      for (final surah in currentPageSurahs) {
        allPages.add(surah.ayahs!.where((ayah) => ayah.page == i).toList());
      }
      // allPages.add(loadedSurahs.where((s) => s.ayahs!.first.page == i).where((surah) => surah.ayahs.))
      // allPages.add(loadedSurahs.where((s) => s.ayahs!.first.page == i).forEach((s2) {
      //   return s2.ayahs!.where((ayah) => ayah.page == i).toList();
      // }));
    }
    surahs.assignAll(loadedSurahs);
  }
}
