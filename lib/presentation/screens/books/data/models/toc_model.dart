part of '../../books.dart';

// نموذج عنصر جدول المحتويات - Table of contents item model
// يمثل عنصر واحد في جدول المحتويات
class TocItem {
  final int page; // رقم الصفحة - Page number
  final String text; // نص العنصر - Item text
  final List<TocItem> children; // العناصر الفرعية - Child items

  TocItem({
    required this.page,
    required this.text,
    this.children = const [],
  });

  factory TocItem.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // عنصر مع نص وصفحة - Item with text and page
      return TocItem(
        page: json['page'] ?? 0,
        text: json['text'] ?? '',
        children: [],
      );
    } else if (json is List) {
      // قائمة من العناصر - List of items
      List<TocItem> items = [];
      for (var item in json) {
        if (item is Map<String, dynamic>) {
          items.add(TocItem.fromJson(item));
        } else if (item is List) {
          items.addAll(
              item.map((subItem) => TocItem.fromJson(subItem)).toList());
        }
      }
      return TocItem(
        page: 0,
        text: '',
        children: items,
      );
    }

    return TocItem(page: 0, text: '');
  }

  // إنشاء مثيل فارغ - Create empty instance
  factory TocItem.empty() {
    return TocItem(
      page: 0,
      text: '',
      children: [],
    );
  }
}
