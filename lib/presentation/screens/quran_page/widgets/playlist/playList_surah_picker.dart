part of '../../quran.dart';

/// واجهة اختيار السورة — تُعرض كـ bottom sheet
class PlayListSurahPicker extends StatelessWidget {
  final bool isFrom;
  PlayListSurahPicker({super.key, required this.isFrom});
  final playList = PlayListController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return QuranSurahList(
      controller: playList.surahScrollController,
      marginBottom: 0.0,
      isSelected: (index) => isFrom
          ? playList.fromSurahIndex.value == index
          : playList.toSurahIndex.value == index,
      onTap: (index) {
        if (isFrom) {
          playList.selectFromSurah(index);
        } else {
          playList.selectToSurah(index);
        }
        Get.back();
      },
    );
  }
}
