import 'package:get/get.dart';

import '../../quran_page/data/model/aya.dart';
import '../../quran_page/data/repository/aya_repository.dart';

class AyaController extends GetxController {
  final AyaRepository _ayaRepository = AyaRepository();

  var isLoading = false.obs;
  var ayahList = <Aya>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllAyas();
  }

  void getAllAyas() {
    _setLoading(true);
    _ayaRepository.all().then((loadedAyahList) {
      ayahList.assignAll(loadedAyahList);
      _setLoading(false);
    }).catchError((e) {
      errorMessage.value = "Error fetching Ayas: $e";
      _setLoading(false);
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

  void search(String text) async {
    String convertedText = _convertArabicToEnglishNumbers(text);
    _setLoading(true);

    try {
      final List<Aya>? values = await _ayaRepository.search(convertedText);
      if (values != null && values.isNotEmpty) {
        ayahList.assignAll(values);
        _setLoading(false);
      } else {
        errorMessage.value = "No results found for $convertedText";
        _setLoading(false);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading.value = value;
  }
}
