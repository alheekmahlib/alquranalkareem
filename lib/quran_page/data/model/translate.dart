class Translate {
  static String tableName = "baghawy";
  static String tableName2 = "ibnkatheer";
  static String tableName3 = "qurtubi";
  static String tableName4 = "saadi";
  static String tableName5 = "tabari";
  late int index;
  late int sorah;
  late int aya;
  late String text;
  late String ayatext;

  static final columns = ["index", "sura", 'aya', 'text', 'ayatext'];

  static fromMap(Map map) {
    Translate translate = new Translate();
    translate.aya = map["aya"];
    translate.sorah = map["sura"];
    translate.text = map["text"];
    translate.ayatext = map['ayatext'];
    return translate;
  }
}
