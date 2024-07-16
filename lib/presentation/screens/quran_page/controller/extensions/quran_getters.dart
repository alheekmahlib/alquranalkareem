import 'dart:math' as math;

import 'package:collection/collection.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../data/model/surahs_model.dart';
import '../quran_controller.dart';

extension QuranGetters on QuranController {
  /// -------- [Getter] ----------
  List<List<Ayah>> getCurrentPageAyahsSeparatedForBasmalah(int pageIndex) =>
      state.pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<Ayah> getPageAyahsByIndex(int pageIndex) => state.pages[pageIndex];

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah..
  /// if you wanna get the last's ayah's surah information
  /// you can use [ayahs.last].
  int getSurahNumberFromPage(int pageNumber) => state.surahs
      .firstWhere(
          (s) => s.ayahs.firstWhereOrNull((a) => a.page == pageNumber) != null)
      .surahNumber;

  Surah getCurrentSurahByPage(int pageNumber) => state.surahs.firstWhere(
      (s) => s.ayahs.contains(getPageAyahsByIndex(pageNumber).first));

  Surah getSurahNumberByAyah(Ayah ayah) =>
      state.surahs.firstWhere((s) => s.ayahs.contains(ayah));

  Surah getSurahDataByAyahUQ(int ayah) => state.surahs
      .firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  Ayah getJuzByPage(int page) =>
      state.allAyahs.firstWhere((a) => a.page == page + 1);

  String getHizbQuarterDisplayByPage(int pageNumber) {
    final List<Ayah> currentPageAyahs =
        state.allAyahs.where((ayah) => ayah.page == pageNumber).toList();
    if (currentPageAyahs.isEmpty) return "";

    // Find the highest Hizb quarter on the current page
    int? currentMaxHizbQuarter =
        currentPageAyahs.map((ayah) => ayah.hizbQuarter).reduce(math.max);

    // Store/update the highest Hizb quarter for this page
    state.pageToHizbQuarterMap[pageNumber] = currentMaxHizbQuarter;

    // For displaying the Hizb quarter, check if this is a new Hizb quarter different from the previous page's Hizb quarter
    // For the first page, there is no "previous page" to compare, so display its Hizb quarter
    if (pageNumber == 1 ||
        state.pageToHizbQuarterMap[pageNumber - 1] != currentMaxHizbQuarter) {
      int hizbNumber = ((currentMaxHizbQuarter - 1) ~/ 4) + 1;
      int quarterPosition = (currentMaxHizbQuarter - 1) % 4;

      switch (quarterPosition) {
        case 0:
          return "الحزب ${'$hizbNumber'.convertNumbers()}";
        case 1:
          return "١/٤ الحزب ${'$hizbNumber'.convertNumbers()}";
        case 2:
          return "١/٢ الحزب ${'$hizbNumber'.convertNumbers()}";
        case 3:
          return "٣/٤ الحزب ${'$hizbNumber'.convertNumbers()}";
        default:
          return "";
      }
    }

    // If the page's Hizb quarter is the same as the previous page, do not display it again
    return "";
  }

  bool getSajdaInfoForPage(List<Ayah> pageAyahs) {
    for (var ayah in pageAyahs) {
      if (ayah.sajda != false && ayah.sajda is Map) {
        var sajdaDetails = ayah.sajda;
        if (sajdaDetails['recommended'] == true ||
            sajdaDetails['obligatory'] == true) {
          return state.isSajda.value = true;
        }
      }
    }
    // No sajda found on this page
    return state.isSajda.value = false;
  }

  List<Ayah> get currentPageAyahs =>
      state.pages[generalCtrl.currentPageNumber.value - 1];

  Ayah? getAyahWithSajdaInPage(int pageIndex) =>
      state.pages[pageIndex].firstWhereOrNull((ayah) {
        if (ayah.sajda != false) {
          if (ayah.sajda is Map) {
            var sajdaDetails = ayah.sajda;
            if (sajdaDetails['recommended'] == true ||
                sajdaDetails['obligatory'] == true) {
              return state.isSajda.value = true;
            }
          } else {
            return ayah.sajda == true;
          }
        }
        return state.isSajda.value = false;
      });
}
