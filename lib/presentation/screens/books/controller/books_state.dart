part of '../books.dart';

/// أنواع ترتيب الكتب - Book sort types
enum BookSortType {
  deathYear, // حسب سنة وفاة المؤلف
  nameAlpha, // أبجدي حسب اسم الكتاب
  authorAlpha, // أبجدي حسب اسم المؤلف
  defaultOrder, // الترتيب الافتراضي
}

extension BookSortTypeExtension on BookSortType {
  String get label {
    switch (this) {
      case BookSortType.deathYear:
        return 'sortDeathYear';
      case BookSortType.nameAlpha:
        return 'sortNameAlpha';
      case BookSortType.authorAlpha:
        return 'sortAuthorAlpha';
      case BookSortType.defaultOrder:
        return 'sortDefault';
    }
  }

  IconData get icon {
    switch (this) {
      case BookSortType.deathYear:
        return Icons.history_edu_outlined;
      case BookSortType.nameAlpha:
        return Icons.sort_by_alpha_outlined;
      case BookSortType.authorAlpha:
        return Icons.person_outline;
      case BookSortType.defaultOrder:
        return Icons.list_outlined;
    }
  }
}

class BooksState {
  /// -------- [Variables] ----------
  final box = GetStorage();
  var booksList = <Book>[].obs;
  var booksInfo = <BookCollection>[].obs;
  var bookTypes = <String>[].obs;
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
  final RxMap<int, List<TocItem>> tocCache = <int, List<TocItem>>{}.obs;
  // كاش لحفظ الأجزاء - Cache for volumes
  final Map<int, List<Volume>> volumesCache = {};
  // كاش مسبق لربط الأجزاء بالفصول - Pre-computed volume→chapters mapping
  final Map<int, Map<int, List<TocItem>>> volumeChaptersCache = {};
  RxBool isSearch = false.obs;
  RxString searchQuery = ''.obs; // نص البحث - Search query text
  Rx<BookSortType> sortType = BookSortType.deathYear.obs; // ترتيب الكتب
  RxBool sortAscending = true.obs; // ترتيب تصاعدي
  late Directory dir;
  final Completer<void> dirInitialized = Completer<void>();

  // ===== Pagination للكتب =====
  final Map<String, int> booksPaginationCounts = {};
  final Map<String, bool> booksIsLoadingMore = {};
  final Map<String, ScrollController> booksScrollControllers = {};
  static const int booksItemsPerPage = 20;
  final tabBarController = FlexibleSheetController();
  final navBarController = FlexibleSheetController();

  // بحث موضوعي - Subject search
  var subjectSearchResults = <SubjectSearchResult>[].obs;
  final ExpansionTileManager searchTileManager = ExpansionTileManager();
  static const int searchResultsPerSection = 4;
  Map<String, RxInt> sectionVisibleCount = {};

  // بحث نصي تدريجي - Progressive text search
  var isTextSearching = false.obs;
  var searchedBookTypes = <String>{}.obs;
  String? activeSearchQuery;

  // كاش صفحات الكتب في الذاكرة - In-memory book pages cache
  final Map<int, List<Map<String, dynamic>>> _pagesCache = {};
  final expansionManager = ExpansionTileManager();
}
