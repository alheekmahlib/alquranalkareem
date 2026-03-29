part of '../../quran.dart';

class QuranController extends GetxController {
  static QuranController get instance =>
      GetInstance().putOrFind(() => QuranController());

  QuranState state = QuranState();

  @override
  void onInit() async {
    // QuranLibrary.quranCtrl.state.fontsSelected.value = 1;
    // QuranLibrary.quranCtrl.state.loadedFontPages.;
    loadQuran();
    state.backgroundPickerColor.value =
        state.box.read(BACKGROUND_PICKER_COLOR) ?? 0xfffaf7f3;
    // await QuranLibrary().fetchTafsir(pageNumber: QuranCtrl.instance.state.currentPageNumber.value);
    // await QuranLibrary().fetchTranslation();
    // Future.delayed(const Duration(seconds: 10), () {
    //   // TafsirCtrl.instance.tafsirDownloadIndexList.contains(0)
    //   //     ? null
    //   //     : QuranLibrary().tafsirDownload(0);
    //   state.box.read(TAFSEER_VAL) != null
    //       ? QuranLibrary().tafsirDownload(state.box.read(TAFSEER_VAL))
    //       : null;
    // });
    super.onInit();
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
