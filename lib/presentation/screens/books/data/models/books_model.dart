part of '../../books.dart';

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
      pageTotal: json['PageTotle'] ?? 0,
    );
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
          .map((page) => PageContent.fromJson(
                page,
                info?.title ?? '',
                bookNumber,
              ))
          .toList();
    }

    if (json.containsKey('info') && json['info'].containsKey('volumes')) {
      Map<String, dynamic> volumesData = json['info']['volumes'];
      volumes = volumesData.entries
          .map((entry) =>
              Volume.fromJson(entry.key, List<int>.from(entry.value)))
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
    );
  }

  // العثور على الجزء الذي يحتوي على صفحة معينة - Find volume containing specific page
  Volume? getVolumeForPage(int pageNumber) {
    try {
      return volumes.firstWhere(
        (volume) => volume.containsPage(pageNumber),
      );
    } catch (e) {
      return null;
    }
  }

  // الحصول على قائمة بأسماء الأجزاء - Get list of volume names
  List<String> get volumeNames => volumes.map((v) => v.name).toList();
}
