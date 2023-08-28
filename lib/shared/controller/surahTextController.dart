import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../quran_text/model/QuranModel.dart';

class SurahTextController extends GetxController {
  var surahs = <SurahText>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadQuranData();
  }

  Future<void> loadQuranData() async {
    final jsondata = await rootBundle.loadString('assets/json/quran.json');
    final list = json.decode(jsondata);
    var data = list["data"]["surahs"];
    var loadedSurahs = <SurahText>[];
    for (int i = 0; i < data.length; i++) {
      loadedSurahs.add(SurahText.fromJson(data[i]));
    }
    surahs.assignAll(loadedSurahs);
  }
}
