import 'package:flutter/material.dart';
import '../../quran_page/data/model/aya.dart';
import 'package:bloc/bloc.dart';

import '../../quran_page/data/repository/aya_repository.dart';

part 'aya_state.dart';

class AyaCubit extends Cubit<AyaState> {
  final AyaRepository _ayaRepository = AyaRepository();

  AyaCubit() : super(AyaLoading());

  void getAllAyas() {
    emit(AyaLoading());
    _ayaRepository.all().then((ayahList) {
      emit(AyaLoaded(ayahList));
    }).catchError((e) {
      emit(AyaError("Error fetching Ayas: $e"));
    });
  }

  String _convertArabicToEnglishNumbers(String input) {
    final arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    final englishNumbers = '0123456789';

    return input.split('').map((char) {
      int index = arabicNumbers.indexOf(char);
      if (index != -1) {
        return englishNumbers[index];
      }
      return char;
    }).join('');
  }

  void searchAyas(String text) {
    emit(AyaLoading());
    _ayaRepository.search(text).then((ayahList) {
      if (ayahList != null) {
        emit(AyaLoaded(ayahList));
      } else {
        emit(AyaError("No results found for $text"));
      }
    }).catchError((e) {
      emit(AyaError("Error searching Ayas: $e"));
    });
  }

  void getPage(int pageNum) {
    emit(AyaLoading());
    _ayaRepository.getPage(pageNum).then((ayahList) {
      emit(AyaLoaded(ayahList));
    }).catchError((e) {
      emit(AyaError("Error fetching Ayas for page $pageNum: $e"));
    });
  }

  void getAllTafseer(int ayahNum) {
    emit(AyaLoading());
    _ayaRepository.allTafseer(ayahNum).then((ayahList) {
      emit(AyaLoaded(ayahList));
    }).catchError((e) {
      emit(AyaError("Error fetching Tafseer for ayah $ayahNum: $e"));
    });
  }

  void search(String text) async {
    // Convert Arabic numerals to English numerals if any
    String convertedText = _convertArabicToEnglishNumbers(text);

    emit(AyaLoading());

    try {
      final List<Aya>? values = await _ayaRepository.search(convertedText);
      if (values != null && values.isNotEmpty) {
        emit(AyaLoaded(values));
      } else {
        emit(AyaError("No results found for $convertedText"));
      }
    } catch (e) {
      emit(AyaError(e.toString()));
    }
  }

}
