part of '../../quran.dart';

class QuranController extends GetxController {
  static QuranController get instance => Get.isRegistered<QuranController>()
      ? Get.find<QuranController>()
      : Get.put<QuranController>(QuranController());

  QuranState state = QuranState();

  final generalCtrl = GeneralController.instance;
  final themeCtrl = ThemeController.instance;

  @override
  void onInit() async {
    await loadQuran();
    state.itemPositionsListener.itemPositions.addListener(_updatePageNumber);
    state.itemPositionsListener.itemPositions
        .addListener(currentListPageNumber);
    state.isBold.value = state.box.read(IS_BOLD) ?? 0;
    state.isPageMode.value = state.box.read(PAGE_MODE) ?? false;
    state.backgroundPickerColor.value =
        state.box.read(BACKGROUND_PICKER_COLOR) ?? 0xfffaf7f3;
    super.onInit();
  }

  @override
  void onClose() {
    state.itemPositionsListener.itemPositions.removeListener(_updatePageNumber);
    state.itemPositionsListener.itemPositions
        .removeListener(currentListPageNumber);
    state.quranPageController.dispose();
    state.ScrollUpDownQuranPage.dispose();
    state.quranPageRLFocusNode.dispose();
    state.quranPageUDFocusNode.dispose();
    super.onClose();
  }

  /// -------- [Methods] ----------

  Future<void> loadQuran() async {
    if (state.surahs.isEmpty) {
      String jsonString =
          await rootBundle.loadString('assets/json/quranV2.json');
      Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
      List<dynamic> surahsJson = jsonResponse['data']['surahs'];
      state.surahs = surahsJson.map((s) => Surah.fromJson(s)).toList();

      for (final surah in state.surahs) {
        state.allAyahs.addAll(surah.ayahs);
        // log('Added ${surah.arabicName} ayahs');
        update();
      }
      List.generate(604, (pageIndex) {
        state.pages.add(state.allAyahs
            .where((ayah) => ayah.page == pageIndex + 1)
            .toList());
      });
      // log('Pages Length: ${state.pages.length}', name: 'Quran Controller');
    }
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

  Future<void> loadSwitchValue() async {
    state.isPages.value = await state.box.read(SWITCH_VALUE) ?? 0;
  }

  Future<void> getLastPage() async {
    try {
      state.currentPageNumber.value = state.box.read(MSTART_PAGE) ?? 1;
      state.lastReadSurahNumber.value = state.box.read(MLAST_URAH) ?? 1;
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }

  // ScrollController scrollToSurah(int surahNumber) {
  //   double position = (surahNumber - 1) * surahItemHeight;
  //   state.surahListController.jumpTo(position);
  // }
}
