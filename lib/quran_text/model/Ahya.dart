class Ayahs {
  int? number;
  String? text;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? pageInSurah;
  int? ruku;
  int? hizbQuarter;
  bool? sajda;
  String? audio;

  Ayahs({
    required int number,
    required String audio,
    required List<String> audioSecondary,
    required String text,
    required int numberInSurah,
    required int juz,
    required int manzil,
    required int page,
    required int pageInSurah,
    required int ruku,
    required int hizbQuarter,
    required bool sajda,
  }) {
    number = number;
    text = text;
    numberInSurah = numberInSurah;
    juz = juz;
    manzil = manzil;
    page = page;
    pageInSurah = pageInSurah;
    ruku = ruku;
    hizbQuarter = hizbQuarter;
    sajda = sajda;
    audio = audio;
  }

  Ayahs.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    text = json['text'];
    numberInSurah = json['numberInSurah'];
    juz = json['juz'];
    manzil = json['manzil'];
    page = json['page'];
    pageInSurah = json['pageInSurah'];
    ruku = json['ruku'];
    audio = json['audio'];
    hizbQuarter = json['hizbQuarter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['text'] = text;
    data['numberInSurah'] = numberInSurah;
    data['juz'] = juz;
    data['manzil'] = manzil;
    data['page'] = page;
    data['pageInSurah'] = pageInSurah;
    data['ruku'] = ruku;
    data['audio'] = audio;
    data['hizbQuarter'] = hizbQuarter;
    data['sajda'] = sajda;
    return data;
  }
}
