class BookmarksTextAyah {
  int? id;
  String? sorahName;
  int? sorahNum;
  int? ayahNum;
  int? nomPageF;
  int? nomPageL;
  String? lastRead;

  BookmarksTextAyah(this.id, this.sorahName, this.sorahNum, this.ayahNum, this.nomPageF, this.nomPageL, this.lastRead);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': sorahName,
      'sorahNum': sorahNum,
      'ayahNum': ayahNum,
      'nomPageF': nomPageF,
      'nomPageL': nomPageL,
      'lastRead': lastRead,
    };
  }

  BookmarksTextAyah.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sorahName = json['sorahName'];
    sorahNum = json['sorahNum'];
    ayahNum = json['ayahNum'];
    nomPageF = json['nomPageF'];
    nomPageL = json['nomPageL'];
    lastRead = json['lastRead'];
  }
}