class PageContent {
  final String title;
  final int pageNumber;
  final String content;
  final List<dynamic> footnotes;

  PageContent({
    required this.title,
    required this.pageNumber,
    required this.content,
    required this.footnotes,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      title: json['title'] ?? '',
      pageNumber: json['pageNumber'] ?? 0,
      content: json['content'] ?? '',
      footnotes: json['footnotes'] ?? [],
    );
  }
}
