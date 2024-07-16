import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '/presentation/controllers/general_controller.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../data/model/surahs_model.dart';
import 'quran_state.dart';

class QuranController extends GetxController {
  static QuranController get instance => Get.isRegistered<QuranController>()
      ? Get.find<QuranController>()
      : Get.put<QuranController>(QuranController());

  QuranState state = QuranState();

  List<int> get downThePageIndex => [
        75,
        206,
        330,
        340,
        348,
        365,
        375,
        413,
        416,
        444,
        451,
        497,
        505,
        524,
        547,
        554,
        556,
        583
      ];
  List<int> get topOfThePageIndex => [
        76,
        207,
        331,
        341,
        349,
        366,
        376,
        414,
        417,
        435,
        445,
        452,
        498,
        506,
        525,
        548,
        554,
        555,
        557,
        583,
        584
      ];

  final generalCtrl = GeneralController.instance;
  final themeCtrl = ThemeController.instance;

  @override
  void onInit() async {
    super.onInit();
    await loadQuran();
    state.itemPositionsListener.itemPositions.addListener(_updatePageNumber);
    state.itemPositionsListener.itemPositions
        .addListener(currentListPageNumber);
    state.isBold.value = state.box.read(IS_BOLD) ?? 0;
  }

  @override
  void onClose() {
    state.itemPositionsListener.itemPositions.removeListener(_updatePageNumber);
    state.itemPositionsListener.itemPositions
        .removeListener(currentListPageNumber);
    super.onClose();
  }

  /// -------- [Methods] ----------

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    state.surahs = surahsJson.map((s) => Surah.fromJson(s)).toList();

    for (final surah in state.surahs) {
      state.allAyahs.addAll(surah.ayahs);
      // log('Added ${surah.arabicName} ayahs');
      update();
    }
    List.generate(604, (pageIndex) {
      state.pages.add(
          state.allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList());
    });
    // log('Pages Length: ${state.pages.length}', name: 'Quran Controller');
  }

  Future<void> loadSwitchValue() async {
    state.isPages.value = await state.box.read(SWITCH_VALUE) ?? 0;
  }

  void currentListPageNumber() {
    final positions = state.itemPositionsListener.itemPositions.value;
    final filteredPositions =
        positions.where((position) => position.itemLeadingEdge >= 0);
    if (filteredPositions.isNotEmpty) {
      final firstItemIndex = filteredPositions
          .reduce((minPosition, position) =>
              position.itemLeadingEdge < minPosition.itemLeadingEdge
                  ? position
                  : minPosition)
          .index;
      state.currentListPage.value = firstItemIndex;
    }
  }

  void _updatePageNumber() {
    final positions = state.itemPositionsListener.itemPositions.value;
    final filteredPositions =
        positions.where((position) => position.itemLeadingEdge >= 0);
    if (filteredPositions.isNotEmpty) {
      final firstItemIndex = filteredPositions
          .reduce((minPosition, position) =>
              position.itemLeadingEdge < minPosition.itemLeadingEdge
                  ? position
                  : minPosition)
          .index;
      state.box.write(MSTART_PAGE, firstItemIndex + 1);
    } else {}
  }
}
