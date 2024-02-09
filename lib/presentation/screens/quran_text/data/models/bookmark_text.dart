class BookmarksText {
  int? id;
  String? sorahName;
  int? sorahNum;
  int? pageNum;
  int? ayahNum;
  String? lastRead;

  BookmarksText(this.id, this.sorahName, this.sorahNum, this.pageNum,
      this.ayahNum, this.lastRead);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': sorahName,
      'sorahNum': sorahNum,
      'pageNum': pageNum,
      'ayahNum': ayahNum,
      'lastRead': lastRead,
    };
  }

  BookmarksText.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sorahName = json['sorahName'];
    sorahNum = json['sorahNum'];
    pageNum = json['pageNum'];
    ayahNum = json['ayahNum'];
    lastRead = json['lastRead'];
  }
}
