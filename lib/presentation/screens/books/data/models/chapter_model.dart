class Chapter {
  final int chapterNumber;
  final String chapterName;

  Chapter({
    required this.chapterNumber,
    required this.chapterName,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['Chapter_number'] ?? 0,
      chapterName: json['Chapter_name'] ?? '',
    );
  }
}
