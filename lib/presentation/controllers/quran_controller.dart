import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../screens/quran_page/data/model/surahs_model.dart';
import '/presentation/controllers/general_controller.dart';

class QuranController extends GetxController {
  var currentPage = 1.obs;
  List<Surah> surahs = [];
  List<List<Ayah>> pages = [];

  RxInt selectedVerseIndex = 0.obs;
  RxBool selectedAyah = false.obs;
  var selectedAyahIndexes = <int>[].obs;
  bool isSelected = false;
  final ScrollController scrollIndicatorController = ScrollController();
  RxInt selectedIndicatorIndex = 0.obs;
  PreferDirection preferDirection = PreferDirection.topCenter;

  final generalCtrl = sl<GeneralController>();

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
  void onInit() async {
    super.onInit();
    await loadQuran();
  }

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    surahs = surahsJson.map((s) => Surah.fromJson(s)).toList();
    List<Ayah> allAyahs = [];
    for (final surah in surahs) {
      allAyahs.addAll(surah.ayahs);
      log('Added ${surah.arabicName} ayahs');
      update();
    }
    List.generate(604, (pageIndex) {
      pages.add(allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList());
    });
    log('Pages Length: ${pages.length}', name: 'Quran Controller');
  }

  List<List<Ayah>> getCurrentPageAyahsSeparatedForBasmala(int pageIndex) =>
      pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  /// This approach is not good.. it takse alot of memory..
  // List<Ayah> getAyahsForCurrentPage(int index) {
  //   List<Ayah> ayahs = [];
  //   for (var surah in surahs) {
  //     ayahs.addAll(surah.ayahs.where((ayah) => ayah.page == index));
  //   }
  //   return ayahs;
  // }

  List<Ayah> getCurrentPageAyahs(int pageIndex) => pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => surahs
      .firstWhere(
          (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first))
      .surahNumber;

  // int getSurahNumberFromPage(int pageNumber) {
  //   for (var surah in surahs) {
  //     for (var ayah in surah.ayahs) {
  //       if (ayah.page == pageNumber && ayah.ayahNumber == 1) {
  //         return surah.surahNumber;
  //       }
  //     }
  //   }
  //   return -1;
  // }

  /// it's not good to return widgets from the controller..
  /// instead return indexes or maps or separated lists..
  // Widget besmAllahWidget(int pageNumber) {
  //   List<Ayah> ayahsOnPage = getAyahsForCurrentPage(pageNumber);
  //   int surahNumber = getSurahNumberFromPage(pageNumber);

  //   if (surahNumber == -1 || surahNumber == 9 || surahNumber == 1) {
  //     return const SizedBox.shrink();
  //   } else if (ayahsOnPage.isNotEmpty && ayahsOnPage.first.ayahNumber == 1) {
  //     if (surahNumber == 95 || surahNumber == 97) {
  //       return besmAllah2();
  //     } else {
  //       return besmAllah();
  //     }
  //   } else {
  //     return const SizedBox.shrink();
  //   }
  // }

  void indicatorOnTap(int pageNumber, int itemWidth, double screenWidth) {
    currentPage.value = pageNumber;
    selectedIndicatorIndex.value = pageNumber;
    final targetOffset =
        itemWidth * pageNumber - (screenWidth * .69 / 2) + itemWidth / 2;
    scrollIndicatorController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    generalCtrl.quranPageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void indicatorScroll(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 80;
    selectedIndicatorIndex.value = currentPage.value;
    final targetOffset =
        itemWidth * currentPage.value - (screenWidth * .69 / 2) + itemWidth / 2;
    if (scrollIndicatorController.hasClients) {
      final targetOffset = itemWidth * currentPage.value -
          (screenWidth * .69 / 2) +
          itemWidth / 2;
      scrollIndicatorController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      // Handle the case where the scroll view is not ready
    }
  }
}
