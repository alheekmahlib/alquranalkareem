import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../model/QuranModel.dart';

class QuranServer {
  Future<List<SurahText>> QuranData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/json/quran.json');
    final list = json.decode(jsondata);
    var data = list["data"]["surahs"];
    List<SurahText> surahs = [];
    for (int i = 0; i < data.length; i++) {
      surahs.add(SurahText.fromJson(data[i]));
    }
    print("surahs[0].name.toString()");
    print(surahs[0].name.toString());
    return surahs;
  }
}
