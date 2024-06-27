class PageContent {
  final String title;
  final int pageNumber;
  final String content;
  final List<dynamic> footnotes;
  final String bookTitle;
  final int bookNumber; // Add this line

  PageContent({
    required this.title,
    required this.pageNumber,
    required this.content,
    required this.footnotes,
    required this.bookTitle,
    required this.bookNumber, // Add this line
  });

  factory PageContent.fromJson(Map<String, dynamic> json, String bookTitle) {
    return PageContent(
      title: json['title'] ?? '',
      pageNumber: json['pageNumber'] ??
          int.tryParse(json['page']?.toString() ?? '0') ??
          0,
      content: json['content'] ?? '',
      footnotes: json['footnotes'] ?? [],
      bookTitle: bookTitle,
      bookNumber: json['bookNumber'] ??
          0, // Ensure this line matches how bookNumber is stored
    );
  }

  // Factory method for an empty PageContent instance
  factory PageContent.empty() {
    return PageContent(
      title: '',
      pageNumber: 0,
      content: '',
      footnotes: [],
      bookTitle: '',
      bookNumber: 0, // Add this line
    );
  }
}
