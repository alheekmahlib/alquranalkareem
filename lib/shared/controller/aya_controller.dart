import 'package:get/get.dart';

import '../../quran_page/data/model/aya.dart';
import '../../quran_page/data/repository/aya_repository.dart';

class AyaController extends GetxController {
  final AyaRepository _ayaRepository = AyaRepository();
  final Rx<AyaState> ayaState = AyaLoading().obs;

  void getAllAyas() async {
    ayaState.value = AyaLoading();
    try {
      final ayahList = await _ayaRepository.all();
      ayaState.value = AyaLoaded(ayahList);
    } catch (e) {
      ayaState.value = AyaError("Error fetching Ayas: $e");
    }
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

  void search(String text) async {
    // Convert Arabic numerals to English numerals if any
    String convertedText = _convertArabicToEnglishNumbers(text);

    try {
      ayaState.value = AyaLoading();

      final List<Aya>? values = await _ayaRepository.search(convertedText);
      if (values != null && values.isNotEmpty) {
        ayaState.value = AyaLoaded(values);
      } else {
        ayaState.value = AyaError("No results found for $convertedText");
      }
    } catch (e) {
      ayaState.value = AyaError(e.toString());
    }
  }
}

class AyaState {}

class AyaLoading extends AyaState {}

class AyaLoaded extends AyaState {
  final List<Aya> ayahList;

  AyaLoaded(this.ayahList);
}

class AyaError extends AyaState {
  final String message;

  AyaError(this.message);
}
