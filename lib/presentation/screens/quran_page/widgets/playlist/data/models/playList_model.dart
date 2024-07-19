class PlayListModel {
  int id;
  int startNum;
  int endNum;
  int startUQNum;
  int endUQNum;
  int surahNum;
  String surahName;
  String readerName;
  String name;

  PlayListModel(
      {required this.id,
      required this.startNum,
      required this.startUQNum,
      required this.endNum,
      required this.endUQNum,
      required this.surahNum,
      required this.surahName,
      required this.readerName,
      required this.name});

  factory PlayListModel.fromJson(Map<String, dynamic> json) {
    return PlayListModel(
      id: json['id'],
      startNum: json['startNum'],
      endNum: json['endNum'],
      startUQNum: json['startUQNum'],
      endUQNum: json['endUQNum'],
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
      'startUQNum': startUQNum,
      'endUQNum': endUQNum,
      'surahNum': surahNum,
      'surahName': surahName,
      'readerName': readerName,
      'name': name,
    };
  }
}
