import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/quran_page/data/model/aya.dart';
import '../screens/quran_page/data/repository/aya_repository.dart';

// class AyaController extends GetxController {
//   final AyaRepository _ayaRepository = AyaRepository();
//
//   var isLoading = false.obs;
//   var ayahList = <Aya>[].obs;
//   var errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getAllAyas();
//   }
//
//   void getAllAyas() {
//     _setLoading(true);
//     _ayaRepository.all().then((loadedAyahList) {
//       ayahList.assignAll(loadedAyahList);
//       _setLoading(false);
//     }).catchError((e) {
//       errorMessage.value = "Error fetching Ayas: $e";
//       _setLoading(false);
//     });
//   }
//
//   String _convertArabicToEnglishNumbers(String input) {
//     const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
//     const englishNumbers = '0123456789';
//
//     return input.split('').map((char) {
//       int index = arabicNumbers.indexOf(char);
//       if (index != -1) {
//         return englishNumbers[index];
//       }
//       return char;
//     }).join('');
//   }
//
//   void search(String text) async {
//     String convertedText = _convertArabicToEnglishNumbers(text);
//     _setLoading(true);
//
//     try {
//       final List<Aya>? values = await _ayaRepository.search(convertedText);
//       if (values != null && values.isNotEmpty) {
//         ayahList.assignAll(values);
//         _setLoading(false);
//       } else {
//         errorMessage.value = "No results found for $convertedText";
//         _setLoading(false);
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _setLoading(false);
//     }
//   }
//
//   void _setLoading(bool value) {
//     isLoading.value = value;
//   }
// }
class AyaController extends GetxController {
  final AyaRepository _ayaRepository = AyaRepository();
  final ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var ayahList = <Aya>[].obs;
  var errorMessage = ''.obs;
  int currentPage = 1;
  int itemsPerPage = 5;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchAyahs();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
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

  String _convertArabicToEnglishNumbers(String input) {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';

    return input.split('').map((char) {
      int index = arabicNumbers.indexOf(char);
      if (index != -1) {
        return englishNumbers[index];
      }
      return char;
    }).join('');
  }

  void _onScroll() {
    if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels &&
        hasMore) {
      fetchAyahs();
    }
  }

  void fetchAyahs() {
    if (isLoading.isTrue || !hasMore) return;

    isLoading.value = true;
    final offset = (currentPage - 1) * itemsPerPage;

    _ayaRepository.fetchAyahsByPage(offset, itemsPerPage).then((newAyahs) {
      if (newAyahs.length < itemsPerPage) {
        hasMore = false; // No more items to add
      }

      ayahList.addAll(newAyahs);
      currentPage++;
      isLoading.value = false;
    }).catchError((error) {
      errorMessage.value = error.toString();
      isLoading.value = false;
    });
  }
}
