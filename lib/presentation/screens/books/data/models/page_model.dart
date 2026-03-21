part of '../../books.dart';

// نموذج محتوى الصفحة - Page content model
// يحتوي على بيانات الصفحة الواحدة
class PageContent {
  final int pageNumber; // رقم الصفحة - Page number
  final int page; // رقم الصفحة الفعلي - Actual page number
  final String text; // نص الصفحة - Page text
  final String bookTitle; // عنوان الكتاب - Book title
  final int bookNumber; // رقم الكتاب - Book number

  PageContent({
    required this.pageNumber,
    required this.page,
    required this.text,
    required this.bookTitle,
    required this.bookNumber,
  });

  factory PageContent.fromJson(
      Map<String, dynamic> json, String bookTitle, int bookNumber) {
    return PageContent(
      pageNumber: json['page_number'] ?? 0,
      page: json['page'] ?? 0,
      text: json['text'] ?? '',
      bookTitle: bookTitle,
      bookNumber: bookNumber,
    );
  }

  // إنشاء مثيل فارغ - Factory method for an empty PageContent instance
  factory PageContent.empty() {
    return PageContent(
      pageNumber: 0,
      page: 0,
      text: '',
      bookTitle: '',
      bookNumber: 0,
    );
  }
}
