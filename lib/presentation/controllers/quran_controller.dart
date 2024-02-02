import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../screens/quran_page/data/model/surahs_model.dart';
import 'general_controller.dart';

class QuranController extends GetxController {
  var currentPage = 1.obs;
  var surahs = <Surah>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadQuran();
  }

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    surahs.value = surahsJson.map((s) => Surah.fromJson(s)).toList();
  }

  List<Ayah> getAyahsForCurrentPage() {
    List<Ayah> ayahs = [];
    for (var surah in surahs) {
      ayahs.addAll(surah.ayahs.where(
          (ayah) => ayah.page == sl<GeneralController>().currentPage.value));
    }
    return ayahs;
  }
}
