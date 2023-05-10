class Quarter {
  static String tableName = "Quarter";
  late int id;
  late int part;
  late int hezb;
  late int quarter;
  late int ayaId;

  Quarter({required this.id, required this.part, required this.hezb, required this.quarter, required this.ayaId});

  static List<String> get columns => [
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

    map["Id"] = id;

    return map;
  }

  static fromMap(Map map) {
    return Quarter(
    id: map["Id"],
    part: map["Part"],
    hezb: map["Hezb"],
    quarter: map["Quarter"],
    ayaId: map["AyaId"],
    );
  }
}
