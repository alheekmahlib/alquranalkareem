part of '../../books.dart';

/// Extension لإدارة التخزين المحلي للكتب
/// Books local storage management extension
extension BooksStorageGetters on BooksController {
  // ============ Last Read Management ============

  void saveLastRead(
      int pageNumber, String bookName, int bookNumber, int totalPages) {
    state.lastReadPage[bookNumber] = pageNumber;
    state.bookTotalPages[bookNumber] = totalPages;
    state.box.write('lastRead_$bookNumber', {
      'pageNumber': pageNumber,
      'bookName': bookName,
      'totalPages': totalPages,
    });
  }

  void removeFromLastRead(int bookNumber) {
    state.lastReadPage.remove(bookNumber);
    state.bookTotalPages.remove(bookNumber);
    state.box.remove('lastRead_$bookNumber');
    log('Book $bookNumber removed from last read', name: 'BooksStorageGetters');
  }

  void loadLastRead() {
    for (var book in state.booksList) {
      final lastRead = state.box.read('lastRead_${book.bookNumber}');
      if (lastRead != null) {
        state.lastReadPage[book.bookNumber] = lastRead['pageNumber'];
        state.bookTotalPages[book.bookNumber] = lastRead['totalPages'];
      }
    }
  }

  // ============ Settings ============

  void loadFromGetStorage() {
    state.isTashkil.value = state.box.read(IS_TASHKIL) ?? true;
  }

  // ============ Downloaded Books ============

  void saveDownloadedBooks() {
    final downloadedBooks = state.downloaded.entries
        .where((e) => e.value)
        .map((e) => e.key.toString())
        .toList();
    state.box.write(DOWNLOADED_BOOKS, downloadedBooks);
    log('Saved downloaded books: $downloadedBooks',
        name: 'BooksStorageGetters');
  }

  Future<void> loadDownloadedBooks() async {
    try {
      final downloadedBooks = state.box.read<List>(DOWNLOADED_BOOKS);
      if (downloadedBooks == null) return;

      for (var bookNumber in downloadedBooks) {
        if (bookNumber is String) {
          state.downloaded[int.parse(bookNumber)] = true;
        }
      }
      log('Loaded ${downloadedBooks.length} downloaded books',
          name: 'BooksStorageGetters');
    } catch (e) {
      log('Error loading downloaded books: $e', name: 'BooksStorageGetters');
    }
  }
}
