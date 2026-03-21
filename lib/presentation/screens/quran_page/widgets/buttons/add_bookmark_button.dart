part of '../../quran.dart';

class AddBookmarkButton extends StatelessWidget {
  final SurahModel surah;
  final AyahModel ayah;
  final int pageIndex;
  final Color? iconColor;

  const AddBookmarkButton({
    super.key,
    required this.surah,
    required this.ayah,
    required this.pageIndex,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookmarksController>(
      id: 'ayah_bookmarked',
      builder: (bookmarksCtrl) {
        return CustomButton(
          height: 40,
          width: 35,
          iconSize: 40,
          isCustomSvgColor: true,
          svgPath: SvgPath.svgQuranBookmark,
          svgColor:
              bookmarksCtrl
                  .hasBookmark(surah.surahNumber, ayah.ayahUQNumber)
                  .value
              ? context.theme.colorScheme.surface
              : iconColor ?? context.theme.canvasColor,
          onPressed: () async {
            if (bookmarksCtrl
                .hasBookmark(surah.surahNumber, ayah.ayahUQNumber)
                .value) {
              bookmarksCtrl.deleteBookmarksText(ayah.ayahUQNumber);
            } else {
              bookmarksCtrl
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
          },
        );
      },
    );
  }
}
