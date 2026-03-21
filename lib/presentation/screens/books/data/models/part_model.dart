part of '../../books.dart';

class Part {
  final String partNumber;
  final List<Chapter> chapters;

  Part({
    required this.partNumber,
    required this.chapters,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    var chaptersList = (json['Chapter_names'] as List<dynamic>)
        .map((chapter) => Chapter.fromJson(chapter))
        .toList();
    return Part(
      partNumber: json['parts_number'] ?? '',
      chapters: chaptersList,
    );
  }
}
