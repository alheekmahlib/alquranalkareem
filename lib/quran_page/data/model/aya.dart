class Aya {
  static String tableName = "Quran";
  late int id;
  late int sorahId;
  late int ayaNum;
  late String pageNum;
  late String sorahName;
  late String text;
  late int partNum;

  static final columns = [
    "ID",
    "SoraNum",
    'AyaNum',
    'PageNum',
    'SoraName_ar',
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
    aya.partNum = map["PartNum"];
    aya.pageNum = map["PageNum"];
    return aya;
  }
}
