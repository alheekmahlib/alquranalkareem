class Surah {
  static String tableName = "Sora";
  late int id;
  late String name;
  late String nameEn;
  late String searchText;
  late int ayaCount;
  late int pageNum;
  static final columns = [
    "Id",
    "Name_ar",
    "Name_en",
    "SearchText",
    'AyatCount',
    'PageNum',
  ];

  Map toMap() {
    Map map = {
      "Name_ar": name,
      "Name_en": nameEn,
      "SearchText": searchText,
      "AyatCount": ayaCount,
      "PageNum": pageNum,
    };

    map["Id"] = id;

    return map;
  }

  static fromMap(Map map) {
    Surah sorah = Surah();
    sorah.id = map["Id"];
    sorah.name = map["Name_ar"];
    sorah.nameEn = map["Name_en"];
    sorah.searchText = map["SearchText"];
    sorah.ayaCount = map["AyatCount"];
    sorah.pageNum = map["PageNum"];
    return sorah;
  }
}
