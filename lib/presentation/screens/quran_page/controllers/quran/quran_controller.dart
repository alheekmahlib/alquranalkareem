part of '../../quran.dart';

class QuranController extends GetxController {
  static QuranController get instance =>
      GetInstance().putOrFind(() => QuranController());

  QuranState state = QuranState();

  @override
  void onInit() async {
    super.onInit();
    loadQuran();
    state.backgroundPickerColor.value =
        state.box.read(BACKGROUND_PICKER_COLOR) ?? 0xfffaf7f3;

    debounce(
      QuranCtrl.instance.state.currentPageNumber,
      (pageNumber) async =>
          await HomeWidgetService.instance.updateReadingProgress(),
      time: const Duration(milliseconds: 700),
    );
  }

  @override
  void onClose() {
    // QuranCtrl.instance.quranPagesController.dispose();
    state.ScrollUpDownQuranPage.dispose();
    state.quranPageRLFocusNode.dispose();
    state.quranPageUDFocusNode.dispose();
    super.onClose();
  }

  /// -------- [Methods] ----------

  Future<void> updateTafsir(int pageIndex) async {
    if (QuranCtrl.instance.state.currentPageNumber.value != pageIndex) {
      await QuranLibrary().fetchTafsir(pageNumber: pageIndex);
      TafsirCtrl.instance.update(['change_tafsir']);
    }
  }

  void loadQuran() {
    state.surahs = QuranLibrary.quranCtrl.surahs;
    state.allAyahs = QuranLibrary.quranCtrl.state.allAyahs;
    state.pages = QuranLibrary.quranCtrl.state.pages;
  }
}
