import 'dart:convert';

import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/presentation/screens/quran_page/widgets/search/search_extensions/convert_arabic_to_english_numbers_extension.dart';
import '../../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../../../core/widgets/time_now.dart';
import '../data/models/search_item.dart';
import 'search_state.dart';

class QuranSearchController extends GetxController {
  static QuranSearchController get instance =>
      Get.isRegistered<QuranSearchController>()
          ? Get.find<QuranSearchController>()
          : Get.put<QuranSearchController>(QuranSearchController());

  final SearchState state = SearchState();

  @override
  void onInit() {
    super.onInit();
    // fetchAyahs();
    loadSearchHistory();
  }

  void search(String text) async {
    if (text.trim().isEmpty) {
      print("Empty search query, skipping search.");
      state.errorMessage.value = "Please enter a valid search term.";
      return;
    }

    state.ayahList.clear();
    _setLoading(true);

    try {
      // final List<QuranTableData>? values = await AyaRepository.searchAyahs(
      //     text.convertArabicToEnglishNumbers(text));
      final values =
          QuranLibrary().search(text.convertArabicToEnglishNumbers(text));
      if (values.isNotEmpty) {
        state.ayahList.assignAll(values);
        _setLoading(false);
      } else {
        state.errorMessage.value = "No results found for \"$text\"";
        _setLoading(false);
      }
    } catch (e) {
      state.errorMessage.value = "Error: ${e.toString()}";
      _setLoading(false);
    }
  }

  void surahSearchMethod(String text) async {
    state.surahList.clear();
    _setLoading(true);
    try {
      // final List<QuranTableData>? values = await AyaRepository.getAyahsBySurah(
      //     text.convertArabicToEnglishNumbers(text));
      final values = QuranLibrary().surahSearch(text);
      if (values.isNotEmpty) {
        // Use a map to track unique Surahs
        var uniqueSurahs = <int, SurahModel>{};
        for (var aya in values) {
          if (!uniqueSurahs.containsKey(aya.surahNumber)) {
            uniqueSurahs[aya.surahNumber!] = aya;
          }
        }
        state.surahList.assignAll(uniqueSurahs.values);
        _setLoading(false);
      } else {
        state.errorMessage.value = "No results found for $text";
        _setLoading(false);
      }
    } catch (e) {
      state.errorMessage.value = e.toString();
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    state.isLoading.value = value;
  }

  // void fetchAyahs() {
  //   if (state.isLoading.isTrue || !state.hasMore) return;
  //
  //   state.isLoading.value = true;
  //   final offset = (state.currentPage - 1) * state.itemsPerPage;
  //
  //   AyaRepository.fetchAyahsByPage(offset, state.itemsPerPage).then((newAyahs) {
  //     if (newAyahs.length < state.itemsPerPage) {
  //       state.hasMore = false; // No more items to add
  //     }
  //
  //     state.ayahList.addAll(newAyahs);
  //     state.surahList.addAll(newAyahs);
  //     state.currentPage++;
  //     state.isLoading.value = false;
  //   }).catchError((error) {
  //     state.errorMessage.value = error.toString();
  //     state.isLoading.value = false;
  //   });
  // }

  void loadSearchHistory() {
    var historyData = state.box.read(SEARCH_HISTORY);
    if (historyData is List) {
      List<Map<String, dynamic>?> rawHistory = historyData
          .map((item) {
            if (item is String) {
              try {
                return jsonDecode(item) as Map<String, dynamic>;
              } catch (e) {
                return null;
              }
            }
            return null;
          })
          .where((item) => item != null)
          .toList();
      state.searchHistory.value =
          rawHistory.map((item) => SearchItem.fromMap(item!)).toList();
    } else {
      state.searchHistory.value = [];
    }
  }

  void addSearchItem(String query) {
    TimeNow timeNow = TimeNow();

    SearchItem newItem = SearchItem(query, timeNow.dateNow);
    state.searchHistory.removeWhere((item) => item.query == query);
    state.searchHistory.insert(0, newItem);
    surahSearchMethod(query);
    search(query);
    state.box.write(SEARCH_HISTORY,
        state.searchHistory.map((item) => jsonEncode(item.toMap())).toList());
  }

  void removeSearchItem(SearchItem item) {
    state.searchHistory.remove(item);
    state.box.write(SEARCH_HISTORY,
        state.searchHistory.map((item) => jsonEncode(item.toMap())).toList());
  }
}
