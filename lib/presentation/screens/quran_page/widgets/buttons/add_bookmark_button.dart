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
    return GestureDetector(
      child: Obx(() => Semantics(
            button: true,
            enabled: true,
            label: 'Add Bookmark',
            child: customSvgWithCustomColor(
              BookmarksController.instance
                      .hasBookmark(surahNum, ayahUQNum)
                      .value
                  ? SvgPath.svgBookmarkIcon2
                  : SvgPath.svgBookmarkIcon,
              height: 20,
            ),
          )),
      onTap: () async {
        if (BookmarksController.instance
            .hasBookmark(surahNum, ayahUQNum)
            .value) {
          BookmarksController.instance.deleteBookmarksText(ayahUQNum);
        } else {
          BookmarksController.instance
              .addBookmarkText(surahName, surahNum, pageIndex + 1, ayahNum,
                  ayahUQNum, sl<GeneralController>().state.timeNow.dateNow)
              .then((value) => context.showCustomErrorSnackBar('addBookmark'.tr,
                  isDone: true));
        }
        sl<AudioController>().clearSelection();
        quranCtrl.state.isPages.value == 1 ? null : cancel!();
      },
    );
  }
}
