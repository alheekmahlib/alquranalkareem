import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/quran_page/widgets/search/search_extensions/convert_arabic_to_english_numbers_extension.dart';
import '../data/model/aya.dart';
import '../data/repository/aya_repository.dart';

class AyaController extends GetxController {
  static AyaController get instance => Get.isRegistered<AyaController>()
      ? Get.find<AyaController>()
      : Get.put<AyaController>(AyaController());
  final AyaRepository _ayaRepository = AyaRepository();
  final ScrollController scrollController = ScrollController();
  final searchTextEditing = TextEditingController();
  ContainerTransitionType transitionType = ContainerTransitionType.fade;

  var isLoading = false.obs;
  var ayahList = <Aya>[].obs;
  var surahList = <Aya>[].obs;
  var errorMessage = ''.obs;
  int currentPage = 1;
  int itemsPerPage = 5;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchAyahs();
    // scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    // scrollController.dispose();
    super.onClose();
  }

  void search(String text) async {
    ayahList.clear();
    _setLoading(true);

    try {
      final List<Aya>? values =
          await _ayaRepository.search(text.convertArabicToEnglishNumbers(text));
      if (values != null && values.isNotEmpty) {
        ayahList.assignAll(values);
        _setLoading(false);
      } else {
        errorMessage.value = "No results found for $text";
        _setLoading(false);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      _setLoading(false);
    }
  }

  void surahSearch(String text) async {
    surahList.clear();
    _setLoading(true);
    try {
      final List<Aya>? values = await _ayaRepository
          .surahSearch(text.convertArabicToEnglishNumbers(text));
      if (values != null && values.isNotEmpty) {
        // Use a map to track unique Surahs
        var uniqueSurahs = <int, Aya>{};
        for (var aya in values) {
          if (!uniqueSurahs.containsKey(aya.surahNum)) {
            uniqueSurahs[aya.surahNum] = aya;
          }
        }
        surahList.assignAll(uniqueSurahs.values);
        _setLoading(false);
      } else {
        errorMessage.value = "No results found for $text";
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

  // void _onScroll() {
  //   if (scrollController.position.maxScrollExtent ==
  //           scrollController.position.pixels &&
  //       hasMore) {
  //     fetchAyahs();
  //   }
  // }

  void fetchAyahs() {
    if (isLoading.isTrue || !hasMore) return;

    isLoading.value = true;
    final offset = (currentPage - 1) * itemsPerPage;

    _ayaRepository.fetchAyahsByPage(offset, itemsPerPage).then((newAyahs) {
      if (newAyahs.length < itemsPerPage) {
        hasMore = false; // No more items to add
      }

      ayahList.addAll(newAyahs);
      surahList.addAll(newAyahs);
      currentPage++;
      isLoading.value = false;
    }).catchError((error) {
      errorMessage.value = error.toString();
      isLoading.value = false;
    });
  }
}
