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
            child:
                sl<BookmarksController>().hasBookmark(surahNum, ayahUQNum).value
                    ? customSvg(
                        SvgPath.svgBookmarkIcon2,
                        height: 20,
                      )
                    : customSvg(
                        SvgPath.svgBookmarkIcon,
                        height: 20,
                      ),
          )),
      onTap: () async {
        if (sl<BookmarksController>().hasBookmark(surahNum, ayahUQNum).value) {
          sl<BookmarksController>().deleteBookmarksText(ayahUQNum);
        } else {
          sl<BookmarksController>()
              .addBookmarkText(surahName, surahNum, pageIndex + 1, ayahNum,
                  ayahUQNum, sl<GeneralController>().state.timeNow.dateNow)
              .then((value) => context.showCustomErrorSnackBar('addBookmark'.tr,
                  isDone: true));
        }
        sl<AudioController>().clearSelection();
        cancel!();
      },
    );
  }
}
