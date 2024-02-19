enum MufaserName {
  ibnkatheer,
  baghawy,
  qurtubi,
  saadi,
  tabari,
}

class Tafseer {
  late int index;
  late int surah;
  late int aya;
  late String text;
  late int pageNum;

  static final columns = ["index", "sura", 'aya', 'text', 'PageNum'];

  static fromMap(Map map) {
    Tafseer translate = Tafseer();
    translate.index = map["index"];
    translate.aya = map["aya"];
    translate.surah = map["sura"];
    translate.text = map["text"];
    translate.pageNum = map['PageNum'];
    return translate;
  }
  // static Tafseer fromMap(Map<String, Object?> map, String mufaserName) {
  //   Tafseer translate = Tafseer();
  //   translate.mufaserName = mufaserName;
  //   translate.index = (map["index"] as int?)!;
  //   translate.aya = (map["aya"] as int?)!;
  //   translate.surah = (map["sura"] as int?)!;
  //   translate.text = (map["text"] as String?)!;
  //   translate.pageNum = (map['PageNum'] as int?)!;
  //   return translate;
  // }
}
