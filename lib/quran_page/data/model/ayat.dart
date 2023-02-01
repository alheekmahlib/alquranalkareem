class Ayat {
  static String tableName = "Ayat";

  int? ayaId;
  int? pageNum;
  int? ayaNum;
  String? tafsser;
  String? translate;
  String? ayatext;
  int? suraNum;

  static final columns = ["AID", 'PageNum', 'Verse', 'ayatext', 'SuraNum'];

  static fromMap(Map map) {
    Ayat aya = Ayat();
    aya.ayaId = map["AID"];
    aya.pageNum = map["PageNum"];
    aya.tafsser = map["AyaInfo"];
    aya.translate = map["text"];
    aya.ayaNum = map["Verse"];
    aya.ayatext = map["ayatext"];
    aya.suraNum = map["SuraNum"];
    return aya;
  }
}
