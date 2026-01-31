part of '../../quran.dart';

class AddBookmarkButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final int pageIndex;
  final String surahName;
  final Function? cancel;

  const AddBookmarkButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahUQNum,
    required this.pageIndex,
    required this.surahName,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      width: 23,
      isCustomSvgColor: true,
      svgPath:
          BookmarksController.instance.hasBookmark(surahNum, ayahUQNum).value
          ? SvgPath.svgBookmarkIcon2
          : SvgPath.svgBookmarkIcon,
      svgColor: context.theme.hintColor,
      onPressed: () async {
        if (BookmarksController.instance
            .hasBookmark(surahNum, ayahUQNum)
            .value) {
          BookmarksController.instance.deleteBookmarksText(ayahUQNum);
        } else {
          BookmarksController.instance
              .addBookmarkText(
                surahName,
                surahNum,
                pageIndex + 1,
                ayahNum,
                ayahUQNum,
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
