class Chapter {
  final int chapterNumber;
  final String chapterName;
  final int PageTotal;

  Chapter({
    required this.chapterNumber,
    required this.chapterName,
    required this.PageTotal,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['Chapter_number'] ?? 0,
      chapterName: json['Chapter_name'] ?? '',
      PageTotal: json['PageTotle'] ?? 0,
    );
  }
}
