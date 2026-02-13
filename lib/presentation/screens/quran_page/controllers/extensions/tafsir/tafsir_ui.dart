part of '../../../quran.dart';

extension TafsirUi on QuranController {
  /// -------- [onTap] --------
  Future<void> copyTafsirOnTap(
    String tafsirName,
    String tafsir,
    String ayahTextNormal,
  ) async {
    await Clipboard.setData(
      ClipboardData(text: '﴿$ayahTextNormal﴾\n\n$tafsirName\n$tafsir'),
    ).then((value) => Get.context!.showCustomErrorSnackBar('copyTafseer'.tr));
  }

  // Future<void> showTafsirOnTap(
  //     {required int pageIndex, required int ayahUQNum}) async {
  //   // final quranCtrl = QuranController.instance;
  //   // ayahUQNumber.value = ayahUQNum;
  //   state.currentPageNumber.value = pageIndex;
  //   state.selectedAyahIndexes.clear();
  //   if (!QuranLibrary().isTafsir) {
  //     await QuranLibrary().fetchTranslation();
  //   } else {
  //     await QuranLibrary().closeAndInitializeDatabase();
  //   }
  //   Get.bottomSheet(
  //     ShowTafseer(
  //       ayahUQNumber: ayahUQNum,
  //     ),
  //     isScrollControlled: true,
  //     enterBottomSheetDuration: const Duration(milliseconds: 400),
  //     exitBottomSheetDuration: const Duration(milliseconds: 300),
  //   );
  // }
}
