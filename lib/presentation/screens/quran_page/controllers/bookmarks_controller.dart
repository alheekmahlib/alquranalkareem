part of '../quran.dart';

class BookmarksController extends GetxController {
  static BookmarksController get instance =>
      Get.isRegistered<BookmarksController>()
          ? Get.find<BookmarksController>()
          : Get.put<BookmarksController>(BookmarksController());
  final RxList<Bookmark> bookmarksList = <Bookmark>[].obs;
  final RxList<BookmarksAyah> bookmarkTextList = <BookmarksAyah>[].obs;
  late int lastBook;
  final quranCtrl = QuranController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  void onInit() {
    getBookmarks();
    getBookmarksText();
    super.onInit();
  }

  Future<void> addBookmarks(
    int pageNum,
    String surahName,
    String lastRead,
  ) async {
    try {
      int? bookmark = await DbBookmarkHelper.addBookmark(
        BookmarksCompanion(
          sorahName: drift.Value(surahName),
          pageNum: drift.Value(pageNum),
          lastRead: drift.Value(lastRead),
        ),
      );
      getBookmarks();
      QuranController.instance.update(['pageBookmarked']);
      print('bookmark number: $bookmark');
    } catch (e, stacktrace) {
      // طباعة تفاصيل الخطأ مع الاستثناء والمكدس الكامل
      print('Error adding bookmark: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  Future<void> getBookmarks() async {
    final bookmarks = await DbBookmarkHelper.queryB();
    bookmarksList.assignAll(bookmarks);
  }

  Future<bool> deleteBookmarks(int pageNum) async {
    Bookmark? bookmarkToDelete = bookmarksList
        .firstWhereOrNull((bookmark) => bookmark.pageNum == pageNum);

    if (bookmarkToDelete != null) {
      await DbBookmarkHelper.deleteBookmark(bookmarkToDelete);
      // تأكد من إزالة العلامة المرجعية من القائمة المحلية
      bookmarksList.remove(bookmarkToDelete);
      Get.context!.showCustomErrorSnackBar('deletedBookmark'.tr);
      QuranController.instance.update(['pageBookmarked']);
      return true;
    }
    return false;
  }

  void updateBookmarks(Bookmark? bookmark) async {
    await DbBookmarkHelper.updateBookmarks(bookmark!);
    getBookmarks();
  }

  RxBool hasPageBookmark(int pageNum) {
    return (bookmarksList.firstWhereOrNull(((b) => b.pageNum == pageNum)) !=
            null)
        ? true.obs
        : false.obs;
  }

  void addPageBookmarkOnTap(int index) {
    if (hasPageBookmark(index + 1).value) {
      deleteBookmarks(index + 1);
    } else {
      addBookmarks(index + 1, quranCtrl.getCurrentSurahByPage(index).arabicName,
              generalCtrl.state.timeNow.dateNow)
          .then((value) => Get.context!
              .showCustomErrorSnackBar('addBookmark'.tr, isDone: true));
    }
  }

  /// =================================================================

  Future<void> getBookmarksText() async {
    final List<BookmarksAyah> bookmarksText = await DbBookmarkHelper.queryT();
    bookmarkTextList.assignAll(bookmarksText); // تحديث القائمة
    QuranController.instance.update(['bookmarked']);
  }

  Future<bool> deleteBookmarksText(int ayahUQNum) async {
    BookmarksAyah? bookmarkToDelete = bookmarkTextList
        .firstWhereOrNull((bookmark) => bookmark.ayahUQNumber == ayahUQNum);

    if (bookmarkToDelete != null) {
      int result = await DbBookmarkHelper.deleteBookmarkText(bookmarkToDelete);
      if (result > 0) {
        // تأكد من إزالة العلامة المرجعية من القائمة المحلية
        bookmarkTextList.remove(bookmarkToDelete);
        Get.context!.showCustomErrorSnackBar('deletedBookmark'.tr);
        QuranController.instance.update(['bookmarked']);
        return true;
      }
    }
    return false;
  }

  void updateBookmarksText(BookmarksAyah? bookmarksText) async {
    await DbBookmarkHelper.updateBookmarksText(bookmarksText!);
    await getBookmarksText();
  }

  RxBool hasBookmark(int surahNum, int ayahNum) {
    return (bookmarkTextList.firstWhereOrNull(((element) =>
                element.surahNumber == surahNum &&
                element.ayahUQNumber == ayahNum)) !=
            null)
        ? true.obs
        : false.obs;
  }

  Future<void> addBookmarkText(
    String surahName,
    int surahNum,
    int pageNum,
    int ayahNum,
    int ayahUQNum,
    String lastRead,
  ) async {
    try {
      int? bookmark = await DbBookmarkHelper.addBookmarkText(
        BookmarksAyahsCompanion(
          surahName: drift.Value(surahName),
          surahNumber: drift.Value(surahNum),
          pageNumber: drift.Value(pageNum),
          ayahNumber: drift.Value(ayahNum),
          ayahUQNumber: drift.Value(ayahUQNum),
          lastRead: drift.Value(lastRead),
        ),
      );
      getBookmarksText();
      QuranController.instance.update(['bookmarked']);
      print('bookmark number: $bookmark');
    } catch (e, stacktrace) {
      // طباعة تفاصيل الخطأ مع الاستثناء والمكدس الكامل
      print('Error adding bookmark: $e');
      print('Stacktrace: $stacktrace');
    }
  }
}
