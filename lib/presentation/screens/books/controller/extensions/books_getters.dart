part of '../../books.dart';

extension BooksGetters on BooksController {
  List<int> get sixthBooksNumbers => [
    216,
    217,
    218,
    219,
    220,
    213,
    214,
    205,
    206,
    207,
    211,
    212,
    208,
    209,
    210,
  ];

  List<int> get ninthBooksNumbers => [80, 81, 82, 83, 254, 258, 259];

  PageController get pageController {
    return state.bookPageController = PageController(
      initialPage: state.currentPageNumber.value,
      keepPage: true,
    );
  }

  /// إنشاء PageController مع حد آمن لرقم الصفحة
  /// Create PageController with safe bounds for initial page
  PageController getSafePageController(int totalPages, {int? initialPage}) {
    final page = initialPage ?? state.currentPageNumber.value;
    final safePage = page.clamp(0, totalPages > 0 ? totalPages - 1 : 0);
    state.currentPageNumber.value = safePage;
    return state.bookPageController = PageController(
      initialPage: safePage,
      keepPage: true,
    );
  }

  // البحث عن كتاب بالرقم - Find book by number
  getBookByNumber(int bookNumber) {
    for (int i = 0; i < state.booksList.length; i++) {
      if (state.booksList[i].bookNumber == bookNumber) {
        return state.booksList[i];
      }
    }
    return null;
  }

  // الحصول على أسماء الأجزاء (غير مستخدم حاليًا) - Get volume names (currently unused)
  Future<List<String>> getParts(int bookNumber) async {
    try {
      List<Volume> volumes = await getVolumes(bookNumber);
      return volumes.map((v) => v.name).toList();
    } catch (e) {
      log('Error in getParts: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء الأبواب - Get chapter names
  Future<List<String>> getChapters(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getChapters: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء الفصول (مرادف للأبواب) - Get section names (synonym for chapters)
  Future<List<String>> getSections(int bookNumber) async {
    return await getChapters(bookNumber);
  }

  // الحصول على أسماء المواضيع (مرادف للأبواب) - Get topic names (synonym for chapters)
  Future<List<String>> getTopics(int bookNumber) async {
    return await getChapters(bookNumber);
  }

  // الحصول على أسماء المقالات (غير مستخدم حاليًا) - Get article names (currently unused)
  Future<List<String>> getArticles(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      // يمكن تخصيص هذه الدالة حسب الحاجة
      // This function can be customized as needed
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getArticles: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء الدروس (غير مستخدم حاليًا) - Get lesson names (currently unused)
  Future<List<String>> getLessons(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getLessons: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء الصفحات الفرعية (غير مستخدم حاليًا) - Get sub-page names (currently unused)
  Future<List<String>> getSubPages(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getSubPages: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء المواضيع الفرعية (غير مستخدم حاليًا) - Get sub-topic names (currently unused)
  Future<List<String>> getSubTopics(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getSubTopics: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء الباب الفرعي (غير مستخدم حاليًا) - Get sub-chapter names (currently unused)
  Future<List<String>> getSubChapters(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      // يمكن تخصيص هذه الدالة لعرض العناصر الفرعية فقط
      // This function can be customized to show sub-items only
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getSubChapters: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على أسماء الفقرات (غير مستخدم حاليًا) - Get paragraph names (currently unused)
  Future<List<String>> getOptions(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      return toc.map((item) => item.text).toList();
    } catch (e) {
      log('Error in getOptions: $e', name: 'BooksGetters');
      return [];
    }
  }

  // الحصول على رقم الصفحة لباب معين - Get page number for specific chapter
  Future<int> getChapterStartPage(int bookNumber, String chapterName) async {
    try {
      return await getTocItemStartPage(bookNumber, chapterName);
    } catch (e) {
      log('Error in getChapterStartPage: $e', name: 'BooksGetters');
      return 0;
    }
  }

  // الحصول على رقم الصفحة لموضوع معين - Get page number for specific topic
  Future<int> getTopicStartPage(int bookNumber, String topicName) async {
    try {
      return await getTocItemStartPage(bookNumber, topicName);
    } catch (e) {
      log('Error in getTopicStartPage: $e', name: 'BooksGetters');
      return 0;
    }
  }

  // الحصول على عدد الصفحات في الكتاب - Get total pages count in book
  Future<int> getBookPagesCount(int bookNumber) async {
    try {
      final pages = await getPages(bookNumber);
      return pages.length;
    } catch (e) {
      log('Error in getBookPagesCount: $e', name: 'BooksGetters');
      return 0;
    }
  }

  // الحصول على عدد الأجزاء في الكتاب - Get volumes count in book
  Future<int> getVolumesCount(int bookNumber) async {
    try {
      List<Volume> volumes = await getVolumes(bookNumber);
      return volumes.length;
    } catch (e) {
      log('Error in getVolumesCount: $e', name: 'BooksGetters');
      return 0;
    }
  }

  // الحصول على عدد الأبواب في الكتاب - Get chapters count in book
  Future<int> getChaptersCount(int bookNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);
      return toc.length;
    } catch (e) {
      log('Error in getChaptersCount: $e', name: 'BooksGetters');
      return 0;
    }
  }

  // الحصول على اسم الفصل عن طريق رقم الصفحة - Get chapter name by page number
  Future<String?> getChapterNameByPage(int bookNumber, int pageNumber) async {
    try {
      List<TocItem> toc = await getTocs(bookNumber);

      // ترتيب الفصول حسب رقم الصفحة - Sort chapters by page number
      toc.sort((a, b) => a.page.compareTo(b.page));

      String? chapterName;

      // البحث عن الفصل المناسب - Find appropriate chapter
      for (int i = 0; i < toc.length; i++) {
        TocItem currentItem = toc[i];

        // إذا كان رقم الصفحة أقل من أو يساوي رقم صفحة الفصل الحالي
        // If page number is less than or equal to current chapter page
        if (pageNumber <= currentItem.page) {
          chapterName = currentItem.text;
          break;
        }

        // إذا كان هذا آخر فصل وكان رقم الصفحة أكبر من رقم صفحة الفصل
        // If this is the last chapter and page number is greater than chapter page
        if (i == toc.length - 1 && pageNumber > currentItem.page) {
          chapterName = currentItem.text;
        }
      }

      // إذا لم نجد فصل مناسب ولكن هناك فصول، اختر الأول
      // If no appropriate chapter found but chapters exist, choose first
      if (chapterName == null && toc.isNotEmpty) {
        chapterName = toc.first.text;
      }

      log(
        'Chapter found for page $pageNumber: $chapterName',
        name: 'BooksGetters',
      );
      return chapterName;
    } catch (e) {
      log('Error in getChapterNameByPage: $e', name: 'BooksGetters');
      return null;
    }
  }

  // الحصول على اسم الفصل الحالي عن طريق رقم الصفحة (بدون Future) - Get current chapter name by page number (without Future)
  String? getCurrentChapterByPage(int bookNumber, int pageNumber) {
    try {
      // التحقق من وجود البيانات في الكاش - Check if data exists in cache
      List<TocItem>? cachedToc = state.tocCache[bookNumber];

      // إذا لم تكن البيانات محملة، حاول تحميلها بشكل متزامن - If data not loaded, try to load synchronously
      if (cachedToc == null || cachedToc.isEmpty) {
        // محاولة تحميل البيانات من المصادر المتاحة - Try to load data from available sources
        _loadTocSynchronously(bookNumber);
        cachedToc = state.tocCache[bookNumber];

        if (cachedToc == null || cachedToc.isEmpty) {
          log(
            'No TOC data available for book $bookNumber',
            name: 'BooksGetters',
          );
          return null;
        }
      }

      List<TocItem> toc = List.from(cachedToc);

      // ترتيب الفصول حسب رقم الصفحة - Sort chapters by page number
      toc.sort((a, b) => a.page.compareTo(b.page));

      String? chapterName;

      // البحث عن الفصل المناسب - Find appropriate chapter
      for (int i = 0; i < toc.length; i++) {
        TocItem currentItem = toc[i];

        // إذا كان رقم الصفحة الحالي أصغر من رقم صفحة الفصل التالي
        // If current page number is smaller than next chapter page
        if (i < toc.length - 1) {
          TocItem nextItem = toc[i + 1];
          if (pageNumber >= currentItem.page && pageNumber < nextItem.page) {
            chapterName = currentItem.text;
            break;
          }
        } else {
          // هذا آخر فصل - This is the last chapter
          if (pageNumber >= currentItem.page) {
            chapterName = currentItem.text;
            break;
          }
        }
      }

      // إذا لم نجد فصل مناسب، اختر الأول - If no appropriate chapter found, choose first
      if (chapterName == null && toc.isNotEmpty) {
        chapterName = toc.first.text;
      }

      log(
        'Chapter for book $bookNumber, page $pageNumber: $chapterName',
        name: 'BooksGetters',
      );
      return chapterName;
    } catch (e) {
      log('Error in getCurrentChapterByPage: $e', name: 'BooksGetters');
      return null;
    }
  }

  // دالة مساعدة لتحميل جدول المحتويات بشكل متزامن - Helper function to load TOC synchronously
  void _loadTocSynchronously(int bookNumber) {
    try {
      // هذه دالة بسيطة تحاول تحميل البيانات الأساسية - Simple function to try loading basic data
      // يمكن تحسينها لاحقاً لتحميل البيانات الفعلية - Can be improved later to load actual data
      log(
        'Attempting to load TOC for book $bookNumber synchronously',
        name: 'BooksGetters',
      );

      // يمكن إضافة منطق تحميل البيانات هنا إذا لزم الأمر
      // Can add data loading logic here if needed
    } catch (e) {
      log('Error loading TOC synchronously: $e', name: 'BooksGetters');
    }
  }

  Color get backgroundColor => state.backgroundPickerColor.value == 0xfffaf7f3
      ? Theme.of(Get.context!).colorScheme.surfaceContainer
      : ThemeController.instance.isDarkMode
      ? Theme.of(Get.context!).colorScheme.surfaceContainer
      : Color(state.backgroundPickerColor.value);
}
