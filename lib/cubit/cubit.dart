import 'dart:async';

import 'package:alquranalkareem/cubit/states.dart';
import 'package:alquranalkareem/quran_page/data/model/ayat.dart';
import 'package:alquranalkareem/shared/controller/ayat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(SoundPageState());
  static QuranCubit get(context) => BlocProvider.of<QuranCubit>(context);

  String translateAyah = '';
  String translate = '';

  int? transIndex;
  bool isShowSettings = false;
  late final AyatController ayatController = Get.put(AyatController());

  void updateText(String ayatext, String translate) {
    emit(TextUpdated(ayatext, translate));
  }

  Future<void> getTranslatedPage(int pageNum, BuildContext context) async {
    // emit(AyaLoading());
    try {
      // ignore: unused_local_variable
      final ayahList = await ayatController
          .handleRadioValueChanged(ayatController.radioValue)
          .getPageTranslate(pageNum);
      // emit(AyaLoaded(ayahList));
    } catch (e) {
      emit(AyaError("Error fetching Translated Page: $e"));
    }
  }

  Future<void> getTranslatedAyah(int pageNum, BuildContext context) async {
    emit(AyaLoading());
    try {
      final ayahList = await ayatController
          .handleRadioValueChanged(ayatController.radioValue)
          .getAyahTranslate(pageNum);
      emit(AyaLoaded(ayahList));
    } catch (e) {
      emit(AyaError("Error fetching Translated Page: $e"));
    }
  }

  Ayat? getAyaByIndex(int index) {
    if (state is AyaLoaded) {
      return (state as AyaLoaded).ayahList.elementAt(index);
    }
    return null;
  }

  void updateTranslation(String newTranslateAyah, String newTranslate) {
    emit(TranslationUpdatedState(
        translateAyah: newTranslateAyah, translate: newTranslate));
  }

  void getNewTranslationAndNotify(BuildContext context, int selectedSurahNumber,
      int selectedAyahNumber) async {
    List<Ayat> ayahs = await ayatController
        .handleRadioValueChanged(ayatController.radioValue)
        .getAyahTranslate(selectedSurahNumber);

    // Now you have a list of ayahs of the Surah. Find the Ayah with the same number as the previously selected Ayah.
    Ayat selectedAyah =
        ayahs.firstWhere((ayah) => ayah.ayaNum == selectedAyahNumber);

    // Update the text with the Ayah text and its translation
    updateText("${selectedAyah.ayatext}", "${selectedAyah.translate}");
  }

  void initState() {
    // MPages.currentPage2 = cuMPage;
    // scrollController = ScrollController();
    // scrollController.addListener(() {
    //   if (scrollController.offset >=
    //           scrollController.position.maxScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     panelController.expand();
    //   } else if (scrollController.offset <=
    //           scrollController.position.minScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     panelController.anchor();
    //   } else {}
    // });
    emit(QuranPageState());
  }

  /// Time
  // var now = DateTime.now();
  String lastRead =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
}
