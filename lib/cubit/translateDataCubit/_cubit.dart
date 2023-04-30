import 'dart:convert';
import 'package:alquranalkareem/cubit/translateDataCubit/translateDataState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TranslateDataCubit extends Cubit<TranslateDataState> {
  TranslateDataCubit() : super(TranslateDataState(data: null, isLoading: false));

  Future<void> fetchSura(BuildContext context, String translation, String surahNumber) async {
    emit(TranslateDataState(data: state.data, isLoading: true)); // Set isLoading to true
    String data = await DefaultAssetBundle.of(context).loadString("assets/json/$translation.json");
    var showData = json.decode(data);
    List<dynamic> sura = showData[surahNumber];
    emit(TranslateDataState(data: sura, isLoading: false)); // Set isLoading to false and update the data
  }

  // Map<String, dynamic>? getVerseByNumber(int verseNumber) {
  //   return state?.firstWhere((verse) => verse['verse'] == verseNumber);
  // }
}
