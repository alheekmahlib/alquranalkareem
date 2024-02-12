import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '/presentation/controllers/quran_controller.dart';

class QuranSearchController extends GetxController {
  final searchTextEditing = TextEditingController();
  RxList<dynamic> searchResults = <dynamic>[].obs;
  final ScrollController scrollController = ScrollController();
  ContainerTransitionType transitionType = ContainerTransitionType.fade;
  final quranCtrl = sl<QuranController>();

  // TODO:
  List<dynamic> searchQuran(String query) {
    var results = [];
    // List<dynamic> searchResults = results;
    searchResults.clear();

    // searchResults.addAll(
    //   quranCtrl.surahs.where((surah) =>
    //       surah.arabicName.contains(query) ||
    //       surah.englishName.contains(query)),
    // );

    searchResults.addAll(
      quranCtrl.allAyahs.where((ayah) =>
          ayah.text.contains(query) ||
          (ayah.aya_text_emlaey?.contains(query) ?? false)),
    );

    // Search by page number
    // Assuming the query can be converted to an integer for page number searches
    int? page = int.tryParse(query);
    if (page != null) {
      searchResults.addAll(
        quranCtrl.allAyahs.where((ayah) => ayah.page == page),
      );
    }
    int? ayahNum = int.tryParse(query);
    if (ayahNum != null) {
      searchResults.addAll(
        quranCtrl.allAyahs.where((ayah) => ayah.ayahNumber == ayahNum),
      );
    }

    // Make sure to remove duplicates if any, especially if an ayah matches both text and page number criteria
    return searchResults.toSet().toList();
  }
}
