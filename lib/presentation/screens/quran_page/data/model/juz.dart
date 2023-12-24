import 'dart:convert';

List<QuranJuz> quranJuzFromJson(String str) =>
    List<QuranJuz>.from(json.decode(str).map((x) => QuranJuz.fromJson(x)));

String quranJuzToJson(List<QuranJuz> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuranJuz {
  QuranJuz({
    required this.index,
    required this.index2,
    required this.start,
    required this.end,
  });

  String index;
  String index2;
  End start;
  End end;

  factory QuranJuz.fromJson(Map<String, dynamic> json) => QuranJuz(
        index: json["index"],
        index2: json["index2"],
        start: End.fromJson(json["start"]),
        end: End.fromJson(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "index2": index2,
        "start": start.toJson(),
        "end": end.toJson(),
      };
}

class End {
  End({
    required this.index,
    required this.verse,
    required this.name,
    required this.pageNum,
    required this.ayatext,
  });

  String index;
  String verse;
  String name;
  String pageNum;
  String ayatext;

  factory End.fromJson(Map<String, dynamic> json) => End(
        index: json["index"],
        verse: json["verse"],
        name: json["name"],
        pageNum: json["pageNum"],
        ayatext: json["ayatext"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "verse": verse,
        "name": name,
        "pageNum": pageNum,
        "ayatext": ayatext,
      };
}
