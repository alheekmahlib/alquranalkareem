class BookmarksText {
  int? id;
  String? sorahName;
  int? sorahNum;
  int? pageNum;
  int? ayahNum;
  int? ayahUQNum;
  String? lastRead;

  BookmarksText(this.id, this.sorahName, this.sorahNum, this.pageNum,
      this.ayahNum, this.ayahUQNum, this.lastRead);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': sorahName,
      'sorahNum': sorahNum,
      'pageNum': pageNum,
      'ayahNum': ayahNum,
      'nomPageF': ayahUQNum,
      'lastRead': lastRead,
    };
  }

  BookmarksText.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sorahName = json['sorahName'];
    sorahNum = json['sorahNum'];
    pageNum = json['pageNum'];
    ayahNum = json['ayahNum'];
    ayahUQNum = json['nomPageF'];
    lastRead = json['lastRead'];
  }
}
