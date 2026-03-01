part of '../../quran.dart';

class AddBookmarkButton extends StatelessWidget {
  final SurahModel surah;
  final AyahModel ayah;
  final int pageIndex;
  final Function? cancel;

  const AddBookmarkButton({
    super.key,
    required this.surah,
    required this.ayah,
    required this.pageIndex,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 40,
      width: 35,
      iconSize: 35,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgQuranBookmark,
      svgColor:
          BookmarksController.instance
              .hasBookmark(surah.surahNumber, ayah.ayahUQNumber)
              .value
          ? context.theme.colorScheme.surface
          : context.theme.canvasColor,
      onPressed: () async {
        if (BookmarksController.instance
            .hasBookmark(surah.surahNumber, ayah.ayahUQNumber)
            .value) {
          BookmarksController.instance.deleteBookmarksText(ayah.ayahUQNumber);
        } else {
          BookmarksController.instance
              .addBookmarkText(
                surah.arabicName,
                surah.surahNumber,
                pageIndex + 1,
                ayah.ayahNumber,
                ayah.ayahUQNumber,
                sl<GeneralController>().state.timeNow.dateNow,
              )
              .then(
                (value) => context.showCustomErrorSnackBar(
                  'addBookmark'.tr,
                  isDone: true,
                ),
              );
        }
        QuranController.instance.clearSelection();
        QuranController.instance.state.isPages.value == 1 ? null : cancel!();
      },
    );
  }
}
