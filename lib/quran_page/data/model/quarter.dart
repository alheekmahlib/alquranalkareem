class Quarter {
  static String tableName = "Quarter";
  late int id;
  late String part;
  late String hezb;
  late int quarter;
  late int ayaId;
  static final columns = [
    "Id",
    "Part",
    "Hezb",
    'Quarter',
    'AyaId',
  ];

  Map toMap() {
    Map map = {
      "Part": part,
      "Hezb": hezb,
      "Quarter": quarter,
      "AyaId": ayaId,
    };

    if (id != null) {
      map["Id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    Quarter quarter = Quarter();
    quarter.id = map["Id"];
    quarter.part = map["Part"];
    quarter.hezb = map["Hezb"];
    quarter.quarter = map["Quarter"];
    quarter.ayaId = map["AyaId"];
    return quarter;
  }
}
