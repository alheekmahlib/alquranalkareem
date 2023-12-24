class BookmarksText {
  int? id;
  String? sorahName;
  int? sorahNum;
  int? pageNum;
  int? ayahNum;
  int? nomPageF;
  int? nomPageL;
  String? lastRead;

  BookmarksText(this.id, this.sorahName, this.sorahNum, this.pageNum,
      this.ayahNum, this.nomPageF, this.nomPageL, this.lastRead);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': sorahName,
      'sorahNum': sorahNum,
      'pageNum': pageNum,
      'ayahNum': ayahNum,
      'nomPageF': nomPageF,
      'nomPageL': nomPageL,
      'lastRead': lastRead,
    };
  }

  BookmarksText.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sorahName = json['sorahName'];
    sorahNum = json['sorahNum'];
    pageNum = json['pageNum'];
    ayahNum = json['ayahNum'];
    nomPageF = json['nomPageF'];
    nomPageL = json['nomPageL'];
    lastRead = json['lastRead'];
  }
}
