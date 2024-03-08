class Surah {
  final int surahNumber;
  final String arabicName;
  final String englishName;
  final String revelationType;
  final List<Ayah> ayahs;

  Surah(
      {required this.surahNumber,
      required this.arabicName,
      required this.englishName,
      required this.revelationType,
      required this.ayahs});

  factory Surah.fromJson(Map<String, dynamic> json) {
    var ayahsFromJson = json['ayahs'] as List;
    List<Ayah> ayahsList = ayahsFromJson.map((i) => Ayah.fromJson(i)).toList();

    return Surah(
      surahNumber: json['number'],
      arabicName: json['name'],
      englishName: json['englishName'],
      revelationType: json['revelationType'],
      ayahs: ayahsList,
    );
  }
}

class Ayah {
  final int ayahUQNumber;
  final int ayahNumber;
  final String text;
  final String aya_text_emlaey;
  final String code_v2;
  final int juz;
  final int page;
  dynamic sajda;

  Ayah({
    required this.ayahUQNumber,
    required this.ayahNumber,
    required this.text,
    required this.aya_text_emlaey,
    required this.code_v2,
    required this.juz,
    required this.page,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      ayahUQNumber: json['number'],
      ayahNumber: json['numberInSurah'],
      text: json['text'],
      aya_text_emlaey: json['aya_text_emlaey'],
      code_v2: json['code_v2'],
      juz: json['juz'],
      page: json['page'],
      sajda: json['sajda'],
    );
  }
}

class Sajda {
  final int id;
  final bool recommended;
  final bool obligatory;

  Sajda(
      {required this.id, required this.recommended, required this.obligatory});

  factory Sajda.fromJson(Map<String, dynamic> json) {
    return Sajda(
      id: json['id'],
      recommended: json['recommended'],
      obligatory: json['obligatory'] ??
          false, // Assuming obligatory might not always be present
    );
  }
}
