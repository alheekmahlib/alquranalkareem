class PlayListModel {
  int id;
  int startNum;
  int endNum;
  int surahNum;
  String surahName;
  String readerName;
  String name;

  PlayListModel(
      {required this.id,
      required this.startNum,
      required this.endNum,
      required this.surahNum,
      required this.surahName,
      required this.readerName,
      required this.name});

  factory PlayListModel.fromJson(Map<String, dynamic> json) {
    return PlayListModel(
      id: json['id'],
      startNum: json['startNum'],
      endNum: json['endNum'],
      surahNum: json['surahNum'],
      surahName: json['surahName'],
      readerName: json['readerName'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startNum': startNum,
      'endNum': endNum,
      'surahNum': surahNum,
      'surahName': surahName,
      'readerName': readerName,
      'name': name,
    };
  }
}
