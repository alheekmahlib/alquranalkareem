part of '../../books.dart';

// نموذج معلومات الكتاب - Book info model
// نماذج البيانات للكتب والصفحات
class BookInfo {
  final String title; // عنوان الكتاب - Book title
  final String author; // المؤلف - Author
  final String bookType; // نوع الكتاب - Book type
  final String about; // نبذة عن الكتاب - About the book
  final String url; // رابط الكتاب - Book URL
  final String id; // معرف الكتاب - Book ID
  final List<dynamic> toc; // جدول المحتويات - Table of contents
  final Map<String, dynamic> pageChapters; // فصول الصفحات - Page chapters
  final int allPages; // إجمالي الصفحات - Total pages
  final Map<String, List<int>> volumes; // أجزاء الكتاب - Book volumes
  final int pages; // عدد الصفحات - Pages count

  BookInfo({
    required this.title,
    required this.author,
    required this.bookType,
    required this.about,
    required this.url,
    required this.id,
    required this.toc,
    required this.pageChapters,
    required this.allPages,
    required this.volumes,
    required this.pages,
  });

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      bookType: json['bookType'] ?? '',
      about: json['about'] ?? '',
      url: json['url'] ?? '',
      id: json['id'] ?? '',
      toc: json['toc'] ?? [],
      pageChapters: json['page_chapters'] ?? {},
      allPages: json['all_pages'] ?? 0,
      volumes: Map<String, List<int>>.from(
        (json['volumes'] ?? {}).map(
          (key, value) => MapEntry(key, List<int>.from(value)),
        ),
      ),
      pages: json['pages'] ?? 0,
    );
  }

  // إنشاء مثيل فارغ - Create empty instance
  factory BookInfo.empty() {
    return BookInfo(
      title: '',
      author: '',
      bookType: '',
      about: '',
      url: '',
      id: '',
      toc: [],
      pageChapters: {},
      allPages: 0,
      volumes: {},
      pages: 0,
    );
  }
}
