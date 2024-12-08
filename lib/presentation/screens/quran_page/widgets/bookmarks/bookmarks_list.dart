part of '../../quran.dart';

class BookmarksList extends StatelessWidget {
  BookmarksList({Key? key}) : super(key: key);

  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: GetBuilder<BookmarksController>(
        builder: (bookmarkCtrl) => bookmarkCtrl.bookmarksList.isEmpty &&
                bookmarkCtrl.bookmarkTextList.isEmpty
            ? Center(
                child: Column(
                children: [
                  const Gap(16),
                  Text(
                    'bookmarks'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  customLottie(LottieConstants.assetsLottieSearch,
                      height: 150.0, width: 150.0),
                ],
              ))
            : Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'bookmarks'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                  bookmarkCtrl.bookmarksList.isEmpty
                      ? const SizedBox.shrink()
                      : Flexible(flex: 10, child: BookmarkPagesBuild()),
                  const Gap(16),
                  bookmarkCtrl.bookmarkTextList.isEmpty
                      ? const SizedBox.shrink()
                      : Flexible(flex: 10, child: BookmarkAyahsBuild()),
                ],
              ),
      ),
    );
  }
}
