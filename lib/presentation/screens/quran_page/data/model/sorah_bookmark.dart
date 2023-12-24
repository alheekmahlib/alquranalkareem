class SoraBookmark {
  static String tableName = "SorahBookmark";
  int? id;
  int? PageNum;
  String? SoraName_ar;
  String? SoraName_En;
  int? SoraNum;

  static final columns = [
    "ID",
    "PageNum",
    'SoraName_ar',
    'SoraName_En',
    'SoraNum'
  ];

  Map toMap() {
    Map map = {
      "PageNum": PageNum,
      "SoraName_ar": SoraName_ar,
      "SoraName_En": SoraName_En,
      "SoraNum": SoraNum
    };

    if (id != null) {
      map["ID"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    SoraBookmark soraBookmark = SoraBookmark();
    soraBookmark.id = map["ID"];
    soraBookmark.PageNum = map["PageNum"];
    soraBookmark.SoraName_ar = map["SoraName_ar"];
    soraBookmark.SoraName_En = map["SoraName_En"];
    soraBookmark.SoraNum = map["SoraNum"];
    return soraBookmark;
  }
}
