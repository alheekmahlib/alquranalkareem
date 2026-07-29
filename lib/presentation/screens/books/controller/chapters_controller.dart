import 'dart:developer' show log;

import 'package:flutter/widgets.dart' show ScrollController, WidgetsBinding;
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '../books.dart';

/// متحكم الفصول مع إدارة السكرول المحسّنة
/// Chapters controller with optimized scroll management
class ChaptersController extends GetxController {
  static ChaptersController get instance =>
      GetInstance().putOrFind(() => ChaptersController());

  // ============ Dependencies ============
  final _booksCtrl = BooksController.instance;

  // ============ State ============
  List<TocItem> chapters = [];
  List<Volume> volumes = [];
  bool isLoading = false;
  ScrollController itemsScrollController = ScrollController();
  TocItem? currentChapterItem;
  String? currentChapterName;

  // ============ Constants ============
  static const double _itemHeight = 40.0;
  static const int _itemsPerPage = 50;

  // ============ Pagination State ============
  final Map<int, int> _paginationCounts = {};
  final Map<int, bool> _isLoadingMore = {};
  final Map<int, ScrollController> _paginationScrollControllers = {};

  // ============ Scroll Position ============

  double _calculateScrollOffset(int index) {
    if (index < 0) return 0.0;

    final baseOffset = index * _itemHeight;

    if (itemsScrollController.hasClients) {
      final maxOffset = itemsScrollController.position.maxScrollExtent;
      return maxOffset > 0 ? baseOffset.clamp(0.0, maxOffset) : baseOffset;
    }

    final maxFallback = (chapters.length * _itemHeight) - _itemHeight;
    return baseOffset.clamp(0.0, maxFallback);
  }

  int _findCurrentChapterIndex() {
    if (currentChapterName == null) return -1;
    return chapters.indexWhere(
      (c) => currentChapterName!.split(',').contains(c.text),
    );
  }

  // ============ Page Change Handling ============

  void onPageChanged(int pageIndex) {
    if (chapters.isEmpty) {
      log('No chapters available', name: 'ChaptersController');
      return;
    }

    final pageNum = pageIndex + 1;
    final newChapterName = _findChapterForPage(pageNum);

    if (currentChapterName != newChapterName) {
      currentChapterName = newChapterName;
      _updateCurrentChapterItem();
    }

    update(['ChapterName']);
    log('Chapter changed to: $currentChapterName', name: 'ChaptersController');
  }

  String _findChapterForPage(int pageNum) {
    final matchingChapters = chapters.where((c) => c.page <= pageNum).toList();

    if (matchingChapters.isEmpty) {
      return chapters.isNotEmpty ? chapters.first.text : '';
    }

    final filtered = matchingChapters.splitBetween(
      (f, s) => pageNum - f.page < pageNum - s.page && f.page != s.page,
    );

    if (filtered.isEmpty) return matchingChapters.last.text;

    final result =
        filtered.first.where((c) => c.page == filtered.first.last.page);
    return result.map((c) => c.text).join(',');
  }

  void _updateCurrentChapterItem() {
    final index = _findCurrentChapterIndex();
    if (index >= 0) {
      currentChapterItem = chapters[index];
      _scrollToIndex(index);
    }
  }

  void _scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (itemsScrollController.hasClients) {
        itemsScrollController.jumpTo(_calculateScrollOffset(index));
      }
    });
  }

  // ============ Scroll Methods ============

  void scrollToChapter(String chapterName) {
    final index = chapters.indexWhere((c) => c.text == chapterName);
    if (index >= 0) _scrollToIndex(index);
  }

  void scrollToCurrentChapterWithDelay() {
    final firstChapter = currentChapterName?.split(',').firstOrNull;
    if (firstChapter != null) scrollToChapter(firstChapter);
  }

  void scrollToCurrentChapterOnOpen() {
    if (chapters.isEmpty || currentChapterName == null) return;

    final index = _findCurrentChapterIndex();
    if (index < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (itemsScrollController.hasClients) {
          itemsScrollController.jumpTo(_calculateScrollOffset(index));
          log('Dropdown scrolled to index: $index', name: 'ChaptersController');
        }
      });
    });
  }

  void resetScrollController() {
    _safeDisposeController(itemsScrollController);
    itemsScrollController = ScrollController();
    log('ScrollController reset', name: 'ChaptersController');
  }

  // ============ Chapter Loading ============

  Future<void> loadChapters(
    String selectedChapterName,
    int bookNumber, {
    bool loadChapters = true,
    int? pageNumber,
  }) async {
    try {
      isLoading = true;

      if (loadChapters) {
        final tocData = await _booksCtrl.getTocs(bookNumber);
        chapters = tocData.where((item) => item.text.isNotEmpty).toList();
      }

      // تحديد اسم الفصل
      // Determine chapter name
      if (selectedChapterName.isNotEmpty && chapters.isNotEmpty) {
        // إذا كان اسم الفصل مُمرر، تحقق من وجوده واستخدمه مباشرة
        // If chapter name is passed, verify it exists and use it directly
        final exists = chapters.any((c) => c.text == selectedChapterName);
        if (!exists) {
          // إذا لم يوجد بالضبط، ابحث عن أقرب فصل
          selectedChapterName =
              pageNumber != null ? _findChapterNameForPage(pageNumber) : '';
        }
        // إذا وُجد، استخدمه كما هو (لا تغيره)
      } else if (pageNumber != null && chapters.isNotEmpty) {
        // إذا لم يكن هناك اسم فصل، ابحث برقم الصفحة
        // If no chapter name, search by page number
        selectedChapterName = _findChapterNameForPage(pageNumber);
      }

      currentChapterName = selectedChapterName;
      _initializeScrollPosition();
    } catch (e) {
      log('Error loading chapters: $e', name: 'ChaptersController');
    } finally {
      isLoading = false;
      update(['ChapterName']);
    }
  }

  /// البحث عن اسم الفصل المناسب لرقم الصفحة
  /// Find appropriate chapter name for page number
  String _findChapterNameForPage(int pageNumber) {
    if (chapters.isEmpty) return '';

    // ترتيب الفصول حسب رقم الصفحة
    final sortedChapters = List<TocItem>.from(chapters)
      ..sort((a, b) => a.page.compareTo(b.page));

    // البحث عن الفصل الذي تقع فيه الصفحة
    for (int i = sortedChapters.length - 1; i >= 0; i--) {
      if (sortedChapters[i].page <= pageNumber) {
        return sortedChapters[i].text;
      }
    }

    return sortedChapters.first.text;
  }

  void _initializeScrollPosition() {
    final index = chapters.indexWhere((c) => c.text == currentChapterName);

    if (index >= 0) currentChapterItem = chapters[index];

    final offset = index >= 0 ? (index * _itemHeight) : 0.0;

    if (!itemsScrollController.hasClients) {
      itemsScrollController = ScrollController(initialScrollOffset: offset);
    } else {
      _scrollToIndex(index);
    }

    log('Chapters: ${chapters.length}, current index: $index',
        name: 'ChaptersController');
  }

  // ============ Pagination ============

  void initPagination(int totalItems, int bookNumber) {
    if (_paginationCounts.containsKey(bookNumber)) return;

    _paginationCounts[bookNumber] = _itemsPerPage.clamp(0, totalItems);
    _isLoadingMore[bookNumber] = false;

    final controller = ScrollController()
      ..addListener(() => _onPaginationScroll(bookNumber, totalItems));
    _paginationScrollControllers[bookNumber] = controller;
  }

  ScrollController getPaginationScrollController(int bookNumber) =>
      _paginationScrollControllers[bookNumber] ?? ScrollController();

  int getPaginationCount(int bookNumber) =>
      _paginationCounts[bookNumber] ?? _itemsPerPage;

  void _onPaginationScroll(int bookNumber, int totalItems) {
    if (_isLoadingMore[bookNumber] == true) return;

    final controller = _paginationScrollControllers[bookNumber];
    if (controller == null || !controller.hasClients) return;

    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      _loadMoreChapters(bookNumber, totalItems);
    }
  }

  void _loadMoreChapters(int bookNumber, int totalItems) {
    if (_isLoadingMore[bookNumber] == true) return;

    final currentCount = _paginationCounts[bookNumber] ?? _itemsPerPage;
    if (currentCount >= totalItems) return;

    _isLoadingMore[bookNumber] = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      _paginationCounts[bookNumber] =
          (currentCount + _itemsPerPage).clamp(0, totalItems);
      _isLoadingMore[bookNumber] = false;
      update(['paginatedChapters_$bookNumber']);
    });
  }

  void resetPagination(int bookNumber) {
    _paginationCounts.remove(bookNumber);
    _isLoadingMore.remove(bookNumber);
    _safeDisposeController(_paginationScrollControllers[bookNumber]);
    _paginationScrollControllers.remove(bookNumber);
  }

  // ============ Cleanup ============

  void _safeDisposeController(ScrollController? controller) {
    try {
      controller?.dispose();
    } catch (e) {
      log('Error disposing controller: $e', name: 'ChaptersController');
    }
  }

  @override
  void onClose() {
    _safeDisposeController(itemsScrollController);

    for (final controller in _paginationScrollControllers.values) {
      _safeDisposeController(controller);
    }

    _paginationCounts.clear();
    _isLoadingMore.clear();
    _paginationScrollControllers.clear();
    super.onClose();
  }
}
