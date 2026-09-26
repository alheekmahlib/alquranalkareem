part of '../../../quran.dart';

extension TafsirUi on QuranController {
  // copyTafsirOnTap نُقل إلى QuranUi (quran_ui.dart) بنسخة تقرأ الآية
  // المعروضة حاليًا في نافذة التفسير بدل استقبال نصوص جاهزة

  // Future<void> showTafsirOnTap(
  //     {required int pageIndex, required int ayahUQNum}) async {
  //   // final quranCtrl = QuranController.instance;
  //   // ayahUQNumber.value = ayahUQNum;
  //   QuranCtrl.instance.state.currentPageNumber.value = pageIndex;
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
