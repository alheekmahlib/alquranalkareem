import 'part_model.dart';

class Book {
  final int bookNumber;
  final String bookName;
  final bool hasChapters;
  final int partsCount;
  final int chapterCount;
  final List<Part> parts;

  Book({
    required this.bookNumber,
    required this.bookName,
    required this.hasChapters,
    required this.partsCount,
    required this.chapterCount,
    required this.parts,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var list = json['parts'] as List;
    List<Part> partsList = list.map((i) => Part.fromJson(i)).toList();

    return Book(
      bookNumber: json['bookNumber'],
      bookName: json['bookName'],
      hasChapters: json['hasChapters'],
      partsCount: json['parts_count'],
      chapterCount: json['Chapter_count'],
      parts: partsList,
    );
  }

  // منشئ فارغ
  factory Book.empty() {
    return Book(
      bookNumber: 0,
      bookName: '',
      hasChapters: true,
      partsCount: 0,
      chapterCount: 0,
      parts: [],
    );
  }
}
