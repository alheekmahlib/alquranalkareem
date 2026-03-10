part of '../../books.dart';

/// Extension للتنقل وعمليات الواجهة
/// Navigation and UI operations extension
extension BooksUi on BooksController {
  // ============ Navigation ============

  Future<void> moveToBookPage(int chapterPage, int bookNumber) async {
    if (!isBookDownloaded(bookNumber)) {
      return Get.context!.showCustomErrorSnackBar('downloadBookFirst'.tr);
    }

    state.currentPageNumber.value = chapterPage;
    Get.to(
      () => ReadViewScreen(bookNumber: bookNumber),
      transition: Transition.fade,
    );
  }

  Future<void> moveToPage(
    String chapterName,
    int bookNumber, {
    int? pageNumber,
  }) async {
    final page =
        pageNumber ?? await getTocItemStartPage(bookNumber, chapterName);
    state.currentPageNumber.value = page;
    state.bookPageController.jumpToPage(page - 1);

    // تمرير رقم الصفحة دائماً لضمان تحديث اسم الفصل بشكل صحيح
    // Always pass page number to ensure chapter name is updated correctly
    await ChaptersController.instance.loadChapters(
      chapterName,
      bookNumber,
      pageNumber: page,
      loadChapters: false, // الفصول محملة مسبقاً
    );
  }

  Future<void> moveToBookPageByNumber(
    int pageNumber,
    int bookNumber, {
    String chapterName = '',
  }) async {
    if (!isBookDownloaded(bookNumber)) {
      return Get.context!.showCustomErrorSnackBar('downloadBookFirst'.tr);
    }

    state.currentPageNumber.value = pageNumber;
    await ChaptersController.instance.loadChapters(
      chapterName,
      bookNumber,
      pageNumber: pageNumber,
      loadChapters: true,
    );
    Get.to(
      () => ReadViewScreen(bookNumber: bookNumber),
      transition: Transition.fade,
    );
  }

  Future<void> moveToPageByNumber(int pageNumber, int bookNumber) async {
    if (!isBookDownloaded(bookNumber)) {
      return Get.context!.showCustomErrorSnackBar('downloadBookFirst'.tr);
    }

    state.currentPageNumber.value = pageNumber;
    state.bookPageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // ============ Settings ============

  void isTashkilOnTap() {
    state.isTashkil.toggle();
    state.box.write(IS_TASHKIL, state.isTashkil.value);
  }

  // ============ Book Management ============

  Future<void> deleteBook(int bookNumber) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');

      if (!await file.exists()) return;

      await file.delete();
      state.downloaded[bookNumber] = false;
      saveDownloadedBooks();

      // Clear last read data
      state.box.remove('lastRead_$bookNumber');
      state.lastReadPage.remove(bookNumber);
      state.bookTotalPages.remove(bookNumber);

      update(['downloadedBooks']);
      Get.context!.showCustomErrorSnackBar('booksDeleted'.tr);
      log('Book $bookNumber deleted successfully', name: 'BooksUi');
    } catch (e) {
      log('Error deleting book: $e', name: 'BooksUi');
    }
  }

  // ============ Keyboard Control ============

  KeyEventResult controlRLByKeyboard(FocusNode node, KeyEvent event) {
    final controller = state.bookPageController;
    const duration = Duration(milliseconds: 600);
    const curve = Curves.easeInOut;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      controller.nextPage(duration: duration, curve: curve);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      controller.previousPage(duration: duration, curve: curve);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // ============ UI Control ============

  Future<void> showControl() async {
    if (QuranController.instance.state.tabBarController.isHandleVisible &&
        QuranController.instance.state.navBarController.isHandleVisible) {
      QuranController.instance.state.tabBarController.hideHandle();
      QuranController.instance.state.navBarController.hideHandle();
    } else {
      QuranController.instance.state.tabBarController.showHandle();
      QuranController.instance.state.navBarController.showHandle();
    }
  }
  // ============ Book Filtering ============

  List<Book> getCustomBookNumber(List<Book> allBooks, List<int> bookType) {
    return bookType
        .map(
          (number) => allBooks.firstWhereOrNull((b) => b.bookNumber == number),
        )
        .whereType<Book>()
        .toList();
  }
}
