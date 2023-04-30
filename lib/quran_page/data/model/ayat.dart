class Ayat {
  static String tableName = "Ayat";

  int? ayaId;
  int? pageNum;
  int? ayaNum;
  String? tafsser;
  String? translate;
  String? ayatext;
  String? sura_name_ar;
  int? suraNum;

  static final columns = ["AID", 'PageNum', 'Verse', 'ayatext', 'sura_name_ar' 'SuraNum'];

  
  static fromMap(Map map) {
    Ayat aya = Ayat();
    aya.ayaId = map["AID"];
    aya.pageNum = map["PageNum"];
    aya.tafsser = map["AyaInfo"];
    aya.translate = map["text"];
    aya.ayaNum = map["Verse"];
    aya.ayatext = map["ayatext"];
    aya.sura_name_ar = map["sura_name_ar"];
    aya.suraNum = map["SuraNum"];
    return aya;
  }
}
