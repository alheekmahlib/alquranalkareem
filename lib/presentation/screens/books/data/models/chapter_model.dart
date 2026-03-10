part of '../../books.dart';

class Chapter {
  final int chapterNumber;
  final String chapterName;
  final int pageTotal;

  Chapter({
    required this.chapterNumber,
    required this.chapterName,
    required this.pageTotal,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['Chapter_number'] ?? 0,
      chapterName: json['Chapter_name'] ?? '',
      pageTotal: json['PageTotle'] ?? 0,
    );
  }
}
