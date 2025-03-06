part of '../../events.dart';

class Hadith {
  final String hadith;
  final String bookInfo;

  Hadith({required this.hadith, required this.bookInfo});

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      hadith: json['hadith'],
      bookInfo: json['bookInfo'],
    );
  }
}

class Event {
  final int id;
  final String title;
  final int month;
  final List<int> day;
  final bool isLottie;
  final bool isSvg;
  final bool isTitle;
  final bool isReminder;
  final String lottiePath;
  final String svgPath;
  final List<Hadith> hadith;

  Event({
    required this.id,
    required this.title,
    required this.month,
    required this.day,
    required this.hadith,
    required this.isLottie,
    required this.isSvg,
    required this.isTitle,
    required this.isReminder,
    required this.lottiePath,
    required this.svgPath,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var hadithList = json['hadith'] as List;
    List<Hadith> hadiths = hadithList.map((i) => Hadith.fromJson(i)).toList();

    var dayList = json['day'] as List;
    List<int> days = dayList.map((i) => i as int).toList();

    return Event(
      id: json['id'],
      title: json['title'],
      month: json['month'],
      day: days,
      isLottie: json['isLottie'],
      isSvg: json['isSvg'],
      isTitle: json['isTitle'],
      isReminder: json['isReminder'],
      lottiePath: json['lottiePath'],
      svgPath: json['svgPath'],
      hadith: hadiths,
    );
  }
}

class DataModel {
  final List<Event> data;

  DataModel({required this.data});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Event> events = dataList.map((i) => Event.fromJson(i)).toList();

    return DataModel(
      data: events,
    );
  }
}
