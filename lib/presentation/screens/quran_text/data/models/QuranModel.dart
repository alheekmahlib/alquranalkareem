import 'Ahya.dart';

class SurahText {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  String? revelationType;
  List<Ayahs>? ayahs;

  SurahText(
      {required int number,
      required String name,
      required String englishName,
      required String englishNameTranslation,
      required String revelationType,
      required List<Ayahs> ayahs}) {
    number = number;
    name = name;
    englishName = englishName;
    englishNameTranslation = englishNameTranslation;
    revelationType = revelationType;
    ayahs = ayahs;
  }

  SurahText.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    revelationType = json['revelationType'];
    if (json['ayahs'] != null) {
      ayahs = <Ayahs>[];
      json['ayahs'].forEach((v) {
        ayahs?.add(Ayahs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['englishName'] = englishName;
    data['englishNameTranslation'] = englishNameTranslation;
    data['revelationType'] = revelationType;
    final ayahs = this.ayahs;
    if (ayahs != null) {
      data['ayahs'] = ayahs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
