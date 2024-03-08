class BookmarksAyahs {
  int? id;
  String? surahName;
  int? surahNumber;
  int? pageNumber;
  int? ayahNumber;
  int? ayahUQNumber;
  String? lastRead;

  BookmarksAyahs(this.id, this.surahName, this.surahNumber, this.pageNumber,
      this.ayahNumber, this.ayahUQNumber, this.lastRead);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': surahName,
      'sorahNum': surahNumber,
      'pageNum': pageNumber,
      'ayahNum': ayahNumber,
      'nomPageF': ayahUQNumber,
      'lastRead': lastRead,
    };
  }

  BookmarksAyahs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surahName = json['sorahName'];
    surahNumber = json['sorahNum'];
    pageNumber = json['pageNum'];
    ayahNumber = json['ayahNum'];
    ayahUQNumber = json['nomPageF'];
    lastRead = json['lastRead'];
  }
}
