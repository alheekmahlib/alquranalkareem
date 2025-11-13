import 'dart:developer' show log;

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/utils/constants/lists.dart';
import '/core/utils/constants/shared_preferences_constants.dart';
import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '../../../quran_page/quran.dart';
import '../../../quran_page/widgets/search/search_extensions/convert_arabic_to_english_numbers_extension.dart';
import '../../../quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '../surah_audio_controller.dart';

extension SurahAudioUi on SurahAudioController {
  Future<void> changeAudioSource() async {
    state.surahDownloadStatus.value[state.surahNum.value] ?? false
        ? await state.audioPlayer.setAudioSource(
            AudioSource.file(await localFilePath, tag: await mediaItem),
          )
        : await state.audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(urlFilePath), tag: await mediaItem),
          );
    print('URL: $urlFilePath');
  }

  void changeReadersOnTap(int index) {
    initializeSurahDownloadStatus();
    state.surahReaderValue.value = surahReaderInfo[index]['readerD'];
    state.surahReaderNameValue.value = surahReaderInfo[index]['readerN'];
    state.box.write(
      SURAH_AUDIO_PLAYER_SOUND,
      surahReaderInfo[index]['readerD'],
    );
    state.box.write(SURAH_AUDIO_PLAYER_NAME, surahReaderInfo[index]['readerN']);
    state.box.write(SURAH_READER_INDEX, index);
    state.surahReaderIndex.value = index;
    changeAudioSource();
    Get.back();
  }

  void searchSurah(String searchInput) {
    final surahList = QuranController.instance.state.surahs;

    int index;
    if (int.tryParse(searchInput.convertArabicToEnglishNumbers(searchInput)) !=
        null) {
      // إذا كان الإدخال رقمًا، ابحث باستخدام رقم السورة
      index = surahList.indexWhere(
        (surah) =>
            surah.surahNumber ==
            int.parse(searchInput.convertArabicToEnglishNumbers(searchInput)),
      );
    } else {
      // إذا كان الإدخال نصًا، ابحث باستخدام اسم السورة
      index = surahList.indexWhere(
        (surah) => surah.arabicName
            .removeDiacritics(surah.arabicName)
            .contains(searchInput),
      );
    }

    log('surahNumber: $index');
    if (index != -1 && state.surahListController != false) {
      jumpToSurah(index);
      state.selectedSurah.value = index;
    }
  }

  void jumpToSurah(int index) async {
    // تأكد من أن ScrollablePositionedList قد تم بناؤه بالكامل
    // state.surahListController = ItemScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (state.surahListController.isAttached) {
      Future.delayed(
        const Duration(milliseconds: 700),
      ).then((_) => state.surahListController.jumpTo((index * 80).toDouble()));
      // } else {
      //   developer
      //       .log('Error: surahListController is not attached. Retrying...');
      // }
    });
  }
}
