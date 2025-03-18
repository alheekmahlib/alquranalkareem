part of '../../quran.dart';

class QuranController extends GetxController {
  static QuranController get instance => Get.isRegistered<QuranController>()
      ? Get.find<QuranController>()
      : Get.put<QuranController>(QuranController());

  QuranState state = QuranState();

  @override
  void onInit() async {
    await QuranLibrary().init().then((_) => loadQuran());
    state.itemPositionsListener.itemPositions.addListener(_updatePageNumber);
    state.itemPositionsListener.itemPositions
        .addListener(currentListPageNumber);
    state.isBold.value = state.box.read(IS_BOLD) ?? 0;
    state.isPageMode.value = state.box.read(PAGE_MODE) ?? false;
    state.backgroundPickerColor.value =
        state.box.read(BACKGROUND_PICKER_COLOR) ?? 0xfffaf7f3;
    await QuranLibrary().initTafsir();
    await QuranLibrary().fetchTafsir(pageNumber: state.currentPageNumber.value);
    await QuranLibrary().fetchTranslation();
    Future.delayed(const Duration(seconds: 10), () {
      state.box.read(TAFSEER_VAL) != null
          ? QuranLibrary().tafsirDownload(state.box.read(TAFSEER_VAL))
          : null;
    });
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

  Future<void> updateTafsir(int pageIndex) async {
    if (state.currentPageNumber.value != pageIndex) {
      await QuranLibrary().fetchTafsir(pageNumber: pageIndex);
      TafsirCtrl.instance.update(['change_tafsir']);
    }
  }

  Future<void> loadQuran() async {
    state.surahs = QuranLibrary().quranCtrl.state.surahs;
    state.allAyahs = QuranLibrary().quranCtrl.state.allAyahs;
    state.pages = QuranLibrary().quranCtrl.state.pages;
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

  void loadSwitchValue() {
    state.isPages.value = state.box.read(SWITCH_VALUE) ?? 0;
  }

  void getLastPage() {
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
