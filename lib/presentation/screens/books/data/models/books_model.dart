part of '../../books.dart';

// نموذج مجموعة الكتب حسب النوع - Book collection grouped by type
// يمثل مجموعة كتب من نفس النوع (تفسير، أحاديث، إلخ)
class BookCollection {
  final String type; // نوع الكتب - Book type category
  final String bookUrlType; // نوع الكتب - Book type category
  final List<Book> books; // قائمة الكتب - List of books

  BookCollection({
    required this.type,
    required this.bookUrlType,
    required this.books,
  });

  factory BookCollection.fromJson(Map<String, dynamic> json) {
    return BookCollection(
      type: json['type'] ?? '',
      bookUrlType: json['urlType'] ?? '',
      books:
          (json['booksType'] as List?)
              ?.map((book) => Book.fromJson(book))
              .toList() ??
          [],
    );
  }
}

// نموذج الكتاب الرئيسي - Main book model
// يحتوي على جميع معلومات الكتاب والصفحات
class Book {
  final int bookNumber; // رقم الكتاب - Book number
  final String bookName; // اسم الكتاب - Book name
  final String bookFullName; // الاسم الكامل للكتاب - Full book name
  final String aboutBook; // نبذة عن الكتاب - About the book
  final String bookType;
  final String author;
  final bool hasChapters; // هل يحتوي على فصول - Has chapters
  final int partsCount; // عدد الأجزاء - Parts count
  final int chapterCount; // عدد الفصول - Chapter count
  final int pageTotal; // إجمالي الصفحات - Total pages
  final BookInfo? info; // معلومات الكتاب - Book info
  final List<PageContent> pages; // صفحات الكتاب - Book pages
  final List<Volume> volumes; // أجزاء الكتاب - Book volumes
  final List<TocItem> toc; // جدول المحتويات - Table of contents
  final int? authorDeathYear; // سنة وفاة المؤلف - Author death year

  Book({
    required this.bookNumber,
    required this.bookName,
    required this.bookFullName,
    required this.aboutBook,
    required this.bookType,
    required this.hasChapters,
    required this.partsCount,
    required this.chapterCount,
    required this.pageTotal,
    required this.author,
    this.info,
    this.pages = const [],
    this.volumes = const [],
    this.toc = const [],
    this.authorDeathYear,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // تحويل البيانات من ملف collections.json - Convert data from collections.json
    return Book(
      bookNumber: json['bookNumber'] ?? 0,
      bookName: json['bookName'] ?? '',
      bookFullName: json['bookFullName'] ?? '',
      aboutBook: json['aboutBook'] ?? '',
      bookType: json['bookType'] ?? '',
      author: json['author'] ?? '',
      hasChapters: json['hasChapters'] ?? false,
      partsCount: json['parts_count'] ?? 0,
      chapterCount: json['Chapter_count'] ?? 0,
      pageTotal: json['PageTotal'] ?? json['PageTotle'] ?? 0,
      authorDeathYear: _extractDeathYear(json['aboutBook'] ?? ''),
    );
  }

  /// استخراج سنة وفاة المؤلف من نص عن الكتاب
  /// Extract author death year from about book text
  /// الأنماط المدعومة:
  /// 1. (ت ٥١٠هـ) — النمط الرئيسي
  /// 2. (٢٢٤ - ٣١٠هـ) — سنة الميلاد والوفاة معاً
  /// 3. (٥١٠هـ) — بدون ت
  /// ملاحظة: \d لا يطابق الأرقام العربية (٠-٩)، لذا نستخدم [\u0660-\u0669]
  static int? _extractDeathYear(String aboutText) {
    // نمط الأرقام العربية - Arabic-Indic digits pattern
    const arabicDigitPattern = '[\u0660-\u0669]';
    final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    int? convertArabicYear(String yearStr) {
      for (int i = 0; i < arabicDigits.length; i++) {
        yearStr = yearStr.replaceAll(arabicDigits[i], '$i');
      }
      return int.tryParse(yearStr);
    }

    // 1. النمط: (xxx - yyy هـ) — نأخذ yyy (سنة الوفاة)
    final rangeRegex = RegExp(
      '[(（]\\s*($arabicDigitPattern{3,4})\\s*[-–—]\\s*($arabicDigitPattern{3,4})\\s*ه\\u0640',
    );
    final rangeMatch = rangeRegex.firstMatch(aboutText);
    if (rangeMatch != null) {
      return convertArabicYear(rangeMatch.group(2)!);
    }

    // 2. النمط: ت xxx هـ — أول تطابق أقل من 1500
    final tRegex = RegExp(
      'ت\\s*($arabicDigitPattern{3,4})\\s*ه\\u0640',
    );
    for (final match in tRegex.allMatches(aboutText)) {
      final year = convertArabicYear(match.group(1)!);
      if (year != null && year < 1500) return year;
    }

    // 3. النمط: (xxxهـ) بدون ت — نأخذ أول تطابق أقل من 1500
    final deathRegex = RegExp(
      '[(（]\\s*($arabicDigitPattern{3,4})\\s*ه\\u0640',
    );
    for (final match in deathRegex.allMatches(aboutText)) {
      final year = convertArabicYear(match.group(1)!);
      if (year != null && year < 1500) return year;
    }

    return null;
  }

  factory Book.fromDownloadedJson(Map<String, dynamic> json, int bookNumber) {
    // تحويل البيانات من الملف المحمل - Convert data from downloaded file
    List<PageContent> pages = [];
    List<Volume> volumes = [];
    List<TocItem> toc = [];
    BookInfo? info;

    if (json.containsKey('info')) {
      info = BookInfo.fromJson(json['info']);
    }

    if (json.containsKey('pages')) {
      pages = (json['pages'] as List)
          .map(
            (page) => PageContent.fromJson(page, info?.title ?? '', bookNumber),
          )
          .toList();
    }

    if (json.containsKey('info') && json['info'].containsKey('volumes')) {
      Map<String, dynamic> volumesData = json['info']['volumes'];
      volumes = volumesData.entries
          .map(
            (entry) => Volume.fromJson(entry.key, List<int>.from(entry.value)),
          )
          .toList();
    }

    if (json.containsKey('info') && json['info'].containsKey('toc')) {
      toc = (json['info']['toc'] as List)
          .map((item) => TocItem.fromJson(item))
          .toList();
    }

    return Book(
      bookNumber: bookNumber,
      bookName: info?.title ?? '',
      bookFullName: info?.title ?? '',
      aboutBook: info?.about ?? '',
      bookType: info?.bookType ?? '',
      author: info?.author ?? '',
      hasChapters: true,
      partsCount: volumes.length,
      chapterCount:
          0, // سيتم حسابه من جدول المحتويات - Will be calculated from TOC
      pageTotal: info?.allPages ?? pages.length,
      info: info,
      pages: pages,
      volumes: volumes,
      toc: toc,
    );
  }

  // إنشاء مثيل فارغ - Create empty instance
  factory Book.empty() {
    return Book(
      bookNumber: 0,
      bookName: '',
      bookFullName: '',
      aboutBook: '',
      bookType: '',
      author: '',
      hasChapters: false,
      partsCount: 0,
      chapterCount: 0,
      pageTotal: 0,
      authorDeathYear: null,
    );
  }

  // العثور على الجزء الذي يحتوي على صفحة معينة - Find volume containing specific page
  Volume? getVolumeForPage(int pageNumber) {
    try {
      return volumes.firstWhere((volume) => volume.containsPage(pageNumber));
    } catch (e) {
      return null;
    }
  }

  // الحصول على قائمة بأسماء الأجزاء - Get list of volume names
  List<String> get volumeNames => volumes.map((v) => v.name).toList();
}
