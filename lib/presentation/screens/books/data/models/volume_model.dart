part of '../../books.dart';

// نموذج الجزء - Volume model
// يمثل جزء من أجزاء الكتاب مع نطاق الصفحات
class Volume {
  final String name; // اسم الجزء - Volume name
  final int startPage; // الصفحة الأولى - Start page
  final int endPage; // الصفحة الأخيرة - End page

  Volume({
    required this.name,
    required this.startPage,
    required this.endPage,
  });

  factory Volume.fromJson(String name, List<int> pageRange) {
    return Volume(
      name: name,
      startPage: pageRange.isNotEmpty ? pageRange[0] : 0,
      endPage: pageRange.length > 1 ? pageRange[1] : 0,
    );
  }

  // إنشاء مثيل فارغ - Create empty instance
  factory Volume.empty() {
    return Volume(
      name: '',
      startPage: 0,
      endPage: 0,
    );
  }

  // التحقق من وجود صفحة في هذا الجزء - Check if page is in this volume
  bool containsPage(int pageNumber) {
    return pageNumber >= startPage && pageNumber <= endPage;
  }

  // عدد الصفحات في هذا الجزء - Number of pages in this volume
  int get pageCount => endPage - startPage + 1;
}
