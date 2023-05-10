import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../model/QuranModel.dart';

part 'surah_text_state.dart';

class SurahTextCubit extends Cubit<List<SurahText>?> {
  SurahTextCubit() : super(null);

  Future<void> loadQuranData() async {
    final jsondata = await rootBundle.loadString('assets/json/quran.json');
    final list = json.decode(jsondata);
    var data = list["data"]["surahs"];
    List<SurahText> surahs = [];
    for (int i = 0; i < data.length; i++) {
      surahs.add(SurahText.fromJson(data[i]));
    }
    emit(surahs);
  }
}
