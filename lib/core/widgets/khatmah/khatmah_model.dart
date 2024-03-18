class KhatmahModel {
  String name;
  int surahNumber;
  int pageNumber;

  KhatmahModel(
      {required this.name,
      required this.surahNumber,
      required this.pageNumber});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surahNumber': surahNumber,
      'pageNumber': pageNumber,
    };
  }

  static KhatmahModel fromMap(Map<String, dynamic> map) {
    return KhatmahModel(
      name: map['name'],
      surahNumber: map['surahNumber'],
      pageNumber: map['pageNumber'],
    );
  }
}
