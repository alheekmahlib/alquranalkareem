class PageContent {
  final String title;
  final int pageNumber;
  final String content;
  final List<dynamic> footnotes;
  final String bookTitle;

  PageContent({
    required this.title,
    required this.pageNumber,
    required this.content,
    required this.footnotes,
    required this.bookTitle,
  });

  factory PageContent.fromJson(Map<String, dynamic> json, String bookTitle) {
    return PageContent(
      title: json['title'] ?? '',
      pageNumber: json['pageNumber'] ??
          int.tryParse(json['page']?.toString() ?? '0') ??
          0,
      content: json['content'] ?? '',
      footnotes: json['footnotes'] ?? [],
      bookTitle: bookTitle, // تعيين اسم الكتاب
    );
  }

  // دالة لإرجاع كائن فارغ من PageContent
  factory PageContent.empty() {
    return PageContent(
      title: '',
      pageNumber: 0,
      content: '',
      footnotes: [],
      bookTitle: '',
    );
  }
}
