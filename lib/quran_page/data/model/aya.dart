class Aya {
  static String tableName = "Quran";
  late int id;
  late int sorahId;
  late int ayaNum;
  dynamic pageNum;
  late String sorahName;
  late String text;
  late String soraNameSearch;
  late int partNum;

  static final columns = [
    "ID",
    "SoraNum",
    'AyaNum',
    'PageNum',
    'SoraName_ar',
    'SoraNameSearch',
    'AyaDiac',
    'PartNum'
  ];

  Map toMap() {
    Map map = {
      "SoraNum": sorahId,
      "AyaNum": ayaNum,
      "PageNum": pageNum,
      "SoraName_ar": sorahName,
      "AyaDiac": text,
      "SoraNameSearch": soraNameSearch,
      "PartNum": partNum,
    };

    if (id != null) {
      map["ID"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    Aya aya = Aya();
    aya.id = map["ID"];
    aya.sorahName = map["SoraName_ar"];
    aya.ayaNum = map["AyaNum"];
    aya.sorahId = map["SoraNum"];
    aya.text = map["AyaDiac"];
    aya.soraNameSearch = map["SoraNameSearch"];
    aya.partNum = map["PartNum"];
    aya.pageNum = map["PageNum"];
    return aya;
  }
}