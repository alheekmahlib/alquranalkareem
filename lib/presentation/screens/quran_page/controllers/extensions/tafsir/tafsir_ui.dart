part of '../../../quran.dart';

extension TafsirUi on TafsirCtrl {
  /// -------- [onTap] --------
  Future<void> copyTafsirOnTap(
      String tafsirName, String tafsir, String ayahTextNormal) async {
    await Clipboard.setData(
            ClipboardData(text: '﴿$ayahTextNormal﴾\n\n$tafsirName\n$tafsir'))
        .then(
            (value) => Get.context!.showCustomErrorSnackBar('copyTafseer'.tr));
  }

  void showTafsirOnTap(int surahNum, int ayahNum, String ayahText,
      int pageIndex, String ayahTextN, int ayahUQNum) {
    final quranCtrl = QuranController.instance;
    ayahUQNumber.value = ayahUQNum;
    quranCtrl.state.currentPageNumber.value = pageIndex;
    quranCtrl.state.selectedAyahIndexes.clear();
    Get.bottomSheet(
      ShowTafseer(
        ayahUQNumber: ayahUQNum,
      ),
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 400),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }
}
