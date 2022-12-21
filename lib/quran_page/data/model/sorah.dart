class Sorah {
  static String tableName = "Sora";
  late int id;
  late String name;
  late String nameEn;
  late int ayaCount;
  late int pageNum;
  static final columns = [
    "Id",
    "Name_ar",
    "Name_en",
    'AyatCount',
    'PageNum',
  ];

  Map toMap() {
    Map map = {
      "Name_ar": name,
      "Name_en": nameEn,
      "AyatCount": ayaCount,
      "PageNum": pageNum,
    };

    if (id != null) {
      map["Id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    Sorah sorah = Sorah();
    sorah.id = map["Id"];
    sorah.name = map["Name_ar"];
    sorah.nameEn = map["Name_en"];
    sorah.ayaCount = map["AyatCount"];
    sorah.pageNum = map["PageNum"];
    return sorah;
  }
}
