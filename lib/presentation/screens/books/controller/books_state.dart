part of '../books.dart';

class BooksState {
  /// -------- [Variables] ----------
  final box = GetStorage();
  var booksList = <Book>[].obs;
  var isLoading = true.obs;
  var downloading = <int, bool>{}.obs;
  var downloaded = <int, bool>{}.obs;
  var downloadProgress = <int, double>{}.obs;
  var searchResults = <PageContent>[].obs;
  RxBool isDownloaded = false.obs;
  final TextEditingController searchController = TextEditingController();
  PageController bookPageController = PageController();
  final FocusNode bookRLFocusNode = FocusNode();
  // final FocusNode bookUDFocusNode = FocusNode();
  // final ScrollController ScrollUpDownBook = ScrollController();
  RxInt currentPageNumber = 0.obs;
  var lastReadPage = <int, int>{}.obs;
  Map<int, int> bookTotalPages = {};
  RxBool isTashkil = true.obs;
  var collapsedHeightMap = <int, RxBool>{}.obs;
  RxInt backgroundPickerColor = 0xfffaf7f3.obs;
  RxInt temporaryBackgroundColor = 0xfffaf7f3.obs;

  // كاش لحفظ جدول المحتويات - Cache for table of contents
  Map<int, List<TocItem>> tocCache = {};
  RxBool isSearch = false.obs;
  RxString searchQuery = ''.obs; // نص البحث - Search query text
  late Directory dir;
  final Completer<void> dirInitialized = Completer<void>();

  // ===== Pagination للكتب =====
  final Map<String, int> booksPaginationCounts = {};
  final Map<String, bool> booksIsLoadingMore = {};
  final Map<String, ScrollController> booksScrollControllers = {};
  static const int booksItemsPerPage = 20;
}
